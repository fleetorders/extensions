/**
 * Markdown Preview Style — local override loader.
 *
 * The opinionated stylesheet ships inside the extension (preview.css,
 * contributed statically). This activation script adds a second, optional
 * layer: a machine-local CSS file the user edits freely. VS Code can only
 * inject stylesheets that live inside the extension, so on activation the
 * script copies the local file into the bundled local-override.css, and
 * watches it, offering a reload when it changes. No local file (the
 * default) means the bundled override stays empty and the extension
 * behaves exactly as before.
 *
 * A marketplace update overwrites local-override.css with the empty one;
 * the next activation re-syncs it from the local file.
 */
let vscode;
try {
  vscode = require("vscode");
} catch {
  vscode = null; // outside VS Code (tests); only the pure helpers are usable
}
const fs = require("fs");
const os = require("os");
const path = require("path");

function config() {
  return vscode.workspace.getConfiguration("markdownPreviewStyle");
}

/** Expand a leading ~ to the user's home directory. */
function expandHome(p) {
  return p.startsWith("~") ? path.join(os.homedir(), p.slice(1)) : p;
}

function overridePath() {
  const p = config().get(
    "localOverride",
    "~/.config/markdown-preview-style/override.css"
  );
  return p ? expandHome(p) : null;
}

/** Copy the local file over the bundled one when their content differs.
 *  Returns true when the bundled copy changed. */
function sync(localFile, bundledFile) {
  let want = "";
  try {
    want = fs.readFileSync(localFile, "utf8");
  } catch {
    return false; // no local file: leave the bundled (empty) override alone
  }
  let have = null;
  try {
    have = fs.readFileSync(bundledFile, "utf8");
  } catch {
    have = null;
  }
  if (have === want) return false;
  fs.writeFileSync(bundledFile, want);
  return true;
}

function offerReload() {
  vscode.window
    .showInformationMessage(
      "Markdown preview style override changed — reload to apply.",
      "Reload Window"
    )
    .then((pick) => {
      if (pick === "Reload Window")
        vscode.commands.executeCommand("workbench.action.reloadWindow");
    });
}

function activate(context) {
  const bundled = path.join(context.extensionPath, "local-override.css");
  const local = overridePath();
  if (!local) return;

  if (sync(local, bundled)) offerReload();

  // Watch the local file's directory (the file itself may not exist yet).
  const dir = path.dirname(local);
  if (fs.existsSync(dir)) {
    const watcher = fs.watch(dir, (_event, name) => {
      if (name === path.basename(local) && sync(local, bundled)) offerReload();
    });
    context.subscriptions.push({ dispose: () => watcher.close() });
  }
}

function deactivate() {}

module.exports = { activate, deactivate, sync, expandHome };
