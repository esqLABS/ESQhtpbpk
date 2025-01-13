#' @title AdministrationProtocol
#' @docType class
#' @description  Description of an administration protocol
#' @format NULL
AdministrationProtocol <- R6::R6Class(
  "AdministrationProtocol",
  cloneable = FALSE,
  inherit = ospsuite.utils::Printable,
  active = list(
    #' @field UUID Unique identifier (read-only)
    UUID = function(value) {
      if (missing(value)) {
        private$.UUID
      } else {
        error("UUID is read-only")
      }
    }
  ),
  public = list(
    # Route of administration
    Route = NULL,
    # Dose
    Dose = NULL,
    # Dose unit
    DoseUnit = NULL,
    # Total number of administrations
    NumberOfRepetitions = 1,
    # Time between administrations
    TimeBetweenRepetitions = 0,
    # Time unit. By default "hours"
    TimeUnit = ospsuite::ospUnits$Time$h,
    # Path of the application protocol
    Path = NULL,

    #' @description
    #' Initialize a new instance of the class
    #' @return A new `AdministrationProtocol` object.
    initialize = function(path, route = "IV", dose = 0, doseUnit = ospsuite::ospUnits$`Dose per body weight`$`mg/kg`, numberOfRepetitions = 1, timeBetweenRepetitions = 0, timeUnit = ospsuite::ospUnits$Time$h) {
      self$Path <- path
      self$Route <- route
      self$Dose <- dose
      self$DoseUnit <- doseUnit
      self$NumberOfRepetitions <- numberOfRepetitions
      self$TimeBetweenRepetitions <- timeBetweenRepetitions
      self$TimeUnit <- timeUnit

      private$.UUID <- uuid::UUIDgenerate()
    },
    getAllParameterPaths = function() {
      allParamPaths <- c()
      if (ospsuite::getDimensionForUnit(self$DoseUnit) == ospsuite::ospDimensions$Mass) {
        doseParamName <- "Dose"
      } else if (ospsuite::getDimensionForUnit(self$DoseUnit) == ospsuite::ospDimensions$`Dose per body weight`) {
        doseParamName <- "DosePerBodyWeight"
      } else if (ospsuite::getDimensionForUnit(self$DoseUnit) == ospsuite::ospDimensions$`Dose per body surface area`) {
        doseParamName <- "DosePerBodySurfaceArea"
      }

      for (i in 1:self$NumberOfRepetitions) {
        allParamPaths <- c(allParamPaths, paste0(self$Path, "|", "Application_", i, "|ProtocolSchemaItem|", doseParamName))
        allParamPaths <- c(allParamPaths, paste0(self$Path, "|", "Application_", i, "|ProtocolSchemaItem|Start time"))
      }

      return(allParamPaths)
    },

    #' @description
    #' Print the object to the console
    #' @param ... Rest arguments.
    print = function(...) {
      private$printClass()
      private$printLine("Route", self$Route)
      private$printLine("Dose", paste(self$Dose, self$DoseUnit, sep = " "))
      private$printLine("Number of repetitions", self$NumberOfRepetitions)
      private$printLine("Time between repetitions", paste(self$TimeBetweenRepetitions, self$TimeUnit, sep = " "))
      private$printLine("Path of the administration", self$Path)
    }
  ),
  private = list(
    # ID of the study
    .UUID = NULL
  )
)
