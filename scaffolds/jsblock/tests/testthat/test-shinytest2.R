# Tier 3: one happy-path shinytest2 test for the JS round-trip. This is the
# only way to verify JS UI -> input binding -> R expression -> rendered plot
# end to end: custom bindings are unreachable for set_inputs(), so the block
# is driven through its JS API via run_js(). Keep this file to ONE test per
# block -- everything else belongs in tiers 1 and 2 (fast, no browser).
#
# Run locally: Sys.setenv(NOT_CRAN = "true"); testthat::test_file(...)

skip_on_cran()
skip_if_not_installed("shinytest2")

test_that("JS state round-trips to a rendered plot", {
  app <- shinytest2::AppDriver$new(
    testthat::test_path("apps", "e2e"),
    name = "myplot-e2e",
    seed = 42,
    load_timeout = 60 * 1000,
    timeout = 15 * 1000
  )
  withr::defer(app$stop())
  app$wait_for_idle()

  input_id <- "board-block_myplot-expr-myplot_input"

  # Drive the JS block instance directly: setState() + _submit() is what a
  # user edit does after the dropdown callbacks fire.
  state_json <- jsonlite::toJSON(
    list(x = "Species", y = "Sepal.Length"),
    auto_unbox = TRUE, null = "null"
  )
  app$run_js(sprintf(
    "var el = document.getElementById('%s');
     el._block.setState(%s);
     el._block._submit();",
    input_id, state_json
  ))
  app$wait_for_idle()

  # The blob arrived in R with strings intact.
  blob <- app$get_values(input = input_id)$input[[input_id]]
  expect_identical(blob$x, "Species")
  expect_identical(blob$y, "Sepal.Length")

  # And the plot output actually rendered (renderPlot produces an <img>).
  rendered <- app$get_js(
    "(() => {
       const img = document.querySelector('#board-block_myplot-expr-plot img')
         || document.querySelector('img');
       return !!img && img.naturalWidth > 0;
     })()"
  )
  expect_true(isTRUE(rendered))
})
