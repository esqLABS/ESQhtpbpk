#' Calculate metrics for single simulation
#'
#' @param results `SimulationResults` object
#' @param methodName String. Method used for calculation of the results.
#' @param dataSets Observed data as `DataSet` objects
#' @param outputPath Output path which is matched to the observed data.
#' Used for naming of the simulated results in the plot.
#' @return Structure with different metrics calculated for the simulation-observed data comparison.
.calculateMetrics <- function(results, methodName, dataSets, outputPath) {
  # Create a DataCombined holding simulation results and median (imputed) observed
  # data for residuals calculation
  dataCombined <- DataCombined$new()
  dataCombined$addSimulationResults(results, quantitiesOrPaths = outputPath, groups = methodName)
  # Add observed data
  dataCombined$addDataSets(dataSets, groups = methodName)

  # Calculate lin and log residuals
  residualsLogDf <- calculateResiduals(
    dataCombined = dataCombined,
    xUnit = ospUnits$Time$min,
    yUnit = ospUnits$`Concentration [molar]`$`µmol/l`,
    scaling = "log"
  )

  residualsLinDf <- calculateResiduals(
    dataCombined = dataCombined,
    xUnit = ospUnits$Time$min,
    yUnit = ospUnits$`Concentration [molar]`$`µmol/l`,
    scaling = "lin"
  )

  cMaxObs <- max(residualsLinDf$yValuesObserved)
  cMaxSim <- max(ospsuite::getOutputValues(simulationResults = results,
                                           quantitiesOrPaths = outputPath,
                                           addMetaData = FALSE)$data[[outputPath]])
  # Get first observed/simulated values (C_first)
  obsFirstTime <- residualsLogDf$xValues[[1]]
  obsFirstConc <- residualsLogDf$yValuesObserved[[1]]
  simFirstConc <- residualsLogDf$yValuesSimulated[[1]]
  # Get last obsreved/simulated values (C_last)
  obsLastTime <- residualsLogDf$xValues[[length(residualsLogDf$xValues)]]
  obsLastConc <- residualsLogDf$yValuesObserved[[length(residualsLogDf$xValues)]]
  simLastConc <- residualsLogDf$yValuesSimulated[[length(residualsLogDf$xValues)]]

  # Calculate AUC_tLast)
  obsAUC <- pracma::trapz(residualsLogDf$xValues, residualsLogDf$yValuesObserved)
  simAUC <- pracma::trapz(residualsLogDf$xValues, residualsLogDf$yValuesSimulated)

  # Calculate fold point wise difference
  folds <- ospsuite.utils::foldSafe(pmax(residualsLogDf$yValuesObserved, residualsLogDf$yValuesSimulated), pmin(residualsLogDf$yValuesObserved, residualsLogDf$yValuesSimulated))

  output <- list(
    obsFirstTime = obsFirstTime,
    obsFirstConc = obsFirstConc,
    simFirstConc = simFirstConc,
    obsLastTime = obsLastTime,
    obsLastConc = obsLastConc,
    simLastConc = simLastConc,
    foldC_first = simFirstConc / obsFirstConc,
    foldC_last = simLastConc / obsLastConc,
    obsCmax = cMaxObs,
    simCmax = cMaxSim,
    cMaxFold = cMaxSim / cMaxObs,
    residualsLog = paste(residualsLogDf$residualValues, collapse = ";"),
    residualsLogMean = mean(residualsLogDf$residualValues),
    residualsLogMedian = median(residualsLogDf$residualValues),
    residualsLin = paste(residualsLinDf$residualValues, collapse = ";"),
    gmfe = exp(mean(abs(residualsLogDf$residualValues))),
    rmse = sqrt(mean(residualsLinDf$residualValues^2)),
    rMedianSE = sqrt(median(residualsLogDf$residualValues^2)),
    folds = paste(folds, collapse = ";"),
    foldMean = mean(folds),
    foldMedian = median(folds),
    shareFold1_5 = sum(folds < 1.5) / length(folds) * 100,
    shareFold2 = sum(folds < 2) / length(folds) * 100,
    shareFold3 = sum(folds < 3) / length(folds) * 100,
    shareFold5 = sum(folds < 5) / length(folds) * 100,
    shareFold10 = sum(folds < 10) / length(folds) * 100,
    observedAUC = obsAUC,
    simulatedAUC = simAUC,
    AUCfold = simAUC / obsAUC
  )
  return(list(metrics = output, dataCombined = dataCombined))
}
