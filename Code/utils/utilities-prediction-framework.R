# required packages
require(dplyr)

#' Run prediction simulations
#'
#' @param jsons page of the json stream (i.e. list of json)
#' @param simulationBatches list of simulation batches objects, must be initialized beforehand.
#' @param outputFolder folder where the results will be saved.
#' @param saveSimulation Boolean. If `TRUE`, the fully parameterized simulation is
#' stored as .pkml. Time consuming, mainly for debugging. Default is `FALSE`.
#' @param plotFigures If `TRUE`, a plot will be created for each simulated study,
#' showing obsered data and results of all simulations of the particular study. Default is `FALSE`.
#' @param numberOfCores number of cores to use to run the simulations batches
#' @return
runPredictions <- function(studies, scenarios, outputFolder, saveSimulation = FALSE, plotFigures = FALSE, numberOfCores = getOSPSuiteSetting("numberOfCores")) {
  # Make the output folder using the current date and time
  outputFolder <- file.path(outputFolder, "SimulationResults", format(Sys.time(), "%Y-%m-%d_%H-%M-%S"))

  # Extract all parameter paths used in the studies
  parametersPaths <- c()
  for (study in studies) {
    parametersPaths <- union(parametersPaths, study$getAllParameterPaths())
  }

  # Create a simulation batch for each scenarios
  simulationsBatches <- lapply(
    scenarios,
    \(x){
      sim <- x$simulation
      # create simulationBatch
      batch <- ospsuite::createSimulationBatch(sim, parametersOrPaths = parametersPaths)
      return(batch)
    }
  )

  # Each combination of a scenario and simulated study gets an ID
  resultsIdsMap <- data.frame(
    runValuesId = vector(mode = "character", length = 0L),
    studyId = vector(mode = "character", length = 0L),
    compoundId = vector(mode = "character", length = 0L),
    scearioName = vector(mode = "character", length = 0L)
  )

  # To avoid running out of memory, a threshold for the maximal number of parallel
  # runs is set.
  queuedRuns <- 0
  # Add runs to SimulationBatch for every study
  for (study in studies) {
    # For each study, simulate every scenario. A scenario can represent e.g.
    # different combination of PC and CP calculation methods
    for (scenario in scenarios) {
      # Update the default parameter values with values defined in the scenario
      parameterStartValues <- .getParameterStartValues(
        parametersPaths = parametersPaths,
        study = study,
        simulation = scenario$simulation
      )

      # Get the simulation batch for the current scenario
      simulationBatch <- simulationsBatches[[scenario$scenarioConfiguration$scenarioName]]
      simName <- file.path(
        paste0(.clearPath(study$Compound$ID), "_", .clearPath(study$ID), "_", scenario$scenarioConfiguration$scenarioName)
      )

      runValuesId <- .addBatchRun(
        parameterStartValues = parameterStartValues,
        simulationBatch = simulationBatch,
        outputFolder = file.path(outputFolder, study$Compound$ID, study$ID),
        saveSimulation = saveSimulation,
        simulationName = simName
      )
      resultsIdsMap <- rbind(
        resultsIdsMap,
        data.frame(
          runValuesId,
          studyId = study$ID,
          compoundId = study$Compound$ID,
          scearioName = scenario$scenarioConfiguration$scenarioName
        )
      )
      queuedRuns <- queuedRuns + 1

      # If the number of queued runs has exceeds the specified core limit,
      # simulate and process
      if (queuedRuns >= numberOfCores) {
        .processBatchRun(simulationsBatches, resultsIdsMap, studies, projectConfiguration, outputFolder, plotFigures, numberOfCores)
        queuedRuns <- 0
      }
    }
  }
  # Simulate and process the remaing runs that are left because queuedRuns != numberOfCores
  .processBatchRun(simulationsBatches, resultsIdsMap, studies, projectConfiguration, outputFolder, plotFigures, numberOfCores)
}

#' Get parameter start values for the given scenario
#'
#' @param parametersPaths Paths of variable parameters
#' @param compoundInVitroData A `Study` object
#' @param simulation A `Simulation` object used for retrieving missing values
#'
#' @return `parameterStartValues` updated with values defined in the `Study` object
.getParameterStartValues <- function(parametersPaths, study, simulation) {
  .updateValueFromProperty <- function(compoundProperty, parameterStartValues) {
    # If the property is NULL, it was not defined for the compound and must be
    # skipped
    if (is.null(compoundProperty)) {
      return(parameterStartValues)
    }

    path <- compoundProperty$path
    if (!path %in% names(parameterStartValues)) {
      stop(messages$parameterPathNotDefined(path))
    }
    parameterStartValues[[path]] <- compoundProperty$toBaseUnit()
    return(parameterStartValues)
  }

  parameterStartValues <- vector(mode = "list", length = length(parametersPaths))
  names(parameterStartValues) <- parametersPaths

  # Apply compound parametrization
  compound <- study$Compound
  compoundName <- compound$name

  # Non-Property parameters
  parameterStartValues[[paste0(compoundName, "|Is small molecule")]] <- compound$get_isSmallMolecule()
  parameterStartValues <- .updateValueFromProperty(compound$get_lipophilicity(), parameterStartValues)
  parameterStartValues <- .updateValueFromProperty(compound$get_fractionUnbound(), parameterStartValues)
  parameterStartValues <- .updateValueFromProperty(compound$get_ppbPartner(), parameterStartValues)
  parameterStartValues <- .updateValueFromProperty(compound$get_MW(), parameterStartValues)
  parameterStartValues <- .updateValueFromProperty(compound$get_Br(), parameterStartValues)
  parameterStartValues <- .updateValueFromProperty(compound$get_Cl(), parameterStartValues)
  parameterStartValues <- .updateValueFromProperty(compound$get_F(), parameterStartValues)
  parameterStartValues <- .updateValueFromProperty(compound$get_I(), parameterStartValues)
  parameterStartValues <- .updateValueFromProperty(compound$get_pKa0(), parameterStartValues)
  parameterStartValues <- .updateValueFromProperty(compound$get_pKa1(), parameterStartValues)
  parameterStartValues <- .updateValueFromProperty(compound$get_pKa2(), parameterStartValues)
  parameterStartValues <- .updateValueFromProperty(compound$get_compoundType0(), parameterStartValues)
  parameterStartValues <- .updateValueFromProperty(compound$get_compoundType1(), parameterStartValues)
  parameterStartValues <- .updateValueFromProperty(compound$get_compoundType2(), parameterStartValues)
  parameterStartValues <- .updateValueFromProperty(compound$get_refPh(), parameterStartValues)
  parameterStartValues <- .updateValueFromProperty(compound$get_solubility(), parameterStartValues)
  parameterStartValues <- .updateValueFromProperty(compound$get_pInt(), parameterStartValues)
  # Update all additional properties of the compound
  for (property in compound$additionalProperties()) {
    parameterStartValues <- .updateValueFromProperty(property, parameterStartValues)
  }

  # Apply administration protocol parametrization
  # 2DO this logic should be moved to AdministrationProtocol class
  startTime <- 0
  administrationProtocol <- study$administrationProtocol
  if (ospsuite::getDimensionForUnit(administrationProtocol$DoseUnit) == ospsuite::ospDimensions$Mass) {
    doseParamName <- "Dose"
  } else if (ospsuite::getDimensionForUnit(administrationProtocol$DoseUnit) == ospsuite::ospDimensions$`Dose per body weight`) {
    doseParamName <- "DosePerBodyWeight"
  } else if (ospsuite::getDimensionForUnit(administrationProtocol$DoseUnit) == ospsuite::ospDimensions$`Dose per body surface area`) {
    doseParamName <- "DosePerBodySurfaceArea"
  }
  for (i in 1:administrationProtocol$NumberOfRepetitions) {
    # Dose
    parameterStartValues[[paste0(administrationProtocol$Path, "|", "Application_", i, "|ProtocolSchemaItem|", doseParamName)]] <- toBaseUnit(quantityOrDimension = ospsuite::getDimensionForUnit(administrationProtocol$DoseUnit), values = administrationProtocol$Dose, unit = administrationProtocol$DoseUnit)
    # Start time
    parameterStartValues[[paste0(administrationProtocol$Path, "|", "Application_", i, "|ProtocolSchemaItem|Start time")]] <- startTime
    # Update the start time
    startTime <- startTime + toBaseUnit(ospDimensions$Time, administrationProtocol$TimeBetweenRepetitions, unit = administrationProtocol$TimeUnit)
  }

  # Set the values into the simulation and get missing values
  parameterStartValues <- .getDefaultParameters(simulation, parameterStartValues = parameterStartValues)

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

  setParameterValuesByPath(
    parameterPaths = paramPaths,
    values = paramValues,
    simulation = simulation
  )

  # Get values from the simulation object
  defaultVal <- getQuantityValuesByPath(names(parameterStartValues), simulation)
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

.processBatchRun <- function(simulationsBatches, resultsIdsMap, studies, projectConfiguration, outputFolder, plotFigures, numberOfCores) {
  # run all simulations batches
  simulationBatchResults <- runSimulationBatches(simulationsBatches, simulationRunOptions = SimulationRunOptions$new(numberOfCores = numberOfCores))

  # Save simulated results
  .saveResults(
    simulationResults = simulationBatchResults,
    resultsIdsMap,
    outputFolder = outputFolder
  )

  simulationsAnalysis <- .analyzeResults(simulationBatchResults,
    studies,
    resultsIdsMap,
    projectConfiguration,
    outputFolder = outputFolder,
    plotFigures = plotFigures
  )
}
