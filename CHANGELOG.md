# gephyra

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
