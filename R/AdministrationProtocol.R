#' @title AdministrationProtocol
#' @docType class
#' @description  Description of an administration protocol
#' @format NULL
#' @export
SimpleProtocol <- R6::R6Class(
  "SimpleProtocol",
  cloneable = FALSE,
  inherit = ospsuite.utils::Printable,
  active = list(
    #' @field UUID Unique identifier (read-only)
    UUID = function(value) {
      if (missing(value)) {
        private$.UUID
      } else {
        cli::cli_abort(messages$readOnly("UUID"))
      }
    },
    Route = function(value) {
      if (missing(value)) {
        private$.Route
      } else {
        if (!(value %in% names(AdminType))) {
          msg <- messages$valueEnumError("route", value, allowed = names(DoseInterval))
          cli::cli_abort("{msg}")
        } else {
          private$.Route <- value
        }
      }
    },
    # Dose Interval (Single, DI_24, DI_12_12, DI_8_8_8, DI_6_6_6_6, DI_6_6_12)
    DoseInterval = function(value) {
      if (missing(value)) {
        private$.DoseInterval
      } else {
        if (!(value %in% names(AdminInterval))) {
          msg <- messages$valueEnumError("dosing interval", value, allowed = names(DoseInterval))
          cli::cli_abort("{msg}")
        } else {
          private$.DoseInterval <- value
        }
      }
    },
    # Dose
    Dose = function(value) {
      if (missing(value)) {
        private$.Dose
      } else {
        if (!is.null(value) && !is.numeric(value)) {
          cli::cli_abort("Dose must be a numeric value.")
        } else {
          private$.Dose <- value
        }
      }
    },
    # Dose unit
    DoseUnit = function(value) {
      if (missing(value)) {
        private$.DoseUnit
      } else {
        if (!is.null(value) && !(value %in% c(ospsuite::ospUnits$`Dose per body weight`, ospsuite::ospUnits$`Dose per body surface area`, ospsuite::ospUnits$Mass))) {
          cli::cli_abort("Supplied dose unit is not valid.")
        } else {
          private$.DoseUnit <- value
        }
      }
    },
    # Starting time
    StartTime = function(value) {
      if (missing(value)) {
        private$.StartTime
      } else {
        if (!is.null(value) && !is.numeric(value)) {
          cli::cli_abort("Start time must be a numeric value.")
        } else {
          private$.StartTime <- value
        }
      }
    },
    # Time unit. By default "hours"
    StartTimeUnit = function(value) {
      if (missing(value)) {
        private$.StartTimeUnit
      } else {
        if (!is.null(value) && !(value %in% ospsuite::ospUnits$`Time`)) {
          cli::cli_abort("Supplied start time unit is not valid.")
        } else {
          private$.StartTimeUnit <- value
        }
      }
    },
    EndTime = function(value) {
      if (missing(value)) {
        private$.EndTime
      } else {
        if (!is.null(value) && !is.numeric(value)) {
          cli::cli_abort("End time must be a numeric value.")
        } else {
          private$.EndTime <- value
        }
      }
    },
    # Time unit.
    EndTimeUnit = function(value) {
      if (missing(value)) {
        private$.EndTimeUnit
      } else {
        if (!is.null(value) && !(value %in% ospsuite::ospUnits$`Time`)) {
          cli::cli_abort("Supplied end time unit is not valid.")
        } else {
          private$.EndTimeUnit <- value
        }
      }
    },
    InfusionTime = function(value) {
      if (missing(value)) {
        private$.InfusionTime
      } else {
        if (!is.null(value) && !is.numeric(value)) {
          cli::cli_abort("Infusion time must be a numeric value.")
        } else {
          private$.InfusionTime <- value
        }
      }
    },
    # Time unit.
    InfusionTimeUnit = function(value) {
      if (missing(value)) {
        private$.InfusionTimeUnit
      } else {
        if (!is.null(value) && !(value %in% ospsuite::ospUnits$`Time`)) {
          cli::cli_abort("Supplied infusion time unit is not valid.")
        } else {
          private$.InfusionTimeUnit <- value
        }
      }
    },
    WaterVolPerBW = function(value) {
      if (missing(value)) {
        private$.WaterVolumePerBW
      } else {
        if (!is.null(value) && !is.numeric(value)) {
          cli::cli_abort("Water volume per body weight must be a numeric value.")
        } else {
          private$.WaterVolumePerBW <- value
        }
      }
    },
    # unit.
    WaterVolPerBWUnit = function(value) {
      if (missing(value)) {
        private$.WaterVolumePerBWUnit
      } else {
        if (!is.null(value) && !(value %in% ospsuite::ospUnits$`Volume per body weight`)) {
          cli::cli_abort("Supplied Water volume per body weight time unit is not valid.")
        } else {
          private$.WaterVolumePerBWUnit <- value
        }
      }
    },
    FormulationKey = function(value) {
      if (missing(value)) {
        private$.FormulationKey
      } else {
        error("FormulationKey is read-only for simple protocol")
      }
    },
    TargetOrgan = function(value) {
      if (missing(value)) {
        private$.TargetOrgan
      } else {
        if (!is.null(value) && !is.character(value)) {
          cli::cli_abort("Supplied TargetOrgan is not valid.")
        } else {
          private$.TargetOrgan <- value
        }
      }
    },
    TargetCompartment = function(value) {
      if (missing(value)) {
        private$.TargetCompartment
      } else {
        if (!is.null(value) && !is.character(value)) {
          cli::cli_abort("Supplied TargetCompartment is not valid.")
        } else {
          private$.TargetCompartment <- value
        }
      }
    },
    # Path of the application protocol
    Path = function(value) {
      if (missing(value)) {
        private$.Path
      } else {
        if (!is.null(value) && !is.character(value)) {
          cli::cli_abort("Supplied Path is not valid.")
        } else {
          private$.Path <- value
        }
      }
    }
  ),
  public = list(
    #' @description
    #' Initialize a new instance of the class
    #' @return A new `SimpleProtocol` object.
    initialize = function(
        path = "Events|AdvancedProtocol",
        route = "IV Bolus",
        dosingInterval = "Single",
        dose = 0,
        doseUnit = "mg/kg",
        startTime = 0,
        startTimeUnit = "h",
        endTime = NULL,
        endTimeUnit = NULL,
        infusionTime = NULL,
        infusionTimeUnit = NULL,
        waterVolPerBW = NULL,
        waterVolPerBWUnit = NULL,
        targetOrgan = NULL,
        targetCompartment = NULL) {

      private$.UUID <- uuid::UUIDgenerate()

      self$Route <- route
      self$DoseInterval <- dosingInterval
      self$Dose <- dose
      self$DoseUnit <- doseUnit
      self$StartTime <- startTime
      self$StartTimeUnit <- startTimeUnit
      self$TargetOrgan <- targetOrgan
      self$TargetCompartment <- targetCompartment

      # Setting default End time for dosing interval other than single
      self$EndTime <- endTime
      self$EndTimeUnit <- endTimeUnit
      if (self$DoseInterval != "Single") {
        if (is.null(self$EndTime)) {
          cli::cli_warn("No {.code endTime} provided, using default value of 24 hours.")
          self$EndTime <- 24
          self$EndTimeUnit <- "h"
        }

        if (!is.null(self$EndTime) & is.null(self$EndTimeUnit)) {
          cli::cli_warn("No {.code endTimeUnit} provided, using default unit of `h`.")
          self$EndTimeUnit <- "h"
        }
      } else {
        if (!is.null(self$EndTime) || !is.null(self$EndTimeUnit)) {
          cli::cli_warn("Removing `EndTime` or `EndTimeUnit` from protocol as they are not used for `Single` administrations.")
          self$EndTime <- NULL
          self$EndTimeUnit <- NULL
        }
      }

      # For IV infusion set default infusion time to 60 min if not given
      self$InfusionTime <- infusionTime
      self$InfusionTimeUnit <- infusionTimeUnit

      if (self$Route == "IV Infusion") {
        if (is.null(self$InfusionTime)) {
          cli::cli_warn("No {.code infusionTime} provided, using default value of 60 minutes.")
          self$InfusionTime <- 60
          self$InfusionTimeUnit <- "min"
        }

        if (!is.null(self$InfusionTime) & is.null(self$InfusionTimeUnit)) {
          cli::cli_warn("No {.code infusionTimeUnit} provided, using default unit of `minutes`.")
          self$InfusionTimeUnit <- "min"
        }
      } else if (!is.null(self$InfusionTime) || !is.null(self$InfusionTimeUnit)) {
        cli::cli_warn("Removing `InfusionTime` or `InfusionTimeUnit` from protocol as they are only used for `IV Infusion` route.")
        self$InfusionTime <- NULL
        self$InfusionTimeUnit <- NULL
      }

      # For oral administration set default water volume per body weight to 3.5 ml/kg if not given
      self$WaterVolPerBW <- waterVolPerBW
      self$WaterVolPerBWUnit <- waterVolPerBWUnit

      if (self$Route == "Oral") {
        if (is.null(self$WaterVolPerBW)) {
          cli::cli_warn("No {.code WaterVolPerBW} provided, using default value of 3.5 ml/kg.")
          self$WaterVolPerBW <- 3.5
          self$WaterVolPerBWUnit <- "ml/kg"
        }

        if (!is.null(self$WaterVolPerBW) & is.null(self$WaterVolPerBWUnit)) {
          cli::cli_warn("No {.code WaterVolPerBWUnit} provided, using default unit of `ml/kg`.")
          self$WaterVolPerBW <- "ml/kg"
        }
      } else if (!is.null(self$WaterVolPerBW) || !is.null(self$waterVolPerBWUnit)) {
        cli::cli_warn("Removing `WaterVolPerBW` or `WaterVolPerBWUnit` from protocol as they are only used for `Oral` route.")
        self$WaterVolPerBW <- NULL
        self$waterVolPerBWUnit <- NULL
      }

      # FormulationKey are only needed for Oral and User defined routes, and set to `Formulation` by default
      if (self$Route %in% c("Oral",  "Custom")) {
        private$.FormulationKey <- "Formulation"
      }

      # For custom route set default target is not given
      if (self$Route == "Custom") {
        if (is.null(self$TargetOrgan)) {
          cli::cli_warn("No {.code targetOrgan} provided, using default value of `ArterialBlood`.")
          self$TargetOrgan <- "ArterialBlood"
        }
        if (is.null(self$TargetCompartment)) {
          cli::cli_warn("No {.code targetCompartment} provided, using default value of `Plasma`.")
          self$TargetCompartment <- "Plasma"
        }
      }

      private$.UUID <- uuid::UUIDgenerate()
    },
    getAllParameterPaths = function() {
      mainPath <- paste(self$Path, paste0(self$Route, self$FormulationKey), sep = "|")

      wantedAdmin <- private$.extractProtocol()

      if (ospsuite::getDimensionForUnit(self$DoseUnit) == ospsuite::ospDimensions$Mass) {
        doseParamName <- "Dose"
      } else if (ospsuite::getDimensionForUnit(self$DoseUnit) == ospsuite::ospDimensions$`Dose per body weight`) {
        doseParamName <- "DosePerBodyWeight"
      } else if (ospsuite::getDimensionForUnit(self$DoseUnit) == ospsuite::ospDimensions$`Dose per body surface area`) {
        doseParamName <- "DosePerBodySurfaceArea"
      }

      for (i in 1:nrow(wantedAdmin)) {
        allParamPaths <- c(allParamPaths, paste(mainPath, paste0("Application_", i), "ProtocolSchemaItem", doseParamName, sep = "|"))
        allParamPaths <- c(allParamPaths, paste(mainPath, paste0("Application_", i), "ProtocolSchemaItem", "Start time", sep = "|"))
        if (!is.null(self$InfusionTime)) {
          allParamPaths <- c(allParamPaths, paste(mainPath, paste0("Application_", i), "ProtocolSchemaItem", "Infusion time", sep = "|"))
        }
        if (!is.null(self$WaterVolPerBW)) {
          allParamPaths <- c(allParamPaths, paste(mainPath, paste0("Application_", i), "ProtocolSchemaItem", "Volume of water/body weight", sep = "|"))
        }

        # return(allParamPaths)
        allParamPaths <- c(allParamPaths, wantedAdmin$time[i])
      }
      return(allParamPaths)
    },


    #' @description
    #' Print the object to the console
    #' @param ... Rest arguments.
    print = function(...) {
      private$printClass()
      private$printLine("Route", AdminType[[self$Route]]$human)
      private$printLine("Dose", paste(self$Dose, self$DoseUnit, sep = " "))
      private$printLine("Dose Interval", AdminInterval[[self$DoseInterval]]$human)
      private$printLine("Start Time", paste(self$StartTime, self$StartTimeUnit, sep = " "))
      if (!is.null(self$EndTime)) {
        private$printLine("End Time", paste(self$EndTime, self$EndTimeUnit, sep = " "))
      }
      if (self$Route == "IV Infusion") {
        private$printLine("Infusion Time", paste(self$InfusionTime, self$InfusionTimeUnit, sep = " "))
      }
      if (self$Route == "Oral") {
        private$printLine("Volume of water per body weight", paste(self$WaterVolPerBW, self$WaterVolPerBWUnit, sep = " "))
      }
      if (self$Route == "Custom") {
        private$printLine("Target", paste(self$TagetOrgan, self$TargetCompartment, sep = "|"))
      }
      private$printLine("Path of the administration", self$Path)
    }
  ),
  private = list(
    # ID of the protocol
    .UUID = NULL,
    # Route of administration (IntravenousBolus, Intravenous, Oral, UserDefined)
    .Route = NULL,
    # Dose Interval (Single, DI_24, DI_12_12, DI_8_8_8, DI_6_6_6_6, DI_6_6_12)
    .DoseInterval = NULL,
    # Dose
    .Dose = NULL,
    # Dose unit
    .DoseUnit = NULL,
    # Starting time
    .StartTime = 0,
    # Time unit. By default "hours"
    .StartTimeUnit = "h",
    # EndTime (default = 24h)
    .EndTime = NULL,
    .EndTimeUnit = NULL,
    # Infusion time
    .InfusionTime = NULL,
    # Infusion time unit
    .InfusionTimeUnit = NULL,
    .WaterVolumePerBW = NULL,
    .WaterVolumePerBWUnit = NULL,
    .FormulationKey = NULL,
    # Path of the application protocol
    .Path = NULL,
    .TargetOrgan = NULL,
    .TargetCompartment = NULL,
    .extractProtocol = function() {
      browser()
      startTime <- ospsuite::toBaseUnit(
        quantityOrDimension = "Time",
        values = self$StartTime,
        unit = self$StartTimeUnit
      )

      endTime <- ospsuite::toBaseUnit(
        quantityOrDimension = "Time",
        values = ifelse(is.null(self$EndTime), Inf, self$EndTime),
        unit = self$EndTimeUnit
      )

      # calculate dosing times based on Dosing interval chosen
      adminTimes <- switch(
        self$DoseInterval,
        "Single" = startTime,
        "12-12" = seq(startTime, endTime, by = ospsuite::toBaseUnit("Time", 12, "h")),
        "8-8-8" = seq(startTime, endTime, by = ospsuite::toBaseUnit("Time", 8, "h")),
        "6-6-12" = sort(c(seq(startTime, endTime, by = ospsuite::toBaseUnit("Time", 24, "h")),
                          seq(startTime + ospsuite::toBaseUnit("Time", 6, "h"), endTime, by = ospsuite::toBaseUnit("Time", 24, "h")),
                          seq(startTime + ospsuite::toBaseUnit("Time", 12, "h"), endTime, by = ospsuite::toBaseUnit("Time", 24, "h")))),
        "6_6_6_6" = seq(startTime, endTime, by = ospsuite::toBaseUnit("Time", 6, "h")),
        "24" = seq(startTime, endTime, by = ospsuite::toBaseUnit("Time", 24, "h"))
      )

      wantedAdmin <- dplyr::tibble(
        type = self$Route,
        time = adminTimes[adminTimes < endTime],
        parameters = list(self),
        formulationName = ifelse(is.null(self$FormulationKey), NA, self$FormulationKey)
      )

      return(wantedAdmin)
    }
  )
)


#' AdvancedProtocol <- R6::R6Class(
#'   "AdvancedProtocol",
#'   cloneable = FALSE,
#'   inherit = ospsuite.utils::Printable,
#'   active = list(
#'     #' @field UUID Unique identifier (read-only)
#'     UUID = function(value) {
#'       if (missing(value)) {
#'         private$.UUID
#'       } else {
#'         error("UUID is read-only")
#'       }
#'     }
#'   ),
#'   Name = NULL,
#'   DoseInterval = "Single",
#'   # Schema
#'   Schema = NULL,
#'   Dose = NULL,
#'   # Dose unit
#'   DoseUnit = NULL,
#'   # Starting time
#'   StartTime = NULL,
#'   # Total number of administrations
#'   NumberOfRepetitions = 1,
#'   # Time between administrations
#'   TimeBetweenRepetitions = 0,
#'   # Time unit. By default "hours"
#'   TimeUnit = ospsuite::ospUnits$Time$h,
#'   Path = NULL,
#'
#'   #' @description
#'   #' Initialize a new instance of the class
#'   #' @return A new `AdministrationProtocol` object.
#'   initialize = function(
#'     dosingInterval = "Single",
#'     startTime = 0, timeUnit = ospsuite::ospUnits$Time$h, numberOfRepetitions = 1, timeBetweenRepetitions = 0, timeBetweenRepetitionsUnit = "h", endTime = NULL) {
#'     private$.UUID <- uuid::UUIDgenerate()
#'   },
#'   addSchema = function(schema) {
#'     self$Schema <- schema
#'   },
#'   addProtocolToSchema = function(protocol) {
#'     self$Schema$addProtocol(protocol)
#'   },
