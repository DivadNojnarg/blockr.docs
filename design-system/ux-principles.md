# UX principles

Behavioural rules for block UIs — how controls should *act*, as opposed to the
visual primitives in [colors.md](./colors.md), [typography.md](./typography.md)
and [spacing-and-sizing.md](./spacing-and-sizing.md).

## Defaults: auto-pick when harmless, require a choice when it changes results

A control that must be filled in has two honest options when the block is
created: pre-fill it with a default, or leave it empty and ask.

**Auto-pick when the default is harmless.** A fresh filter row landing on the
first column is a no-op filter; a fresh summarize row computing `mean` of the
first column is a visible, obviously-editable guess. Nothing is silently
decided on the user's behalf, because the result is either inert or plainly
wrong in a way the user can see.

**Require a choice when the default silently changes results.** `slice_min()`
without `order_by` decides *which rows survive*; `separate()` decides which
column gets torn apart; weighted sampling decides how the sample is drawn.
Picking the first column here produces a plausible-looking, quietly wrong
answer. These fields start empty, carry the amber
[required-empty cue](#required-empty-fields), and wait.

The test is not "is this field required?" but **"if I guess, will the user
notice?"** If the answer is no, don't guess.

### Two invariants this rests on

1. **The model and the control never disagree.** After any option refresh, the
   block's state must equal what the control displays. A picker showing `mpg`
   while the block's `col` is `""` is a bug in both directions: the block looks
   configured and isn't, or it errors on data the user believes it accepted.
   In `Blockr.Select` single mode, opt a field out of the first-option fallback
   with `allowEmpty: true` (then `''` survives `setOptions()` and the
   placeholder shows); otherwise re-read `getValue()` into the model after
   `setOptions()`.

2. **An unconfigured block passes data through — it never errors.** The amber
   cue is the message; a red error banner or a `dplyr` exception is not. The
   expression builder returns the input unchanged until the required fields are
   set (`make_separate_expr()`, `make_slice_expr()`).

## Required-empty fields

A required field with no value gets a soft amber cue on the **control itself**,
never a warning banner:

- border `var(--blockr-color-warning, #f59e0b)`, background
  `var(--blockr-color-warning-bg, #fffbeb)`
- the label carries a trailing `*`
- a muted help line sits **directly beneath the field**, saying what to supply
  in a terse noun phrase ("one or more columns", "column to aggregate…") — the
  label already names the field, so the hint should not repeat it

The cue clears the moment the field has a value. This is attention, not error:
it says "this still needs you", not "you did something wrong".

## Boolean controls

- **Values → cycling pill.** The label *is* the value and both states are
  equally valid choices: `AND`/`OR`, `asc`/`desc`, `n`/`%`, comparison
  operators, join types.
- **Data options → checkbox.** A self-labeling on/off toggle is ambiguous — when
  a pill reads `include`, the user cannot tell whether that is the current state
  or the action a click performs. A checkbox shows state and action separately.
- **UI modes → switch** (reserved; ships when a real use case lands).

## Text commit

Text and number fields commit on **Enter or blur**, never per keystroke. While
the typed value differs from the committed one, an `Enter ↵` chip is armed
inside the field's right edge; committing fades it to a ✓, typing re-arms it,
and Escape reverts. The chip always spells `Enter` — a bare glyph is not
self-evident. Per-keystroke updates survive only where the input *is* a live
filter (a table's quick-search box).

See `target/design-system.html` §5.5 for the keystroke-label rules.
