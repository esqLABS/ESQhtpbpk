#' @title Compound
#' @docType class
#' @description  Description of a compound
#' @format NULL
#' @export
Compound <- R6::R6Class(
  "Compound",
  inherit = ospsuite.utils::Printable,
  active = list(
    #' @field PartitionCoefficientMethod Method used to calculate the partition coefficient
    PartitionCoefficientMethod = function(value) {
      if (missing(value)) {
        private$.pc
      } else {
        if (!is.character(value) || !(value %in% names(PCMethods))) {
          cli::cli_abort(messages$valueEnumError("PartitionCoefficientMethod", value, allowed = names(PCMethods)))
        }
        private$.pc <- PCMethods[[value]]
      }
    },
    #' @field CellularPermeabilityMethod Method used to calculate the cellular permeability coefficient
    CellularPermeabilityMethod = function(value) {
      if (missing(value)) {
        private$.cp
      } else {
        if (!is.character(value) || !(value %in% names(CPMethods))) {
          cli::cli_abort(messages$valueEnumError("CellularPermeabilityMethod", value, allowed = names(CPMethods)))
        }
        private$.cp <- CPMethods[[value]]
      }
    },
    #' @field Protocol Protocol used for compoud
    Protocol = function(value) {
      if (missing(value)) {
        private$.protocol
      } else {
        ospsuite.utils::validateIsOfType(value, c("SimpleProtocol", "AdvancedProtocol"), nullAllowed = FALSE)
        private$.protocol <- value
      }
    }
  ),
  public = list(
    #' @field ID Id of the compound
    ID = NULL,
    #' @field Name Name of the compound as used in the generic simulation
    Name = NULL,

    #' @description
    #' Initialize a new instance of the class Compound
    #' @param ID Id of the compound
    #' @param name Name of the compound in the simulation pkmls
    #' @param PCMethod Partition coefficient method to use for the compound
    #' @param CPMethod Cellular permeability method to use for the compound
    #' @return A new `Compound` object.
    initialize = function(ID, name = "Compound", PCMethod = "PK-Sim", CPMethod = "PK-Sim") {
      self$ID <- ID
      self$Name <- name
      self$PartitionCoefficientMethod <- PCMethod
      self$CellularPermeabilityMethod <- CPMethod

      # replace with given ${name}$ in template by given name
      template <- readr::read_file(system.file("extdata", "generic_compound_template.json", package = "ESQhtpbpk"))
      filled_template <- glue::glue(template, .open = "${", .close = "}$")

      private$.allProperties <- private$.initializePropertiesFromJSON(filled_template)
      names(private$.allProperties) <- sapply(private$.allProperties, \(x) x$name)

      private$.allPropertyPaths <- sapply(private$.allProperties, \(x) {x$path})
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
        return(private$.allProperties[[name]]$print(compoundName = self$name))
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
    #' @param parName Corresponding parameter name in the simulation pkml of the property to add.
    #' @param dimension Dimension of the property to add.
    #' @param value Value for the property.
    #' @param unit (Optional) Unit to use for the property. If not given, it is assumed to be the baseUnit of the dimension.
    #' @param enum (Optional) Name list mapping user friendly values to PK-Sim allowed values.
    #' @param check (Optional) Function to check the validity of the supplied value for the property.
    #' @param path Corresponding full path of the parameter in the simulation pkml of the property to add
    #' (default to NULL to create it automatically based on parName).
    addProperty = function(name, parName, dimension, value = 0, unit = NULL, enum = NULL, check = NULL, path = NULL) {
      if (name %in% names(private$.allProperties)) {
        stop("Property '", name, "' already exists.")
      }

      private$.allProperties[[name]] <- Property$new(
        name = name,
        parName = parName,
        path = path,
        dimension = dimension,
        value = value,
        unit = unit,
        enum = enum,
        check = check
      )
      if (is.null(path)) {
        path <- paste0("{compoundName}|", parName)
      }
      private$.allPropertyPaths <- c(private$.allPropertyPaths, path)
    },
    # Remove a property
    #' @description
    #' Remove a property from the compound.
    #' @param name Name of the property to remove
    removeProperty = function(name) {
      path <- private$.allProperties[[name]]$path
      private$.allProperties[[name]] <- NULL
      private$.allPropertyPaths <- private$.allPropertiesPaths[-which(private$.allPropertiesPaths == path)]
    },
    # Add a new process
    #' @description
    #' Add a new process property for the compound.
    #' @param propertyName Name of the property to add.
    #' @param processType Corresponding Process type. Allowed Process types are:
    #' "Liver Plasma Clearance", "Hep T1/2", "Hep Residuals", "Liver Mic T1/2",
    #' "Liver Mic Residuals", "Renal Plasma Clearance", "Tub Sec FirstOrder",
    #' "Tub Sec MM", "GFR", "Biliary Plasma Clearance".
    #' @param parName Corresponding parameter name in the simulation pkml of the property to add.
    #' @param dimension Dimension of the property to add.
    #' @param value Value for the property.
    #' @param unit (Optional) Unit to use for the property. If not given, it is assumed to be the baseUnit of the dimension.
    #' @param enum (Optional) Name list mapping user friendly values to PK-Sim allowed values.
    #' @param check (Optional) Function to check the validity of the supplied value for the property.
    #' @param path (Optional) Corresponding full path of the parameter in the simulation pkml of the
    #' property to add. Needed when using a predefined pkml for the HTPBPK simulation.
    addProcessProperty = function(propertyName, processType, parName, dimension, value = 0, unit = NULL, enum = NULL, check = NULL,  path = NULL) {
      if (!(processType %in% names(ProcessTypes))) {
        cli::cli_abort("ProcessType {.var {processType}} not allowed. Allowed values are {names(ProcessTypes)}.")
      }
      # only allow one type of hepatic or renal clearance
      if (!(processType %in% names(private$.allProcessProperties)) && ProcessTypes[processType] %in% ProcessTypes[names(private$.allProcessProperties)]) {
        cli::cli_abort("Only one process of each type is allowed.")
      }
      if (propertyName %in% names(private$.allProcessProperties[[processType]])) {
        stop("Property '", propertyName, "' already exists.")
      }

      if (is.null(path)) {
        path <- paste0("{compoundName}-", paste(ProcessPrefixes[processType], processType, sep = "-"), "|", parName)
      }
      private$.allProcessProperties[[processType]][[propertyName]] <- Property$new(
        name = propertyName,
        parName = parName,
        path = path,
        dimension = dimension,
        value = value,
        unit = unit,
        enum = enum,
        check = check
      )

      private$.allPropertyPaths <- c(private$.allPropertyPaths, path)
    },
    # Remove a process property
    #' @description
    #' Remove a process property from the compound.
    #' @param propertyName Name of the property to remove
    #' @param processType Type of the process to remove the property from
    removeProcessProperty = function(propertyName, processType) {
      path <- private$.allProcessProperties[[processType]][[propertyName]]$path
      private$.allProcessProperties[[processType]][[propertyName]] <- NULL
      private$.allProcessProperties <- purrr::compact(private$.allProcessProperties)
      private$.allPropertyPaths <- private$.allPropertyPaths[-which(private$.allPropertyPaths == path)]
    },
    # Getter
    #' @description
    #' Get specific process property of the compound
    #' @param propertyName Name of the property to get values from
    #' @param processType Type of the process to get the property from
    #' #' @return The corresponding property object.
    getProcessProperty = function(propertyName, processType) {
      if (!processType %in% names(private$.allProcessProperties)) {
        stop("ProcessType '", processType, "' not found in Compound.")
      }
      if (!propertyName %in% names(private$.allProcessProperties[[processType]])) {
        stop("Property '", propertyName, "' not found in process '",processType, "' .")
      } else {
        return(private$.allProcessProperties[[processType]][[propertyName]]$print(compoundName = self$name))
      }
    },

    # Setter
    #' @description
    #' Update specific process property value for the compound.
    #' @param propertyName Name of the property to set values for
    #' @param processType Type of the process to set the property from
    #' @param value New value for the property.
    #' @param unit New unit to use for the property, if not given the unit is assumed to be the same as previously.
    setProcessPropertyValue = function(propertyName, processType, value, unit = NULL) {
      if (!processType %in% names(private$.allProcessProperties)) {
        stop("ProcessType '", processType, "' not found in Compound.")
      }
      if (!propertyName %in% names(private$.allProcessProperties[[processType]])) {
        stop("Property '", propertyName, "' not found in process '",processType, "' .")
      } else {
        prop <- private$.allProcessProperties[[processType]][[propertyName]]

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

    # Set the administration protocol of a compound
    #' @description
    #' Set the administration protocol to be used for a compound
    #' @param protocol administration protocol to use for the compound. Must be an object of class `SimpleProtocol` or `AdvancedProtocol`.
    setProtocol = function(protocol) {
      self$Protocol <- protocol
      invisible(self)
    },
    # Create a snapshot representation of the compound
    #' @description
    #' Create a snapshot representation of the compound
    toSnapshot = function() {
      snap <- list(
        Name = self$Name,
        IsSmallMolecule = as.logical(private$.allProperties[["Is small molecule"]]$value),
        PlasmaProteinBindingPartner = names(private$.allProperties[["Plasma protein binding partner"]]$value),
        Lipophilicity = list(list(Name = "Lipophilicity", Parameters = list(private$.allProperties[["Lipophilicity"]]$toSnapshot()))),
        FractionUnbound = list(list(Name = "FractionUnbound", Parameters = list(private$.allProperties[["Fraction unbound"]]$toSnapshot()))),
        Solubility = list(
          list(
            Name = "Solubility",
            Parameters = purrr::compact(
              list(
                private$.allProperties[["Solubility"]]$toSnapshot(),
                private$.allProperties[["Reference pH"]]$toSnapshot())
              )
          )
        ),
        PkaTypes = purrr::compact(
          list(
            switch(
              names(private$.allProperties[["Compound type 0"]]$value),
              "Neutral" = NULL,
              list(Type = names(private$.allProperties[["Compound type 0"]]$value), Pka = private$.allProperties[["pKa value 0"]]$value)
            ),
            switch(
              names(private$.allProperties[["Compound type 1"]]$value),
              "Neutral" = NULL,
              list(Type = names(private$.allProperties[["Compound type 1"]]$value), Pka = private$.allProperties[["pKa value 1"]]$value)
            ),
            switch(
              names(private$.allProperties[["Compound type 2"]]$value),
              "Neutral" = NULL,
              list(Type = names(private$.allProperties[["Compound type 2"]]$value), Pka = private$.allProperties[["pKa value 2"]]$value)
            )
          )
        ),
        Processes = purrr::compact(
          unname(
            purrr::imap(private$.allProcessProperties, \(x,name) {
              list(
                InternalName = unname(as.character(ProcessInternalNames[name])),
                DataSource = name,
                # Species will be added when generating study snapshot to match used specie in study
                Parameters = unname(x %>% purrr::map(\(y) y$toSnapshot()) %>% purrr::compact())
              )
            })
          )
        ),
        Parameters = unname(
          purrr::compact(
            purrr::map(private$.allProperties, \(x) {
              if (!x$name %in% c("Is small molecule", "Plasma protein binding partner",
                                 "Lipophilicity", "Fraction unbound", "Solubility",
                                 "Reference pH", paste("Compound type", 0:2), paste("pKa value", 0:2))) {
                x$toSnapshot()
              }
            })
          )
        ),
        CalculationMethods = c(
          paste0("Cellular partition coefficient method - ", self$PartitionCoefficientMethod),
          paste0("Cellular permeability - ", self$CellularPermeabilityMethod)
        )
      )

      # remove empty lists
      snap <- purrr::compact(snap)

      return(snap)
    },

    #' @description
    #' Get the paths of all parameters defined for the compound
    #' @param compoundName name of the compound in the simulations
    #' @return A character vector with the paths of all parameters
    getAllPropertyPaths = function(compoundName = NULL) {
      if (is.null(compoundName)) {
        compoundName <- self$Name
      }
      res <- as.vector(sapply(private$.allProperties, \(x) {glue::glue(x$path)}))
      res <- c(res, as.character(sapply(private$.allProcessProperties, \(x) {
        sapply(x, \(y) {glue::glue(y$path)})
      })))

      if ( any(c("SimpleProtocol", "AdvancedProtocol") %in% class(self$Protocol))) {
        res <- c(res, self$Protocol$getAllParameterPaths())
      }
      return(unique(unname(res)))
    },

    #' @description
    #' Print the object to the console
    #' @param ... Rest arguments.
    print = function(...) {
      cli::cli_li("Compound Properties:")
      ul <- cli::cli_ul()
      for (prop in private$.allProperties) {
        if (is.list(prop$enum) && !is.null(names(prop$enum))) {
          cli::cli_li(paste0(prop$name, ": ", names(prop$value)))
        } else {
          cli::cli_li(paste0(prop$name, ": ", prop$value, " ", prop$unit))
        }
      }
      cli::cli_end(ul)
      if ( length(private$.allProcessProperties) > 0) {
        cli::cli_li("Compound Processes:")
        ulproc <- cli::cli_ul()
        for (procIdx in seq_along(private$.allProcessProperties)) {
          cli::cli_li(names(private$.allProcessProperties)[procIdx])
          ulprop <- cli::cli_ul()
          for (prop in private$.allProcessProperties[[procIdx]]) {
            if (is.list(prop$enum) && !is.null(names(prop$enum))) {
              cli::cli_li(paste0(prop$name, ": ", names(prop$value)))
            } else {
              cli::cli_li(paste0(prop$name, ": ", prop$value, " ", prop$unit))
            }
          }
          cli::cli_end(ulprop)
        }
        cli::cli_end(ulproc)
      }
      cli::cli_li("Compound Methods:")
      ul <- cli::cli_ul()
      cli::cli_li(paste0("Partition Coefficient Method: ",  self$PartitionCoefficientMethod))
      cli::cli_li(paste0("Cellular Permeability Method: ",  self$CellularPermeabilityMethod))
      cli::cli_end(ul)
      if (length(private$.protocol) != 0) {
        cli::cli_li(paste0("Protocol Properties: "))
        ul <- cli::cli_ul()
        cli::cli_li()
        private$.protocol$print()
        cli::cli_end(ul)
      }
      invisible(self)
    }
  ),
  private = list(
    .allProperties = list(),
    .allProcessProperties = list(),
    .allPropertyPaths = c(),
    .protocol = list(),
    .pc = NULL,
    .cp = NULL,
    .initializePropertiesFromJSON = function(json) {
      generic_compound <- jsonlite::fromJSON(json, simplifyVector = T, simplifyDataFrame = FALSE)

      properties <- lapply(generic_compound$CompoundProperties, \(x) {
        Property$new(
          name = x$name,
          parName = x$parName,
          dimension = x$dimension,
          value = x$value,
          unit = x$unit,
          check = NULL,
          enum = if (!is.null(x$enum)) {
            get(x$enum)
          } else {
            NULL
          },
          min = x$min,
          max = x$max,
          rangeUnit = x$rangeUnit
        )
      })
      return(properties)
    },
    deep_clone = function(...) {.myDeepClone(...)}
  )
)
