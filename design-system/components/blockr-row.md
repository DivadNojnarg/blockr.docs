# Row primitives

Shared layout pieces for row-based blocks (filter, mutate, arrange, …). Source: `blockr.dplyr/inst/css/blockr-blocks.css`.

Every row-based block composes the same primitives: a repeating `.blockr-row` with a fixed-width "key" on the left, a separator, flex content on the right, and a remove button revealed on hover. Below the list sits a `.blockr-add-row` bar.

## Classes

```
.blockr-row          — flex container, 42px min-height, grey bg, 8px radius
.blockr-row-content  — flex: 1, holds the dynamic content
.blockr-row-remove   — 26px button, margin-left: auto, hidden until row hover
.blockr-add-row      — footer bar with "+ Add" link
.blockr-add-link     — the clickable "+ Add" control inside `.blockr-add-row`
.blockr-add-icon     — leading "+" glyph for `.blockr-add-link`
.blockr-label        — small label inside a row (e.g. column name)
```

Rows typically have a fixed-width left column (150–160px) for the "key" (column name), a separator (`=`, `→`), and flex content for the "value".

## Interaction

- Row remove button: `opacity: 0` at rest, `opacity: 1` on `.blockr-row:hover`; turns `--blockr-color-danger` on button hover. Never show the remove button in resting state.
- `.blockr-row:focus-within` — subtle focus treatment so keyboard users see the active row.
- Hover transitions: 0.15s ease (see [spacing-and-sizing.md](../spacing-and-sizing.md)).

## Pills

`.blockr-pill` is the small toggle/button used for op selectors (AND/OR,
ascending/descending). `--blockr-radius-sm`, small padding, hover lightens the
background; `.blockr-pill--active` marks the current selection — one shared
modifier, not a per-block re-implementation. Pills currently ship at 24px and
fold into the 26px `--blockr-control-h-xs` tier with the token layer.

**A pill is only correct when the label *is* the value.** A self-labelling
on/off pill is ambiguous: when a pill reads `include`, the user cannot tell
whether that is the current state or the action a click performs. Plain data
options are `.blockr-checkbox` instead — see
[ux-principles.md](../ux-principles.md#boolean-controls).

**Label the meaning, not the mechanism.** A click-through pill cycles options in place, so its text must state what the *current setting means* — never a bare `On` / `Off`. Like `AND` / `OR` and `Ascending` / `Descending`, a binary feature toggle reads `Search bar` / `No search bar`, `Sortable` / `Not sortable`, `Collapsible` / `Not collapsible`. The row label names the dimension; the pill names the chosen state. `On`/`Off` forces the reader to remember which feature the row controls and which direction is which — the descriptive label is self-evident at a glance.

## Gear header

```
.blockr-gear-header  — flex container, justify-content: flex-end
.blockr-gear-btn     — 26px square icon button
.blockr-gear-active  — state while the settings band is open (primary + tinted bg)
```

The gear toggles `.blockr-settings`, the full-width band that opens in flow
directly below this header. **No gear when there is nothing to configure** —
hide the button rather than opening an empty band.

For what belongs in the band and how its fields are laid out, see
[blockr-settings.md](./blockr-settings.md). That doc is the spec; this section
is just the class list.

The legacy `.blockr-popover-*` classes still exist in blockr.dplyr's stylesheet
and are still referenced by bands that have not been rebuilt yet — the band
scopes them back up to the standard 42px control height. Do not reach for them
in new code.

## Confirm button

`.blockr-expr-confirm` — 24px confirm action for expression rows. `.confirmed` modifier when the expression matches the last-submitted value (turns green, `--blockr-color-primary` on hover off).

## Number and text inputs

`.blockr-num-input` / `.blockr-text-input` are the bare input primitives used inside rows when a full `Blockr.Input` is overkill. Transparent background, no border, focus adopts the shared focus ring. Placeholders use `--blockr-grey-400`.

## Composition example

```html
<div class="blockr-row">
  <span class="blockr-label">col_a</span>
  <div class="blockr-row-content">
    <!-- Blockr.Input or Blockr.Select here -->
  </div>
  <button class="blockr-row-remove" aria-label="Remove"></button>
</div>
<!-- … more rows … -->
<div class="blockr-add-row">
  <a class="blockr-add-link" href="#">
    <span class="blockr-add-icon">+</span> Add
  </a>
</div>
```

For responsive multi-column content inside `.blockr-row-content`, use the flex-wrap pattern in [spacing-and-sizing.md](../spacing-and-sizing.md) — not media or container queries.
