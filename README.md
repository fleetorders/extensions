# extensions

<div align="center">
  <img src="https://raw.githubusercontent.com/triartleet/extensions/main/media/extensions-logo.png" width="520" alt="extensions — a night sky over water; a pair of golden braces stands open, holding room for the family's members">
</div>

**Editor extensions — one monorepo, one naming standard.**

Small tools that each do one thing in the editor; this repo is their shared
home — one folder per extension, one look, one publishing standard. Everything
is MIT and published to both the VS Code Marketplace and Open VSX.

| Extension | What it does | Install |
| --- | --- | --- |
| [Claude Code Provider Switcher](claude-code-provider-switcher/) | Switches the official Claude Code extension between Anthropic and GLM providers per project | `ext install alkisyuv.claude-code-provider-switcher` |
| [Explorer Follows Terminal](explorer-follows-terminal/) | In multi-root workspaces, the Explorer reveals the workspace folder of the focused terminal | `ext install alkisyuv.explorer-follows-terminal` |
| [Markdown Preview Style](markdown-preview-style/) | A markdown-preview reading stylesheet, contributed globally so every workspace gets it | `ext install alkisyuv.markdown-preview-style` |

All three are also published to [Open VSX](https://open-vsx.org/publisher/alkisyuv), so Cursor and VSCodium install the same ids.

## Conventions

- **Descriptive names.** Extension names say what the extension does;
  kebab-case IDs match the display names. Codenames are reserved for
  standalone products, not shelf tools.
- **One folder per extension** at the repo root, each with its own
  `package.json` and README, its `repository.url` pointing at the folder's
  tree path, and the family surface (D-004): shared README skeleton,
  `media/icon.png` with SVG source, `LICENSE`, `CHANGELOG.md`.
- **Publishing** is per folder: `npx @vscode/vsce package/publish` from
  inside the extension's directory. Versions and changelog entries are
  managed with changesets.

## License

[MIT](LICENSE)
