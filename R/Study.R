#' @title Study
#' @docType class
#' @description  Description of a study
#' @format NULL
#' @export
Study <- R6::R6Class(
  "Study",
  cloneable = FALSE,
  active = list(
    #' @field Compounds List of administered compounds (with administration protocol), object of class `Compound`
    Compounds = function(value) {
      if (missing(value)) {
        private$.compounds
      } else {
        lapply(value, \(x) {
          ospsuite.utils::validateIsOfType(x, "Compound", nullAllowed = TRUE)
        })
        private$.compounds <- purrr::map(value, \(x) x$clone(deep = TRUE))
      }
    },
    #' @field Individual Individual used in the study.
    Individual = function(value) {
      if (missing(value)) {
        private$.individual
      } else {
        if (!is.character(value)) {
          cli::cli_abort(messages$notValid("Individual"))
        }
        # if no generic model given assume it will be automatically generated, then individual
        # need to be default individuals
        if (is.null(private$.genericModel)) {
          if (!value %in% c(ospsuite::HumanPopulation, ospsuite::Species)) {
            msg <- messages$valueEnumError(
              name = "Individual",
              value = value,
              allowed = c(ospsuite::Species, ospsuite::HumanPopulation)
            )
            cli::cli_abort("{msg}")
          }
        }
        private$.individual <- value
      }
    }
  ),
  public = list(
    #' @field ID of the study
    ID = NULL,
    #' @description
    #' Initialize a new instance of the class
    #' @param ID ID of the study
    #' @param compounds list of administered compounds, compounds must be object of class `Compound`.
    #' @param individual individual used in the study
    #' @param genericModel path to a generic model to use if pre-generated (for example from MoBi with PD).
    #' Keep to NULL if a generic model should be automatically generated.
    #' @return A new `Study` object.
    initialize = function(ID, compounds, individual, genericModel = NULL) {
      self$ID <- ID
      self$Compounds <- compounds
      self$setGenericModel(genericModel)
      self$Individual <- individual
      private$.outputSchema <- self$addOutputInterval(startTime = 0, endTime = 24, timeUnit = "h", resolution = 4)
      return(self)
    },

    #' @description
    #' Get the paths of all parameters defined for the study.
    #' This is a union of all compounds and administration protocol parameters.
    #' @return A character vector with the paths of all parameters
    getAllParameterPaths = function() {
      paths <- purrr::list_c(purrr::map(private$.compounds, \(x) {
        x$getAllPropertyPaths()
      }))
      if (!is.null(private$.simulation)) {
        availablePaths <- ospsuite::getAllParameterPathsIn(private$.simulation)

        if (!all(paths %in% availablePaths)) {
          cli::cli_warn("Some paths were not found in the simulation. Please check.")
        }

        paths <- intersect(paths, availablePaths)
      }
      return(paths)
    },

    #' @description
    #' Add DataSet objects to the study
    #' @param dataSets a DataSet object
    addDataSets = function(dataSets) {
      # if only single dataset given wrap in list
      if (!("list" %in% class(dataSets))) {
        dataSets <- list(dataSets)
      }

      ospsuite.utils::validateIsOfType(dataSets, "DataSet", nullAllowed = FALSE)
      for (dataSet in dataSets) {
        private$.observedData[[dataSet$name]] <- dataSet
      }
      invisible(self)
    },
    #' @description
    #' Get the DataSet objects of the study
    #' @return A list of DataSet objects
    getDataSets = function() {
      return(private$.observedData)
    },
    #' @description
    #' Clears the output interval from the simulation and adds a new one.
    #' @param startTime start time of the interval in time units
    #' @param endTime end time of the interval in time units
    #' @param resolution resolution of the interval in pts/time units
    #' @param timeUnit time unit of the interval
    setOutputInterval = function(startTime, endTime, timeUnit, resolution) {
      private$.outputSchema <- list()
      self$addOutputInterval(startTime, endTime, timeUnit, resolution)
    },
    #' @description
    #' Adds an interval to the output schema of the study
    #' @param startTime start time of the interval in time units
    #' @param endTime end time of the interval in time units
    #' @param resolution resolution of the interval in pts/time units
    #' @param timeUnit time unit of the interval
    addOutputInterval = function(startTime, endTime, timeUnit, resolution) {
      ospsuite.utils::validateIsNumeric(c(startTime, endTime, resolution))
      ospsuite::validateUnit(unit = timeUnit, dimension = "Time")

      private$.outputSchema <- c(
        private$.outputSchema,
        list(
          list(
            Parameters = list(
              list(
                Name = "Start time",
                Value = startTime,
                Unit = timeUnit
              ),
              list(
                Name = "End time",
                Value = endTime,
                Unit = timeUnit
              ),
              list(
                Name = "Resolution",
                Value = resolution,
                Unit = paste0("pts/", timeUnit)
              )
            )
          )
        )
      )
    },
    #' @description
    #' Convert study to a snapshot
    toSnapshot = function() {
      data <- list(
        "Version" = 80,
        "Individuals" = list(
          list(
            Name = self$Individual,
            OriginData = purrr::compact(
              list(
                Species = ifelse(self$Individual %in% ospsuite::HumanPopulation, "Human", self$Individual),
                Population = if (self$Individual %in% ospsuite::HumanPopulation) {
                  self$Individual
                } else if (self$Individual == "Human") {
                  cli::cli_warn("Using default of `European_ICRP_2002` for population.")
                  "European_ICRP_2002"
                } else {
                  NULL
                }
              )
            ),
            ExpressionProfiles = list()
          )
        ),
        "Compounds" = purrr::map(self$Compounds, \(x) {
          x$toSnapshot()
        }),
        "Formulations" = purrr::list_c(
          purrr::map(self$Compounds, \(x) {
            purrr::map(x$Protocol$Formulations, \(y) {
              y$toSnapshot()
            })
          })
        ),
        "Protocols" = purrr::map(
          self$Compounds, \(x) {
            x$Protocol$toSnapshot()
          }
        ),
        "Simulations" = list(
          list(
            Name = self$ID,
            Model = "4Comp",
            Solver = c(),
            OutputSchema = private$.outputSchema,
            Individual = self$Individual,
            Compounds = purrr::map(
              self$Compounds,
              \(x) {
                list(
                  Name = x$Name,
                  CalculationMethods = list(
                    paste0("Cellular partition coefficient method - ", x$PartitionCoefficientMethod),
                    paste0("Cellular permeability - ", x$CellularPermeabilityMethod)
                  ),
                  Processes = list(),
                  Protocol = list(
                    Name = x$Protocol$Name,
                    Formulations = purrr::map2(x$Protocol$Formulations, x$Protocol$FormulationsKey, \(y, z) {
                      list(
                        Name = y$Name,
                        Key = z
                      )
                    })
                  )
                )
              }
            ),
            HasResults = FALSE
          )
        )
      )
      # update Fu species
      for (compIndex in seq_along(data$Compounds)) {
        data$Compounds[[compIndex]]$FractionUnbound[[1]]$Species <-
          ifelse(self$Individual %in% ospsuite::HumanPopulation, "Human", self$Individual)
      }
      return(data)
    },
    #' @description
    #' Convert study to a snapshot
    #' @param file file path to save the snapshot
    exportSnapshot = function(file) {
      jsonlite::write_json(self$toSnapshot(), auto_unbox = TRUE, pretty = TRUE, path = file)
    },
    #' @description
    #' Convert study to a pkml
    #' @param file file path to save the pkml
    #' @param overwrite if TRUE, overwrite existing file
    exportPKML = function(file, overwrite = FALSE) {
      tempDir <- tempfile()
      tempFile <- tempfile(tmpdir = tempDir, fileext = ".json")
      if (!dir.exists(tempDir)) {
        dir.create(tempDir)
      }

      self$exportSnapshot(tempFile)

      ospsuite::runSimulationsFromSnapshot(tempFile, exportPKML = TRUE, exportCSV = FALSE, output = tempDir)

      if (!dir.exists(dirname(file))) {
        dir.create(dirname(file), recursive = TRUE, showWarnings = FALSE)
      }
      if (!file.exists(paste0(gsub(tempFile, pattern = "\\.json$", replacement = ""), "-", self$ID, ".pkml"))) {
        cli::cli_abort("Something went wrong with the export of the pkml file.")
      }
      fs::file_copy(
        path = fs::path(paste0(gsub(tempFile, pattern = "\\.json$", replacement = ""), "-", self$ID, ".pkml")),
        new_path = file,
        overwrite = overwrite
      )
    },
    #' @description
    #' Set generic model to use if pre-generated (for example from MoBi with PD)
    #' @param modelPath path of the pkml model to use for the study. Keep to NULL if a generic
    #' model should be automatically generated.
    setGenericModel = function(modelPath) {
      # ensure it exist and is a pkml file
      if (!is.null(modelPath)) {
        if (!file.exists(modelPath) || !grepl(".pkml$", modelPath)) {
          cli::cli_abort("Model path does not exist or is not a pkml file.")
        }
      }
      private$.genericModel <- modelPath
    },
    #' @description
    #' Set simulation model to use if pre-generated (for example from MoBi with PD)
    #' @param simulation simulation loaded from pkml (to check )
    setSimulation = function(simulation) {
      ospsuite.utils::validateIsOfType(simulation, "Simulation")
      private$.simulation <- simulation
    },
    #' @description
    #' Print the object to the console
    #' @param ... Rest arguments.
    print = function(...) {
      ospsuite.utils::ospPrintClass(self)
      cli::cli_text("ID: ", self$ID)
      cli::cli_text("Individual: ", self$Individual)
      if (!is.null(self$Compounds)) {
        cli::cli_par()
        cli::cli_text("Compounds: ")
        purrr::map(
          self$Compounds,
          \(x) {
            cli::cli_li(paste0(x$Name, " with protocol ", x$Protocol$Name))
            ul1 <- cli::cli_ul()
            x$print()
          }
        )
      }
      invisible(self)
    }
  ),
  private = list(
    .compounds = NULL,
    .individual = NULL,
    .observedData = list(),
    .genericModel = NULL,
    .simulation = NULL,
    .outputSchema = list()
  )
)
