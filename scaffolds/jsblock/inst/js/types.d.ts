/**
 * Type declarations for the myplot block.
 *
 * The state interface is the R <-> JS protocol contract: write it FIRST
 * when changing the block, then keep `_compose()` / `setState()` and the
 * R expression builder in sync with it.
 *
 * The `Blockr` declarations below are the subset of the shared component
 * API (blockr.dplyr/inst/js/types.d.ts) that this block uses. If you use
 * more of it (Blockr.Select.multi, Blockr.Input, Blockr.onDocClick),
 * extend these declarations from the upstream file.
 */

/* --- This block's state (the protocol contract) --- */

interface MyplotState {
  /** Grouping column mapped to x; '' while unset. */
  x: string;
  /** Numeric column mapped to y; '' while unset. */
  y: string;
}

/* --- Column metadata pushed by R on every data change --- */

interface BlockrColumnMeta {
  name: string;
  /** Human label ('' if the column has none). */
  label?: string;
}

/* --- Shared components (subset; source of truth: blockr.dplyr) --- */

type BlockrSelectOption = string | { value: string; label?: string };

interface BlockrSelectSingleConfig {
  options?: BlockrSelectOption[];
  selected?: string | null;
  /** '' means "nothing selected" and survives setOptions(). */
  allowEmpty?: boolean;
  placeholder?: string;
  onChange?: (value: string) => void;
}

interface BlockrSelectSingleHandle {
  el: HTMLDivElement;
  getValue(): string;
  setOptions(
    opts: BlockrSelectOption[] | null | undefined,
    sel?: string | null
  ): void;
  destroy(): void;
}

interface BlockrBlockHost extends HTMLElement {
  _block?: any;
}

interface BlockrStatic {
  Select: {
    single(
      container: HTMLElement,
      config: BlockrSelectSingleConfig
    ): BlockrSelectSingleHandle;
  };
  registerBlock(config: {
    name: string;
    Block: new (el: HTMLElement) => any;
    messages?: Record<string, (block: any, msg: any) => void>;
  }): void;
}

declare const Blockr: BlockrStatic;
