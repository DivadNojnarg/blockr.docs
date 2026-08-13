# Two test tiers, per blockr.docs/patterns/r-driven-blocks.md:
#   tier 1 -- the expression builder as a pure function (no Shiny)
#   tier 2 -- testServer() for state handling and the returned expression
# No shinytest2: testServer() covers everything an R-driven block does.

# bbquote() leaves `.(data)` unresolved; the framework substitutes it at
# eval time. Do that substitution by hand in tests.
eval_bquoted <- function(expr, df) {
  resolved <- do.call(bquote, list(expr, list(data = as.name("data"))))
  eval(resolved, envir = list(data = df))
}

# --- Tier 1: expression builder ---------------------------------------------
# No unconfigured-state test: x and y are required state (allow_empty_state
# defaults to FALSE), so the framework never evaluates the expression until
# both are set. That gating is blockr.core's contract, tested there.

test_that("configured state yields the boxplot with the right mappings", {
  expr <- make_myplot_expr(x = "Species", y = "Sepal.Length")
  p <- eval_bquoted(expr, iris)
  expect_s3_class(p, "ggplot")
  expect_identical(p$labels$x, "Species")
  expect_identical(p$labels$y, "Sepal.Length")
  # Renders without error (catches bad aesthetics / missing columns).
  expect_no_error(ggplot2::ggplot_build(p))
})

test_that("non-syntactic column names survive", {
  df <- data.frame(`odd name` = c("a", "b"), `val ue` = c(1, 2), check.names = FALSE)
  expr <- make_myplot_expr(x = "odd name", y = "val ue")
  expect_no_error(ggplot2::ggplot_build(eval_bquoted(expr, df)))
})

# --- Tier 2: testServer() ----------------------------------------------------

test_that("inputs flow into expression and state", {
  blk <- new_myplot_block()

  shiny::testServer(
    blk$expr_server,
    args = list(data = shiny::reactive(iris)),
    {
      session$setInputs(xcol = "Species", ycol = "Petal.Width")
      session$flushReact()

      expect_identical(session$returned$state$x(), "Species")
      expect_identical(session$returned$state$y(), "Petal.Width")

      p <- eval_bquoted(session$returned$expr(), iris)
      expect_s3_class(p, "ggplot")
      expect_identical(p$labels$y, "Petal.Width")
    }
  )
})

test_that("constructor state restores (this is how saved boards reopen)", {
  blk <- new_myplot_block(x = "Species", y = "Sepal.Width")

  shiny::testServer(
    blk$expr_server,
    args = list(data = shiny::reactive(iris)),
    {
      session$flushReact()
      expect_identical(session$returned$state$x(), "Species")
      p <- eval_bquoted(session$returned$expr(), iris)
      expect_identical(p$labels$y, "Sepal.Width")
    }
  )
})
