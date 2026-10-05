# Claude Code Provider Switcher

## 0.7.2

### Patch Changes

- 8f29162: Messages and the README use the extension's name instead of its former codename, and the README's setting and command names are correct again.
- 2323efc: The vision proxy's health check uses the extension's name. The previous path and marker are still answered and probed for one release, so windows on the old and new versions share one proxy during the upgrade.

## 0.7.1

### Patch Changes

- New marketplace icon and README layout; the Repository link on the listing now opens this extension's folder.

## 0.7.0

### Minor Changes

- 0ee76f6: Renamed from gephyra to Claude Code Provider Switcher: the extension ID changes
  from `alkisyuv.gephyra` to `alkisyuv.claude-code-provider-switcher` (the old
  listing is deprecated with a pointer here), the repository moves into the
  extensions monorepo, and the README leads with the new name. No behavior
  changes; internal configuration keys are unchanged.

## 0.6.2

### Patch Changes

- The extension package ships only what runs — dev-only files are excluded.
- Documentation and record-keeping cleanups.

## 0.6.1

### Patch Changes

- The usage probe is read-only now: it no longer refreshes the CLI's OAuth
  token.

## 0.6.0

### Minor Changes

- Opt-in vision proxy, off by default.

## 0.5.0

### Minor Changes

- Live Claude usage with a weekly bar, and delegated re-login.

## 0.4.0

### Minor Changes

- Provider profiles: any Anthropic-compatible endpoint via a named `<name>.env`
  profile, with a Kimi adapter included.
- Live provider switching for open conversations; the post-switch toast can be
  turned off in settings.
