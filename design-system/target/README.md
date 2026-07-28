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
- [outline-titles-and-headings.html](./outline-titles-and-headings.html) —
  whether stack/block titles should become document headings, live over
  one board (stack-only / plus blocks / overrides / start level / none);
  naming: stack in the app, section in the output. Proposed: asymmetric
  default + overrides + level as a document property. Undecided.
- [outline-move-chapters.html](./outline-move-chapters.html) — moving a
  WHOLE chapter: the handle decides the scope (chip = block, heading =
  chapter), chapters land only at chapter boundaries, legality is the DAG
  one level up; dependencies are really enforced in this mock.
- [outline-move-vs-reorder.html](./outline-move-vs-reorder.html) — the two
  same-style creation links (+ New block / + New chapter) and the drag
  question: "position implies membership" (recommended) vs "membership is
  explicit", both live, showing how the second manufactures split
  "(continued)" chapters.
- [outline-section-variants-live.html](./outline-section-variants-live.html)
  — the four creation gestures side by side, each driving the same live
  model (split / merge up / ungroup all work); pane C shows the drag
  collision instead of describing it.
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
- [outline-render-group-proposals.html](./outline-render-group-proposals.html) — grouping
  the toolbar's format picker + render action, then the action's label (decided
  2026-07-21: split button — neutral picker fused to the green action, one pill; label is
  "Download" not "Render" since render is the internal step; both toolbar groups share one
  height and centre line, which needs the shinyWidgets form-group margin zeroed;
  implemented in blockr.outline).
- [outline-code-preview-proposals.html](./outline-code-preview-proposals.html) — the
  R script / Document code preview: the grey box nested inside the panel's own
  card, and where copy belongs (decided 2026-07-20: C + B's header — one
  full-bleed tinted surface under a sticky file header naming report.R /
  report.qmd, copy moved onto the code, toolbar restyled to the segmented
  control drawn there; implemented in blockr.outline). Note the correction
  recorded on the page: the surface is inset by the panel padding, NOT bled to
  the edge — the dock's own grey sits behind every panel, so a full-bleed grey
  erases the panel boundary. Mockups on a white page hide this.
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
- [select-controls.html](./select-controls.html) — the one select
  (`Blockr.Select`, blockr.dplyr), displayed systematically: single / multi,
  closed / placeholder / open, tags with remove + drag-reorder, option
  anatomy (value primary, label sublabel — labelPrimary swap recorded as an
  open question for clinician-facing pickers), when-to-use table (decided
  2026-07-22: blockr-select everywhere, including 2-choice pickers; the
  segmented/pill button pickers from measure-switch-proposals stay a
  recorded future variant, not shipped UI). Mocks use the component's real
  classes with the verbatim CSS subset.
- [measure-switch-proposals.html](./measure-switch-proposals.html) — the
  measure switch block: one curated upstream control (pick the measure) feeding
  a fully fixed chart, for locked CDEX views. Control type is derived, not
  configured — segmented ≤4 choices / dropdown beyond / pills + free-y facets
  when multiple; always emits the long measure+value shape so facet growth
  never changes the schema; labels shown, raw names never; last pill refuses
  to turn off (≥1 validated). D mocks the locked end state: the switch adopted
  into its consumer panel's toolbar (needs dock support, follow-up). For BDS
  data the same UI fronts a PARAM filter instead of a pivot. Control style
  (segmented/pills, variants A–C) superseded 2026-07-22 by select-controls
  (blockr-select everywhere); the block/schema design and variant D remain
  the record.
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

## Idea (unratified): promote the gear row to a 30px block header control row

> Captured 2026-07-28 as a thought, **not a decision**. Nothing is being
> changed off this note. The status quo below stays canon until it is ratified.

Today the gear is specified as a lone 26px icon button in the block's top-right
corner (`../spacing-and-sizing.md`, `../components/blockr-row.md:37`). The idea
is to stop treating that corner as "where the gear lives" and treat it as a
**control row**: a right-aligned strip of always-visible block chrome, sized at
30px (`--blockr-control-h-sm`) so the gear sits flush with everything else that
lands there.

The motivation is capacity, not aesthetics. Once the row is a row, it can hold
a search field, a download button, a small selector, and other controls that
should stay visible rather than hide behind the gear. 26px is too short to
share a line with those; 30px is the height they already use.

This is not hypothetical: blockr.viz has effectively already done it. Its chart
and table blocks moved search and download into the gear row, then bumped the
gear to 30px so the cluster would line up
(`blockr.viz/inst/css/chart.css:668`, `blockr.viz/inst/css/table.css:213`,
commit 220b9b5). The commit reads as a local fix, but the pressure behind it is
this design question.

**Current drift, for whoever picks this up.** Measured 2026-07-28:

| Size | Where |
|---|---|
| 26px (canon) | blockr.dplyr, blockr.ggplot, blockr.extra, blockr.admiral, blockr.seasonal, blockr.dm (`.jscf-gear-btn`), blockr.pharma (`.pp-gear-btn`) |
| 30px | blockr.viz chart + table/rank (scoped, 3-deep, so it wins wherever both sheets load); blockr.outline panel (`--otl-ctrl-h`) |
| 32px | blockr.io (`blockr.io/inst/assets/css/io-blocks.css:82`) |

Two of those are separate defects regardless of which way this idea goes.
blockr.io is at 32px, which matches nothing, and its comment claims it "matches
blockr.dplyr". Worse, its selector is **unscoped** `.blockr-gear-btn`, so any
board loading io's CSS after dplyr's restyles every block's gear in the app.
That is the same failure mode as the blockr.outline leak
(`blockr.outline` 0.0.71). Fix the scope whatever else happens.

**Open questions to settle before doing it:**

- The token. `--blockr-control-h-sm: 30px` is currently documented as "nested
  in-row inputs, number inputs, add-row bar", and `--blockr-control-h-xs: 26px`
  is the icon-button token. Adopting 30px means either redefining what the xs
  tier is for or accepting that icon buttons in a header row use the sm tier
  while icon buttons inside a row (remove, etc.) stay at 26px. The second is
  probably right but needs stating, because it makes size context-dependent
  rather than per-component.
- Which icon buttons move. The gear is the obvious one. The in-row remove "x"
  almost certainly should not: it belongs to a 30px row and would crowd it.
- Blast radius. Seven packages currently render 26px gears. A bump is visible
  on every block in the ecosystem, so it wants one coordinated pass plus a
  visual re-check, not incremental drift.
- Whether the row needs its own class. If it becomes a real container with
  layout rules (gap, alignment, overflow when controls exceed the width), it is
  a component, not a size change, and `.blockr-gear-header` is the wrong name
  for it.
- What happens in narrow blocks. Blocks resize down to ~300px. A row holding a
  search field plus three buttons needs a defined collapse behaviour, and the
  no-media-query rule (`../spacing-and-sizing.md`) applies.
