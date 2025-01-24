messages <- list()

# Value in range error message
messages$valueRangeError = function(name, valueLower, valueUpper) {
  paste0("The value for '", name, "' must be between ", valueLower, " and ", valueUpper, ".")
}
