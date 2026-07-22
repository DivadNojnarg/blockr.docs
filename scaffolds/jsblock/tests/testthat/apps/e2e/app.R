# Test board for the shinytest2 round-trip (tier 3). Plain new_board (no
# dock UI) keeps startup fast; the JS control plane is identical either way.
library(blockr.core)
pkgload::load_all("../../../..", quiet = TRUE)

serve(
  new_board(
    blocks = c(
      data = new_dataset_block("iris"),
      myplot = new_myplot_block()
    ),
    links = c(new_link("data", "myplot", "data"))
  ),
  id = "board"
)
