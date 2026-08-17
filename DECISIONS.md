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
