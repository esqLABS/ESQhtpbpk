#' @title Study
#' @docType class
#' @description  Description of a study
#' @format NULL
Study <- R6::R6Class(
  "Study",
  cloneable = FALSE,
  inherit = ospsuite.utils::Printable,
  active = list(
    #' @field AdministrationProtocol Description of the administration protocol
    administrationProtocol = function(value) {
      if (missing(value)) {
        private$.administrationProtocol
      } else {
        ospsuite.utils::validateIsOfType(value, "AdministrationProtocol")
        private$.administrationProtocol <- value
      }
    },

    #' @field Compound Administered compound, object of class `Compound`
    #' 2DO support multiple compounds
    Compound = function(value) {
      if (missing(value)) {
        private$.compound
      } else {
        ospsuite.utils::validateIsOfType(value, "Compound", nullAllowed = TRUE)
        private$.compound <- value
      }
    }
  ),
  public = list(
    # ID of the study
    ID = NULL,
    # Species
    Species = NULL,

    #' @description
    #' Initialize a new instance of the class
    #' @param ID ID of the study
    #' @param compound Administered compound, object of class `Compound`.
    #' Current assumption - only one compound per study
    #' @return A new `Study` object.
    initialize = function(ID, compound) {
      self$ID <- ID
      self$Compound <- compound
    },

    #' @description
    #' Get the paths of all parameters defined for the study.
    #' This is a union of all compounds and administration protocol parameters.
    #' @return A character vector with the paths of all parameters
    getAllParameterPaths = function() {
      return(union(private$.compound$getAllParameterPaths(), private$.administrationProtocol$getAllParameterPaths()))
    },

    #' @description
    #' Add DataSet objects to the study
    #' @param ... Rest arguments.
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
    #' Print the object to the console
    #' @param ... Rest arguments.
    print = function(...) {
      private$printClass()
      private$printLine("ID", self$ID)
      if (!is.null(self$Compound)) {
        self$Compound$print()
      }
      private$printLine("Species", self$Species)
      if (!is.null(self$administrationProtocol)) {
        self$administrationProtocol$print()
      }

      invisible(self)
    }
  ),
  private = list(
    .administrationProtocol = NULL,
    .compound = NULL,
    .observedData = list()
  )
)
