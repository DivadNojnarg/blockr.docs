# Design system

blockr's UI chrome is hand-rolled: plain CSS, plain ES modules, no Sass, no
bundler, no component library. [Why](../decisions/0001-hand-rolled-vs-libraries.md).
That makes a written design system load-bearing — there is no framework to fall
back on when two packages need the same control to look the same.

This folder is that system. It describes **one** design system, the one new
code should be written against.

## Where the code lives

The system is delivered as plain CSS plus versioned `htmlDependency` objects.
Ownership is mid-migration, and it helps to know which half you are looking at:

| Layer | Today | Destination |
|---|---|---|
| Design tokens (`--blockr-*`) | `blockr.dock/inst/assets/css/blockr-dock.css` defines the only `:root` | `blockr.ui` → `blockr-tokens.css` |
| Typography classes, Bootstrap overrides | blockr.dock | `blockr.ui` → `blockr-base.css` |
| Row / pill / add-row / gear primitives | `blockr.dplyr/inst/css/blockr-blocks.css` | `blockr.ui` → `blockr-blocks.css` |
| `Blockr.Select`, `Blockr.Input` | `blockr.dplyr/inst/{css,js}/` | `blockr.ui` |
| Settings band, checkbox | `settings-band.css` (blockr.viz, copied to dplyr + ggplot) | `blockr.ui` → `blockr-settings.css` |
| Chart palettes, ramps, scale maps | `blockr.theme` | stays there — [why](../patterns/scale-map.md) |
| Per-block stylesheets | each block package | stay there |

Packages that need an asset before it moves copy it and mark the copy with a
`CANONICAL SOURCE:` comment naming the file it was copied from. The copies are
byte-identical by convention; if you edit one, edit all of them.

**The direction is settled: blockr.ui owns the shared layer.** Everything below
is written against that end state, because the rules do not change when the
files move. What is still open is sequencing, tracked as a spec in the
`blockr.design` repo under `open/blockr.ui/`.

## The token contract

Three rules, and the first is the one that matters:

1. **Components reference semantic tokens** (`--blockr-color-*`), never
   primitives, never literals. Primitives (`--blockr-grey-*`, `--blockr-blue-*`)
   exist only to feed the semantic layer. This is what keeps a dark mode a
   one-file change later rather than a grep.
2. **Fallbacks stay** in consuming CSS — `var(--blockr-color-border, #e5e7eb)`
   — so a block renders sensibly when its stylesheet loads without the token
   sheet. The fallback must equal the token's value. That is an invariant you
   can lint, and a drifted fallback is a bug.
3. **Data-encoding colours are not UI tokens.** Chart palettes, sequential and
   diverging ramps, and category colours belong to `blockr.theme` and never
   enter this layer. A colour that encodes a value obeys different constraints
   than a colour that draws a border.

## Contents

**Primitives**

- [colors.md](./colors.md) — greyscale, semantic aliases, focus ring.
- [typography.md](./typography.md) — families, sizes, weights.
- [spacing-and-sizing.md](./spacing-and-sizing.md) — control heights, radii,
  gaps, and the flex-wrap rule that replaces media queries.
- [naming-conventions.md](./naming-conventions.md) — BEM, the reserved
  `blockr-` prefix, per-block prefixes.

**Behaviour**

- [ux-principles.md](./ux-principles.md) — how controls should *act*: when to
  auto-pick a default and when to refuse, the amber required-empty cue, what
  each of a field's four text carriers is allowed to say, boolean controls,
  text commit, keystroke labels. Read this one before adding a control.

**Components**

- [components/blockr-select.md](./components/blockr-select.md) — the select.
  One component, used everywhere, including two-choice pickers.
- [components/blockr-input.md](./components/blockr-input.md) — code input with
  autocomplete.
- [components/blockr-row.md](./components/blockr-row.md) — row, pill, add-row,
  gear header.
- [components/blockr-settings.md](./components/blockr-settings.md) — the
  settings band the gear opens, and what belongs in it.

**Tooling**

- [design-system-prompt.md](./design-system-prompt.md) — the whole system
  condensed into one paste-ready brief for artifact-style UI generators.

## Naming rules

Everything the shared layer ships is `.blockr-*`, and **that prefix is
reserved**. Block packages use their own short prefixes (`fb-`, `mb-`, …) and
never mint a `blockr-` class. Details and the prefix table are in
[naming-conventions.md](./naming-conventions.md); three rules are worth
stating here because they apply across every component:

- **Components are BEM**: `.blockr-<component>`, elements `__el`, modifiers
  `--mod`.
- **Utility and typography classes stay flat**: `.blockr-title`,
  `.blockr-label`, `.blockr-helper`, `.blockr-meta`, `.blockr-error`. They are
  single-purpose text styles, not components, and BEM would be noise.
- **State is a modifier, not a sibling class**: `.blockr-sidebar--open`, not
  `.blockr-sidebar-open`. In particular, one shared `.blockr-pill--active`
  serves every block — do not re-implement it per block, and never restyle a
  shared class with `!important` from block CSS.

Renaming shared classes is lower-risk than it looks, because the markup comes
from exported R and JS builders rather than hand-written HTML. The exception to
audit is a package layering delta CSS onto shared classes.
