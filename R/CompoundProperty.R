#' @title Property
#' @docType class
#' @description  Property of a compound, of a formulation
#' @format NULL
Property <- R6::R6Class(
  "Property",
  active = list(
    #' @field name Name of the property
    name = function(value) {
      if (missing(value)) {
        return(private$.name)
      } else {
        cli::cli_abort(messages$readOnly("name"))
      }
    },

    #' @field dimension Dimension of the property
    dimension = function(value) {
      if (missing(value)) {
        return(private$.dimension)
      } else {
        cli::cli_abort(messages$readOnly("dimension"))
      }
    },
    #' @field value Value of the property.
    value = function(value) {
      if (missing(value)) {
        return(private$.value)
      } else {
        if (!is.null(private$.enum)) {
          if (!(value %in% names(private$.enum))) {
            msg <- messages$valueEnumError(
              private$.name,
              value,
              allowed = names(private$.enum)
            )
            cli::cli_abort("{msg}")
          }
          private$.value <- private$.enum[value]
        } else if (!is.null(private$.check)) {
          private$.check(value, private$.unit)
          private$.value <- value
        } else {
          private$.value <- value
        }
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
    },
    #' @field parName Parameter name of the property in the simulation pkmls
    parName = function(value) {
      if (missing(value)) {
        return(private$.parName)
      } else {
        cli::cli_abort(messages$readOnly("parName"))
      }
    },
    #' @field path Path of the property in the simulation pkmls
    path = function(value) {
      if (missing(value)) {
        return(private$.path)
      } else {
        cli::cli_abort(messages$readOnly("path"))
      }
    },
    #' @field enum Enums to convert from user friendly value to PK-Sim allowed value
    enum = function(value) {
      if (missing(value)) {
        return(private$.enum)
      } else {
        cli::cli_abort(messages$readOnly("enum"))
      }
    },
    #' @field check Function to check validity of given value, must take value and unit as arguments
    #' and must return an error if value is not valid
    check = function(value) {
      if (missing(value)) {
        return(private$.check)
      } else {
        cli::cli_abort(messages$readOnly("check"))
      }
    }
  ),
  public = list(
    #' @description
    #' Initialize a new instance of the class.
    #' @param name Name of the property.
    #' @param parName Parameter name of the property in the simulation pkmls.
    #' @param dimension Dimension of the property.
    #' @param value Value of the property
    #' @param unit Unit of the property.
    #' @param enum (Optional) Enum to convert from user friendly value to PK-Sim allowed value
    #' @param check (Optional) Function to check validity of given value, must take value and unit as arguments
    #' and must return an error if the value is not valid
    #' @param min (Optional) Min value allowed to check validity of given value
    #' @param max (Optional) Max value allowed to check validity of given value
    #' @param rangeUnit (Optional) Unit in which the min/max range is given
    #' @param path path of the property in the simulation pkmls. Default to `CompoundName|parName`
    #' (if not given, the unit is assumed to be the same as the unit of the property).

    #' valid).
    #' @return A new `Property` object.
    initialize = function(
      name,
      parName,
      dimension,
      value = 0,
      unit = NULL,
      enum = NULL,
      check = NULL,
      min = NULL,
      max = NULL,
      rangeUnit = NULL,
      path = NULL
    ) {
      private$.name <- name
      private$.parName <- parName
      if (is.null(path)) {
        path <- paste0("{compoundName}|", parName)
      }
      private$.path <- path

      # check validity of dimension
      ospsuite::validateDimension(dimension)
      private$.dimension <- dimension

      # check and set validity of unit with dimension
      if (is.null(unit)) {
        unit <- ospsuite::getBaseUnit(dimension)
      }
      self$unit <- unit

      # check validity of enum
      if (!is.null(enum) && (!is.list(enum) || is.null(names(enum)))) {
        cli::cli_abort(messages$notValid("enum"))
      }
      private$.enum <- enum

      # check validity of constraint function
      if (is.null(check) && !is.null(min) && !is.null(max)) {
        check <- function(value, unit) {
          .checkValueInRangeEq(
            name,
            dimension,
            value,
            unit,
            min,
            max,
            rangeUnit
          )
        }
      }
      if (!is.null(check) && !is.function(check)) {
        cli::cli_abort(messages$notValid("check"))
      }
      private$.check <- check

      # set and validate value
      self$value <- value
    },

    # Return the value of the property in base unit
    #' @description Return the value of the property in base unit
    toBaseUnit = function() {
      return(ospsuite::toBaseUnit(
        quantityOrDimension = self$dimension,
        values = self$value,
        unit = self$unit
      ))
    },
    #' @description
    #' Convert to snapshot
    toSnapshot = function() {
      snap <- list(
        Name = self$parName,
        Value = self$value,
        Unit = self$unit
      )

      if (snap$Unit == "") {
        snap <- purrr::discard_at(snap, "Unit")
      }

      return(snap)
    },

    #' @description
    #' Print the object to the console
    #' @param compoundName compoundName in the simulation to replace placeholder in the path
    print = function(compoundName = NULL) {
      ospsuite.utils::ospPrintClass(self)
      ospsuite.utils::ospPrintItems(
        list(
          "Property Name" = self$name,
          "Parameter name" = self$parName
        )
      )
      if (!is.null(compoundName)) {
        ospsuite.utils::ospPrintItems(
          list("Path" = glue::glue(self$path))
        )
      } else {
        ospsuite.utils::ospPrintItems(
          list("Path" = self$path)
        )
      }
      if (is.list(private$.enum) && !is.null(names(private$.enum))) {
        ospsuite.utils::ospPrintItems(
          list("Value" = names(self$value))
        )
      } else {
        ospsuite.utils::ospPrintItems(
          list(
            "Value" = self$value,
            "Unit" = self$unit
          )
        )
      }

      invisible(self)
    }
  ),
  private = list(
    .name = NULL,
    .parName = NULL,
    .path = NULL,
    .dimension = NULL,
    .unit = NULL,
    .value = NULL,
    .enum = NULL,
    .check = NULL
  )
)
