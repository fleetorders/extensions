# extensions

Alkis Yuv's editor extensions — one monorepo, one naming standard.

| Extension | What it does | Install |
| --- | --- | --- |
| [Claude Provider Switcher](claude-provider-switcher/) | Switches the official Claude Code extension between Anthropic and GLM providers per project | `ext install alkisyuv.claude-provider-switcher` |
| [Explorer Follows Terminal](explorer-follows-terminal/) | In multi-root workspaces, the Explorer reveals the workspace folder of the focused terminal | `ext install alkisyuv.explorer-follows-terminal` |
| [Markdown Preview Style](markdown-preview-style/) | A markdown-preview reading stylesheet, contributed globally so every workspace gets it | `ext install alkisyuv.markdown-preview-style` |

## Conventions

- **Descriptive names.** Extension names say what the extension does;
  kebab-case IDs match the display names. Codenames are reserved for
  standalone products, not shelf tools.
- **One folder per extension** at the repo root, each with its own
  `package.json`, README, and `repository.directory` pointing here, so
  marketplace listings link into the right folder.
- **Publishing** is per folder: `npx @vscode/vsce package/publish` from
  inside the extension's directory. Versions and changelog entries are
  managed with changesets.

## History

Claude Provider Switcher was previously published as `alkisyuv.gephyra`
(that listing is deprecated and points here) and lived in its own repository;
its full commit history was merged into this monorepo when the family
consolidated.

## License

[MIT](LICENSE)
