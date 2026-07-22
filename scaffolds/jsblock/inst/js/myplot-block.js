// @ts-check
/**
 * MyplotBlock — JS-driven plot block input binding.
 *
 * Two single-select column pickers (x group, y value) built on the shared
 * Blockr.Select component. Submits immediately on any change; R turns the
 * {x, y} state into a ggplot2 expression (R/expr-builders.R).
 *
 * Depends on: blockr-core.js, blockr-select.js (loaded via blockr.dplyr's
 * exported dependency functions — see R/js-block.R).
 *
 * The class contract (same in every JS-driven block):
 *   getValue()        -> state JSON, or null before the first user submit
 *   setState(state)   -> rebuild UI from state; must NEVER fire _callback
 *   updateColumns(m)  -> refresh pickers with new column metadata
 *   _compose()        -> state JSON; must round-trip through setState()
 */
(() => {
  'use strict';

  class MyplotBlock {
    /** @param {HTMLElement} el */
    constructor(el) {
      this.el = el;
      /** @type {string} */
      this.x = '';
      /** @type {string} */
      this.y = '';
      /** @type {BlockrSelectOption[]} */
      this.columnOptions = [];
      /** @type {((value: boolean) => void) | null} */
      this._callback = null;
      this._submitted = false;
      /** @type {BlockrSelectSingleHandle | null} */
      this._xSelect = null;
      /** @type {BlockrSelectSingleHandle | null} */
      this._ySelect = null;
      /** @type {HTMLDivElement} */
      this.card = document.createElement('div');

      this._buildDOM();
    }

    _buildDOM() {
      this.card.className = 'myplot-card';
      this.el.appendChild(this.card);

      this._xSelect = this._pickerRow('X axis (groups)', (value) => {
        this.x = value;
        this._submit();
      });
      this._ySelect = this._pickerRow('Y axis (values)', (value) => {
        this.y = value;
        this._submit();
      });
    }

    /**
     * One labelled picker row.
     * @param {string} label
     * @param {(value: string) => void} onChange
     * @returns {BlockrSelectSingleHandle}
     */
    _pickerRow(label, onChange) {
      const row = document.createElement('div');
      row.className = 'myplot-row';

      const lab = document.createElement('div');
      lab.className = 'blockr-label';
      lab.textContent = label;
      row.appendChild(lab);

      const handle = Blockr.Select.single(row, {
        options: this.columnOptions,
        selected: '',
        allowEmpty: true, // no silent auto-pick: '' keeps the placeholder
        placeholder: 'Pick a column…',
        onChange
      });
      handle.el.classList.add('blockr-select--bordered');

      this.card.appendChild(row);
      return handle;
    }

    /** @returns {MyplotState} */
    _compose() {
      return { x: this.x, y: this.y };
    }

    _submit() {
      this._submitted = true;
      this._callback?.(true);
    }

    getValue() {
      if (!this._submitted) return null;
      return this._compose();
    }

    /** @param {MyplotState | null | undefined} state */
    setState(state) {
      this.x = state?.x || '';
      this.y = state?.y || '';
      this._xSelect?.setOptions(this.columnOptions, this.x);
      this._ySelect?.setOptions(this.columnOptions, this.y);
    }

    /** @param {BlockrColumnMeta[] | null | undefined} meta */
    updateColumns(meta) {
      this.columnOptions = (meta || []).map((col) => ({
        value: col.name,
        label: col.label || ''
      }));
      // allowEmpty keeps the current ('' included) selection when possible.
      this._xSelect?.setOptions(this.columnOptions, this.x);
      this._ySelect?.setOptions(this.columnOptions, this.y);
    }
  }

  // --- Shiny wiring (binding + message handlers via shared factory) ---

  Blockr.registerBlock({
    name: 'myplot',
    Block: MyplotBlock,
    messages: {
      'myplot-columns': (block, msg) => block.updateColumns(msg.columns),
      'myplot-block-update': (block, msg) => block.setState(msg.state)
    }
  });
})();
