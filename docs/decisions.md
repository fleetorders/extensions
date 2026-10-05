# Design decisions

What this repository decided about how its extensions are named, laid out and published,
and why. Decisions that belong to one extension live in that extension's own
`docs/decisions.md`.

### D-1 — One repository, one folder per extension

Every extension lives here, in its own folder at the root, with its own `package.json`,
README, `LICENSE`, `CHANGELOG.md` and `media/`. Nothing is imported across folders.

**Why:** one place to find the extensions and one way to build, check and publish them.

### D-2 — Names say what the extension does

An extension's display name describes its function, and its id is the kebab-case of the
display name. Codenames are for standalone products, not small editor tools.

The provider switcher started life as "gephyra". It ships as
`alkisyuv.claude-code-provider-switcher` ("Claude Code Provider Switcher"); the shorter
`claude-provider-switcher` was already taken by another publisher. Its settings, commands and
config directory keep the `gephyra` prefix so existing users' settings keep working.

**Why:** marketplaces are searched by function; a codename on a utility listing is never
found.

### D-3 — The same surface in every folder

Each extension folder carries a README in one shape (a one-line summary, Install for both the
VS Code Marketplace and Open VSX, usage and settings, license), a marketplace icon
`media/icon.png` with its SVG source beside it, `LICENSE` and `CHANGELOG.md`.

**Why:** a fixed surface makes a new extension obvious to add and keeps the listings
consistent.

### D-4 — Repository links point at the extension's folder

Each extension's `repository.url` is its own folder's tree URL
(`https://github.com/fleetorders/extensions/tree/main/<folder>`), with no `directory` field.

**Why:** the marketplace shows `repository.url` as is, so a reader who clicks Repository on a
listing lands on that extension's code rather than on this index.

### D-5 — The root README shows a banner and no badges

Registry badges live in each extension's own README; the root README carries the banner and
the table of extensions.

**Why:** one badge per extension crowds the index as it grows.

### D-6 — Every release goes to both registries

A version is published to the VS Code Marketplace (`vsce publish`) and to Open VSX
(`ovsx publish`) together; Cursor and VSCodium install from Open VSX. Versions and changelog
entries come from changesets at the repository root.

**Why:** a version on one registry only leaves half the users on an older release.
