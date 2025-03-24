messages <- list()

# Value in range error message
messages$valueRangeError <- function(name, valueLower, valueUpper, unit) {
  paste0("The value for '", name, "' must be between ", valueLower, " and ", valueUpper, " ", unit, ".")
}

# Value in enum error message
messages$valueEnumError <- function(name, value, allowed = NULL) {
  msg <- paste0("Value '", value, "' is not allowed for '", name, "'.")
  if (!is.null(allowed)) {
    msg <- capture.output(
      cli::cli_text("{msg} {stringr::str_to_sentence(name)} must be one of {.code {allowed}}."),
      type = "message"
    )
  }
  return(msg)
}

# Read-only error message
messages$readOnly <- function(name) {
  paste0("'", name, "' is read-only.")
}

# Not valid error message
messages$notValid <- function(name) {
  paste0("'", name, "' is not valid.")
}

# Not found error message
messages$notFound <- function(name, value) {
  paste0(name, " '", value, "' not found.")
}

# Already exist error message
messages$alreadyExist <- function(name, value) {
  paste0(name, " '", value, "' already exists.")
}
