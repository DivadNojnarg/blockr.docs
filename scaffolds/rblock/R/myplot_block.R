#' Myplot block (R-driven)
#'
#' Distribution plot: pick a grouping column and a numeric column, get a
#' boxplot with jittered points. Deliberately small -- this block exists to
#' be replaced. Describe the visualization you actually want to your coding
#' agent and let it rewrite `make_myplot_expr()` (and, if needed, the inputs
#' below) while keeping the tests green.
#'
#' Structure (identical in every R-driven block):
#' - constructor arguments = the block's state; names must match the
#'   `state` list returned by the server, exactly and in count
#' - server returns `list(expr = reactive(...), state = list(...))`
#' - the UI uses stock Shiny inputs; `NS(id, ...)` namespaces every input id
#'
#' @param x Grouping column (x axis).
#' @param y Numeric column (y axis).
#' @param ... Forwarded to [blockr.core::new_plot_block()].
#'
#' @export
new_myplot_block <- function(x = character(), y = character(), ...) {
  new_plot_block(
    function(id, data) {
      moduleServer(id, function(input, output, session) {
        x_col <- reactiveVal(x)
        y_col <- reactiveVal(y)

        observeEvent(input$xcol, x_col(input$xcol))
        observeEvent(input$ycol, y_col(input$ycol))

        # Refresh the column choices whenever upstream data changes,
        # keeping the current selection if it still exists.
        observeEvent(colnames(data()), {
          cols <- colnames(data())
          updateSelectInput(
            session, "xcol",
            choices = c("Pick a column" = "", cols),
            selected = if (isTRUE(x_col() %in% cols)) x_col() else ""
          )
          updateSelectInput(
            session, "ycol",
            choices = c("Pick a column" = "", cols),
            selected = if (isTRUE(y_col() %in% cols)) y_col() else ""
          )
        })

        list(
          expr = reactive(make_myplot_expr(x_col(), y_col())),
          state = list(x = x_col, y = y_col)
        )
      })
    },
    function(id) {
      tagList(
        selectInput(
          inputId = NS(id, "xcol"),
          label = "X axis (groups)",
          choices = x,
          selected = x
        ),
        selectInput(
          inputId = NS(id, "ycol"),
          label = "Y axis (values)",
          choices = y,
          selected = y
        )
      )
    },
    dat_valid = function(data) {
      stopifnot(is.data.frame(data))
    },
    class = "myplot_block",
    expr_type = "bquoted",
    allow_empty_state = TRUE,
    ...
  )
}
