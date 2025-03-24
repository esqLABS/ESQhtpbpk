#' @title AdministrationProtocol
#' @docType class
#' @description  Description of an administration protocol
#' @format NULL
#' @export
SimpleProtocol <- R6::R6Class(
  "SimpleProtocol",
  active = list(
    #' @field UUID Unique identifier (read-only)
    UUID = function(value) {
      if (missing(value)) {
        private$.UUID
      } else {
        cli::cli_abort(messages$readOnly("UUID"))
      }
    },
    #' @field Route Route of administration
    Route = function(value) {
      if (missing(value)) {
        private$.Route
      } else {
        if (!(value %in% names(AdminType))) {
          msg <- messages$valueEnumError(
            name = "route",
            value = value,
            allowed = names(AdminType)
          )
          cli::cli_abort("{msg}")
        } else {
          if (value == "Custom") {
            cli::cli_abort("`Custom` route is not yet supported.")
          }
          private$.Route <- value
        }
      }
    },
    #' @field DoseInterval Dosing interval
    DoseInterval = function(value) {
      if (missing(value)) {
        private$.DoseInterval
      } else {
        if (!(value %in% names(AdminInterval))) {
          msg <- messages$valueEnumError(
            name = "dosing interval",
            value = value,
            allowed = names(AdminInterval)
          )
          cli::cli_abort("{msg}")
        } else {
          private$.DoseInterval <- value
        }
      }
    },
    #' @field Dose Dose
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
    #' @field DoseUnit Dose unit
    DoseUnit = function(value) {
      if (missing(value)) {
        private$.DoseUnit
      } else {
        allowedUnits <- c(
          ospsuite::ospUnits$`Dose per body weight`,
          ospsuite::ospUnits$`Dose per body surface area`,
          ospsuite::ospUnits$Mass
        )

        if (!is.null(value) && !(value %in% allowedUnits)) {
          cli::cli_abort("Supplied dose unit is not valid.")
        } else {
          private$.DoseUnit <- value
        }
      }
    },
    #' @field StartTime Starting time of administration
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
    #' @field StartTimeUnit Time unit of administration starting time
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
    #' @field EndTime End time of administration
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
    #' @field EndTimeUnit Time unit of administration end time
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
    #' @field InfusionTime Duration of infusion
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
    #' @field InfusionTimeUnit Time unit of infusion duration
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
    #' @field WaterVolPerBW Water volume per body weight
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
    #' @field WaterVolPerBWUnit Unit or water volume per body weight
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
    # #' @field TargetOrgan Target organ for user defined administration
    # TargetOrgan = function(value) {
    #   if (missing(value)) {
    #     private$.TargetOrgan
    #   } else {
    #     if (!is.null(value) && !is.character(value)) {
    #       cli::cli_abort("Supplied TargetOrgan is not valid.")
    #     } else {
    #       private$.TargetOrgan <- value
    #     }
    #   }
    # },
    # #' @field TargetCompartment Target compartment for user defined administration
    # TargetCompartment = function(value) {
    #   if (missing(value)) {
    #     private$.TargetCompartment
    #   } else {
    #     if (!is.null(value) && !is.character(value)) {
    #       cli::cli_abort("Supplied TargetCompartment is not valid.")
    #     } else {
    #       private$.TargetCompartment <- value
    #     }
    #   }
    # },
    #' @field Path Prefix path for the administration
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
    },
    #' @field Name Protocol name for the administration
    Name = function(value) {
      if (missing(value)) {
        private$.Name
      } else {
        if (!is.null(value) && !is.character(value)) {
          cli::cli_abort("Supplied Name is not valid.")
        } else {
          private$.Name <- value
        }
      }
    },
    #' @field Formulation Formulation to use with protocol
    Formulation = function(value) {
      if (missing(value)) {
        private$.Formulation
      } else {
        ospsuite.utils::validateIsOfType(value, "Formulation", nullAllowed = TRUE)
        private$.Formulation <- value
      }
    },
    #' @field FormulationKey FormulationKey mapping of the protocol
    FormulationKey = function(value) {
      if (missing(value)) {
        private$.FormulationKey
      } else {
        private$.FormulationKey <- value
      }
    }
  ),
  public = list(
    #' @description
    #' Initialize a new instance of the class
    #' @param name Protocol name for the path of administration in the simulations
    #' @param path Prefix for the path of administration in the simulations. (Defaults to Events|{protocolName})
    #' @param route Route of administration
    #' @param dosingInterval Dosing interval
    #' @param dose Dose
    #' @param doseUnit Unit of dose
    #' @param startTime Starting time of administration
    #' @param startTimeUnit Time unit of administration starting time
    #' @param endTime End time of administration
    #' @param endTimeUnit Time unit of administration end time
    #' @param infusionTime Infusion duration (for IV infusion)
    #' @param infusionTimeUnit Time unit of infusion duration (for IV infusion )
    #' @param waterVolPerBW Water volume per body weight (for oral administration)
    #' @param waterVolPerBWUnit Unit of water volume per body weight (for oral administration)
    # #' @param targetOrgan Target organ (for user defined administration)
    # #' @param targetCompartment Target compartment (for user defined administration)
    #' @return A new `SimpleProtocol` object.
    initialize = function(name = "Protocol",
                          path = NULL,
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
                          waterVolPerBWUnit = NULL) {
      private$.UUID <- uuid::UUIDgenerate()
      self$Name <- name
      self$Path <- "Events|{protocolName}"
      self$Route <- route
      self$DoseInterval <- dosingInterval
      self$Dose <- dose
      self$DoseUnit <- doseUnit
      self$StartTime <- startTime
      self$StartTimeUnit <- startTimeUnit
      # self$TargetOrgan <- targetOrgan
      # self$TargetCompartment <- targetCompartment

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
          msg <- paste(
            "Removing `EndTime` and `EndTimeUnit` from protocol as they are not used for",
            "`Single` administrations."
          )
          cli::cli_warn("{msg}")
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
        cli::cli_warn(
          paste(
            "Removing `InfusionTime` and `InfusionTimeUnit` from protocol",
            "as they are only used for `IV Infusion` route."
          )
        )
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
          self$WaterVolPerBWUnit <- "ml/kg"
        }
      } else if (!is.null(self$WaterVolPerBW) || !is.null(self$waterVolPerBWUnit)) {
        cli::cli_warn(
          paste(
            "Removing `WaterVolPerBW` and `WaterVolPerBWUnit` from protocol as ",
            "they are only used for `Oral` route."
          )
        )
        self$WaterVolPerBW <- NULL
        self$WaterVolPerBWUnit <- NULL
      }

      # Formulation are only needed for Oral and User defined routes, and set to `Dissolved` by default
      if (self$Route %in% c("Oral", "Custom")) {
        private$.Formulation <- createDissolvedFormulation(name = "Dissolved")
        private$.FormulationKey <- "Formulation"
      }

      # # For custom route set default target is not given
      # if (self$Route == "Custom") {
      #   if (is.null(self$TargetOrgan)) {
      #     cli::cli_warn("No {.code targetOrgan} provided, using default value of `ArterialBlood`.")
      #     self$TargetOrgan <- "ArterialBlood"
      #   }
      #   if (is.null(self$TargetCompartment)) {
      #     cli::cli_warn("No {.code targetCompartment} provided, using default value of `Plasma`.")
      #     self$TargetCompartment <- "Plasma"
      #   }
      # }

      private$.UUID <- uuid::UUIDgenerate()
    },
    #' @description
    #' Add a formulation to oral or user defined protocol
    #' @param formulation Formulation to add to the protocol
    #' @return The updated `SimpleProtocol` object.
    setFormulation = function(formulation) {
      if (self$Route %in% c("Oral", "Custom")) {
        self$Formulation <- formulation
      } else {
        cli::cli_abort("Formulation can only be set for `Oral` and `Custom` routes.")
      }
    },
    #' @description
    #' Extract all single administration to be applied by a protocol. For easier mapping to path in the simulation pkml.
    #' @return A tibble with the type of administration, time of administration, parameters of the administration
    #' and the formulation name.
    extractProtocol = function() {
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
        "6-6-12" = sort(
          c(
            seq(
              startTime,
              endTime,
              by = ospsuite::toBaseUnit("Time", 24, "h")
            ),
            seq(
              startTime + ospsuite::toBaseUnit("Time", 6, "h"),
              endTime,
              by = ospsuite::toBaseUnit("Time", 24, "h")
            ),
            seq(
              startTime + ospsuite::toBaseUnit("Time", 12, "h"),
              endTime,
              by = ospsuite::toBaseUnit("Time", 24, "h")
            )
          )
        ),
        "6_6_6_6" = seq(startTime, endTime, by = ospsuite::toBaseUnit("Time", 6, "h")),
        "24" = seq(startTime, endTime, by = ospsuite::toBaseUnit("Time", 24, "h"))
      )

      wantedAdmin <- dplyr::tibble(
        type = self$Route,
        time = adminTimes[adminTimes < endTime],
        parameters = list(self),
        formulationType = ifelse(is.null(self$Formulation), NA, self$Formulation$Type),
        formulationName = ifelse(is.null(self$Formulation), NA, self$Formulation$Name),
        formulation = ifelse(is.null(self$Formulation), NA, list(self$Formulation)),
        formulationKey = ifelse(is.null(self$Formulation), NA, list(self$FormulationKey))
      )

      return(wantedAdmin)
    },
    #' @description
    #' Extract all parameter paths needed to be changed in the simulation
    #' @param path Prefix path for the administration
    #' @return A character vector with all parameter paths.
    getAllParameterPaths = function(path = self$Path) {
      allParamPaths <- c()

      protocolName <- self$Name
      path <- glue::glue(path)
      if (is.null(self$Formulation$Name)) {
        mainPath <- path
      } else {
        mainPath <- paste(path, self$Formulation$Name, sep = "|")
      }

      wantedAdmin <- self$extractProtocol()

      if (ospsuite::getDimensionForUnit(self$DoseUnit) == ospsuite::ospDimensions$Mass) {
        doseParamName <- "Dose"
      } else if (ospsuite::getDimensionForUnit(self$DoseUnit) == ospsuite::ospDimensions$`Dose per body weight`) {
        doseParamName <- "DosePerBodyWeight"
      } else if (ospsuite::getDimensionForUnit(self$DoseUnit) == ospsuite::ospDimensions$`Dose per body surface area`) {
        doseParamName <- "DosePerBodySurfaceArea"
      }

      for (i in seq_len(nrow(wantedAdmin))) {
        appPath <- paste(mainPath, paste0("Application_", i), "ProtocolSchemaItem", sep = "|")
        allParamPaths <- c(allParamPaths, paste(appPath, doseParamName, sep = "|"))
        allParamPaths <- c(allParamPaths, paste(appPath, "Start time", sep = "|"))
        if (!is.null(self$InfusionTime)) {
          allParamPaths <- c(allParamPaths, paste(appPath, "Infusion time", sep = "|"))
        }
        if (!is.null(self$WaterVolPerBW)) {
          allParamPaths <- c(allParamPaths, paste(appPath, "Volume of water/body weight", sep = "|"))
        }
      }

      if (!is.null(self$Formulation)) {
        allParamPaths <- c(allParamPaths, self$Formulation$getAllPropertyPaths(protocolName = self$Name))
      }
      return(unique(unname(allParamPaths)))
    },
    #' @description
    #' Convert to snapshot
    toSnapshot = function() {
      data <- list(
        Name = self$Name,
        ApplicationType = AdminType[[self$Route]]$pksim,
        DosingInterval = AdminInterval[[self$DoseInterval]]$pksim,
        Parameters = list(
          list(
            Name = "Start time",
            Value = self$StartTime,
            Unit = self$StartTimeUnit
          ),
          list(
            Name = "InputDose",
            Value = self$Dose,
            Unit = self$DoseUnit
          )
        )
      )
      # add formulationKey if not null
      if (!is.null(self$FormulationKey)) {
        data$FormulationKey <- self$FormulationKey
      }

      # add all existing parameters
      if (!is.null(self$EndTime)) {
        data$Parameters <- c(
          data$Parameters,
          list(
            list(
              Name = "End time",
              Value = self$EndTime,
              Unit = self$EndTimeUnit
            )
          )
        )
      }

      if (!is.null(self$InfusionTime)) {
        data$Parameters <- c(
          data$Parameters,
          list(
            list(
              Name = "Infusion time",
              Value = self$InfusionTime,
              Unit = self$InfusionTimeUnit
            )
          )
        )
      }

      if (!is.null(self$WaterVolPerBW)) {
        data$Parameters <- c(
          data$Parameters,
          list(
            list(
              Name = "Volume of water/body weight",
              Value = self$WaterVolPerBW,
              Unit = self$WaterVolPerBWUnit
            )
          )
        )
      }

      return(data)
    },
    #' @description
    #' Print the object to the console
    print = function() {
      ul <- cli::cli_ul()
      cli::cli_li(paste("Route:", AdminType[[self$Route]]$human))
      cli::cli_li(paste("Dose:", self$Dose, self$DoseUnit))
      cli::cli_li(paste("Dose Interval:", AdminInterval[[self$DoseInterval]]$human))
      cli::cli_li(paste("Start Time:", paste(self$StartTime, self$StartTimeUnit)))
      if (!is.null(self$EndTime)) {
        cli::cli_li(paste("End Time:", paste(self$EndTime, self$EndTimeUnit)))
      }
      if (self$Route == "IV Infusion") {
        cli::cli_li(paste("Infusion Time:", paste(self$InfusionTime, self$InfusionTimeUnit)))
      }
      if (self$Route == "Oral") {
        cli::cli_li(paste("Volume of water per body weight:", paste(self$WaterVolPerBW, self$WaterVolPerBWUnit)))
      }
      if (self$Route == "Custom") {
        cli::cli_li(paste("Target:", paste(self$TagetOrgan, self$TargetCompartment, sep = "|")))
      }
      if (self$Route %in% c("Oral", "Custom")) {
        cli::cli_li(paste("Formulation:", self$Formulation$Name))
      }
      cli::cli_end(ul)
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
    .Formulation = NULL,
    .FormulationKey = NULL,
    # Path of the application protocol
    .Path = NULL,
    .Name = NULL
    # .TargetOrgan = NULL,
    # .TargetCompartment = NULL
  )
)

#' @title AdvancedProtocol
#' @docType class
#' @description  Description of an advanced administration protocol
#' @format NULL
#' @export
AdvancedProtocol <- R6::R6Class(
  "AdvancedProtocol",
  active = list(
    #' @field UUID Unique identifier (read-only)
    UUID = function(value) {
      if (missing(value)) {
        private$.UUID
      } else {
        cli::cli_abort(messages$readOnly("UUID"))
      }
    },
    #' @field Name Protocol name
    Name = function(value) {
      if (missing(value)) {
        private$.Name
      } else {
        if (!is.null(value) && !is.character(value)) {
          cli::cli_abort("Supplied Name is not valid.")
        } else {
          private$.Name <- value
        }
      }
    },
    #' @field Schemas List of schemas for the advanced protocol
    Schemas = function(value) {
      if (missing(value)) {
        private$.Schemas
      } else {
        cli::cli_abort(messages$readOnly("Schemas"))
      }
    },
    #' @field Path Prefix path for the administration
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
    },
    #' @field Formulations Formulations used with protocol
    Formulations = function(value) {
      if (missing(value)) {
        unique(
          purrr::compact(
            unlist(
              lapply(private$.Schemas, \(x) {
                lapply(x$SchemaItems, \(y) {
                  y$Formulation
                })
              }),
              recursive = TRUE
            )
          )
        )
      } else {
        cli::cli_abort(messages$readOnly("Formulations"))
      }
    },
    #' @field FormulationsKey Formulations Key used with protocol
    FormulationsKey = function(value) {
      if (missing(value)) {
        unique(
          purrr::compact(
            unlist(
              lapply(private$.Schemas, \(x) {
                lapply(x$SchemaItems, \(y) {
                  y$FormulationKey
                })
              }),
              recursive = TRUE
            )
          )
        )
      } else {
        cli::cli_abort(messages$readOnly("FormulationsKey"))
      }
    }
  ),
  public = list(
    #' @description
    #' Initialize a new instance of the class
    #' @param name Name of the protocol
    #' @param path Prefix for the path of administration in the simulations
    #' @return A new `AdvancedProtocol` object.
    initialize = function(name = "Protocol", path = NULL) {
      private$.UUID <- uuid::UUIDgenerate()
      self$Name <- name
      if (is.null(path)) {
        path <- "Events|{protocolName}"
      }
      self$Path <- path
    },
    #' @description
    #' Add a schema of administration
    #' @param startTime Starting time of the schema
    #' @param numberOfRepetitions Number of repetitions of the schema
    #' @param timeBetweenRepetitions Time between repetitions of the schema
    #' @param timeUnit Time unit for `startTime` and `timeBetweenRepetitions` of the schema
    #' @param schemaName Name of the schema
    #' @return The updated `AdvancedProtocol` object.
    addSchema = function(startTime, numberOfRepetitions, timeBetweenRepetitions, timeUnit, schemaName) {
      # ensure schema name does not exist
      if (schemaName %in% sapply(self$Schemas, \(x) x$Name)) {
        cli::cli_abort("Schema {.var {schemaName}} already exists.")
      }
      private$.Schemas <- c(
        private$.Schemas,
        list(
          list(
            Name = schemaName,
            SchemaItems = list(),
            StartTime = startTime,
            NumberOfRepetitions = numberOfRepetitions,
            TimeBetweenRepetitions = timeBetweenRepetitions,
            TimeUnit = timeUnit
          )
        )
      )
      return(invisible(self))
    },
    #' @description
    #' Add a protocol of administration to an existing schema
    #' @param protocol The protocol to add to the schema
    #' @param schemaName Name of the schema to add the protocol to
    #' @return The updated `AdvancedProtocol` object.
    addProtocolToSchema = function(protocol, schemaName) {
      # check that schema exists
      schemaIndex <- which(
        sapply(private$.Schemas, \(x) {
          x$Name
        }) == schemaName
      )
      if (length(schemaIndex) == 0) {
        cli::cli_abort("Could not find schema {.var {schemaName}}.")
      }
      # check that protocol is single
      if (!("SimpleProtocol" %in% class(protocol)) || protocol$DoseInterval != "Single") {
        cli::cli_abort("Only `SimpleProtocol` objects with a `Single` dose interval can be added to a schema.")
      }
      # check that if protocol contains a formulation, the formulation name is not already used
      # for a different formulation
      if (!is.null(protocol$Formulation)) {
        # check that name is unused or that formulation is identical
        existingForm <- self$Formulations
        if (protocol$Formulation$Name %in% purrr::list_c(purrr::map(existingForm, ~ .x$Name))) {
          identicalIdx <- which(purrr::list_c(purrr::map(existingForm, ~ .x$Name)) == protocol$Formulation$Name)
          for (idx in identicalIdx) {
            if (!identical(existingForm[[idx]], protocol$Formulation)) {
              cli::cli_abort(
                paste(
                  "Formulation name {.var {protocol$Formulation$Name}}",
                  "is already used for a different formulation."
                )
              )
            }
          }
          protocol$FormulationKey <- paste0("Formulation", identicalIdx)
        } else {
          # update protocol with correct formulation key
          protocol$FormulationKey <- paste0("Formulation", length(existingForm) + 1)
        }
      }

      # rename protocol to ensure uniqueness
      protocol$Name <- paste0("Schema Item ", length(private$.Schemas[[schemaIndex]]$SchemaItems) + 1)
      private$.Schemas[[schemaIndex]]$SchemaItems <- c(private$.Schemas[[schemaIndex]]$SchemaItems, protocol)
      return(invisible(self))
    },
    #' @description
    #' Extract all single administration to be applied by a protocol. For easier mapping to path in
    #' the simulation pkml.
    #' @return A tibble with the type of administration, time of administration, parameters of the
    #' administration and the formulation name.
    extractProtocol = function() {
      # for advanced protocol
      wantedAdmin <- vector(mode = "list", length = length(self$Schemas))

      for (schemaIdx in seq_along(self$Schemas)) {
        wantedAdmin[[schemaIdx]] <- vector(mode = "list", length = length(self$Schemas[[schemaIdx]]$SchemaItems))
        startTimeSchema <- ospsuite::toBaseUnit(
          quantityOrDimension = "Time",
          values = self$Schemas[[schemaIdx]]$StartTime,
          unit = self$Schemas[[schemaIdx]]$TimeUnit
        )
        schemaInterval <- ospsuite::toBaseUnit(
          quantityOrDimension = "Time",
          values = self$Schemas[[schemaIdx]]$TimeBetweenRepetitions,
          unit = self$Schemas[[schemaIdx]]$TimeUnit
        )
        schemaTimes <- seq(
          from = startTimeSchema,
          by = schemaInterval,
          length.out = self$Schemas[[schemaIdx]]$NumberOfRepetitions
        )

        for (schemaItemsIdx in seq_along(self$Schemas[[schemaIdx]]$SchemaItems)) {
          wantedAdminProt <- self$Schemas[[schemaIdx]]$SchemaItems[[schemaItemsIdx]]$extractProtocol()
          wantedAdmin[[schemaIdx]][[schemaItemsIdx]] <- dplyr::tibble(
            type = wantedAdminProt$type,
            time = wantedAdminProt$time + schemaTimes,
            parameters = wantedAdminProt$parameters,
            formulationType = wantedAdminProt$formulationType,
            formulationName = wantedAdminProt$formulationName,
            formulation = wantedAdminProt$formulation
          )
        }
        wantedAdmin[[schemaIdx]] <- dplyr::bind_rows(wantedAdmin[[schemaIdx]])
      }
      wantedAdmin <- dplyr::bind_rows(wantedAdmin)
      uniqueFormulations <- unique(wantedAdmin$formulation) %>% purrr::compact()
      wantedAdmin <- wantedAdmin %>%
        dplyr::rowwise() %>%
        dplyr::mutate(
          formulationKey = ifelse(
            is.null(formulation),
            NA,
            paste0(
              "Formulation",
              which(
                purrr::list_c(
                  purrr::map(
                    uniqueFormulations, \(x) {
                      identical(x, formulation)
                    }
                  )
                )
              )
            )
          )
        )

      return(wantedAdmin)
    },
    #' @description
    #' Extract all parameter paths needed to be changed in the simulation
    #' @param path Prefix path for the administration.
    #' @return A character vector with all parameter paths.
    getAllParameterPaths = function(path = self$Path) {
      allParamPaths <- c()
      protocolName <- self$Name
      path <- glue::glue(path)

      wantedAdmin <- self$extractProtocol()

      # loop across formulationName
      for (form in unique(wantedAdmin$formulationName)) {
        if (is.na(form)) {
          adminSubset <- wantedAdmin[is.na(wantedAdmin$formulationName), ]
        } else {
          adminSubset <- wantedAdmin[sapply(wantedAdmin$formulationName == form, isTRUE), ]
        }

        # sort admin subset by time
        adminSubset <- adminSubset[order(adminSubset$time), ]
        for (i in seq_len(nrow(adminSubset))) {
          mainPath <- paste(path, paste0(na.omit(form)), sep = "|")
          appPath <- paste(mainPath, paste0("Application_", i), "ProtocolSchemaItem", sep = "|")

          ospDim <- ospsuite::getDimensionForUnit(adminSubset$parameters[[i]]$DoseUnit)
          if (ospDim == ospsuite::ospDimensions$Mass) {
            doseParamName <- "Dose"
          } else if (ospDim == ospsuite::ospDimensions$`Dose per body weight`) {
            doseParamName <- "DosePerBodyWeight"
          } else if (ospDim == ospsuite::ospDimensions$`Dose per body surface area`) {
            doseParamName <- "DosePerBodySurfaceArea"
          }

          allParamPaths <- c(allParamPaths, paste(appPath, doseParamName, sep = "|"))
          allParamPaths <- c(allParamPaths, paste(appPath, "Start time", sep = "|"))
          if (!is.null(adminSubset$parameters[[i]]$InfusionTime)) {
            allParamPaths <- c(allParamPaths, paste(appPath, "Infusion time", sep = "|"))
          }
          if (!is.null(adminSubset$parameters[[i]]$WaterVolPerBW)) {
            allParamPaths <- c(allParamPaths, paste(appPath, "Volume of water/body weight", sep = "|"))
          }
        }
      }
      # add formulations parameters
      if (!is.null(self$Formulations)) {
        allParamPaths <- c(
          allParamPaths,
          unlist(
            sapply(
              self$Formulations,
              \(y) {
                y$getAllPropertyPaths(protocolName = path)
              }
            )
          )
        )
      }
      return(unique(unname(allParamPaths)))
    },
    #' @description
    #' Convert to snapshot
    toSnapshot = function() {
      data <- list(
        Name = self$Name,
        DosingInterval = "Single",
        Schemas = purrr::map(
          self$Schemas,
          \(x) {
            list(
              Name = x$Name,
              SchemaItems = purrr::map(
                x$SchemaItems,
                \(y) {
                  y$toSnapshot()
                }
              ),
              Parameters = list(
                list(
                  Name = "Start time",
                  Value = x$StartTime,
                  Unit = x$TimeUnit
                ),
                list(
                  Name = "NumberOfRepetitions",
                  Value = x$NumberOfRepetitions
                ),
                list(
                  Name = "TimeBetweenRepetitions",
                  Value = x$TimeBetweenRepetitions,
                  Unit = x$TimeUnit
                )
              )
            )
          }
        )
      )
      return(data)
    },
    #' @description
    #' Print the object to the console
    print = function() {
      purrr::map(self$Schemas, \(x) {
        ul1 <- cli::cli_ul()
        cli::cli_text("Schema: ", x$Name)
        ul2 <- cli::cli_ul()
        cli::cli_li(paste("Start time:", x$StartTime, x$TimeUnit))
        cli::cli_li(paste("Number of repetitions:", x$NumberOfRepetitions))
        cli::cli_li(paste("Time between repetitions:", x$TimeBetweenRepetitions, x$TimeUnit))
        purrr::imap(x$SchemaItems, \(y, i) {
          cli::cli_text("Schema item ", i)
          ul3 <- cli::cli_ul()
          y$print()
          cli::cli_end(ul3)
        })
        cli::cli_end(ul2)
        cli::cli_end(ul1)
      })
    }
  ),
  private = list(
    .UUID = NULL,
    .Path = NULL,
    .Name = NULL,
    .Schemas = NULL,
    deep_clone = function(...) {
      .myDeepClone(...)
    }
  )
)
