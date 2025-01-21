#' @title Compound
#' @docType class
#' @description  Description of a compound
#' @format NULL
#' @export
Compound <- R6::R6Class(
  "Compound",
  cloneable = FALSE,
  inherit = ospsuite.utils::Printable,
  active = list(),
  public = list(
    #' @field ID Id of the compound
    ID = NULL,
    #' @field name Name of the compound as used in the generic simulation
    name = NULL,

    #' @description
    #' Initialize a new instance of the class Compound
    #' @param ID Id of the compound
    #' @param name Name of the compound in the simulation pkmls
    #' @return A new `Compound` object.
    initialize = function(ID, name = "Compound") {
      self$ID <- ID
      self$name <- name

      private$.allProperties <- list(
        CompoundProperty$new(
          name = "Lipophilicity",
          path = paste(name, "Lipophilicity", sep = "|"),
          dimension = ospsuite::ospDimensions$`Log Units`,
          check = function(value, unit) {
            valid <- (value >= -10 && value <= 10)
            if (!valid) {
              stop("Value must be betwen -10 and 10")
            }
          }
        ),
        CompoundProperty$new(
          name = "Fraction unbound",
          path = paste(name, "Fraction unbound (plasma, reference value)", sep = "|"),
          dimension = ospsuite::ospDimensions$`Fraction`,
          value = 1,
          check = function(value, unit) {
            if (unit == "") {
              valid <- (value >= 0 && value <= 1)
              if (!valid) {
                stop("Value must be betwen 0 and 1")
              }
            } else if (unit == "%") {
              valid <- (value >= 0 && value <= 100)
              if (!valid) {
                stop("Value must be betwen 0 and 100 %")
              }
            }
          }
        ),
        CompoundProperty$new(
          name = "Plasma protein binding partner",
          path = paste(name, "Plasma protein binding partner", sep = "|"),
          dimension = ospsuite::ospDimensions$Dimensionless,
          value = "Albumin",
          enum = PPBPartner
        ),
        CompoundProperty$new(
          name = "Is small molecule",
          path = paste(name, "Is small molecule", sep = "|"),
          dimension = ospsuite::ospDimensions$Dimensionless,
          value = 1
        ),
        CompoundProperty$new(
          name = "Molecular weight",
          path = paste(name, "Molecular weight", sep = "|"),
          dimension = ospsuite::ospDimensions$`Molecular weight`,
          value = 100,
          unit = "g/mol"
        ),
        CompoundProperty$new(
          name = "Bromine count",
          path = paste(name, "Br", sep = "|"),
          dimension = ospsuite::ospDimensions$Dimensionless,
          value = 0,
          check = function(value, unit) {
            valid <- (value >= 0 && value <= 10)
            if (!valid) {
              stop("Value must be betwen 0 and 10")
            }
          }
        ),
        CompoundProperty$new(
          name = "Chlorine count",
          path = paste(name, "Cl", sep = "|"),
          dimension = ospsuite::ospDimensions$Dimensionless,
          value = 0,
          check = function(value, unit) {
            valid <- (value >= 0 && value <= 10)
            if (!valid) {
              stop("Value must be betwen 0 and 10")
            }
          }
        ),
        CompoundProperty$new(
          name = "Chlorine count",
          path = paste(name, "Cl", sep = "|"),
          dimension = ospsuite::ospDimensions$Dimensionless,
          value = 0,
          check = function(value, unit) {
            valid <- (value >= 0 && value <= 10)
            if (!valid) {
              stop("Value must be betwen 0 and 10")
            }
          }
        ),
        CompoundProperty$new(
          name = "Fluorine count",
          path = paste(name, "F", sep = "|"),
          dimension = ospsuite::ospDimensions$Dimensionless,
          value = 0,
          check = function(value, unit) {
            valid <- (value >= 0 && value <= 10)
            if (!valid) {
              stop("Value must be betwen 0 and 10")
            }
          }
        ),
        CompoundProperty$new(
          name = "Iodine count",
          path = paste(name, "I", sep = "|"),
          dimension = ospsuite::ospDimensions$Dimensionless,
          value = 0,
          check = function(value, unit) {
            valid <- (value >= 0 && value <= 10)
            if (!valid) {
              stop("Value must be betwen 0 and 10")
            }
          }
        ),
        CompoundProperty$new(
          name = "pKa value 0",
          path = paste(name, "pKa value 0", sep = "|"),
          dimension = ospsuite::ospDimensions$Dimensionless,
          value = 0,
          check = function(value, unit) {
            valid <- (value >= 0 && value <= 14)
            if (!valid) {
              stop("Value must be betwen 0 and 14")
            }
          }
        ),
        CompoundProperty$new(
          name = "Compound type 0",
          path = paste(name, "Compound type 0", sep = "|"),
          dimension = ospsuite::ospDimensions$Dimensionless,
          value = "Neutral",
          enum = CompoundType
        ),
        CompoundProperty$new(
          name = "pKa value 1",
          path = paste(name, "pKa value 1", sep = "|"),
          dimension = ospsuite::ospDimensions$Dimensionless,
          value = 0,
          check = function(value, unit) {
            valid <- (value >= 0 && value <= 14)
            if (!valid) {
              stop("Value must be betwen 0 and 14")
            }
          }
        ),
        CompoundProperty$new(
          name = "Compound type 1",
          path = paste(name, "Compound type 1", sep = "|"),
          dimension = ospsuite::ospDimensions$Dimensionless,
          value = "Neutral",
          enum = CompoundType
        ),
        CompoundProperty$new(
          name = "pKa value 2",
          path = paste(name, "pKa value 2", sep = "|"),
          dimension = ospsuite::ospDimensions$Dimensionless,
          value = 0,
          check = function(value, unit) {
            valid <- (value >= 0 && value <= 14)
            if (!valid) {
              stop("Value must be betwen 0 and 14")
            }
          }
        ),
        CompoundProperty$new(
          name = "Compound type 2",
          path = paste(name, "Compound type 2", sep = "|"),
          dimension = ospsuite::ospDimensions$Dimensionless,
          value = "Neutral",
          enum = CompoundType
        ),
        CompoundProperty$new(
          name = "Reference pH",
          path = paste(name, "Reference pH", sep = "|"),
          dimension  = ospsuite::ospDimensions$Dimensionless,
          value = 7,
          check = function(value, unit) {
            valid <- (value >= 0 && value <= 14)
            if (!valid) {
              stop("Value must be betwen 0 and 14")
            }
          }
        ),
        CompoundProperty$new(
          name = "Solubility",
          path = paste(name, "Solubility at reference pH", sep = "|"),
          dimension = ospsuite::ospDimensions$`Concentration (mass)`,
          value = 1,
          unit = "mg/l"
        )
      )

      names(private$.allProperties) <- sapply(private$.allProperties, \(x) x$name)
      private$.allPropertyPaths <- sapply(private$.allProperties, \(x) x$path)
    },

    # Getter
    #' @description
    #' Get specific property of the compound
    #' @param name Name of the property to retrieve.
    #' @return The corresponding property object.
    getProperty = function(name) {
      if (!name %in% names(private$.allProperties)) {
        stop("Property '", name, "' not found.")
      } else {
        return(private$.allProperties[[name]])
      }
    },

    # Setter
    #' @description
    #' Update specific property value for the compound.
    #' @param name Name of the property to modify.
    #' @param value New value for the property.
    #' @param unit New unit to use for the property, if not given the unit is assumed to be the same as previously.
    setPropertyValue = function(name, value, unit = NULL) {
      if (!name %in% names(private$.allProperties)) {
        stop("Property '", name, "' not found.")
      } else {
        prop <- private$.allProperties[[name]]

        # check validity of unit with regards to dimension
        if (!is.null(unit) && !(unit %in% ospsuite::getUnitsForDimension(prop$dimension))) {
          stop("Unit '", unit, "' not valid for dimension '", prop$dimension, "'.")
        }

        # if unit is not given assume it is unchanged
        if (is.null(unit)) {
          unit <- prop$unit
        }

        # Check validity of value
        if (!is.null(prop$check)) {
          prop$check(value, unit)
        }

        prop$unit <- unit
        prop$value <- value
      }
    },

    # Add a new property
    #' @description
    #' Add a new property for the compound.
    #' @param name Name of the property to add.
    #' @param path Corresponding path in the simulation pkml of the property to add.
    #' @param dimension Dimension of the property to add.
    #' @param value Value for the property.
    #' @param unit (Optional) Unit to use for the property. If not given, it is assumed to be the baseUnit of the dimension.
    #' @param enum (Optional) Name list mapping user friendly values to PK-Sim allowed values.
    #' @param check (Optional) Function to check the validity of the supplied value for the property.
    addProperty = function(name, path, dimension, value = 0, unit = NULL, enum = NULL, check = NULL) {
      if (name %in% names(private$.allProperties)) {
        stop("Property '", name, "' already exists.")
      }
      private$.allProperties[[name]] <- CompoundProperty$new(name, path, dimension, value, unit, enum, check)
      private$.allPropertyPaths <- c(private$.allParameterPaths, path)
    },

    # Remove a property
    #' @description
    #' Remove a property from the compound.
    #' @param name Name of the property to remove
    removeProperty = function(name) {
      private$.allProperties[[name]] <- NULL
      private$.allPropertyPaths <- sapply(private$.allProperties, \(x) x$path)
    },

    #' @description
    #' Get the paths of all parameters defined for the compound
    #' @return A character vector with the paths of all parameters
    getAllPropertyPaths = function() {
      private$.allPropertyPaths
    },

    #' @description
    #' Print the object to the console
    #' @param ... Rest arguments.
    print = function(...) {
      for (prop in private$.allProperties) {
        if (is.list(prop$enum) && !is.null(names(prop$enum))) {
          private$printLine(prop$name, names(prop$value))
        } else {
          private$printLine(prop$name, paste(prop$value, prop$unit))
        }
      }
      invisible(self)
    }
  ),
  private = list(
    .allProperties = list(),
    .allPropertyPaths = c()
  )
)
