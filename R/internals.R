#' Ensure that a given value is in a given range
#'
#' @param name Name to use in the error message.
#' @param dimension dimension of the value for unit conversion
#' @param value Value to check if is in the range
#' @param unit Unit of the value for unit conversion
#' @param lower lower bound of the range to be respected
#' @param upper upper bound of the range to be respected
#' @param rangeUnit Unit of the lower and upper values for unit conversion
#' @keywords internal
#' @noRd
.checkValueInRangeEq <- function(
  name,
  dimension,
  value,
  unit,
  lower,
  upper,
  rangeUnit
) {
  # ensure that the lower and upper bounds are numeric and that lower <= upper
  stopifnot(is.numeric(lower), is.numeric(upper), lower <= upper)

  # if unit are not given assume base unit
  if (is.null(unit)) {
    unit <- ospsuite::getBaseUnit(dimension)
  }
  if (is.null(rangeUnit)) {
    rangeUnit <- ospsuite::getBaseUnit(dimension)
  }

  # check that value is in range otherwise return error message
  if (rangeUnit != unit) {
    range <- ospsuite::toUnit(
      values = c(lower, upper),
      sourceUnit = rangeUnit,
      targetUnit = unit,
      quantityOrDimension = dimension
    )
    lower <- range[1]
    upper <- range[2]
  }
  valid <- (value >= lower && value <= upper)
  if (!valid) {
    cli::cli_abort(messages$valueRangeError(name, lower, upper, rangeUnit))
  }
}

#' @keywords internal
#' @noRd
.myDeepClone <- function(name, value) {
  # if some nested class are found do a deep clone
  r6obj <- "R6" %in% class(value)

  if (r6obj) {
    return(value$clone(deep = TRUE))
  } else {
    r6obj <- unlist(
      lapply(
        unlist(value, recursive = TRUE),
        \(x) {
          "R6" %in% class(x)
        }
      )
    )

    if (any(r6obj)) {
      res <- purrr::modify_tree(value, leaf = \(x) {
        if ("R6" %in% class(x)) {
          y <- x$clone(deep = TRUE)
          return(y)
        } else {
          return(x)
        }
      })

      return(res)
    } else {
      # For all other fields, just return the value
      return(value)
    }
  }
}

#' @keywords internal
#' @noRd
.myDeepClone <- function(name, value) {
  # if some nested class are found do a deep clone
  r6obj <- "R6" %in% class(value)

  if (r6obj) {
    return(value$clone(deep = TRUE))
  } else {
    r6obj <- unlist(
      lapply(
        unlist(value, recursive = TRUE),
        \(x) {
          "R6" %in% class(x)
        }
      )
    )
    if (any(r6obj)) {
      res <- purrr::modify_tree(
        value,
        leaf = \(x) {
          if ("R6" %in% class(x)) {
            y <- x$clone(deep = TRUE)
            return(y)
          } else {
            return(x)
          }
        }
      )

      return(res)
    } else {
      # For all other fields, just return the value
      return(value)
    }
  }
}
