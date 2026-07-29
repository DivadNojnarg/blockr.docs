# Colors

A Tailwind-aligned greyscale feeding a small semantic palette. Components
reference the **semantic** names only; the primitives exist to define them.

Defined in `blockr.dock/inst/assets/css/blockr-dock.css` (`:root`), moving to
`blockr.ui/inst/assets/css/blockr-tokens.css`. Always write a literal fallback
— `var(--blockr-color-border, #e5e7eb)` — and make it match the token's value.

## Primitives

| Variable | Hex | Feeds |
|---|---|---|
| `--blockr-grey-50` | `#f9fafb` | `bg-subtle`, `bg-input` |
| `--blockr-grey-100` | `#f3f4f6` | `bg-hover` |
| `--blockr-grey-200` | `#e5e7eb` | `border` |
| `--blockr-grey-300` | `#d1d5db` | `border-hover`, dividers |
| `--blockr-grey-400` | `#9ca3af` | `text-subtle` — placeholders, muted icons |
| `--blockr-grey-500` | `#6b7280` | `text-muted`, `text-meta` |
| `--blockr-grey-600` | `#4b5563` | *(deprecated — see below)* |
| `--blockr-grey-700` | `#374151` | `text-secondary` |
| `--blockr-grey-800` | `#1f2937` | *(deprecated — see below)* |
| `--blockr-grey-900` | `#111827` | `text-primary` |
| `--blockr-blue-50` | `#eff6ff` | `primary-bg` |
| `--blockr-blue-100` | `#dbeafe` | tints |
| `--blockr-blue-500` | `#3b82f6` | — |
| `--blockr-blue-600` | `#2563eb` | `primary` |
| `--blockr-blue-700` | `#1d4ed8` | `primary-hover` |

`--blockr-grey-600` and `--blockr-grey-800` carry no semantic role — no alias
points at them, and their scattered direct uses are indistinguishable from
their neighbours. New code should not reference them; existing uses fold into
`grey-700` and `grey-900` respectively when the token layer moves.

## Semantic

These are what components use.

| Variable | Resolves to | Use |
|---|---|---|
| `--blockr-color-text-primary` | grey-900 `#111827` | main body text |
| `--blockr-color-text-secondary` | grey-700 `#374151` | de-emphasised text |
| `--blockr-color-text-muted` | grey-500 `#6b7280` | labels, descriptions |
| `--blockr-color-text-subtle` | grey-400 `#9ca3af` | placeholders, muted icons |
| `--blockr-color-text-meta` | grey-500 `#6b7280` | meta / helper |
| `--blockr-color-border` | grey-200 `#e5e7eb` | all borders |
| `--blockr-color-border-hover` | grey-300 `#d1d5db` | hovered borders |
| `--blockr-color-bg-subtle` | grey-50 `#f9fafb` | subtle fills |
| `--blockr-color-bg-input` | grey-50 `#f9fafb` | input / row backgrounds |
| `--blockr-color-bg-hover` | grey-100 `#f3f4f6` | hover background |
| `--blockr-color-primary` | blue-600 `#2563eb` | focus rings, active states |
| `--blockr-color-primary-hover` | blue-700 `#1d4ed8` | hovered primary |
| `--blockr-color-primary-bg` | blue-50 `#eff6ff` | tinted primary background |
| `--blockr-color-error` | `#dc2626` | validation error text |
| `--blockr-color-success` | `#16a34a` | confirmed states |

## Specified but not yet in `:root`

These are part of the system — write components against them, with fallbacks —
but they are not yet defined centrally, so the fallback is currently doing the
work. They land with the token layer.

| Variable | Value | Use |
|---|---|---|
| `--blockr-color-danger` | `#dc2626` | destructive action (row remove hover) |
| `--blockr-color-warning` | `#f59e0b` | required-empty border and icons |
| `--blockr-color-warning-text` | `#b45309` | warning prose (contrast on light bg) |
| `--blockr-color-warning-bg` | `#fffbeb` | required-empty field background |
| `--blockr-focus-ring` | `0 0 0 3px rgba(37, 99, 235, 0.12)` | the one focus ring |
| `--blockr-shadow-dropdown` | `0 4px 12px rgba(0, 0, 0, 0.1)` | dropdowns, floating menus |

**Red is one colour.** Destructive and error states currently ship as three
different reds across the ecosystem — `#dc3545` (Bootstrap's), `#F43F5E`, and
the token's `#dc2626`. They unify on `--blockr-color-danger`. If you are
touching CSS that hardcodes one of the first two, change it.

## Focus ring

Every focusable element gets the same ring, no exceptions:

```css
border-color: var(--blockr-color-primary, #2563eb);
box-shadow: var(--blockr-focus-ring, 0 0 0 3px rgba(37, 99, 235, 0.12));
```

## Destructive interaction

Row remove buttons are `opacity: 0` at rest, revealed on row hover, and turn
`--blockr-color-danger` on button hover. Never show a remove button in the
resting state.

## Data colours are not here

Chart palettes, sequential and diverging ramps, and category colours live in
`blockr.theme` and are out of scope for this file. A colour that encodes a
value answers to different constraints — ordering, colour-vision deficiency,
how many levels stay distinguishable — than a colour that draws a border. See
[../patterns/scale-map.md](../patterns/scale-map.md).
