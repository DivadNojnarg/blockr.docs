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

That is the whole recipe. For the rare field that also earns a help line, see
[below](#help-text-earns-its-place-or-it-does-not-exist).

The cue clears the moment the field has a value. This is attention, not error:
it says "this still needs you", not "you did something wrong".

### Four places a field can speak, and what each is allowed to say

A field has four carriers, and they are not interchangeable. Most bad UI text
is a sentence sitting in the wrong one.

**0. The control itself, which beats all the text.** If the control can be made
incapable of expressing the wrong value, do that and say nothing. A picker that
offers only numeric columns needs no line asking for a numeric column. Narrate
a constraint only when you cannot enforce it.

**1. The label — what the field *is*.** Said once. Nothing else may re-say it.

**2. The placeholder — the empty slot's voice.** It exists only while the field
is empty, so it may only speak about the empty state, and what it says depends
on whether empty is an answer or a question:

- *Empty is a legal configuration*: name what it does. `None`, `Auto`,
  `All other columns`. This is a **claim about behaviour, and it must be true**
  — see the two footguns below.
- *Empty is not legal*: say what to supply. `Select columns…`, next to the
  amber cue.

For a text field the same rule takes two shapes: show the **effective default**
the code applies when the box is cleared (`_`, `united`, `name`), or show the
**format** a value takes (`col1, col2, col3`, `e.g. USD`).

The trailing `…` marks which of the two you are reading. A prompt trails off
because you are meant to finish it: `Select columns…`. A state does not,
because it is already complete: `None`, `Auto`, `All other columns`. So the
ellipsis is not decoration, it is the difference between "do something" and
"here is what you get".

What a placeholder may never do is describe the field. `Select columns…` under
a label reading `ID columns` describes the field; `All other columns` describes
the empty state.

**3. The help line — what the *value* does.** Optional, rare, and defined by
one property: **it survives the field being filled**, because the value it
speaks about only exists once the field is filled. This gives a test you can
apply without knowing anything about the field:

> If the line disappears when the field is filled, it was placeholder text.

`blockr.io`'s file reader has the canonical example. Under the **Combination
strategy** select sits `Will row-bind files (requires same columns)`. It is a
function of the current value, it changes when the value changes, and it is
*more* useful after you choose than before, because that is when you can check
it. A placeholder physically cannot do that job.

A help line may be silent for some values, including when empty. What it may
not be is a line that speaks *only* when empty and whose content is "what goes
here". That is a placeholder that has wandered below the field.

Restating what is already on screen costs a line of chrome and teaches the user
that our hints carry no information, so the one hint that *would* have mattered
gets skipped too.

### Two ways this went wrong, both worth recognising

**The engine that made every hint into a placeholder.** `drilldown-config.js`
used to blank the help line as soon as the field had a value, and to fall back
to the role's placeholder when no hint was declared. Both follow from the same
mistaken premise, that the help line is a second placeholder. The result was
that an empty column picker printed `column to aggregate…` inside itself and
again directly beneath itself. Whoever wrote the fallback read the slot's
lifecycle correctly; the lifecycle was the bug.

**The illustration that outran the rule.** This document once offered
`one or more columns` and `column to aggregate…` as model help lines. Both fail
the test above. `blockr.ggplot` copied the first into its facet block with a
comment conceding that the label already carried the information. Never quote a
hint as a model without checking that it clears the bar. Illustrations
propagate faster than rules, including the wrong ones.

### A placeholder is a claim, so it can be false

Once the placeholder names the empty state, it becomes checkable, and two of
ours were lying.

`blockr.dplyr`'s `Separator` fields showed `_` while the JS shipped the raw
empty string, so clearing the box pasted values with no separator at all. The
control promised a default and delivered none.

`pivot_wider`'s `ID columns (optional)` read `Select columns…`, which hid the
fact that leaving it empty makes tidyr use *every column not already used*. The
placeholder described the field and so had no room to describe the behaviour.

When you write a placeholder for an optional field, go read what the builder
does with an empty value. That is now the placeholder's content.

### Tooltips are a fifth carrier, not a cheaper help line

A `title` tooltip appears on mouse hover only: keyboard focus does not raise it
and touch never does. Screen readers expose it as the *description*, which many
users have switched off. So a fact a user needs in order to act must never live
only in a tooltip. If they need it, it goes in the visible help line above, and
that line is what `aria-describedby` points at.

That leaves three tiers, by what the control already shows:

1. **The control has no visible text** — an icon button, a gear, a pill whose
   glyph is not self-evident. The tooltip is the control's *name*, not a hint,
   and it is mandatory. Give it `aria-label`, not `title` alone, or keyboard
   and screen-reader users never receive it.
2. **The control is labelled, and the tooltip adds a fact the label cannot
   carry.** Keep it. `Distinct rows` earns "deduplicate based on the selected
   columns" because the checkbox cannot show its *scope*; `Keep ties` earns
   "rows with equal values are all included or cut off at n" because nothing on
   screen defines a tie.
3. **The tooltip rephrases the label.** Delete it. `Exclude selected` does not
   need "remove the selected columns instead of keeping them".

The bar is lower than for a help line, because a tooltip costs no chrome. It is
the same bar in kind: add a fact, do not restate one. Redundant tooltips spend
a different currency — the user's habit of hovering. Hover enough controls that
tell you nothing new and you stop hovering, and the tooltip on `Keep ties` that
would have helped goes unread.

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
