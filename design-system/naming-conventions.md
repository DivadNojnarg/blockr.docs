# Naming conventions

## Shared components — BEM

Shared component classes use BEM: component name is the block, `__` for elements, `--` for modifiers.

```
.blockr-select                       — component
.blockr-select__control              — element
.blockr-select--open                 — modifier
.blockr-select--bordered             — modifier (standalone 42px variant)
.blockr-select__option--highlighted  — element + modifier
```

The `blockr-` prefix is **reserved** for shared primitives: `.blockr-select`,
`.blockr-input`, `.blockr-row`, `.blockr-pill`, `.blockr-settings`,
`.blockr-checkbox`, `.blockr-gear-btn`, `.blockr-add-row`. A block package
never mints a `blockr-` class, and never restyles one — least of all with
`!important`. If a shared class is wrong for your block, either the block wants
its own class or the shared class needs changing for everyone.

Two carve-outs from BEM:

- **Utility and typography classes stay flat.** `.blockr-title`,
  `.blockr-label`, `.blockr-helper`, `.blockr-meta`, `.blockr-error` are
  single-purpose text styles, not components, and BEM structure on them is
  noise.
- **State is a modifier, not a sibling class.** `.blockr-sidebar--open`, not
  `.blockr-sidebar-open`. One shared `.blockr-pill--active` serves every block;
  do not re-implement an active-pill style per block.

Some older shared classes still use flat chains (`.blockr-row-remove`,
`.blockr-sidebar-header`). They migrate to BEM (`.blockr-row__remove`,
`.blockr-sidebar__header`) when the shared layer moves to blockr.ui, with
builders emitting both names for one release. Write new classes in BEM.

## Block-specific — short prefix

Every dplyr block uses a short letter prefix so block-scoped classes cannot collide with the shared primitives or with each other. Convention: initials of the block name + `b` for "block" + `-`.

| Prefix | Block |
|---|---|
| `ab-`  | arrange |
| `bcb-` | bind-cols |
| `brb-` | bind-rows |
| `fb-`  | filter |
| `jb-`  | join |
| `mb-`  | mutate |
| `plb-` | pivot-longer |
| `pwb-` | pivot-wider |
| `rb-`  | rename |
| `sb-`  | select **and** summarize (known collision) |
| `slb-` | slice |
| `spb-` | separate |
| `ub-`  | unite |
| `seas-`| seasonal (blockr.seasonal) |

### Known collision: `sb-`

Both `select-block.css` and `summarize-block.css` use `sb-`, and unite borrows
`sb-toggle` from summarize on top of that. Renaming one (`selb-` for select, or
`smb-` for summarize) is a pending cleanup. Don't add to the collision.

## Where to put new classes

- A shared layout primitive used by three or more blocks → `blockr-*` in `blockr-blocks.css`.
- One-off structure inside a single block → `xxb-*` in that block's `.css`.
- A variant of a shared component → BEM modifier on the shared class, not a new namespace.

## R bindings

Shiny input binding classes match the component. For `Blockr.Select` consumers, the binding looks for `.blockr-select` on the input element; the binding lives in the consuming package, not in `blockr.dplyr`.
