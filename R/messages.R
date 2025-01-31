messages <- list()

# Value in range error message
messages$valueRangeError = function(name, valueLower, valueUpper, unit) {
  paste0("The value for '", name, "' must be between ", valueLower, " and ", valueUpper, " ", unit, ".")
}

# Value in enum error message
messages$valueEnumError = function(name, value) {
  paste0("Value '", value, "' is not allowed for '", name, "'.")
}

# Read-only error message
messages$readOnly = function(name) {
  paste0("'", name, "' is read-only.")
}

# Not valid err
messages$notValid = function(name) {
  paste0("'", name, "' is not valid.")
}

