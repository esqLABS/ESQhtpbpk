#' Save simulation results to CSV files
#'
#' @param simulationResults List of simulation results returned by `runSimulationBatches()`
#' @param resultsIdsMap
#' @param outputFolder Folder where the outputs will be written to
#'
#' @return
#' @export
#'
#' @examples
.saveResults <- function(simulationResults, resultsIdsMap, outputFolder) {
  simulationResults <- unlist(simulationResults)
  for (resultsId in names(simulationResults)) {
    compoundId <- resultsIdsMap$compoundId[resultsIdsMap$runValuesId == resultsId]
    studyId <- resultsIdsMap$studyId[resultsIdsMap$runValuesId == resultsId]
    scenario <- resultsIdsMap$scearioName[resultsIdsMap$runValuesId == resultsId]

    outputPath <- file.path(
      outputFolder, .clearPath(compoundId), .clearPath(studyId),
      paste0(.clearPath(compoundId), "_", .clearPath(studyId), "_", scenario, ".csv")
    )
    tryCatch(
      {
        # Create a new folder if it does not exist
        if (!dir.exists(paths = dirname(outputPath))) {
          dir.create(path = dirname(outputPath), recursive = TRUE)
        }
        results <- simulationResults[[resultsId]]
        if (!is.null(results)) {
          ospsuite::exportResultsToCSV(results = results, filePath = outputPath)
        }
      },
      error = function(cond) {
        warning(paste0("Cannot save to path '", dirname(outputPath), "'"))
        message("Original error message:")
        warning(cond)
      },
      warning = function(cond) {
        warning(cond)
      }
    )
  }
}

#' Title
#'
#' @param frameworkSimulationResults A named list of simulation results as produced
#' by the `.extractSimulationBatchResults()` function.
#' @param projectConfiguration A `ProjectConfiguration` object.
#' @param inVivoData Data frame with in vivo PK data.
#' @param inVivoDataImputed Data frame with in vivo PK data where LLOQ values
#' have been imputed.
#' @param importerConfiguration Importer configuration that will be used to load
#' observed data.
#' @param plotCombinedTimeProfile Boolean. Should time profile plots for all
#' simulated methods in one plot be created? Default is `FALSE`.
#' @param plotMethodsTimeProfile Boolean. Should time profile plots for each separate
#' simulated method be created? Default is `FALSE`.
#' @param outputFolder If `NULL` (default), path defined in `projectConfiguration` will be used
#' to write results outputs.
#' @param plotFigures If `TRUE`, a plot will be created for each simulated study,
#' showing obsered data and results of all simulations of the particular study. Default is `FALSE`.
#'
#' @return A tibble with metrics calculated for the provided simulation results.
.analyzeResults <- function(simulationBatchResults,
                            studies,
                            resultsIdsMap,
                            projectConfiguration,
                            outputFolder = NULL,
                            plotFigures = FALSE) {
  if (plotFigures) {
    # Create plot configurations to be used for figure creation
    plotConfiguration <- createEsqlabsPlotConfiguration()
    plotConfiguration$xUnit <- ospUnits$Time$h
    plotConfiguration$subtitle <- "Time profile"
    # Plot configuration for predicted-vs-observed plots
    pvoPlotConfiguration <- createEsqlabsPlotConfiguration()
    pvoPlotConfiguration$legendPosition <- "none"
    exportConfiguration <- createEsqlabsExportConfiguration(projectConfiguration)
  }

  outputFolder <- outputFolder %||% projectConfiguration$outputFolder

  # Metrics DF for all simulated compounds/studies
  # Names are results IDs
  globalMetricsData <- data.frame()

  simulationBatchResults <- unlist(simulationBatchResults)
  # Analyse each study
  for (resultsId in names(simulationBatchResults)) {
    study <- studies[[resultsIdsMap$studyId[resultsIdsMap$runValuesId == resultsId]]]

    studyId <- study$ID
    compoundId <- study$Compound$ID
    # get the results for this study
    simResults <- simulationBatchResults[[resultsId]]
    scenarioName <- resultsIdsMap$scearioName[resultsIdsMap$runValuesId == resultsId]

    # 1. Calculate PK-Params
    # 2. Calculate metrics if in vivo data available
    # 3. Plot time profiles (incl. in vivo data if available)

    # 1. Calculate PK-Params
    pkAnalyses <- calculatePKAnalyses(simResults)
    outputPath <- file.path(
      outputFolder, .clearPath(compoundId),
      .clearPath(studyId),
      paste0(.clearPath(compoundId), "_", .clearPath(studyId), "_", scenarioName, "_PKAnalyses", ".csv")
    )
    exportPKAnalysesToCSV(pkAnalyses, outputPath)

    # 2. Calculate metrics if in vivo data available
    # 2DO currently only for plasma concentrations
    outputPath <- "Organism|VenousBlood|Plasma|Compound|Concentration in container"
    metrics <- .calculateMetrics(
      results = simResults,
      methodName = scenarioName,
      dataSets = study$getDataSets(),
      outputPath = outputPath
    )

    # Append metrics to the global data frame
    globalMetricsData <- bind_rows(globalMetricsData, data.frame(
      compoundId = compoundId,
      studyId = studyId,
      scenarioName = scenarioName,
      data.frame(metrics$metrics)
    ))

    # 3. Plot time profiles (incl. in vivo data if available)
    # plotConfiguration$legendPosition <- tlf::LegendPositions$none
    if (plotFigures) {
      plotConfiguration$yAxisScale <- tlf::Scaling$log
      plotGridConfiguration <- createEsqlabsPlotGridConfiguration()
      plotGridConfiguration$title <- paste(compoundId, studyId, scenarioName, sep = "_")
      # Log scale plots
      # Add time profile first.
      individualTimeProfilePlot <- plotIndividualTimeProfile(
        metrics$dataCombined,
        defaultPlotConfiguration = plotConfiguration
      )
      plotGridConfiguration$addPlots(
        plotIndividualTimeProfile(metrics$dataCombined, defaultPlotConfiguration = plotConfiguration)
      )
      # Add pred vs observed and other GOF plots if data available
      if (length(study$getDataSets()) > 0) {
        obsVsSimulated <- plotObservedVsSimulated(
          metrics$dataCombined,
          defaultPlotConfiguration = pvoPlotConfiguration
        )
        plotGridConfiguration$addPlots(
          obsVsSimulated
        )
        # Lin scale lots
        plotConfiguration$yAxisScale <- tlf::Scaling$lin
        indTimeProfileLin <- plotIndividualTimeProfile(
          metrics$dataCombined,
          defaultPlotConfiguration = plotConfiguration
        )
        resVsTime <- plotResidualsVsTime(
          metrics$dataCombined,
          defaultPlotConfiguration = plotConfiguration
        )
        plotGridConfiguration$addPlots(list(
          indTimeProfileLin,
          resVsTime
        ))
      }

      exportConfiguration$path <- file.path(outputFolder, .clearPath(compoundId), .clearPath(studyId))

      exportConfiguration$name <- paste(.clearPath(compoundId), .clearPath(studyId), scenarioName, sep = "_")
      exportConfiguration$savePlot(plotGrid(plotGridConfiguration))
    }
  }

  # Appending to the possibly existing file.
  fileName <- file.path(outputFolder, "Prediction_metrics.csv")
  # If the file exists, append to it. Separate code because otherwise column names are not stored.
  if (file.exists(fileName)) {
    readr::write_csv(globalMetricsData, fileName, append = TRUE)
  } else {
    readr::write_csv(globalMetricsData, fileName)
  }
}


.clearPath <- function(string) {
  # Replace "\" and "/" by "_" so the file name does not result in folders
  string <- gsub(pattern = "\\", "_", string, fixed = TRUE)
  string <- gsub(pattern = "/", "_", string, fixed = TRUE)

  return(string)
}
