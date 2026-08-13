#' Build the myplot expression
#'
#' Pure function: column choices in, quoted ggplot2 code out. Kept free of
#' Shiny so it is unit-testable in isolation (tier 1 tests). This is the
#' function to rewrite when you turn myplot into your own visualization --
#' the server and UI around it can usually stay as they are.
#'
#' Rules that bite:
#' - Build language objects (`as.name()`), never `paste()` + parse.
#' - Qualify every function (`ggplot2::`): the expression is evaluated
#'   outside this package's namespace.
#' - No unconfigured branch: `x` and `y` are required state, so the
#'   framework only evaluates this expression once both are set (see the
#'   constructor). Don't guard, and don't error -- a throw here would
#'   escape the framework's error handling.
#'
#' @param x Grouping column (mapped to the x axis, treated as discrete).
#' @param y Numeric column (mapped to the y axis).
#' @noRd
make_myplot_expr <- function(x, y) {
  bbquote(
    ggplot2::ggplot(
      .(data),
      ggplot2::aes(x = factor(.(x)), y = .(y), fill = factor(.(x)))
    ) +
      ggplot2::geom_boxplot(alpha = 0.6, outlier.shape = NA) +
      ggplot2::geom_jitter(width = 0.15, alpha = 0.5, size = 1.5) +
      ggplot2::labs(x = .(x_lab), y = .(y_lab)) +
      ggplot2::guides(fill = "none") +
      ggplot2::theme_minimal(base_size = 13),
    list(
      x = as.name(x),
      y = as.name(y),
      x_lab = x,
      y_lab = y
    )
  )
}
