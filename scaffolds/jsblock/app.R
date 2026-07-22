# Demo board: see the myplot block working in a real pipeline.
# Launch with shiny::runApp("<this package dir>") or RStudio's Run App.
# runApp sets the working directory to this folder, so load_all(".") loads
# this package. Deps are assumed already installed -- do not (re)install.
library(blockr.core)
library(blockr.dock) # dockable layout + block picker
library(blockr.dag) # DAG view extension
pkgload::load_all(".")

serve(
  new_dock_board(
    blocks = c(
      data = new_dataset_block("iris"), # upstream source
      myplot = new_myplot_block() # the block under development
    ),
    links = c(new_link(from = "data", to = "myplot", input = "data")),
    extensions = new_dag_extension()
  )
)
