# Tier 2: testServer() for the R server logic. The JS class can't be driven
# from here (custom input bindings are out of testServer's reach), but the
# state blob it WOULD send can be injected directly on the input -- that
# exercises the decompose path in js_block_state().

eval_bquoted <- function(expr, df) {
  resolved <- do.call(bquote, list(expr, list(data = as.name("data"))))
  eval(resolved, envir = list(data = df))
}

test_that("constructor state flows to expression and state fields", {
  blk <- new_myplot_block(x = "Species", y = "Sepal.Width")

  shiny::testServer(
    blk$expr_server,
    args = list(data = shiny::reactive(iris)),
    {
      session$flushReact()

      expect_identical(session$returned$state$x(), "Species")
      expect_identical(session$returned$state$y(), "Sepal.Width")

      p <- eval_bquoted(session$returned$expr(), iris)
      expect_s3_class(p, "ggplot")
      expect_identical(p$labels$y, "Sepal.Width")
    }
  )
})

test_that("a JS state blob updates the per-field reactiveVals", {
  blk <- new_myplot_block()

  shiny::testServer(
    blk$expr_server,
    args = list(data = shiny::reactive(iris)),
    {
      # Simulate what the input binding would deliver after a user edit.
      session$setInputs(myplot_input = list(x = "Species", y = "Petal.Length"))
      session$flushReact()

      expect_identical(session$returned$state$x(), "Species")
      expect_identical(session$returned$state$y(), "Petal.Length")

      p <- eval_bquoted(session$returned$expr(), iris)
      expect_identical(p$labels$y, "Petal.Length")
    }
  )
})

test_that("fresh block renders the placeholder, not an error", {
  blk <- new_myplot_block()

  shiny::testServer(
    blk$expr_server,
    args = list(data = shiny::reactive(iris)),
    {
      session$flushReact()
      expect_s3_class(eval_bquoted(session$returned$expr(), iris), "ggplot")
    }
  )
})
