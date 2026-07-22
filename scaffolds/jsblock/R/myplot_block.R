#' Myplot block (JS-driven)
#'
#' Distribution plot: pick a grouping column and a numeric column, get a
#' boxplot with jittered points. The control UI is a JavaScript class
#' (`inst/js/myplot-block.js`) built on the shared `Blockr.Select`
#' component; R receives the state as JSON and turns it into a ggplot2
#' expression in `make_myplot_expr()`.
#'
#' Deliberately small -- this block exists to be replaced. Describe the
#' visualization you actually want to your coding agent and let it rewrite
#' `make_myplot_expr()` and the JS class while keeping the tests green.
#'
#' Structure (identical in every JS-driven block):
#' - constructor arguments = the block's state; names must match the
#'   `state` list assembled below, exactly and in count
#' - the factory (`R/js-block.R`) owns the sync, lifecycle, and UI shell
#' - the JS class owns the DOM; `inst/js/types.d.ts` types the state JSON
#'
#' @param x Grouping column (x axis).
#' @param y Numeric column (y axis).
#' @param ... Forwarded to [blockr.core::new_plot_block()].
#'
#' @export
new_myplot_block <- function(x = NULL, y = NULL, ...) {
  new_js_plot_block(
    class = "myplot_block",
    name = "myplot",
    state = list(x = x, y = y),
    expr_fn = function(s) make_myplot_expr(s$x, s$y),
    dat_valid = function(data) {
      stopifnot(is.data.frame(data))
    },
    ...
  )
}
