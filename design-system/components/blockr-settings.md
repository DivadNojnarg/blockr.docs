# Settings band — the block's configuration surface

The gear button in a block's top-right corner opens `.blockr-settings`: a
**full-width, in-flow band** between the gear header and the block content.
This doc covers **what goes in it** and **how its fields are laid out**.

Source: `settings-band.css` (canonical copy in `blockr.viz/inst/css/`, copied
into blockr.dplyr and blockr.ggplot; moves to blockr.ui as
`blockr-settings.css`).

## The band is not a popover

Settings used to open in a floating `.blockr-popover`. They no longer do, and
the difference is structural rather than cosmetic:

| | Popover (gone) | Band (`.blockr-settings`) |
|---|---|---|
| Positioning | absolute, over the content | in flow, pushes content down |
| Stacking | `<body>` portal, z-index fights, clipped by dock panels | none of that — it is just a div |
| Dismissal | outside-click, like a menu | the gear toggles it; it is a panel, not a menu |
| Control heights | its own 38px tier | the standard 42 / 30 / 26 tiers |
| While configuring | covers the thing you are configuring | the thing you are configuring stays visible |

That last row is the reason. You cannot tune a chart you cannot see.

`.blockr-popover` survives **only as a menu container** — a short list of
actions that dismisses on outside click. It never holds form controls again.

### Classes

```
.blockr-settings              — the band; display:none until opened
.blockr-settings--open        — flex-wrap container, gap 0 14px
.blockr-settings--beak        — opt-in: grows a notch pointing at the gear
.blockr-settings__title       — micro-label heading, uppercase, full row
.blockr-settings__grid        — field grid for hand-built bands
.blockr-settings__field       — one field, flex 1 1 190px
.blockr-settings__field--full — field that always owns its own row
.blockr-checkbox              — boolean data option (see ux-principles.md)
```

The band is 1px bordered, `--blockr-radius-lg`, `padding: 12px 14px 16px`,
white, `margin-bottom: 10px`. It owns its own bottom rhythm — do not add a
trailing margin to the last row inside it.

Bands opened *by a gear* opt into `--beak`, which draws a notch on the top edge
pointing at the gear; the gear holds `.blockr-gear-active` while the band is
open. Bands that are always open (blockr.ggplot's main settings area) get no
beak.

## Principle 1 — the card shows the result, the gear configures it

A block's resting surface is its **output** plus **direct interactions with
that output**. Everything that defines *what the output is* goes in the band.

| On the card | In the band |
|---|---|
| The chart / table / value | Column mapping (group, x, y, series, color, facet) |
| Sort, search, paginate | Chart type, aggregation function, metric |
| Click-to-drill, brush, hover | Coloring, rounding, sort order, theme |
| The echarts zoom/save toolbox (small, muted, always on) | Anything sourced from the block's `_arguments()` metadata |

The test for any control: *am I interacting with the data shown, or redefining
what data is shown?* Redefining → band.

Why, for blockr specifically: blocks compose densely into workspaces and must
render from ~300px to full screen. An always-on config bar costs vertical space
in every block in every workspace, permanently, to expose controls that are set
once and rarely touched.

### The exception: block role decides how much is on the card

- **Authoring blocks** (blockr.ggplot) show main configuration on the card,
  with only type-specific extras behind the gear. When there are no extras,
  there is no gear at all — hide the button rather than opening an empty band.
- **Rendering blocks** (blockr.viz) keep everything behind the gear. The
  rendered output *is* the dashboard control, so a dashboard shows the control,
  not the configuration.

For the drilldown family the column mapping is the block's **transform
definition** and the click or brush is the **filter it emits**. Both are
configuration; the mapping goes in the band, the interaction stays on the card.

## Principle 2 — each field is a vertical unit; fields flow in a grid

A **field** is one labelled control, stacked top to bottom:

```
[ label                    ]
[ full-width control       ]   width:100%; box-sizing:border-box
[ muted help text below    ]   --blockr-color-text-subtle, 0.75rem, line-height 1.3
```

| Element | Spec |
|---|---|
| Field | `display:flex; flex-direction:column; align-items:stretch; gap:4px; margin-bottom:12px` |
| Control | `width:100%; box-sizing:border-box`, standard 42px height |
| Help text | `font-size:0.75rem; color:var(--blockr-color-text-subtle,#9ca3af); line-height:1.3` |
| Title | `.blockr-settings__title` — `flex: 1 1 100%`, 12px, uppercase, muted |

One control per row wastes horizontal space and gets tall fast. So fields
**flow in a wrapping grid**: the band is a `flex-wrap` container, each field
`flex: 1 1 190px; min-width: 0`, so a wide block fits about three across and a
narrow one collapses to one. `flex-wrap`, never media or container queries —
[the general rule](../spacing-and-sizing.md#responsive-layout-flex-wrap-not-media-queries).

Fields that always own a full row (`--full`): the title, and any mode selector
that gates the fields below it.

Do **not**: put the label beside the control, put two controls in one field, or
put help text above the control. The grid places whole fields side by side; it
never splits a field.

Help goes *below* because a side description column gets squished, and help
above separates the label from its control and reads as noise before the reader
knows what the control is. Below, it is read after the control has been seen,
only when needed, and degrades gracefully as the lowest-priority element in the
stack.

## Principle 3 — help text comes from `_arguments()`

Block argument descriptions already exist in the block's `_arguments()`
metadata, so one string serves both the LLM-facing API and the human-facing
settings form. Keep it to one line. The band is a settings form, not
documentation.

**Exception — column pickers show the selected variable, not the role text.**
When a field maps a data column (X, Y, Group, Color, …), a static "X-axis
column …" sentence does not tell the user *which* variable is mapped. These
fields show the selected column in the usual `name (label)` convention — the
column name plus its `attr(x, "label")` — updated live as the selection
changes. Fall back to the `_arguments()` role text when the value is not a
column (`(none)`, `.count`, an aggregation function) or the column carries no
label.

## Principle 4 — order by causality, not registration

Controls read in the order one would set them, not the order they appear in
`external_ctrl`:

1. Type / mode selector first — it gates everything below it.
2. Mapping (group / x / y / series / color / facet).
3. Encoding (metric, aggregation).
4. Presentation (sort, rounding, theme, coloring).

Conditional field sets stay conditional, but the conditional logic moves *with
the fields* into the band. The band stays open across changes, so re-encoding
is not a repeated open and close.

## Principle 5 — what explicitly stays on the card

- The echarts toolbox (zoom / restore / save) — small, muted, always on, shared
  by every chart family.
- The table search box and column sort headers.
- Click / brush / hover drill interaction.

These are interactions with the shown result, not configuration.

**Corollary — the result must self-describe.** Once mapping moves behind the
gear, nothing on screen says which column is X, Y or group. The result itself
becomes the only place that information lives, so it has to carry it: axis
titles derived from the mapped column's label, labelled column headers, a
legend for the color or series split, and a block name that states the subject.
A chart with bare numeric axes and no titles is a **defect**, not a clean look.
This was the concrete regression when the drilldown chart's pickers first moved
off the card — the axes lost their only labels.

## Type pickers

The picker's form follows the number of choices, and it is derived, not
configured:

- **5 or more types** → an icon tile grid, uniform icon-over-label tiles, with
  per-group micro-headings when the types are grouped. The field label sits
  above the grid; the label-on-the-left arrangement is retired.
- **2 to 4 types** → the segmented strip (facet wrap/grid, and similar).

## The trade-off, accepted knowingly

Mapping behind the gear means the current encoding is not visible at a glance
and re-encoding is a two-click action. Mitigations: the band stays open across
changes, and the block name carries the semantics ("AE max grade by subject").
The drilldown table block showed the trade-off is acceptable in practice.
Accept it rather than re-litigate it per block.
