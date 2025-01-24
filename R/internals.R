#' Ensure that a given value is in a given range
#'
#' @param name Name to use in the error message.
#' @param value Value to check if is in the range
#' @param lower lower bound of the range to be respected
#' @param upper upper bound of the range to be respected
#' @keywords internal
#' @noRd
.checkValueInRangeEq = function(name, value, lower, upper) {
  # ensure that the lower and upper bounds are numeric and that lower <= upper
  stopifnot(is.numeric(lower), is.numeric(upper), lower <= upper)

  # check that value is in range otherwise return error message
  valid <- (value >= lower && value <= upper)
  if (!valid) {
    stop(messages$valueRangeError(name, lower, upper))
  }
}
