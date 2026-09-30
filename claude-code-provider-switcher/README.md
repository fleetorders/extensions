# Claude Code Provider Switcher

<div align="center">
  <img src="https://raw.githubusercontent.com/fleetorders/extensions/main/claude-code-provider-switcher/media/claude-code-provider-switcher-logo.png" width="520" alt="Claude Code Provider Switcher — a bridge from your editor to whichever provider you pick">
  <p>
    <a href="https://marketplace.visualstudio.com/items?itemName=alkisyuv.claude-code-provider-switcher"><img src="https://img.shields.io/visual-studio-marketplace/v/alkisyuv.claude-code-provider-switcher?label=VS%20Marketplace&color=0066b8" alt="VS Marketplace"></a>
    <a href="https://open-vsx.org/extension/alkisyuv/claude-code-provider-switcher"><img src="https://img.shields.io/open-vsx/v/alkisyuv.claude-code-provider-switcher?label=Open%20VSX&color=a60ee5" alt="Open VSX"></a>
    <a href="https://github.com/fleetorders/extensions/blob/main/claude-code-provider-switcher/LICENSE"><img src="https://img.shields.io/badge/license-MIT-green" alt="MIT license"></a>
  </p>
</div>

**Give every project its own AI subscription.**

One AI subscription answers every project you work on, so they all drain the same allowance — and when you hit the limit, everything stops, whether a project needed the expensive plan or not.

Claude Code Provider Switcher adds a switch to the Claude Code extension in Cursor and VS Code so each project can pick its own provider — the company and subscription that answers your AI requests. The other providers are separate subscriptions you sign up and pay for yourself; it connects them, it doesn't include them. Installing it changes nothing until you accept the one pop-up question it shows and opt a project in. And if it is ever broken, misconfigured, or deleted, Claude Code keeps working as if it were never installed.

Works on macOS and Linux (not Windows), alongside the official Claude Code extension.

Your status bar afterwards — one meter per subscription (C = Claude, G = GLM, K = Kimi):

```text
⇄ Claude · C 28% · G 1% · K 7%
```

## Your first switch

1. **Install the extension and accept the one-time pop-up question** it shows — that single yes is all the setup Claude Code itself needs. If you decline, the extension does nothing at all. Details in [Install](#install).
2. **Add one provider.** [Provider setup](#provider-setup) walks you through it: you copy a short ready-made block into a small text file and paste in the sign-in details the provider gives you — the blocks for z.ai's GLM plan and Moonshot's Kimi plan are ready to copy. Each provider you add becomes one choice on the switch.
3. **Click the `⇄` item in the status bar and start a new conversation.** That conversation is answered by the provider you just picked — in this project only.

From then on the meter at the bottom of the window shows how much of each subscription's allowance you've used and when it resets, side by side.

## What you get

- **A per-project switch** — a switch changes which provider this project's next conversations use; other projects and windows are untouched. → [Everyday use](#everyday-use)
- **Any compatible provider** — each one is a small saved file with its connection details; GLM and Kimi also show their allowance numbers in the meter, other providers work but show no numbers. → [Provider setup](#provider-setup)
- **Side-by-side usage meters** — the status bar readout shows every subscription's allowance and reset time at once. → [Usage readouts](#usage-readouts)
- **Live Claude usage** *(opt-in, off by default; macOS only)* — the Claude number refreshes on its own instead of waiting for other activity. → [Usage readouts](#usage-readouts)
- **Vision fallback** *(opt-in, off by default)* — if a provider mishandles images, the messages that carry images can be answered by Claude instead, billed per use to a separate account you set up: an extra cost, and only if you turn this on. → [Vision fallback](#vision-fallback-opt-in-proxy)
- **The busy gate** — while an answer is being written, switching waits; forcing it asks you first. → [Everyday use](#everyday-use)
- **Conversations carry over** — continue any conversation on the other provider from Claude Code's own list of past conversations; nothing is copied. → [Everyday use](#everyday-use)
- **Beam to phone** — beam is sending an ongoing conversation to your phone while the work keeps running on your computer; it needs the Claude app on your phone, signed in to your Claude account. → [Everyday use](#everyday-use)
- **Fail-open safety** — the extension failing can never take Claude Code down with it; the worst case is that the switch quietly does nothing. → [How it works](#how-it-works)

## How it works

A **provider** is the company and subscription that answers your AI requests: Anthropic's Claude plan, z.ai's GLM plan, Moonshot's Kimi plan. A **profile** is a small file with the connection details for one provider, and each profile is one choice on the switch. Anthropic needs no file; it is the built-in default the extension leaves untouched. Any other Anthropic-compatible service (one that accepts the request format Claude Code already uses) works too, without usage numbers.

- **A switch applies to the next new conversation** in the project. A conversation that is writing an answer is never interrupted: the busy gate holds the switch until the answer finishes, and forcing it asks you first.
- **Open conversations move with the switch.** The extension tracks which conversation each Claude tab hosts, and on a switch closes and reopens each tracked tab on the same conversation under the new provider: same transcript, one flicker, each tab back in its column, focus back on the tab you were on. Tabs it could not identify (open since before it started) move when you close and resume them.
- **The wrapper.** The extension sets one official Claude Code setting, `claudeCode.claudeProcessWrapper`, to a small POSIX-sh script (`bin/gephyra-wrapper`, copied to `~/.config/gephyra/`). Each time Claude Code starts its CLI, the script reads the project's provider from `~/.config/gephyra/state.json` (workspace path → provider name, plus a `default`) and starts the real CLI either untouched (Anthropic) or with that provider's profile in its environment.
- **Restart on switch** (`gephyra.restartCliOnSwitch`, on by default). Claude Code keeps one CLI process per window, so the extension ends this window's idle CLI after a switch; the next conversation starts under the new provider and `/model` shows its model names without a window reload. A process behind a still-open conversation is ended only after that conversation closes, so no "process exited" error appears.
- **Busy detection.** The extension finds the project's live conversation in Claude Code's session registry (`~/.claude/sessions/<pid>.json`) and reads the end of its transcript, sub-agents included. Long silent tool runs count as busy (the safe side), and a conversation silent for 30 minutes stops counting.
- **Model-name fallback.** A profile that leaves out the `ANTHROPIC_DEFAULT_<TIER>_MODEL[_NAME]` variables takes them from `glm.env`, so `/model` shows real names. Connection variables are never borrowed, and a profile that sets its own tiers (like `kimi.env`) is left alone.
- **Fail-open.** On any doubt (missing state, unreadable profile, provider down) the wrapper starts the real CLI untouched. If the extension is broken, misconfigured or deleted, Claude Code works as if it were never installed; the worst case is a switch that does nothing.
- **Nothing hidden.** By default the extension never intercepts your traffic and never touches your sign-in. The two exceptions are opt-in and off by default: [live Claude usage](#usage-readouts) and the [vision fallback](#vision-fallback-opt-in-proxy).

**Why "gephyra"?** It is the extension's original name. Its settings, commands, config directory (`~/.config/gephyra/`), `GEPHYRA_*` variables and wrapper script keep that prefix, so existing settings keep working.

## Install

From a marketplace:

- **Cursor / VSCodium**: search **"Claude Code Provider Switcher"** in the Extensions panel
  (served from [Open VSX](https://open-vsx.org/extension/alkisyuv/claude-code-provider-switcher)),
  or `cursor --install-extension alkisyuv.claude-code-provider-switcher`.
- **VS Code**: install from the
  [VS Code Marketplace](https://marketplace.visualstudio.com/items?itemName=alkisyuv.claude-code-provider-switcher),
  or `code --install-extension alkisyuv.claude-code-provider-switcher`.

Or build from source (Node 20 or later):

```bash
git clone https://github.com/fleetorders/extensions
cd extensions
npm ci
cd claude-code-provider-switcher
npm run build
npx @vscode/vsce package --no-dependencies
cursor --install-extension claude-code-provider-switcher-*.vsix   # or: code --install-extension …
```

Requires the official **Claude Code** extension, on macOS or Linux (the wrapper is POSIX sh).

## Setup

1. **Configure the wrapper.** On first activation the extension offers to point
   `claudeCode.claudeProcessWrapper` at its wrapper (a copy under `~/.config/gephyra/`,
   refreshed on every activation). Decline and the extension stays inert. The setting is
   global: every window starts the CLI through the wrapper, which passes straight through
   for Anthropic.
2. **Add provider profiles**: `~/.config/gephyra/<name>.env` files, see
   [Provider setup](#provider-setup). With no profiles, the switch says there is nothing to
   switch to.
3. **(Optional) Feed the Claude usage readout.** Claude Code hands `rate_limits` only to
   statusline scripts, so the extension reads a copy of that payload. If you use a custom
   statusline, add this after it reads stdin (it can never break the status line):

   ```bash
   # after: input=$(cat)
   {
     gephyra_dir="$HOME/.config/gephyra"
     mkdir -p "$gephyra_dir" &&
       printf '%s' "$input" >"$gephyra_dir/statusline-last.json.tmp" &&
       mv -f "$gephyra_dir/statusline-last.json.tmp" "$gephyra_dir/statusline-last.json"
   } 2>/dev/null || true
   ```

   Without it, the Claude column says why it is unavailable; everything else works.
   [Live Claude usage](#usage-readouts) and the
   [vision fallback](#vision-fallback-opt-in-proxy) are optional too.

## Provider setup

Profiles live at `~/.config/gephyra/<name>.env`: strict `KEY=value` lines, parsed, never
sourced as shell, never committed anywhere.

### GLM (z.ai Coding Plan)

`glm.env`, per z.ai's Claude Code docs:

```bash
ANTHROPIC_BASE_URL=https://api.z.ai/api/anthropic
ANTHROPIC_AUTH_TOKEN=your-coding-plan-key
ANTHROPIC_DEFAULT_OPUS_MODEL=glm-5.3[1m]
ANTHROPIC_DEFAULT_SONNET_MODEL=glm-5.3[1m]
ANTHROPIC_DEFAULT_HAIKU_MODEL=glm-4.7
ANTHROPIC_SMALL_FAST_MODEL=glm-4.7
```

### Kimi Code (Moonshot)

`kimi.env`, per Moonshot's Kimi Code docs for Claude Code. Their endpoint does **not** map
Claude model names, so every tier is set; Tool Search is not supported on their side. See the
Kimi item under [Known issues and limitations](#known-issues-and-limitations) for what is verified.

```bash
ANTHROPIC_BASE_URL=https://api.kimi.com/coding/
ANTHROPIC_API_KEY=sk-kimi-your-coding-key
ANTHROPIC_AUTH_TOKEN=sk-kimi-your-coding-key
ANTHROPIC_MODEL=k3
ANTHROPIC_DEFAULT_OPUS_MODEL=k3
ANTHROPIC_DEFAULT_SONNET_MODEL=k3
ANTHROPIC_DEFAULT_HAIKU_MODEL=kimi-for-coding
CLAUDE_CODE_SUBAGENT_MODEL=kimi-for-coding
CLAUDE_CODE_MAX_CONTEXT_TOKENS=262144
CLAUDE_CODE_AUTO_COMPACT_WINDOW=262144
ENABLE_TOOL_SEARCH=false
```

### Any other Anthropic-compatible endpoint

Any `~/.config/gephyra/<name>.env` file is a provider: add the file and it appears in the
switch. Unknown endpoints work fully but show no usage numbers.

### Vision fallback (opt-in proxy)

Some providers mishandle pasted images, and the failure is silent: the model describes a
plausible picture it never received. With **`gephyra.visionProxy`** on and a pay-as-you-go
Anthropic key in `~/.config/gephyra/anthropic-vision.env`, image turns go to Anthropic
(billed per use to that key) while text and code stay on the provider. The
[vision fallback guide](https://github.com/fleetorders/extensions/blob/main/claude-code-provider-switcher/docs/vision-fallback.md) covers the probe that tells you whether you need it, the setup,
and how the routing works.

## Everyday use

### Switching providers

Click the **`⇄`** status-bar item: with two providers it flips to the other one, with three
or more it opens a picker showing each provider's 5-hour usage. Then start a **new
conversation** (the notification offers it). To continue a conversation on the other
provider, resume it from Claude Code's session list (Claude Code calls a saved conversation
a *session*); the transcript carries over.

### Switching models within a provider

Each profile maps Claude Code's four model tiers (`fable`, `opus`, `sonnet`, `haiku`) to
distinct models of that provider, so the **`/model` picker switches models**, live. The tiers
show the provider's model names because the profile sets the
`ANTHROPIC_DEFAULT_<TIER>_MODEL` variables.

- **The names show only in a conversation started under the provider.** `/model` reads the
  environment when the conversation starts; start a new one after switching.
- **More than four models?** Type one directly: **`/model kimi-for-coding-highspeed`**. Behind
  a custom endpoint the name is passed through unchecked.
- `/status` shows what actually serves a turn.

### Beam a session to your phone (Remote Control)

The Claude Code extension cannot turn on Anthropic's Remote Control, but its sessions are
shared with the CLI. Before stepping away, run **`Claude Code Provider Switcher: Beam session
to phone (Remote Control)`** from the command palette. The extension resumes the project's
active session in an integrated terminal as
`claude --resume <id> --remote-control <name> --permission-mode bypassPermissions`
(permission prompts are skipped so the session does not stall while you are away), under the
project's provider. The session then shows in the Claude mobile app and at claude.ai/code:
answer its questions, send the next step, switch models, while it runs on your computer. The
first beam may ask you to pair your Claude account. Beaming waits while the session is busy.
Close the panel for that session first: two surfaces replying to one session fork it.

To come back, `/exit` the beamed terminal, then resume the session from the Claude panel's
**local** session list; a fresh resume reads the whole transcript, phone turns included. Do
not reopen the old tab: it shows the transcript as it was before the beam.

## Usage readouts

The status item shows every provider's 5-hour **and weekly** usage plus the next 5-hour reset:

```text
⇄ Claude │ C 28%/82% ↻14:00 · G 1%/40% ↻15:30
```

The tooltip adds plan tiers and reset times, and the item turns to the warning color when the
active provider passes 80% of its 5-hour window. Profiles are matched to a usage reader by the
hostname of their base URL: z.ai reads the GLM Coding Plan quota endpoint, kimi.com the Kimi
Code usage endpoint (community-documented, so an unexpected response shows "usage
unavailable"), anything else shows no numbers.

The Claude side reads the statusline copy from setup step 3, which updates only when a
terminal `claude` session takes a turn; after 30 minutes it is marked "as of HH:MM". With
**`gephyra.anthropicLiveUsage`** on (macOS only), the extension instead reads the access token
Claude Code keeps in the Keychain and asks the usage endpoint directly, so the number stays
fresh in the panel too. It only reads that token: refreshing it would log the CLI out. While
the token is expired it falls back to the statusline copy until Claude Code renews it. If
your sign-in itself has lapsed, run **`Claude Code Provider Switcher: Re-login Anthropic`**,
which runs `claude login`.

## Settings

| Setting | Default | What it does |
| --- | --- | --- |
| `gephyra.quietWindowMs` | `2500` | How long the transcript must be silent before a session counts as idle. |
| `gephyra.switchToast` | `true` | The notification after a switch, with a [New conversation] button. Off: the status-bar label is the only confirmation. |
| `gephyra.restartCliOnSwitch` | `true` | End this window's idle CLI after a switch and reopen tracked tabs, see [How it works](#how-it-works). |
| `gephyra.anthropicLiveUsage` | `false` | Read live Claude usage with the token Claude Code keeps in the Keychain (read-only). macOS only. |
| `gephyra.visionProxy` | `false` | The [vision fallback](#vision-fallback-opt-in-proxy). Off: nothing is proxied. |
| `gephyra.visionProxyPort` | `4399` | The vision proxy's localhost port, shared across windows. |
| `gephyra.visionModel` | `"claude-sonnet-5"` | Claude model for image turns; `GEPHYRA_VISION_MODEL` in the env file overrides it. |

| Command | Title |
| --- | --- |
| `gephyra.toggle` | Claude Code Provider Switcher: Switch provider for this project (Claude ⇄ GLM ⇄ …) |
| `gephyra.setupWrapper` | Claude Code Provider Switcher: Configure Claude Code process wrapper |
| `gephyra.beam` | Claude Code Provider Switcher: Beam session to phone (Remote Control) |
| `gephyra.loginAnthropic` | Claude Code Provider Switcher: Re-login Anthropic (run claude login) |

## Debugging

`touch ~/.config/gephyra/debug-on` (or `GEPHYRA_DEBUG=1` in the environment Claude Code
starts with) makes the wrapper log its arguments, cwd and provider choice to
`~/.config/gephyra/debug.log` (size-capped). `GEPHYRA_GLM_ENV` overrides the path of
`glm.env`.

## Known issues and limitations

- **Reopened tabs come back in mixed order.** VS Code inserts a new tab to the right of the
  active one, and moving tabs afterwards can move the wrong editors, so order is not restored.
- **A tab dragged to another editor group loses its tracking.** It keeps its provider until
  closed and resumed.
- **The tab focused when the window loads starts untracked** until it is the project's only
  conversation, or until you interact with it after another tab is tracked.
- **A single tab may rarely fail to reopen.** If a reopen fails twice, a warning names the
  session.
- **A new GLM conversation may open on the small model** (for example `glm-4.7`), depending on
  the panel's remembered model choice. Check `/model` after switching; the extension never
  changes the model.
- **Kimi**: the pay-as-you-go endpoint is verified (a real CLI turn served by `kimi-k3`); the
  Kimi Code plan endpoint and its usage readout are not yet. Expect WebFetch not to work,
  Tool Search to stay off, and Kimi's own prompt caching.
- **Remote Control is Anthropic-only.** The CLI turns it off whenever `ANTHROPIC_BASE_URL` is
  set, so a beamed GLM or Kimi session runs as a plain terminal session without phone reach.
  The panel does not show turns made from the phone; resume the session when you are back.
  The extension never turns on "Enable Remote Control for all sessions".
- **The Claude Code extension can change.** A release may change the wrapper setting or how it
  starts the CLI. The wrapper fails open, so the failure is a switch that does nothing, never a
  broken Claude Code; re-check after major updates.
- The Claude panel may show Claude model names in some places under another provider; the
  status bar shows the real provider.

## Roadmap

- **Remote reach for other providers.** Remote Control is Anthropic-only, so look at other
  ways to reach sessions served by other providers.
- **Tests for switch behaviour**: simulated registry entries, scripted tab events and runs of
  many consecutive switches, so the known issues above can be fixed without breaking tabs.
- Verify the Kimi Code plan endpoint (auth variable, model tiers, usage response).
- A button in the Claude panel's title bar beside the status-bar item.
- Per-session provider badges in the tooltip.

The design record, including approaches already ruled out, is
[docs/decisions.md](https://github.com/fleetorders/extensions/blob/main/claude-code-provider-switcher/docs/decisions.md).

## License

[MIT](LICENSE). Not affiliated with Anthropic, Z.ai or Moonshot AI. Claude Code is a product
of Anthropic, PBC; use of each provider is governed by its own terms.
