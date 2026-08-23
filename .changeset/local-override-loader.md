---
'markdown-preview-style': minor
---

Local override loader: the extension now layers an optional machine-local stylesheet (`markdownPreviewStyle.localOverride`, default `~/.config/markdown-preview-style/override.css`) over its bundled one, syncing it in on activation and on change with a reload prompt. Style tweaks on one machine no longer require repackaging or a release; without the local file nothing changes.
