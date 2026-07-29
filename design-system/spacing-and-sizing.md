# Spacing and sizing

## Control heights

Three tiers, and controls of the same tier line up on a row.

| Token | Height | Use |
|---|---|---|
| `--blockr-control-h` | **42px** | standalone inputs, bordered selects — the universal "input" height |
| `--blockr-control-h-sm` | **30px** | nested inputs inside rows, number inputs, add-row bar |
| `--blockr-control-h-xs` | **26px** | icon buttons (gear, remove), pill toggles, confirm buttons |

`Blockr.Select` is transparent and unsized by default so it inherits the parent
row's 30px slot; the `--bordered` modifier promotes it to the 42px standalone
size.

There is no popover tier. Settings used to open in a floating popover with its
own 38px control height; that popover is gone, replaced by the in-flow settings
band, which uses the standard tiers like everything else. See
[components/blockr-settings.md](./components/blockr-settings.md).

> **Known drift.** The 26px gear is canon, but blockr.viz renders it at 30px so
> it can share the block's top-right corner with search and download, and
> blockr.io at 32px through an unscoped selector that leaks onto every block in
> the app. Whether that corner should become a proper 30px control row is an
> open question, tracked in the `blockr.design` repo under
> `open/blockr.ui/open-questions.md`. **26px remains canon until it is decided
> — do not bump a gear to match a neighbour.**

## Border radius

| Token | Radius | Use |
|---|---|---|
| `--blockr-radius-lg` | **8px** | inputs, rows, dropdowns, settings bands |
| `--blockr-radius-md` | **6px** | internal card sub-sections (separate, bind-rows, pivot-longer, unite) |
| `--blockr-radius-sm` | **4px** | pills, small buttons |

## Gaps and padding

- Row padding: 5px vertical, flex gap 6–12px between fields.
- Dropdown shadow: `--blockr-shadow-dropdown` (`0 4px 12px rgba(0, 0, 0, 0.1)`).
- Focus ring: `--blockr-focus-ring` — one ring for everything focusable, see [colors.md](./colors.md).
- Hover transitions: `--blockr-transition` (`0.15s ease`). No other motion.

## Responsive layout (flex-wrap, not media queries)

Block width is unknown at author time — stacks range from ~300px (narrow sidebar) to the full workspace width, and resize at runtime. **Do not use `@media` or `@container` queries** for block internals. The idiom is a wrapping flex row where each field claims an equal share above a soft minimum, then wraps:

```css
.xxb-grid  { display: flex; flex-wrap: wrap; align-items: flex-end; gap: 6px 12px; }
.xxb-field { flex: 1 1 160px; min-width: 0; display: flex; flex-direction: column; }
```

Rules:

- `flex: 1 1 160px` — fields grow equally, shrink to the ~160px soft minimum, then wrap. Tune the basis per block (short labels can go ~120px; long inputs need 200px+).
- `min-width: 0` is **mandatory** on flex children that contain `Blockr.Select` or other overflowing content — otherwise the intrinsic content width prevents shrinking.
- `align-items: flex-end` keeps inputs bottom-aligned when labels span two lines on one field but not another.
- For a field that should always occupy its own row (e.g. a multi-select with many tags), add a `--full` modifier: `.xxb-field--full { flex: 1 1 100%; }`.

Canonical examples: `blockr.dplyr/inst/css/pivot-longer-block.css` (`.plb-input-row` / `.plb-field`), `blockr.viz/inst/css/summary-table-block.css` (`.stb-grid` / `.stb-field` / `.stb-field--full`).
