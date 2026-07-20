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
- [outline-section-operations.html](./outline-section-operations.html) —
  ALL section (stack) operations on one page: what exists, the gesture
  budget, the drag collision that rules out creation-by-drag, and the
  rule "drag changes where a block is, clicking changes what the chapters
  are" (proposed: implement B, drop C; undecided).
- [outline-drag-to-create-mock.html](./outline-drag-to-create-mock.html) —
  interactive mock of variant C: drop zones that exist only during a drag,
  hidden where the DAG forbids the landing (drop on a heading = join,
  drop in a zone = new chapter). Preferred; not yet implemented.
- [outline-new-section-proposals.html](./outline-new-section-proposals.html)
  — how to CREATE a chapter from the outline (proposed: A, a "split here"
  pill on the boundary, pairing with merge-up; undecided).
- [outline-insert-proposals.html](./outline-insert-proposals.html) — adding
  blocks from the outline and the rewiring rule it implies (proposed: A,
  boundary ⊕ rail, insert-after only; real graph surgery stays in the dag —
  undecided).
- [outline-reorder-proposals.html](./outline-reorder-proposals.html) — the
  reorder affordance for the outline's rare order-free boundaries (decided
  2026-07-20: B, the overlay grip — floats in the column gap so it reserves
  no space; rendered only where the DAG permits a move; implemented).
- [outline-document-styling-proposals.html](./outline-document-styling-proposals.html)
  — how the outline's document column styles chapter title, lead and collapse
  (principle: color groups, typography ranks; decided 2026-07-20: B, the
  thread, revised — one line on the far left from title to last block,
  lead as plain body prose exactly as quarto renders it, collapsed
  chapters show their blocks' mini icons; implemented in blockr.outline).
- [board-outline-gutter-proposals.html](./board-outline-gutter-proposals.html)
  — gutter refinement of the board outline: block chip (icon + title + switch)
  in a narrow gutter on the same grid row as its code section, stack as a
  colored spine, no wire (decided + implemented on the pilot branch
  2026-07-19; chip click reveals the dock panel like a dag node click).
- [board-outline-proposals.html](./board-outline-proposals.html) — linked
  two-pane "board outline": panel-navigator rail left, report source right,
  hover-synced (variant A picked from the blocks-code brainstorm; mock only,
  builds on panel-navigator PR #253 + the block-docs pilot).
- [description-style-proposals.html](./description-style-proposals.html) — how
  the per-block description (block-docs pilot) should look in the card
  (decided 2026-07-19: B, the docstring band — tinted band + left accent
  between header and controls, pencil on hover, dashed + chip when excluded;
  implemented on the pilot branch).
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

## Idea (unratified — to rethink): dplyr as interim shared-UI owner

> Captured 2026-07-11 as a thought, **not a decision**. Christoph wants to
> rethink it before acting. Do not implement off this note.

Instead of waiting for the full blockr.ui extraction, **misuse blockr.dplyr as
the interim owner** of the shared UI assets. It already de-facto plays the role:
it exports `blockr_core_js_dep()`, `blockr_blocks_css_dep()`, `blockr_select_dep()`,
`blockr_input_dep()`, and every UI-bearing package but blockr.io already depends
on it. The move would be: have blockr.ggplot and blockr.io depend on it too,
export one canonical `settings_band_dep()` (and possibly the drilldown-config
gear engine) from dplyr, have all five packages call those instead of vendoring
their own copies, and delete the vendored copies. When blockr.ui is ready, the
shared layer lifts out of dplyr into blockr.ui and the `Imports` repoint.

**Why it's only an idea, not queued work.** The payoff is *maintenance*, not
performance or correctness:

- The vendored copies are effectively **byte-identical** — the four
  `settings-band.css` copies (dplyr / viz / ggplot / io) differ only in a 2–3
  line `CANONICAL SOURCE:` provenance comment; the CSS itself is the same.
- The assets load in **every workflow anyway** and are small + URL-cached, so
  the multi-dep-name duplication is **~zero practical waste** (measured this
  session; see [[project_block_build_cost_profiling]]).
- The one same-name/different-version wrinkle (blockr.viz redeclaring
  `blockr-blocks-css` / `blockr-select-js` under dplyr's names with a higher
  version + a superset file list) is **benign in practice** — the extra file is
  loaded anyway, so whichever definition wins, the page's file set is identical.
- The real per-build cost — rebuilding the htmlDependency objects (disk I/O) on
  every construct/render — was already removed by memoising the dep builders
  across viz / dplyr / dm / ggplot / io (`memoise0`, this session).

**Open questions to settle before doing it:**

- Semantic misuse: dplyr is a *transform* package; making it the UI-asset owner
  is a deliberate stopgap. Is that acceptable, or does it muddy the eventual
  blockr.ui extraction more than it helps?
- blockr.io gaining a blockr.dplyr dependency (it has none today) — fine inside
  a blockr app where dplyr is always present, heavier for io standalone.
- The drilldown-config / drilldown-agg gear engine is viz-flavoured
  (aggregation vocabulary), not obviously a dplyr asset — settings-band is the
  clean shared candidate; the engine may not belong in dplyr at all.
- Given ~zero functional/perf payoff, is the churn (5 packages, re-verify the
  look everywhere) better spent folding straight into the blockr.ui migration
  rather than done twice?
