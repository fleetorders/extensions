# Decisions

Append-only record; entries are never edited, corrections supersede.

### D-001 — One monorepo; code on triartleet, published as alkisyuv

**Scope:** repo · **Decided:** 2026-08-17

All editor extensions live in this repository, one folder per extension,
each carrying a `repository.directory` so marketplace listings link into the
right folder. The repo lives under the triartleet GitHub account while every
published artifact carries the alkisyuv identity — npm publisher, marketplace
publisher (display name "Alkis Yuv"), social handle — exactly the pairing the
published products already used before consolidation.

**Why:** one place to find the family (the original ask: "all extensions
under a directory"), one automation story, and the identity split already
proven in production rather than a new org or account renaming with its
redirect breakage.

### D-002 — Descriptive names; gephyra becomes Claude Provider Switcher

**Scope:** repo · **Decided:** 2026-08-17

Extension names describe what the extension does; IDs are the kebab-case of
the display name; codenames are reserved for standalone products. Applied
retroactively to the one outlier: gephyra is renamed Claude Provider Switcher
(`alkisyuv.claude-provider-switcher`), riding the function's search keywords.
The old listing is deprecated with a successor pointer rather than deleted,
so existing links keep resolving. Internal configuration keys are unchanged
by the rename; a later release may migrate them deliberately.

**Why:** marketplaces are search shelves — a codename is a brand asset that a
utility listing never earns; every extension starts discoverable by name
instead. Renaming now, while install counts are small, is the cheap moment.

### D-003 — Final id: claude-code-provider-switcher (name collision)

**Scope:** repo · **Decided:** 2026-08-17

The rename target from D-002, `claude-provider-switcher`, is held by another
marketplace publisher — extension names are globally unique across publishers.
The final id is `alkisyuv.claude-code-provider-switcher`, display name
"Claude Code Provider Switcher", verified free by gallery query. The gephyra
listing is deprecated with a successor pointer to this id.

**Why:** the collision name is unavailable outright; the "code" infix keeps the
locked intent, rides the strongest search pair, and was verified free before
committing.

### D-004 — Family layout standard: README skeleton, generated icons, per-folder metadata

**Scope:** repo · **Decided:** 2026-08-17

Every extension folder carries the same surface: a README in the family
skeleton (one-line summary, Install covering the VS Marketplace and Open
VSX/Cursor, usage/settings, license), a generated `media/icon.png`
marketplace icon with its SVG source beside it, `LICENSE`, `CHANGELOG.md`,
and `repository.directory` equal to the actual folder name. The pass that
introduced this also fixed the first violation: the renamed extension's
`repository.directory` still pointed at the pre-collision folder name,
breaking every Repository link and badge URL in its listings.

**Why:** the family grew by consolidation, not birth, so the folders drifted
(READMEs of 487/38/23 lines, one icon among three, no two install sections
alike); a fixed surface keeps new extensions obvious and listings
trustworthy.

### D-005 — Repository links point at the child folder, not the monorepo root

**Scope:** repo · **Decided:** 2026-08-17

Each extension's `repository.url` is its own folder's tree URL
(`…/extensions/tree/main/<folder>`); the `directory` field is dropped.
Corrects D-001's mechanism, not its intent: the marketplace renders
`repository.url` verbatim in Project Details — `directory` never changed the
displayed link (it only resolves relative README links, and this family's
READMEs are absolute-only).

**Why:** a reader clicking Repository on a listing should land on that
extension's code, not the family index.

### D-006 — Root README: banner without badges

**Scope:** repo · **Decided:** 2026-08-17

The family README's header block carries the banner alone — no badge row.
Each extension's own README carries its registry badges.

**Why:** one badge per member makes the row crowd and truncate as the family
grows; the index needs to stay legible at any size. (A sanctioned deviation
from the README standard's rule 1, recorded per its "not a gate" clause.)
