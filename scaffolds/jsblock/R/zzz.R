.onLoad <- function(libname, pkgname) {
  blockr.core::register_blocks(
    ctor = "new_myplot_block",
    name = "My plot",
    description = "Boxplot with jittered points by group",
    category = "plot",
    package = pkgname
  )
}
