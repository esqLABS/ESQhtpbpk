#' Run prediction simulations
#'
#' @param studies list of study defined as Study objects
#' @param outputFolder folder where the results will be saved (a subfolder called
#' DateTime with DateTime being the run date and time will be created).
#' @param saveResults Boolean. If `TRUE`, the simulations results will be saved as csv in a subfolder.
#' @param saveSimulation Boolean. If `TRUE`, the fully parameterized simulation is
#' stored as .pkml. Time consuming, mainly for debugging. Default is `FALSE`.
#' @param plotFigures Boolean If `TRUE`, a plot will be created for each simulated study,
#' showing all simulations results of the particular study. If observed data are available they
#' will be shown on top. Default is `FALSE`.
#' @param numberOfCores number of cores to use to run the simulations batches
#' @param queueSize number of runs to queue before processing them
#' @param outputSelections list of output selections to be used for all simulations
#' (default is all compounds plasma concentration in the PeripheralVenousBlood compartement)
#' @param simulationResolution vector of start time (min), end time (min) and resolution (pts/min) for all simulations
#' @export
runPredictions <- function(
    studies,
    outputFolder,
    saveResults = TRUE,
    saveSimulation = FALSE,
    plotFigures = FALSE,
    numberOfCores = ospsuite::getOSPSuiteSetting("numberOfCores"),
    queueSize = 1000,
    outputSelections = c("Organism|PeripheralVenousBlood|**|Plasma*(Peripheral Venous Blood)"),
    simulationResolution = c(0, 10 * 24 * 60, 1 / 3)) {
  # validate inputs
  if (!is.list(studies) || length(studies) == 0 || any(sapply(studies, \(x) !("Study" %in% class(x))))) {
    cli::cli_abort("The {.arg studies} argument must be a non-empty list of Study objects.")
  }
  # check unicity of studyIDs
  if (any(duplicated(sapply(studies, \(x) x$ID)))) {
    cli::cli_abort("The {.arg studies} argument must contain unique study IDs.")
  }

  ospsuite.utils::validateIsCharacter(outputFolder)
  ospsuite.utils::validateIsLogical(saveResults)
  ospsuite.utils::validateIsLogical(saveSimulation)
  ospsuite.utils::validateIsLogical(plotFigures)
  ospsuite.utils::validateIsInteger(numberOfCores)
  ospsuite.utils::validateIsInteger(queueSize)
  ospsuite.utils::validateIsCharacter(outputSelections)
  if (!is.numeric(simulationResolution) || length(simulationResolution) != 3) {
    cli::cli_abort(
      paste(
        "The {.arg simulationResolution} argument must be a numeric vector of simulation ",
        "start time (in min), end time (in min) and resolution in (pts/min)."
      )
    )
  }
  if (any(simulationResolution < 0) || simulationResolution[2] <= simulationResolution[1]) {
    cli::cli_abort(
      paste(
        "The {.arg simulationResolution} is not valid."
      )
    )
  }

  # Make the output folder unique using the current date and time
  outputFolder <- file.path(outputFolder, format(Sys.time(), "%Y-%m-%d_%H-%M-%S"))
  simResultsFolder <- file.path(outputFolder, "SimulationResults")

  # prepare and load model for all studies
  studies <- .prepareStudies(studies, outputFolder, outputSelections, simulationResolution)

  # initialise simulation batches
  simulationsBatches <- .initSimBatches(studies)

  # To avoid running out of memory, a threshold for the maximal queued jobs is set.
  results <- .processStudies(
    studies = studies,
    simulationsBatches = simulationsBatches,
    queueSize = queueSize,
    saveSimulation = saveSimulation,
    saveResults = saveResults,
    simResultsFolder = simResultsFolder,
    plotFigures = plotFigures,
    numberOfCores = numberOfCores
  )

  return(results)
}

.updateValueFromProperty <- function(property, parameterStartValues, ...) {
  # additional argument for glue
  additionalArgs <- list(...)
  if (length(additionalArgs) > 0) {
    for (i in seq_along(additionalArgs)) {
      assign(names(additionalArgs[i]), additionalArgs[[i]])
    }
  }

  # If the property is NULL, it was not defined for the compound and must be
  # skipped
  if (is.null(property)) {
    return(parameterStartValues)
  }

  path <- glue::glue(property$path)
  if (!path %in% names(parameterStartValues)) {
    stop(messages$parameterPathNotDefined(path))
  }
  parameterStartValues[[path]] <- unname(unlist(property$toBaseUnit()))
  return(parameterStartValues)
}

#' Get parameter start values for the given scenario
#'
#' @param parametersPaths Paths of variable parameters to update in the simulation batch
#' @param study A `Study` object
#' @param simulation A `Simulation` object used for retrieving missing values
#'
#' @return `parameterStartValues` updated with values defined in the `Study` object
.getParameterStartValues <- function(parametersPaths, study, simulation) {
  parameterStartValues <- vector(mode = "list", length = length(parametersPaths))
  names(parameterStartValues) <- parametersPaths

  # Apply all compound parametrization
  for (compound in study$Compounds) {
    for (property in compound$getAllProperty()) {
      parameterStartValues <- .updateValueFromProperty(property, parameterStartValues, compoundName = compound$Name)
    }
    # get all compound process parameters
    for (processName in names(compound$getAllProcessProperty())) {
      for (property in compound$getAllProcessProperty(processName)) {
        parameterStartValues <- .updateValueFromProperty(property, parameterStartValues, compoundName = compound$Name)
      }
    }
    # get all application parameters
    parameterStartValues <- .updateValueFromAdmin(
      compound = compound,
      parameterStartValues = parameterStartValues,
      simulation = simulation
    )
  }

  # Set the values into the simulation and get missing values
  parameterStartValues <- .getDefaultParameters(simulation, parameterStartValues = parameterStartValues)

  return(parameterStartValues)
}

.updateValueFromAdmin <- function(compound, parameterStartValues, simulation) {
  allAdmins <- compound$Protocol$extractProtocol()
  for (adminIdx in seq_len(nrow(allAdmins))) {
    protocolName <- compound$Protocol$Name
    prot <- allAdmins[adminIdx, ]$parameters[[1]]
    pathPrefix <- glue::glue(allAdmins[adminIdx, ]$path[[1]])

    if (ospsuite::getDimensionForUnit(prot$DoseUnit) == ospsuite::ospDimensions$Mass) {
      doseParamName <- "Dose"
    } else if (ospsuite::getDimensionForUnit(prot$DoseUnit) == ospsuite::ospDimensions$`Dose per body weight`) {
      doseParamName <- "DosePerBodyWeight"
    } else if (ospsuite::getDimensionForUnit(prot$DoseUnit) == ospsuite::ospDimensions$`Dose per body surface area`) {
      doseParamName <- "DosePerBodySurfaceArea"
    }
    doseQuantity <- ospsuite::getQuantity(
      path = paste(pathPrefix, "ProtocolSchemaItem", doseParamName, sep = "|"),
      container = simulation
    )
    parameterStartValues[[doseQuantity$path]] <- ospsuite::toBaseUnit(
      quantityOrDimension = doseQuantity,
      values = prot$Dose,
      unit = prot$DoseUnit
    )

    parPath <- paste(pathPrefix, "ProtocolSchemaItem", "Start time", sep = "|")
    parameterStartValues[[parPath]] <- allAdmins[adminIdx, ]$time

    if (!is.null(prot$InfusionTime)) {
      parPath <- paste(pathPrefix, "ProtocolSchemaItem", "Infusion time", sep = "|")
      parameterStartValues[[parPath]] <- ospsuite::toBaseUnit(
        quantityOrDimension = "Time",
        values = prot$InfusionTime,
        unit = prot$InfusionTimeUnit
      )
    }

    if (!is.null(prot$WaterVolPerBW)) {
      parPath <- paste(pathPrefix, "ProtocolSchemaItem", "Volume of water/body weight", sep = "|")
      parameterStartValues[[parPath]] <- ospsuite::toBaseUnit(
        quantityOrDimension = "Volume per body weight",
        values = prot$WaterVolPerBW,
        unit = prot$WaterVolPerBWUnit
      )
    }

    if (!is.null(prot$Formulation)) {
      for (formulationParameter in prot$Formulation$Parameters) {
        parameterStartValues <- .updateValueFromProperty(
          formulationParameter,
          parameterStartValues,
          formulationName = prot$Formulation$Name,
          protocolPrefix = paste0("Events|", protocolName)
        )
      }
    }
  }

  return(parameterStartValues)
}

#' Get original values of the parameters from simulation used in batches
#'
#' @param simulation A Simulation object, to get the parameters from.
#' @param parameterStartValues List of parameter start values, with names being parameter paths
#'
#' @return a list of the default parameter values for each simulationBatch (in internal units)
.getDefaultParameters <- function(simulation, parameterStartValues) {
  # First apply updated parameter values
  # Entries with NULL values should be ignored
  nullIdx <- which(sapply(parameterStartValues, is.null), useNames = FALSE)

  if (length(nullIdx) == 0) {
    paramPaths <- names(parameterStartValues)
    paramValues <- unlist(parameterStartValues)
  } else {
    paramPaths <- names(parameterStartValues)[-nullIdx]
    paramValues <- unlist(parameterStartValues[-nullIdx])
  }

  if (length(paramPaths) > 0) {
    ospsuite::setParameterValuesByPath(
      parameterPaths = paramPaths,
      values = paramValues,
      simulation = simulation
    )
  }

  # Get values from the simulation object
  defaultVal <- ospsuite::getQuantityValuesByPath(names(parameterStartValues), simulation)
  names(defaultVal) <- names(parameterStartValues)

  return(defaultVal)
}

#' Add simulation batch run to simulation batches
#'
#' @param parameterStartValues Named list with parameter values to add for the run
#' @param simulationBatch Instance of `SimulationBatch`
#' @param simulationName Name of the simulation. Only used when `saveSimulation` is ` TRUE`. Used for
#' saving the simulation instance to .pkml. If `NULL`, the file name is composed from the ID of
#' the simulation batch and the ID of the run.
#' @param outputFolder Folder where the simulation .pkml will be stored if `saveSimulation` is `TRUE`
#' @param saveSimulation Boolean. If `TRUE`, the fully parameterized simulation is
#' stored as .pkml. Time consuming, mainly for debugging. Default is `FALSE`.
#'
#' @return Id of the simulation batch run
.addBatchRun <- function(parameterStartValues,
                         simulationBatch,
                         simulationName = NULL,
                         outputFolder,
                         saveSimulation = FALSE) {
  # run values id should be a combination of batch id with the run values id
  runValuesId <- simulationBatch$addRunValues(parameterValues = unlist(parameterStartValues, use.names = FALSE))
  runValuesId <- paste(simulationBatch$id, runValuesId, sep = ".")

  # Save the updated simulation as PKML.
  # Time consuming, but useful for debugging purposes
  if (saveSimulation) {
    if (is.null(simulationName)) {
      simulationName <- paste0(simulationBatch$id, "_", runValuesId)
    }
    simulationName <- gsub("/", "per", simulationName) %||% runValuesId
    outputPath <- file.path(outputFolder, paste0(simulationName, ".pkml"))
    tryCatch(
      {
        # Create a new folder if it does not exist
        if (!dir.exists(paths = outputFolder)) {
          dir.create(path = outputFolder, recursive = TRUE)
        }
        ospsuite::saveSimulation(simulation = simulationBatch$simulation, filePath = outputPath)
      },
      error = function(cond) {
        warning(paste0("Cannot save to path '", outputFolder, "'"))
        message("Original error message:")
        message(cond)
      },
      warning = function(cond) {
        warning(cond)
      }
    )
  }

  return(runValuesId)
}

#' Process queued runs
#'
#' @param simulationBatches Instance of `SimulationBatch`
#' @param resultsIdsMap Mapping between run id and study ids
#' @param outputFolder Folder where the simulation results will be stored if `saveResults` is `TRUE`
#' @param plotFigures Boolean If `TRUE`, a plot will be created for each simulated study,
#' showing all simulations results of the particular study. If observed data are available they
#' will be shown on top. Default is `FALSE`.
#' @param numberOfCores number of cores to use to run the simulations batches
#' @param saveResults Boolean. If `TRUE`, the simulations results will be saved as csv in a subfolder.
#' @return List of the simulation results, with names being the study IDs
.processBatchRun <- function(
    simulationsBatches,
    resultsIdsMap,
    outputFolder,
    plotFigures,
    numberOfCores,
    saveResults = TRUE) {
  cli::cli_text("Running queued jobs.")
  cli::cli_text("Started at {Sys.time()}")

  # run all simulations batches
  simulationBatchResults <- ospsuite::runSimulationBatches(
    simulationBatches = simulationsBatches,
    simulationRunOptions = ospsuite::SimulationRunOptions$new(numberOfCores = numberOfCores)
  )

  # Save simulated results
  simulationResults <- unlist(simulationBatchResults)
  names(simulationResults) <- resultsIdsMap$studyId[match(names(simulationResults), resultsIdsMap$runValuesId)]

  if (saveResults) {
    .saveResults(
      simulationResults = simulationResults,
      outputFolder = outputFolder
    )
  }
  cli::cli_text("Done {Sys.time()}")

  return(simulationResults)
}

#' Initialise progress bar for current queuing of studies
#'
#' @param remainingStudies Number of studies remaining to be queued
#' @param queueSize Number of study to be added in the queue
#' @return id of the progress bar
.showQueueProgress <- function(remainingStudies, queueSize) {
  id <- cli::cli_progress_bar(
    .envir = parent.frame(n = 2),
    name = "Queueing studies:",
    total = min(remainingStudies, queueSize),
    format = "{cli::pb_name} {cli::pb_bar} {cli::pb_percent} ({study$ID})"
  )

  return(id)
}

#' Process all studies in a queued manner
#' @param studies List of prepared studies to be processed
#' @param simulationBatches Instance of `SimulationBatch`
#' @param queueSize Max number of studies to queue before processing them
#' @param saveSimulation Boolean. If `TRUE`, the fully parameterized simulation is
#' stored as .pkml.
#' @param saveResults Boolean. If `TRUE`, the simulations results will be saved as csv in a subfolder.
#' @param simResultsFolder Folder where the simulation results will be stored if `saveResults` is `TRUE`
#' @param plotFigures Boolean If `TRUE`, a plot will be created for each simulated study,
#' showing all simulations results of the particular study. If observed data are available they
#' will be shown on top. Default is `FALSE`.
#' @param numberOfCores number of cores to use to run the simulations batches
#' @return List of the simulation results, with names being the study IDs
.processStudies <- function(
    studies,
    simulationsBatches,
    queueSize,
    saveSimulation,
    saveResults,
    simResultsFolder,
    plotFigures,
    numberOfCores) {
  # initialised needed objects
  queuedRuns <- 0
  remainingStudies <- length(studies)
  results <- list()

  # Each combination of a scenario and simulated study gets an ID
  resultsIdsMap <- data.frame(
    runValuesId = vector(mode = "character", length = 0L),
    studyId = vector(mode = "character", length = 0L)
  )

  # get id of progress bar
  pbId <- .showQueueProgress(remainingStudies = remainingStudies, queueSize)

  # Add runs to SimulationBatch for every study
  for (studyIdx in seq_along(studies)) {
    study <- studies[[studyIdx]]

    cli::cli_progress_update(id = pbId)

    # Get the simulation batch for the current generic model
    simulationBatch <- simulationsBatches[[study$getSimulation()$sourceFile]]

    parameterStartValues <- .getParameterStartValues(
      parametersPaths = simulationBatch$getVariableParameters(),
      study = study,
      simulation = simulationBatch$simulation
    )

    runValuesId <- .addBatchRun(
      parameterStartValues = parameterStartValues,
      simulationBatch = simulationBatch,
      outputFolder = file.path(simResultsFolder, study$ID),
      saveSimulation = saveSimulation,
      simulationName = study$ID
    )

    # reset updated parameters (where set just to get formula values if any)
    lapply(
      ospsuite::getAllQuantitiesMatching(
        paths = simulationBatch$getVariableParameters(),
        container = simulationBatch$simulation
      ),
      \(x) x$reset()
    )

    resultsIdsMap <- rbind(
      resultsIdsMap,
      data.frame(
        runValuesId,
        studyId = study$ID
      )
    )
    queuedRuns <- queuedRuns + 1

    # If the number of queued runs has exceeds the specified queue limit
    # or all study have been queued; simulate and process
    if (queuedRuns >= queueSize || studyIdx == length(studies)) {
      results <- c(
        results,
        .processBatchRun(
          simulationsBatches = simulationsBatches,
          resultsIdsMap = resultsIdsMap,
          outputFolder = simResultsFolder,
          saveResults = saveResults,
          plotFigures = plotFigures,
          numberOfCores = numberOfCores
        )
      )
      # reset queuedRund and progress bar
      remainingStudies <- remainingStudies - queuedRuns
      queuedRuns <- 0
      pbId <- .showQueueProgress(remainingStudies, queueSize)
    }
  }
  cli::cli_progress_done(id = pbId)

  return(results)
}

#' Initialise of the needed simulation batches
#' @param studies List of prepared studies to be processed
#' @return List of simulation batches
.initSimBatches <- function(studies) {
  cli::cli_text("Initialising simulation batches.")
  simulations <- unique(sapply(studies, \(x) x$getSimulation()))

  # Create a simulation batch for each generic model
  simulationsBatches <- lapply(
    simulations,
    \(x) {
      sim <- x

      parametersPaths <- unique(
        unlist(
          purrr::compact(
            sapply(studies, \(study) {
              if (identical(study$getSimulation(), sim)) {
                study$getAllParameterPaths()
              } else {
                NULL
              }
            })
          )
        )
      )

      # create simulationBatch
      batch <- ospsuite::createSimulationBatch(sim, parametersOrPaths = parametersPaths)
      return(batch)
    }
  )
  names(simulationsBatches) <- sapply(simulations, \(x) x$sourceFile)

  return(simulationsBatches)
}

#' Prepare studies to be run
#' @description Prepare studies to be run. Create generic pkml if not set,
#' load and update generic simulation with output selections and simulation resolution.
#' Assign simulation object to studies and ensure output selection and required path exist
#' in simulation. Remove studies that are not correctly set up
#' @param studies list of study defined as Study objects
#' @param outputFolder folder where the results will be saved.
#' @param outputSelections list of output selections to be used for all simulations
#' (default is all compounds plasma concentration in the PeripheralVenousBlood compartement)
#' @param simulationResolution vector of start time (min), end time (min) and resolution (pts/min) for all simulations
#' @return List of prepared simulations
.prepareStudies <- function(
    studies,
    outputFolder,
    outputSelections,
    simulationResolution) {
  # create generic pkml if not already set up
  pkmlsList <- sapply(studies, \(x) x$getGenericModel(silent = TRUE))
  if (any(sapply(pkmlsList, is.null))) {
    cli::cli_inform(
      paste(
        "Generic Model not set for some studies.",
        "Generic pkml will be automatically created for those studies."
      )
    )
    createGenericPKMLs(
      studyList = studies[which(sapply(pkmlsList, \(x) is.null(x)))],
      outputFolder =  file.path(outputFolder, "GenericModels"),
      overwrite = FALSE
    )
  }
  pkmlsList <- sapply(studies, \(x) x$getGenericModel())

  # flag wrongly set up studies
  toSkip <- c()

  # Load all simulation once and associate with the study
  for (pkml in unique(pkmlsList)) {
    sim <- ospsuite::loadSimulation(pkml)
    idx <- which(pkmlsList == pkml)

    outputSelectionsNew <- sapply(ospsuite::getAllQuantitiesMatching(paths = outputSelections, sim), \(x) x$path)
    if (length(outputSelectionsNew) > 0) {
      ospsuite::setOutputs(simulation = sim, quantitiesOrPaths = outputSelectionsNew)
      ospsuite::setOutputInterval(
        simulation = sim,
        startTime = simulationResolution[1],
        resolution = simulationResolution[3],
        endTime = simulationResolution[2]
      )

      # associate sim to studies
      for (i in idx) {
        studies[[i]]$setSimulation(sim)

        # check that all defined paths are included in the used simulation
        paths <- tryCatch(studies[[i]]$getAllParameterPaths(), error = function(e) {
          return(NULL)
        })

        if (is.null(paths)) {
          cli::cli_warn(
            paste(
              "Study {.var {studies[[i]]$ID}} is not configured correctly.",
              "Some paths could not be found in the associated study. Skipping the study."
            )
          )

          # flag studies as to be skip
          toSkip <- c(toSkip, i)
        }
      }
    } else {
      cli::cli_warn("None of the selected outputs were found in the the simulation.")
      cli::cli_text("Skipping pkml file {.var {pkml}}.")

      # flag studies as to be skip
      toSkip <- c(toSkip, idx)
    }
  }

  studies <- .removeStudies(studies, toSkip)

  return(studies)
}

.removeStudies <- function(studies, toSkip) {
  if (length(toSkip) > 0) {
    studies[toSkip] <- NULL
  }

  studies <- purrr::compact(studies)
  if (length(studies) == 0) {
    cli::cli_abort("No studies to simulate.")
  }
  return(studies)
}
