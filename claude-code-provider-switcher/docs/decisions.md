# Design decisions

What this extension decided, what it rejected, and which approaches were tried and failed.
The README says how to install and use it; this file records what the code alone cannot
tell a contributor, above all the approaches already shown not to work.

Findings here were verified on macOS against Claude Code extension 2.1.220.

**Why no fork:** the Claude Code extension is closed-source under a commercial licence, so
its UI cannot be copied. Its own configuration exposes everything a switcher needs, and its
session store is shared across providers, so a switched session can simply be resumed.

### D-1 — Switching works through a process-wrapper shim

`claudeCode.claudeProcessWrapper` points at `bin/gephyra-wrapper`. The shim reads the
project's provider from `~/.config/gephyra/state.json` and injects that provider's
environment when Claude Code spawns its CLI.

**Rejected:** rewriting `claudeCode.environmentVariables` (machine-wide, and the extension
does not reliably honour it) and editing the env blocks in `.claude/settings*.json` (the
override leaks into unrelated sessions).

### D-2 — Busy detection reads the session transcript

The Claude Code extension exposes no "busy" context key. The switcher finds the active
session in Claude Code's live-session registry (`~/.claude/sessions/<pid>.json`: session id,
cwd and pid, no status) and decides busy or idle from the tail of that session's transcript
and its sub-agents' activity. A switch waits while the session is busy.

### D-3 — The provider is per project; the model is the user's

State is keyed by workspace folder and the shim resolves the project from its cwd. The
switcher changes the provider and never the model choice, which stays with `/model`.

### D-4 — A provider is a named env profile

A provider is either the reserved `anthropic` (the environment passes through clean) or the
basename of `~/.config/gephyra/<name>.env` (characters `[A-Za-z0-9_-]`).

Two rules follow. Usage readers are chosen by the profile's base-URL hostname, not its name
(`*.z.ai` reads the GLM quota endpoint, `*.kimi.com` the Kimi one, anything else shows no
usage), so profiles can be named freely. And a profile whose env file is missing resolves to
`anthropic` in both the shim and the extension, so the status bar never shows a provider the
spawned CLI would not get.

### D-5 — Models are switched through the four tier variables

Claude Code's `/model` picker is filled from `ANTHROPIC_DEFAULT_{OPUS,SONNET,HAIKU,FABLE}_MODEL`,
not from the provider's `/v1/models`, and its gateway discovery drops ids that do not start
with `claude` or `anthropic`. So the four tiers are both the labels and the model switcher,
and `/model <raw-id>` reaches a fifth model.

A profile therefore sets the whole family plus `CLAUDE_CODE_SUBAGENT_MODEL` (`ANTHROPIC_MODEL`
alone changes the model served but not the labels), maps the tiers to distinct models, and may
add `*_MODEL_NAME` and `*_DESCRIPTION` for friendly labels. The labels change only in a
conversation spawned under the provider; `/status` shows what is actually served.

### D-6 — A switch restarts the CLI and reopens the open panels

The Claude Code extension keeps one CLI process per window and has no restart command, so a
new profile would only apply after a window reload. With `gephyra.restartCliOnSwitch` on (the
default), the switcher finds the CLI with `pgrep -P <extension host pid>`, keeps only
processes under the Claude Code extension's install path, and sends SIGTERM. Errors are
ignored and the reload path still works.

It then reopens every Claude panel bound to a session: each is checked for busy, closed,
awaited until its registry entry disappears, and reopened by session id with
`claude-vscode.editor.open(sessionId, prompt, viewColumn)` in its original column, the
focused panel last. Tabs are bound to sessions in `src/tabs.ts` from three signals: tab
open and close events, the registry entry each spawn writes, and an order-preserving pairing
poll (every 2 s, entries must agree within 15 s) so sidebar and terminal spawns cannot take
a tab's binding.

CLI processes that back open conversations in this workspace are killed only after their
registry entry disappears, so no "exited with code 143" banner is painted into a live view.
`registeredSessionPidsFor(projectPath)` filters on `cwd == projectPath` and
`entrypoint == "claude-vscode"`; without that filter, any open conversation in any project
blocks every switch.

The toast after a switch (`gephyra.switchToast`, on by default) offers a new conversation or
a window reload, and is the only place the flow is explained to a new user.

### D-7 — Remote reach uses Anthropic's Remote Control

`gephyra.beam` resumes the project's active session in an integrated terminal with
`--remote-control --permission-mode bypassPermissions`, injecting the provider's environment
itself (terminal spawns do not go through the wrapper). Closing the window ends the beam.
The switcher never turns on Remote Control for all sessions.

**Rejected:** a web app or relay of our own. The Remote Control view in the Claude apps
already covers watching a session, answering its questions and sending the next step.

### D-8 — Provider traffic is never proxied, with one opt-in exception

The switcher does not intercept provider traffic and does not take part in OAuth flows. The
official extension stays the only conversation UI.

The exception is the vision proxy (`gephyra.visionProxy`, off by default), a fallback for
providers whose image handling fails. It is an in-process `node:http` server
(`src/visionProxy.ts`). When it is on and `~/.config/gephyra/anthropic-vision.env` holds a
pay-as-you-go key, it writes `visionProxyUrl` into `state.json`, and the wrapper points
non-Anthropic providers at `http://127.0.0.1:<port>/<provider>`. A request goes to Anthropic
only when the last user message carries an image, or when the last message is a tool result
continuing a loop Anthropic started; everything else goes to the provider unchanged, with only
the model field rewritten on the redirected turns.

It fails open: the wrapper uses the proxy only while `visionProxyUrl` is present, so a missing
or unreachable proxy means direct injection. One fixed port is shared across windows (the
first to bind hosts it; the others health-probe it and take over if the host dies). Shutdown
closes all connections so the port frees at once, and every request aborts its upstream call
when the client disconnects, so no stream keeps billing.

### D-9 — Claude Code's credential is read, never written

Live Anthropic usage (`gephyra.anthropicLiveUsage`, off by default) reads the access token
Claude Code keeps in the macOS Keychain (service `Claude Code-credentials`, account
`claude-code-user` first) and calls `api.anthropic.com/api/oauth/usage`, the endpoint Claude
Code itself uses. The token is used only while unexpired (60 s margin); otherwise the cycle
is skipped and the statusline feed answers. The response carries `utilization` and an
ISO-8601 `resets_at`; `usageWindow()` also parses the statusline's field shape.

The refresh token rotates, so refreshing it logs Claude Code out. Re-login is delegated:
`gephyra.loginAnthropic` opens a terminal running `claude login`, and Claude Code stores the
credential. Any feature that would write, refresh or rotate a credential is out of bounds.

## Failed approaches: do not re-attempt

Each of these was built, shipped or tested, and reverted. The open issues in the README
("mixed reopen order", "moved-tab unbinding") are open because their obvious fixes are here.

- **Restoring tab order with `moveActiveEditor`.** The reopened panel is not reliably the
  active editor when the command runs, so it moved the wrong editors, including across groups
  where tab objects are recreated, and lost tabs. Mixed reopen order is the accepted cost.
- **Reopening in original (column, index) order.** VS Code inserts a new tab to the right of
  the active tab, not at the group's end, so reopen order never determines final order.
- **Transferring bindings for moved tabs.** A move between groups arrives as a paired close
  and open with no new process, so the binding cannot re-pair; pairing `closed[i]` with
  `opened[i]` mis-bound tabs. Moved tabs stay unbound and keep their provider until closed.
- **Trusting `editor.open`'s return value.** The extension's session-to-panel map can outlive
  the dying CLI, so the call reveals the dying panel and returns cleanly. `openSessionPanel`
  counts Claude panels before the call and reports success only when a new panel appears
  (watched for up to 1 s).
- **Binding a tab to any registry entry that appears after it opens.** Opening a panel fires
  short-lived warm-up spawns that also register; binding to one reopened an id with no
  transcript as a blank panel. Pairing requires the candidate pid to be alive, and respawn
  refuses to close a tab whose session has no transcript content.
- **Using tab snapshots taken before the kill.** After groups renumber, stale `Tab` objects
  make `close()` fail silently. Tabs are re-resolved from bindings when used, a failed close
  means "leave the tab", deregistration is awaited before reopening, one retry follows after
  500 ms, and a remaining failure shows a warning naming the session.
- **Refreshing the OAuth token.** See D-9.

## Behaviour of Claude Code that the code relies on

- **The wrapper's arguments.** The extension calls the wrapper with the real CLI path as the
  first argument, followed by the full flag list, so the executable-passthrough branch in the
  wrapper is the live one; the node and `find_cli` branches are fallbacks. It also calls the
  wrapper for `auth status --json` probes and a `--thinking disabled` warm-up, about three
  calls per panel open.
- **The session registry.** A clean exit removes `~/.claude/sessions/<pid>.json`. SIGKILL
  leaves a stale entry that nothing removes, which is why `pidAlive()` in `src/busy.ts` is
  required. `peerProtocol` is a bare version number, so there is no richer status channel.
