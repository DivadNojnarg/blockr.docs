# Tier 1 (of 3, per blockr.docs/patterns/js-driven-blocks.md): the
# expression builder as a pure function. Most bugs in JS-driven blocks live
# here, not in the UI -- keep this tier the thorough one.

# bbquote() leaves `.(data)` unresolved; the framework substitutes it at
# eval time. Do that substitution by hand in tests.
eval_bquoted <- function(expr, df) {
  resolved <- do.call(bquote, list(expr, list(data = as.name("data"))))
  eval(resolved, envir = list(data = df))
}

test_that("unconfigured state yields a placeholder plot, not an error", {
  for (state in list(
    list(),
    list(x = NULL, y = NULL),
    list(x = "Species", y = NULL), # partially edited
    list(x = "", y = "")
  )) {
    expr <- make_myplot_expr(state$x, state$y)
    expect_s3_class(eval_bquoted(expr, iris), "ggplot")
  }
})

test_that("configured state yields the boxplot with the right mappings", {
  expr <- make_myplot_expr(x = "Species", y = "Sepal.Length")
  p <- eval_bquoted(expr, iris)
  expect_s3_class(p, "ggplot")
  expect_identical(p$labels$x, "Species")
  expect_identical(p$labels$y, "Sepal.Length")
  expect_no_error(ggplot2::ggplot_build(p))
})

test_that("non-syntactic column names survive", {
  df <- data.frame(`odd name` = c("a", "b"), `val ue` = c(1, 2), check.names = FALSE)
  expr <- make_myplot_expr(x = "odd name", y = "val ue")
  expect_no_error(ggplot2::ggplot_build(eval_bquoted(expr, df)))
})

test_that("values from JS stay strings (no type guessing)", {
  # A column literally named "007" must be looked up as the name `007`,
  # not the number 7.
  df <- data.frame(`007` = c("a", "b"), v = c(1, 2), check.names = FALSE)
  expr <- make_myplot_expr(x = "007", y = "v")
  expect_no_error(ggplot2::ggplot_build(eval_bquoted(expr, df)))
})
