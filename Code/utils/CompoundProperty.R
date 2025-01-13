#' @title CompoundProperty
#' @docType class
#' @description  Property of a compound
#' @format NULL
CompoundProperty <- R6::R6Class(
  "CompoundProperty",
  cloneable = FALSE,
  inherit = ospsuite.utils::Printable,
  active = list(
    #' @field dimension Dimension of the property
    dimension = function(value) {
      if (missing(value)) {
        return(private$.dimension)
      } else {
        error("Dimension is read-only")
      }
    },
    #' @field unit Unit of the property
    unit = function(value) {
      if (missing(value)) {
        return(private$.unit)
      } else {
        ospsuite::validateUnit(value, private$.dimension)
        private$.unit <- value
      }
    }
  ),
  public = list(
    # ID of the compound
    name = NULL,
    path = NULL,
    value = NULL,

    #' @description
    #' Initialize a new instance of the class
    #' @return A new `CompoundProperty` object.
    initialize = function(name, path, dimension, value = 0, unit = NULL) {
      self$name <- name
      self$path <- path
      self$value <- value

      private$.dimension <- dimension
      if (!is.null(unit)) {
        self$unit <- unit
      } else {
        private$.unit <- ospsuite::getBaseUnit(dimension)
      }
    },

    # Return the value of the property in base unit
    toBaseUnit = function() {
      return(ospsuite::toBaseUnit(
        quantityOrDimension = self$dimension,
        values = self$value,
        unit = self$unit
      ))
    },

    #' @description
    #' Print the object to the console
    #' @param ... Rest arguments.
    print = function(...) {
      private$printClass()
      private$printLine("Name", self$name)
      private$printLine("Path", self$path)
      private$printLine("Value", self$value)
      private$printLine("Unit", self$unit)

      invisible(self)
    }
  ),
  private = list(
    .dimension = NULL,
    .unit = NULL
  )
)
