# Markdown Preview Style

<div align="center">
  <img src="https://raw.githubusercontent.com/triartleet/extensions/main/markdown-preview-style/media/markdown-preview-style-logo.png" width="520" alt="Markdown Preview Style — a pendant lamp hangs over a wide open page, warm light on comfortable type">
  <p>
    <a href="https://marketplace.visualstudio.com/items?itemName=alkisyuv.markdown-preview-style"><img src="https://img.shields.io/visual-studio-marketplace/v/alkisyuv.markdown-preview-style?label=VS%20Marketplace&color=0066b8" alt="VS Marketplace"></a>
    <a href="https://open-vsx.org/extension/alkisyuv/markdown-preview-style"><img src="https://img.shields.io/open-vsx/v/alkisyuv/markdown-preview-style?label=Open%20VSX&color=a60ee5" alt="Open VSX"></a>
    <a href="https://github.com/triartleet/extensions/blob/main/markdown-preview-style/LICENSE"><img src="https://img.shields.io/badge/license-MIT-green" alt="MIT license"></a>
  </p>
</div>

**A comfortable reading stylesheet for the markdown preview, in every workspace.**

You want your markdown previews to read well — a comfortable measure, calmer
headings, code blocks that read as blocks — so you point VS Code's
`markdown.styles` setting at a CSS file, and the preview answers *"Could not
load 'markdown.styles'"*. That is not a missing file: the preview webview only
loads resources under extension contributions or open workspace folders, so a
path outside the workspace is refused outright.

Markdown Preview Style contributes the stylesheet as a global extension —
every workspace gets it, no per-repo settings, no per-repo CSS files. Nothing
to enable: it applies the moment the extension is installed.

## Install

- **VS Code** — install from the
  [VS Code Marketplace](https://marketplace.visualstudio.com/items?itemName=alkisyuv.markdown-preview-style),
  or `code --install-extension alkisyuv.markdown-preview-style`
- **Cursor / VSCodium** — served from
  [Open VSX](https://open-vsx.org/extension/alkisyuv/markdown-preview-style),
  or `cursor --install-extension alkisyuv.markdown-preview-style`

## What it styles

See [`preview.css`](preview.css) — a comfortable reading measure, calmer
heading scale, and code blocks that read as blocks. Edit the CSS and rebuild
the extension to see changes; the shipped stylesheet is the built artifact.

## License

[MIT](LICENSE)
