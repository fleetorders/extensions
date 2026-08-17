# gephyra

## 0.7.0

### Minor Changes

- 0ee76f6: Renamed from gephyra to Claude Provider Switcher: the extension ID changes
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

- Provider profiles: any OpenAI-compatible endpoint via a named `<name>.env`
  profile, with a Kimi adapter included.
- Live provider switching for open conversations; the post-switch toast can be
  turned off in settings.
