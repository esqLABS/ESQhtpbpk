messages <- list(
  valueNotAvailable = function(compoundId, property) {
    paste0(
      "Compound ID ", compoundId, " cannot be used because no ", property, " is available."
    )
  },
  parameterPathNotDefined = function(path) {
    paste0("Trying to update parameter with path '", path, "', but the path has not been defined as variable!")
  }
)
