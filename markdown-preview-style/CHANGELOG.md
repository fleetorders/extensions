# Changelog

## 1.1.1

### Patch Changes

- cf0fbc3: README documents the local override (`markdownPreviewStyle.localOverride`), which v1.1.0 shipped undocumented.

## 1.1.0

### Minor Changes

- ba7f8c1: Local override loader: the extension now layers an optional machine-local stylesheet (`markdownPreviewStyle.localOverride`, default `~/.config/markdown-preview-style/override.css`) over its bundled one, syncing it in on activation and on change with a reload prompt. Style tweaks on one machine no longer require repackaging or a release; without the local file nothing changes.

### Patch Changes

- 0cdd127: Display elements breathe: blockquotes, code blocks, tables, figures and collapsibles get 1.8em of space above and below, shared by one rule, so a block reads as its own thing rather than as the tail of the paragraph before it (tables previously sat at 1.2em, blockquotes and code blocks at the browser default).
- 0cdd127: Family standardization pass: marketplace icons for all three in the family's night-and-gold language (the original bridge icon restored for the provider switcher; night-tree and pendant-lamp scenes with SVG sources for the other two), a consistent README skeleton (one-liner, Install for both marketplaces, license), repository links now point at each extension's child folder (the rename had left the old folder path, breaking listing links and README badge URLs — D-005), root repo metadata (repository, license, author), and the previously-published/formerly references dropped from the READMEs (root and switcher) with the banner renamed to the standard filename.

Versions and entries are managed with changesets; notes appear here at release time.
