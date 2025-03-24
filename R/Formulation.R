#' @title Formulations
#' @docType class
#' @description  Description of a formulation
#' @format NULL
Formulation <- R6::R6Class(
  "Formulation",
  active = list(
    #' @field Type Type of Formulation
    Type = function(value) {
      if (missing(value)) {
        return(private$.Type)
      } else {
        if (!(value %in% names(FormulationType))) {
          msg <- messages$valueEnumError(
            name = "Formulation type",
            value = value,
            allowed = names(FormulationType)
          )
          cli::cli_abort(msg)
        } else {
          if (!is.null(private$.Type) && value != private$.Type) {
            # remove all parameters
            cli::cli_abort("Type can not be modified.")
          }
          private$.Type <- value
        }
      }
    },
    #' @field Name Name of formulation
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
    #' @field Parameters Parameters of the formulation
    Parameters = function(value) {
      if (missing(value)) {
        private$.Parameters
      } else {
        if (!is.list(value) || !all(sapply(value, \(x) "Property" %in% class(x)))) {
          cli::cli_abort("Supplied Parameters are not valid.")
        } else {
          private$.Parameters <- value
        }
      }
    }
  ),
  public = list(
    #' @description
    #' Initialize a new instance of the class Formulation
    #' @param type Type of the formulation
    #' @param name Name of the formulation
    #' @return A new `Formulation` object.
    initialize = function(type, name = "Formulation") {
      self$Name <- name
      self$Type <- type
    },
    # Add a new property
    #' @description
    #' Add a new property/parameter for the formulation
    #' @param name Name of the property to add.
    #' @param parName Corresponding parameter name of the property to add in the simulation
    #' @param dimension Dimension of the property to add.
    #' @param value Value for the property.
    #' @param unit (Optional) Unit to use for the property. If not given, it is assumed to be the
    #' baseUnit of the dimension.
    #' @param enum (Optional) Name list mapping user friendly values to PK-Sim allowed values.
    #' @param check (Optional) Function to check the validity of the supplied value for the property.
    #' @param pathPrefix Corresponding path in the simulation pkml of the property to add.
    #' Default to `{protocolPrefix}|{formulationName}`
    addParameter = function(name, parName, dimension, value = 0, unit = NULL, enum = NULL, check = NULL, pathPrefix = NULL) {
      if (name %in% names(private$.Parameters)) {
        cli::cli_abort(messages$alreadyExist("Property", name))
      }
      pathPrefix <- ifelse(!is.null(pathPrefix), pathPrefix, paste0("{protocolPrefix}|{formulationName}"))
      private$.Parameters[[name]] <- Property$new(
        name = name,
        parName = parName,
        path = paste(pathPrefix, parName, sep = "|"),
        dimension = dimension,
        value = value,
        unit = unit,
        enum = enum,
        check = check
      )
    },
    #' @description
    #' Get the paths of all parameters defined for the formulation, using protocolName and formulationName
    #' @param protocolPrefix Name of the protocol in the simulation
    #' @param formulationName Name of the formulation in the simulation
    #' @return A character vector with the paths of all parameters
    getAllPropertyPaths = function(protocolPrefix = NULL, formulationName = self$Name) {
      if (is.null(protocolPrefix) || is.null(formulationName)) {
        purrr::list_c(
          purrr::map(self$Parameters, \(x) {
            x$path
          })
        )
      } else {
        unlist(
          purrr::map(self$Parameters, \(x) {
            glue::glue(x$path)
          }),
          use.names = FALSE
        )
      }
    },
    #' @description
    #' Convert the object to a snapshot
    #' @return A snapshot representation of the formulation
    toSnapshot = function() {
      snap <- list(
        Name = self$Name,
        FormulationType = FormulationType[[self$Type]],
        Parameters = unname(
          purrr::map(
            self$Parameters,
            \(x) {
              x$toSnapshot()
            }
          )
        )
      )
      # if no parameter remove field
      if (length(snap$Parameters) == 0) {
        snap <- purrr::discard_at(snap, "Parameters")
      }

      return(snap)
    },

    #' @description
    #' Print the object to the console
    #' @param ... Rest arguments.
    print = function(...) {
      cli::cli_text("Formulation Name: ", self$Name)
      cli::cli_text("Formulation Type: ", self$Type)

      for (param in private$.Parameters) {
        if (is.list(param$enum) && !is.null(names(param$enum))) {
          lst <- list(names(param$value))
        } else {
          lst <- list(paste(param$value, param$unit))
        }
        names(lst) <- param$name
        ospsuite.utils::ospPrintItems(lst)
      }
      invisible(self)
    }
  ),
  private = list(
    .Name = NULL,
    .Type = NULL,
    .Parameters = list(),
    deep_clone = function(...) {
      .myDeepClone(...)
    }
  )
)

#' @title Create dissolved formulation
#' @description
#' Create a dissolved formulation
#' @param name Name of the formulation to create
#' @return A new `Formulation` object.
#' @export
createDissolvedFormulation <- function(
    name = "Dissolved") {
  Formulation$new(
    name = name,
    type = "Dissolved"
  )
}

#' @title Create Weibull tablet formulation
#' @description
#' Create a Weibull formulation
#' @param name Name of the formulation to create
#' @param dissolutionTime50 Time to achieve 50% dissolution (default 240)
#' @param dissolutionTime50Unit Time unit for dissolutionTime50 (default min)
#' @param lagTime lag time before dissolution starts (default 0)
#' @param lagTimeUnit Time unit for lagTime (default min)
#' @param shape dissolution shape parameter (default 0.92)
#' @param suspension Boolean, whether to use as suspension (default True)
#' @param path prefix of formulation path in the sim. NULL will defaults to `{protocolPrefix}|{formulationName}`
#' @return A new `Formulation` object.
#' @export
createWeibullFormulation <- function(
    name = "Weibull",
    dissolutionTime50 = 240, dissolutionTime50Unit = "min",
    lagTime = 0, lagTimeUnit = "min",
    shape = 0.92,
    suspension = TRUE,
    path = NULL) {
  formulation <- Formulation$new(
    name = name,
    type = "Weibull"
  )
  formulation$addParameter(
    name = "Dissolution time (50% dissolved)",
    parName = "Dissolution time (50% dissolved)",
    dimension = "Time",
    value = dissolutionTime50,
    unit = dissolutionTime50Unit,
    pathPrefix = path
  )
  formulation$addParameter(
    name = "Lag time",
    parName = "Lag time",
    dimension = "Time",
    value = lagTime,
    unit = lagTimeUnit,
    pathPrefix = path
  )
  formulation$addParameter(
    name = "Dissolution shape",
    parName = "Dissolution shape",
    dimension = "Dimensionless",
    value = shape,
    pathPrefix = path
  )
  formulation$addParameter(
    name = "Use as suspension",
    parName = "Use as suspension",
    dimension = "Dimensionless",
    value = as.numeric(suspension),
    pathPrefix = path
  )

  return(formulation)
}

#' @title Create Lint80 tablet formulation
#' @description
#' Create a Lint80 formulation
#' @param name Name of the formulation to create
#' @param dissolutionTime80 Time to achieve 80% dissolution (default 240)
#' @param dissolutionTime80Unit Time unit for dissolutionTime80 (default min)
#' @param lagTime lag time before dissolution starts (default 0)
#' @param lagTimeUnit Time unit for lagTime (default min)
#' @param suspension Boolean, whether to use as suspension (default True)
#' @param path prefix of formulation path in the sim. NULL will defaults to `{protocolPrefix}|{formulationName}`
#' @return A new `Formulation` object.
#' @export
createLint80Formulation <- function(
    name = "Lint80",
    dissolutionTime80 = 240, dissolutionTime80Unit = "min",
    lagTime = 0, lagTimeUnit = "min",
    suspension = TRUE,
    path = NULL) {
  formulation <- Formulation$new(
    name = name,
    type = "Lint80"
  )
  formulation$addParameter(
    name = "Dissolution time (80% dissolved)",
    parName = "Dissolution time (80% dissolved)",
    dimension = "Time",
    value = dissolutionTime80,
    unit = dissolutionTime80Unit,
    pathPrefix = path
  )
  formulation$addParameter(
    name = "Lag time",
    parName = "Lag time",
    dimension = "Time",
    value = lagTime,
    unit = lagTimeUnit,
    pathPrefix = path
  )
  formulation$addParameter(
    name = "Use as suspension",
    parName = "Use as suspension",
    dimension = "Dimensionless",
    value = as.numeric(suspension),
    pathPrefix = path
  )

  return(formulation)
}

#' @title Create particle dissolution tablet formulation
#' @description
#' Create a  particle dissolution formulation
#' @param name Name of the formulation to create
#' @param thickness Thickness of unstirred water layer (default 30)
#' @param thicknessUnit Unit for thickness of unstirred water layer (default µm)
#' @param distributionType Type of distribution, either "Monodisperse" or "Polydisperse" (default "Monodisperse")
#' @param distribution Distribution for polydisperse type, either "Normal" or "LogNormal" (default "Normal")
#' @param radius Particle distribution radius, mean or geomean depending on distribution (default 10)
#' @param radiusUnit Unit for particle distribution radius (default µm)
#' @param radiusSD Particle distribution radius standard deviation, for polydisperse normal only (default 3)
#' @param radiusCV Particle distribution radius coefficient of variation, for polydisperse log-normal only (default 3)
#' @param radiusMin Mininum particle radius, for polydispersed only (default 1)
#' @param radiusMax Maximum particle radius, for polydispersed only (default 19)
#' @param nBins Number of bins for polydisperse only (default 3)
#' @param path prefix of formulation path in the sim. NULL will defaults to `{protocolPrefix}|{formulationName}`
#' @return A new `Formulation` object.
#' @export
createParticleDissolutionFormulation <- function(
    name = "ParticleDissolution",
    thickness = 30, thicknessUnit = "µm",
    distributionType = "Monodisperse", distribution = "Normal",
    radius = 10, radiusUnit = "µm", radiusSD = 3, radiusCV = 1.5, radiusMin = 1, radiusMax = 19,
    nBins = 3,
    path = NULL) {
  formulation <- Formulation$new(
    name = name,
    type = "Particle"
  )
  formulation$addParameter(
    name = "Thickness (unstirred water layer)",
    parName = "Thickness (unstirred water layer)",
    dimension = "Length",
    value = thickness,
    unit = thicknessUnit,
    pathPrefix = path
  )
  formulation$addParameter(
    name = "Type of particle size distribution",
    parName = "Type of particle size distribution",
    dimension = "Dimensionless",
    value = distributionType,
    enum = ParticleSizeDistributionType,
    pathPrefix = path
  )
  # for monodisperse
  if (distributionType == "Monodisperse") {
    formulation$addParameter(
      name = "Particle radius (mean)",
      parName = "Particle radius (mean)",
      dimension = "Length",
      value = radius,
      unit = radiusUnit,
      pathPrefix = path
    )
  } else { # polydisperse
    formulation$addParameter(
      name = "Particle size distribution",
      parName = "Particle size distribution",
      dimension = "Dimensionless",
      value = distribution,
      enum = ParticleSizeDistribution,
      pathPrefix = path
    )
    if (distribution == "Normal") {
      formulation$addParameter(
        name = "Particle radius (mean)",
        parName = "Particle radius (mean)",
        dimension = "Length",
        value = radius,
        unit = radiusUnit,
        pathPrefix = path
      )
      formulation$addParameter(
        name = "Particle radius (SD)",
        parName = "Particle radius (SD)",
        dimension = "Length",
        value = radiusSD,
        unit = radiusUnit,
        pathPrefix = path
      )
    } else {
      formulation$addParameter(
        name = "Particle radius (geomean)",
        parName = "Particle radius (geomean)",
        dimension = "Length",
        value = radius,
        unit = radiusUnit,
        pathPrefix = path
      )
      formulation$addParameter(
        name = "Coefficient of variation",
        parName = "Coefficient of variation",
        dimension = "Dimensionless",
        value = radiusCV,
        pathPrefix = path
      )
    }
    formulation$addParameter(
      name = "Particle radius (min)",
      parName = "Particle radius (min)",
      dimension = "Length",
      value = radiusMin,
      unit = radiusUnit,
      pathPrefix = path
    )
    formulation$addParameter(
      name = "Particle radius (max)",
      parName = "Particle radius (max)",
      dimension = "Length",
      value = radiusMax,
      unit = radiusUnit,
      pathPrefix = path
    )
    formulation$addParameter(
      name = "Number of bins",
      parName = "Number of bins",
      dimension = "Dimensionless",
      value = nBins,
      pathPrefix = path
    )
  }

  return(formulation)
}

#' @title Create particle ZeroOrder formulation
#' @description
#' Create a  ZeroOrder formulation
#' @param name Name of the formulation to create
#' @param endTime Time of administration end (default 60)
#' @param endTimeUnit Unit for time of administration end (default min)
#' @param path prefix of formulation path in the sim. NULL will defaults to `{protocolPrefix}|{formulationName}`
#' @return A new `Formulation` object.
#' @export
createZeroOrderFormulation <- function(
    name = "ZeroOrder",
    endTime = 60, endTimeUnit = "min",
    path = NULL) {
  formulation <- Formulation$new(
    name = name,
    type = "ZeroOrder"
  )
  formulation$addParameter(
    name = "End time",
    parName = "End time",
    dimension = "Time",
    value = endTime,
    unit = endTimeUnit,
    pathPrefix = path
  )
  return(formulation)
}

#' @title Create particle FirstOrder formulation
#' @description
#' Create a  FirstOrder formulation
#' @param name Name of the formulation to create
#' @param tHalf Half-life of the drug release process (default 0.01)
#' @param tHalfUnit Unit of half-life of the drug release process (default min)
#' @param path prefix of formulation path in the sim. NULL will defaults to `{protocolPrefix}|{formulationName}`
#' @return A new `Formulation` object.
#' @export
createFirstOrderFormulation <- function(
    name = "FirstOrder",
    tHalf = 0.01, tHalfUnit = "min",
    path = NULL) {
  formulation <- Formulation$new(
    name = name,
    type = "FirstOrder"
  )
  formulation$addParameter(
    name = "t1/2",
    parName = "t1/2",
    dimension = "Time",
    value = tHalf,
    unit = tHalfUnit,
    pathPrefix = path
  )
  return(formulation)
}
