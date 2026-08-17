# Explorer Follows Terminal

> The file tree follows the terminal you're in.

In a **multi-root workspace**, the Explorer sidebar reveals the workspace
folder of the **focused terminal's working directory**. Click a terminal,
get that project's file tree — no manual navigation, no second click.

Built for terminal-centric workflows: multi-project windows, monitor panes,
agent cockpits. If you keep one workspace window open with many project
folders and many terminals, this keeps the file list where your attention
already is.

## Install

- **VS Code** — install from the
  [VS Code Marketplace](https://marketplace.visualstudio.com/items?itemName=alkisyuv.explorer-follows-terminal),
  or `code --install-extension alkisyuv.explorer-follows-terminal`
- **Cursor / VSCodium** — served from
  [Open VSX](https://open-vsx.org/extension/alkisyuv/explorer-follows-terminal),
  or `cursor --install-extension alkisyuv.explorer-follows-terminal`

## How it works

- When the **active terminal changes** (you click into another pane), the
  extension reads the terminal's current working directory from VS Code's
  shell integration and reveals the containing workspace folder in the
  Explorer.
- When the **focused terminal changes directory** into a different root
  (`cd ../other-project`), the Explorer follows again.
- Terminals whose working directory is outside every workspace folder are
  skipped silently.

## Requirements

Shell integration must be active in your shells (it is by default for
PowerShell, bash, zsh, fish and others). The directory signal also survives
multiplexers such as tmux when the inner shell reports its cwd.

## Settings

| Setting | Default | Description |
| --- | --- | --- |
| `explorerFollowsTerminal.enabled` | `true` | Reveal the focused terminal's workspace folder in the Explorer. |
| `explorerFollowsTerminal.focusView` | `false` | Also move keyboard focus to the Explorer view (by default the tree is revealed, not focused). |

## License

[MIT](LICENSE)
