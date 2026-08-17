/**
 * Explorer Follows Terminal — in a multi-root workspace, the Explorer reveals
 * the workspace folder of the focused terminal's working directory.
 *
 * The terminal's directory comes from VS Code's shell integration
 * (`terminal.shellIntegration.cwd`, reported per prompt), so this also works
 * through multiplexers like tmux as long as the shell reports its cwd. Panes
 * whose cwd is outside every workspace folder are skipped silently.
 */
const vscode = require("vscode");

let lastRevealed; // Uri of the last folder revealed — skip no-op repeats

function config() {
  return vscode.workspace.getConfiguration("explorerFollowsTerminal");
}

function sync(terminal) {
  if (!terminal || !config().get("enabled", true)) return;
  const cwd = terminal.shellIntegration && terminal.shellIntegration.cwd;
  if (!cwd) return;
  const folder = vscode.workspace.getWorkspaceFolder(cwd);
  if (!folder) return;
  if (lastRevealed && lastRevealed.toString() === folder.uri.toString()) return;
  lastRevealed = folder.uri;
  if (config().get("focusView", false))
    vscode.commands.executeCommand("workbench.view.explorer");
  vscode.commands.executeCommand("revealInExplorer", folder.uri);
}

function activate(context) {
  context.subscriptions.push(
    vscode.window.onDidChangeActiveTerminal(sync),
    // Re-sync when the *focused* terminal changes directory (cd between roots).
    vscode.window.onDidChangeTerminalShellIntegration((e) => {
      if (e.terminal === vscode.window.activeTerminal) sync(e.terminal);
    }),
  );
}

module.exports = { activate, deactivate() {} };
