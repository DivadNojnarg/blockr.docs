# Design system — target (the plan we're moving to)

> **This folder is the plan, not the status quo.** It describes the design
> system we *want*: a single token layer and one set of well-named component
> classes owned by **blockr.ui**, that every depending package builds on.
> For how things are documented **today**, see the markdown primitives in the
> [parent folder](../README.md).

Surveyed 2026-07-02 across blockr.dock, blockr.dplyr, blockr.ui, blockr.docs.
Originally drafted on the `docs/design-system` branch of blockr.ui
(`blockr.ui/dev/`); moved here so it lives with the durable ecosystem docs.

## Contents

- **[design-system.html](./design-system.html)** — the consolidation spec.
  Who owns what today (§1–4: token authority, class inventory, known drift),
  then the **target** and an ordered **migration map** (§5–6) that moves the
  token layer + shared JS/CSS into blockr.ui. The `:root` block in the file
  doubles as the draft `blockr-tokens.css`. Open in a browser — it renders its
  own tokens live.

### Decision records it links to

- [text-commit-proposals.html](./text-commit-proposals.html) — when text
  fields commit (decided: commit on Enter/blur with an Enter chip while dirty).
- [archive/gear-panel-proposals.html](./archive/gear-panel-proposals.html) —
  gear popover → full-width in-flow settings band (variant B, piloted in
  blockr.viz).
- [archive/boolean-controls-proposals.html](./archive/boolean-controls-proposals.html)
  — values → pill, data options → checkbox, UI modes → switch.

## Status

Proposed / in progress. Steps 1–2 of the migration map (create the token layer
in blockr.ui, make blockr.dock consume it) alone fix the biggest structural
problem (drift #1). The larger dock → ui extraction is tracked in
`_blockr.design/open/blockr.ui/`.
