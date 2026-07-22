`%||%` <- function(x, y) if (is.null(x)) y else x

#' Is a column choice set?
#'
#' @param v Candidate column name.
#' @noRd
is_set <- function(v) {
  is.character(v) && length(v) == 1L && nzchar(v)
}

#' Build the myplot expression
#'
#' Pure function: state in, quoted ggplot2 code out. Kept free of Shiny so
#' it is unit-testable in isolation (tier 1 tests). This is the function to
#' rewrite when you turn myplot into your own visualization -- the JS class
#' owns the controls, this function owns the plot.
#'
#' Rules that bite:
#' - Build language objects (`as.name()`), never `paste()` + parse.
#' - Qualify every function (`ggplot2::`): the expression is evaluated
#'   outside this package's namespace.
#' - Everything arriving from JS is untrusted: strings stay strings, and
#'   an unconfigured or partially-edited state must never error -- return
#'   a friendly placeholder plot until both columns are chosen.
#'
#' @param x Grouping column (mapped to the x axis, treated as discrete).
#' @param y Numeric column (mapped to the y axis).
#' @noRd
make_myplot_expr <- function(x = NULL, y = NULL) {
  if (!is_set(x %||% "") || !is_set(y %||% "")) {
    return(
      bbquote(
        ggplot2::ggplot() +
          ggplot2::annotate(
            "text",
            x = 0, y = 0, label = "Pick x and y columns to draw the plot",
            color = "grey45", size = 5
          ) +
          ggplot2::theme_void()
      )
    )
  }

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
