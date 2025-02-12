#' @title Study
#' @docType class
#' @description  Description of a study
#' @format NULL
#' @export
Study <- R6::R6Class(
  "Study",
  cloneable = FALSE,
  inherit = ospsuite.utils::Printable,
  active = list(
    #' @field Compounds List of administered compounds (with administration protocol), object of class `Compound`
    Compounds = function(value) {
      if (missing(value)) {
        private$.compounds
      } else {
        lapply(value, \(x) {ospsuite.utils::validateIsOfType(x, "Compound", nullAllowed = TRUE)})
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
        # if no generic model given assume it will be automatically generated, then individual need to be default individuals
        if (is.null(private$.genericModel)) {
          if (!value %in% c(ospsuite::HumanPopulation, ospsuite::Species)) {
            cli::cli_abort(messages$valueEnumError("Individual", value, allowed = c(ospsuite::Species, ospsuite::HumanPopulation)))
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
      return(self)
    },

    #' @description
    #' Get the paths of all parameters defined for the study.
    #' This is a union of all compounds and administration protocol parameters.
    #' @return A character vector with the paths of all parameters
    getAllParameterPaths = function() {
      paths <- purrr::map(private$.compounds, \(x) {
        x$getAllParameterPaths()
      })
      return(paths)
    },

    #' @description
    #' Add DataSet objects to the study
    #' @param dataSets a DataSet object
    addDataSets = function(dataSets) {
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
    #' Convert study to a snapshot
    toSnapshot = function() {
      data <- list(
        "Version" = 80,
        "Individuals" =  list(
          list(
            Name = self$Individual,
            OriginData = list(
                 Species = ifelse(self$Individual %in% ospsuite::HumanPopulation, "Human", self$Individual),
                 Population = ifelse(self$Individual %in% ospsuite::HumanPopulation,  self$Individual, c())
            ),
            ExpressionProfiles = list()
          )
        ),
        "Compounds" = purrr::map(self$Compounds, \(x) {x$toSnapshot()}),
        "Formulations" = purrr::list_c(purrr::map(self$Compounds, \(x) {purrr::map(x$Protocol$Formulations, \(y) {y$toSnapshot()})})),
        "Protocols" = purrr::map(self$Compounds, \(x) {x$Protocol$toSnapshot()}),
        "Simulations" = list(
          list(
            Name = self$ID,
            Model = "4Comp",
            Solver = c(),
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
        data$Compounds[[compIndex]]$FractionUnbound[[1]]$Species <- ifelse(self$Individual %in% ospsuite::HumanPopulation, "Human", self$Individual)
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
    #' Set generic model to use if pre-generated (for example from MoBi with PD)
    #' @param modelPath path of the pkml model to use for the study. Keep to NULL if a generic model should be automatically generated.
    setGenericModel = function(modelPath) {
      # ensure it exist and is a pkml file
      if (!file.exists(modelPath) || !grepl(".pkml$", modelPath)) {
        cli::cli_abort("Model path does not exist or is not a pkml file.")
      }
      private$.genericModel <- modelPath
    },
    #' @description
    #' Print the object to the console
    #' @param ... Rest arguments.
    print = function(...) {
      private$printClass()
      cli::cli_text("ID:", self$ID)
      cli::cli_text("Individual:", self$Individual)
      if (!is.null(self$Compounds)) {
        purrr::map(self$Compounds,
          \(x) {
            cli::cli_text(paste0("Compound ", x$Name, " with protocol ", x$Protocol$Name))
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
    .genericModel = NULL
  )
)
