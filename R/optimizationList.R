extract_best     <- function(x, ...) { UseMethod("extract_best", x) }

extract_best.OptimizationList <- function(stanoptimList, pars = NULL) {
  ind       <- which.max(sapply(stanoptimList, "[[", "value"))
  stanoptim <- stanoptimList[[ind]]
  attrNames <- names(attributes(stanoptimList))

  for (name in attrNames[-1]) {
    attr(stanoptim, name) <- attr(stanoptimList, name)
  }

  stanoptim
}

extract_grid.OptimizationList <- function(stanoptim, pars = NULL) {
  mat <- do.call(
    rbind,
    lapply(stanoptim, extract_grid, pars)
  )
  cbind(n = 1:NROW(mat), mat)[order(-mat[, "logPosterior"]), ]
}
