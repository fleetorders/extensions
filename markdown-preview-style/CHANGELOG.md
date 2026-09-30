# Changelog

## 1.1.1

### Patch Changes

- cf0fbc3: README documents the local override (`markdownPreviewStyle.localOverride`), which v1.1.0 shipped undocumented.

## 1.1.0

### Minor Changes

- ba7f8c1: Local override loader: the extension now layers an optional machine-local stylesheet (`markdownPreviewStyle.localOverride`, default `~/.config/markdown-preview-style/override.css`) over its bundled one, syncing it in on activation and on change with a reload prompt. Style tweaks on one machine no longer require repackaging or a release; without the local file nothing changes.

### Patch Changes

- 0cdd127: Display elements breathe: blockquotes, code blocks, tables, figures and collapsibles get 1.8em of space above and below, shared by one rule, so a block reads as its own thing rather than as the tail of the paragraph before it (tables previously sat at 1.2em, blockquotes and code blocks at the browser default).
- New marketplace icon and README layout; the Repository link on the listing now opens this extension's folder.
