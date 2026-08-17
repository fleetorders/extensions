# Markdown Preview Style

> A comfortable reading stylesheet for the markdown preview, in every workspace.

A markdown-preview reading stylesheet, contributed as a global extension so
every workspace gets it — no per-repo settings, no per-repo CSS files.

## Install

- **VS Code** — install from the
  [VS Code Marketplace](https://marketplace.visualstudio.com/items?itemName=alkisyuv.markdown-preview-style),
  or `code --install-extension alkisyuv.markdown-preview-style`
- **Cursor / VSCodium** — served from
  [Open VSX](https://open-vsx.org/extension/alkisyuv/markdown-preview-style),
  or `cursor --install-extension alkisyuv.markdown-preview-style`

Nothing to enable: the stylesheet applies the moment the extension is
installed.

## Why an extension and not the `markdown.styles` setting

`markdown.styles` pointed at the same CSS by absolute path and failed with
*"Could not load 'markdown.styles'"* — that is not a missing file, it is how
the preview webview works: it only loads resources under extension
contributions or open workspace folders, so a path outside the workspace is
refused outright. Contributing the stylesheet through an extension sidesteps
the restriction entirely.

## What it styles

See [`preview.css`](preview.css) — a comfortable reading measure, calmer
heading scale, and code blocks that read as blocks. Edit the CSS and rebuild
the extension to see changes; the shipped stylesheet is the built artifact.

## License

[MIT](../LICENSE)
