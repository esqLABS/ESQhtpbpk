#' @title Compound
#' @docType class
#' @description  Description of a compound
#' @format NULL
Compound <- R6::R6Class(
  "Compound",
  cloneable = FALSE,
  inherit = ospsuite.utils::Printable,
  active = list(),
  public = list(
    # ID of the compound
    ID = NULL,
    # Name of the compound as used in the simulation
    name = NULL,

    #' @description
    #' Initialize a new instance of the class
    #' @param netObject Reference to `NetObject` .NET simulation object
    #' @param sourceFile (Optional) File used to load the simulation
    #' @return A new `Simulation` object.
    initialize = function(ID, name = "Compound") {
      self$ID <- ID
      self$name <- name

      property <- CompoundProperty$new("Lipophilicity", paste(name, "Lipophilicity", sep = "|"), ospsuite::ospDimensions$`Log Units`)
      private$.lipophilicity <- property
      private$.allParameterPaths <- c(private$.allParameterPaths, property$path)

      property <- CompoundProperty$new("Fraction unbound", paste(name, "Fraction unbound (plasma, reference value)", sep = "|"), ospsuite::ospDimensions$`Fraction`, value = 1)
      private$.fractionUnbound <- property
      private$.allParameterPaths <- c(private$.allParameterPaths, property$path)

      property <- CompoundProperty$new("Fraction unbound", paste(name, "Plasma protein binding partner", sep = "|"), ospsuite::ospDimensions$Dimensionless, value = 1)
      private$.ppbPartner <- property
      private$.allParameterPaths <- c(private$.allParameterPaths, property$path)

      # 2DO isSmallMolecule should also be a CompoundProperty
      # 2DO get rid of all "get/set" and implement everything as CompoundProperty
      private$.isSmallMolecule <- TRUE
      private$.allParameterPaths <- c(private$.allParameterPaths, paste(name, "Is small molecule", sep = "|"))

      property <- CompoundProperty$new("Molecular weight", paste(name, "Molecular weight", sep = "|"), ospsuite::ospDimensions$`Molecular weight`, value = 100, unit = ospsuite::ospUnits$`Molecular weight`$`g/mol`)
      private$.MW <- property
      private$.allParameterPaths <- c(private$.allParameterPaths, property$path)

      property <- CompoundProperty$new("Bromine count", paste(name, "Br", sep = "|"), ospsuite::ospDimensions$Dimensionless, value = 0)
      private$.Br <- property
      private$.allParameterPaths <- c(private$.allParameterPaths, property$path)

      property <- CompoundProperty$new("Chlorine count", paste(name, "Cl", sep = "|"), ospsuite::ospDimensions$Dimensionless, value = 0)
      private$.Cl <- property
      private$.allParameterPaths <- c(private$.allParameterPaths, property$path)

      property <- CompoundProperty$new("Fluorine count", paste(name, "F", sep = "|"), ospsuite::ospDimensions$Dimensionless, value = 0)
      private$.F <- property
      private$.allParameterPaths <- c(private$.allParameterPaths, property$path)

      property <- CompoundProperty$new("Iodine count", paste(name, "I", sep = "|"), ospsuite::ospDimensions$Dimensionless, value = 0)
      private$.I <- property
      private$.allParameterPaths <- c(private$.allParameterPaths, property$path)

      property <- CompoundProperty$new("Compound type 0", paste(name, "Compound type 0", sep = "|"), ospsuite::ospDimensions$Dimensionless, value = 0)
      private$.compoundType0 <- property
      private$.allParameterPaths <- c(private$.allParameterPaths, property$path)

      property <- CompoundProperty$new("Compound type 1", paste(name, "Compound type 1", sep = "|"), ospsuite::ospDimensions$Dimensionless, value = 0)
      private$.compoundType1 <- property
      private$.allParameterPaths <- c(private$.allParameterPaths, property$path)

      property <- CompoundProperty$new("Compound type 2", paste(name, "Compound type 2", sep = "|"), ospsuite::ospDimensions$Dimensionless, value = 0)
      private$.compoundType2 <- property
      private$.allParameterPaths <- c(private$.allParameterPaths, property$path)

      property <- CompoundProperty$new("pKa value 0", paste(name, "pKa value 0", sep = "|"), ospsuite::ospDimensions$Dimensionless, value = 0)
      private$.pKa0 <- property
      private$.allParameterPaths <- c(private$.allParameterPaths, property$path)

      property <- CompoundProperty$new("pKa value 1", paste(name, "pKa value 1", sep = "|"), ospsuite::ospDimensions$Dimensionless, value = 0)
      private$.pKa1 <- property
      private$.allParameterPaths <- c(private$.allParameterPaths, property$path)

      property <- CompoundProperty$new("pKa value 2", paste(name, "pKa value 2", sep = "|"), ospsuite::ospDimensions$Dimensionless, value = 0)
      private$.pKa2 <- property
      private$.allParameterPaths <- c(private$.allParameterPaths, property$path)

      property <- CompoundProperty$new("Reference pH", paste(name, "Reference pH", sep = "|"), ospsuite::ospDimensions$Dimensionless, value = 7)
      private$.refPh <- property
      private$.allParameterPaths <- c(private$.allParameterPaths, property$path)

      property <- CompoundProperty$new("Solubility", paste(name, "Solubility at reference pH", sep = "|"), ospsuite::ospDimensions$`Concentration (mass)`, value = 1, unit = ospsuite::ospUnits$`Concentration [mass]`$`mg/l`)
      private$.solubility <- property
      private$.allParameterPaths <- c(private$.allParameterPaths, property$path)
    },

    # Getter
    get_lipophilicity = function() {
      private$.lipophilicity
    },
    get_fractionUnbound = function() {
      private$.fractionUnbound
    },
    get_ppbPartner = function() {
      private$.ppbPartner
    },
    get_MW = function() {
      private$.MW
    },
    get_isSmallMolecule = function() {
      private$.isSmallMolecule
    },
    get_Br = function() {
      private$.Br
    },
    get_Cl = function() {
      private$.Cl
    },
    get_F = function() {
      private$.F
    },
    get_I = function() {
      private$.I
    },
    get_compoundType0 = function() {
      private$.compoundType0
    },
    get_compoundType1 = function() {
      private$.compoundType1
    },
    get_compoundType2 = function() {
      private$.compoundType2
    },
    get_pKa0 = function() {
      private$.pKa0
    },
    get_pKa1 = function() {
      private$.pKa1
    },
    get_pKa2 = function() {
      private$.pKa2
    },
    get_refPh = function() {
      private$.refPh
    },
    get_solubility = function() {
      private$.solubility
    },
    get_pInt = function() {
      private$.pInt
    },

    # Setter
    set_lipophilicity = function(value) {
      if (value > 10 || value < -10) {
        stop("Lipophilicity value must be between -10 and 10")
      }
      private$.lipophilicity$value <- value
    },
    set_fractionUnbound = function(value, unit = NULL) {
      private$.fractionUnbound$value <- value
      private$.fractionUnbound$unit <- unit
    },
    set_ppbPartner = function(value) {
      private$.ppbPartner$value <- value
    },
    set_MW = function(value, unit = NULL) {
      private$.MW$value <- value
      private$.MW$unit <- unit
    },
    set_isSmallMolecule = function(value) {
      ospsuite.utils::validateIsLogical(value)
      private$.isSmallMolecule <- value
    },
    set_Br = function(value) {
      private$.Br$value <- value
    },
    set_Cl = function(value) {
      private$.Cl$value <- value
    },
    set_F = function(value) {
      private$.F$value <- value
    },
    set_I = function(value) {
      private$.I$value <- value
    },
    set_compoundType0 = function(value) {
      private$.compoundType0$value <- value
    },
    set_compoundType1 = function(value) {
      private$.compoundType1$value <- value
    },
    set_compoundType2 = function(value) {
      private$.compoundType2$value <- value
    },
    set_pKa0 = function(value) {
      private$.pKa0$value <- value
    },
    set_pKa1 = function(value) {
      private$.pKa1$value <- value
    },
    set_pKa2 = function(value) {
      private$.pKa2$value <- value
    },
    set_refPh = function(value) {
      private$.refPh$value <- value
    },
    set_solubility = function(value, unit = NULL) {
      private$.solubility$value <- value
      private$.solubility$unit <- unit
    },
    set_pInt = function(value, unit = NULL) {
      property <- CompoundProperty$new("Intestinal permeability", paste(self$name, "Specific intestinal permeability (transcellular)", sep = "|"), ospsuite::ospDimensions$Velocity, value = value, unit = unit)
      private$.pInt <- property
      private$.allParameterPaths <- c(private$.allParameterPaths, property$path)
    },
    addProperty = function(name, path, dimension, value, unit = NULL) {
      property <- CompoundProperty$new(name, path, dimension, value, unit)
      private$.additionalProperties <- c(private$.additionalProperties, property)
      private$.allParameterPaths <- c(private$.allParameterPaths, property$path)
    },
    additionalProperties = function() {
      private$.additionalProperties
    },

    #' @description
    #' Get the paths of all parameters defined for the compound
    #' @return A character vector with the paths of all parameters
    getAllParameterPaths = function() {
      private$.allParameterPaths
    },

    #' @description
    #' Print the object to the console
    #' @param ... Rest arguments.
    print = function(...) {
      private$printClass()
      private$printLine("ID", self$ID)
      private$printLine("Name of the molecule in simulation", self$name)
      private$printLine("Is small molecule", private$.isSmallMolecule)
      private$printLine("Lipophilicity", paste(private$.lipophilicity$value, private$.lipophilicity$unit))
      private$printLine("Fraction unbound", paste(private$.fractionUnbound$value, private$.fractionUnbound$unit))
      private$printLine("Plasma protein binding partner", ospsuite.utils::enumGetKey(PPBPartner, private$.ppbPartner$value))
      private$printLine("Molecular weight", paste(private$.MW$value, private$.MW$unit))
      private$printLine("Bromine count", private$.Br$value)
      private$printLine("Chlorine count", private$.Cl$value)
      private$printLine("Fluorine count", private$.F$value)
      private$printLine("Iodine count", private$.I$value)
      private$printLine("Compound type 0", ospsuite.utils::enumGetKey(CompoundType, private$.compoundType0$value))
      private$printLine("pKa value 0", private$.pKa0$value)
      private$printLine("Compound type 1", ospsuite.utils::enumGetKey(CompoundType, private$.compoundType1$value))
      private$printLine("pKa value 1", private$.pKa1$value)
      private$printLine("Compound type 2", ospsuite.utils::enumGetKey(CompoundType, private$.compoundType2$value))
      private$printLine("pKa value 2", private$.pKa2$value)
      private$printLine("Solubility", paste(private$.solubility$value, private$.solubility$unit, "at pH", private$.refPh$value))
      private$printLine("Intestinal permeability", paste(private$.pInt$value, private$.pInt$unit))

      # Print additional properties
      print("Additional properties:")
      for (prop in private$.additionalProperties) {
        private$printLine(prop$name, paste(prop$value, prop$unit))
      }
      invisible(self)
    }
  ),
  private = list(
    .lipophilicity = NULL,
    .fractionUnbound = NULL,
    .ppbPartner = NULL,
    .MW = NULL,
    .isSmallMolecule = NULL,
    .Br = NULL,
    .Cl = NULL,
    .F = NULL,
    .I = NULL,
    .compoundType0 = NULL,
    .compoundType1 = NULL,
    .compoundType2 = NULL,
    .pKa0 = NULL,
    .pKa1 = NULL,
    .pKa2 = NULL,
    .refPh = NULL,
    .solubility = NULL,
    .pInt = NULL,
    .additionalProperties = list(),
    .allParameterPaths = c()
  )
)
