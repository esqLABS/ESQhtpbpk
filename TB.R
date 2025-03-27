### Loading library
library(readxl)
library(ESQhtpbpk)
library(dplyr)
library(ggplot2)


# Reading TB data
TBStudies <- read_excel("TBStudyInputsForHTPBPK.xlsx", sheet = 1)
TBCompounds <- read_excel("TBStudyInputsForHTPBPK.xlsx", sheet = 2)
TBProtocol <- read_excel("TBStudyInputsForHTPBPK.xlsx", sheet = 3)
TBFormulation <- read_excel("TBStudyInputsForHTPBPK.xlsx", sheet = 4)
TBDatasets <- read_excel("TBStudyInputsForHTPBPK.xlsx", sheet = 5)


Studies <- list()
# Create TB studies for each compound
for (compoundIdx in seq_len(nrow(TBCompounds))) {
  compName <- TBCompounds$Compound[compoundIdx]
  comp <- Compound$new(ID = compName)

  comp$setPropertyValue("Chlorine count", value = TBCompounds$Cl[compoundIdx])
  comp$setPropertyValue("Bromine count", TBCompounds$Br[compoundIdx])
  comp$setPropertyValue("Fluorine count", TBCompounds$`F`[compoundIdx])
  comp$setPropertyValue("Iodine count", TBCompounds$I[compoundIdx])
  comp$setPropertyValue("Molecular weight", TBCompounds$`MW (g/mol)`[compoundIdx], unit = "g/mol")
  comp$setPropertyValue("Solubility", 10^TBCompounds$`logS - ADMETLab (mol/l)`[compoundIdx] * TBCompounds$`MW (g/mol)`[compoundIdx], unit = "g/l")
  # comp$setPropertyValue("Lipophilicity", TBCompounds$`logP - ADMETLab (mol/l)`[compoundIdx])
  comp$setPropertyValue("Lipophilicity", TBCompounds$`logD - ADMETLab (mol/l)`[compoundIdx])
  # comp$setPropertyValue("pKa value 0", TBCompounds$`pka_basic - ADMETLab`[compoundIdx])
  # comp$setPropertyValue("Compound type 0", "Basic")
  # comp$setPropertyValue("pKa value 1", TBCompounds$`pka_acidic - ADMETLab`[compoundIdx])
  # comp$setPropertyValue("Compound type 1", "Acidic")
  comp$setPropertyValue("Fraction unbound", TBCompounds$`Fu - ADMETLab`[compoundIdx], unit = "%")
  comp$addProperty(
    name = "PInt",
    parName = "Specific intestinal permeability (transcellular)",
    dimension = "Velocity",
    value = 10^TBCompounds$`logMDCK - ADMETLab (cm/s)`[compoundIdx],
    unit = "cm/s"
  )
  # comp$addProperty(
  #   name = "PInt",
  #   parName = "Specific intestinal permeability (transcellular)",
  #   dimension = "Velocity",
  #   value = 60 * 266 * (ospsuite::toBaseUnit(quantityOrDimension = "Molecular weight", TBCompounds$`MW (g/mol)`[compoundIdx] - TBCompounds$`F`[compoundIdx] * 0.000000017 - TBCompounds$Cl[compoundIdx] * 0.000000022 -  TBCompounds$Br[compoundIdx] * 0.000000062 - TBCompounds$I[compoundIdx] * 0.000000098, unit = "g/mol") * 1e9)^(-4.5)*10^TBCompounds$`logP - ADMETLab (mol/l)`[compoundIdx] * 60 * 1e-1
  # )
  # add general clearance (as hepatic clearance)
  comp$addProcessProperty(
    processType = "Liver Plasma Clearance",
    propertyName = "Plasma clearance",
    parName = "Plasma clearance",
    dimension = "Flow per weight",
    value = TBCompounds$`cl-plasma - ADMETLab (ml/min/kg)`[compoundIdx], unit = "ml/min/kg"
  )
  comp$addProcessProperty(
    processType = "Liver Plasma Clearance",
    propertyName = "Lipophilicity",
    parName = "Lipophilicity (experiment)",
    dimension = "Log Units",
    # value = TBCompounds$`logP - ADMETLab (mol/l)`[compoundIdx]
    value = TBCompounds$`logD - ADMETLab (mol/l)`[compoundIdx]
  )
  comp$addProcessProperty(
    processType = "Liver Plasma Clearance",
    propertyName = "Fraction unbound",
    parName = "Fraction unbound (experiment)",
    dimension = "Fraction",
    value = TBCompounds$`Fu - ADMETLab`[compoundIdx],
    unit = "%"
  )

  # set default gfr of 1
  comp$addProcessProperty(
    processType = "GFR",
    propertyName = "GFR",
    parName = "GFR fraction",
    dimension = "Fraction",
    value = 0,
    unit = ""
  )

  for (studyIdx in which(TBStudies$Compound == compName)) {
    studyId <- TBStudies$StudyID[studyIdx]
    studyProtocolId <- TBStudies$ProtocolID[studyIdx]
    protocolTable <- TBProtocol[TBProtocol$ProtocolID == studyProtocolId, ]

    prot <- AdvancedProtocol$new()
    for (i in seq_len(nrow(protocolTable))) {
      prot$addSchema(
        schemaName = paste0("Schema_", i),
        startTime = protocolTable$`StartTime (h)`[i],
        timeBetweenRepetitions = ifelse(is.na(protocolTable$`TimeBetweenRep (h)`[i]), 0, protocolTable$`TimeBetweenRep (h)`[i]),
        numberOfRepetitions = ifelse(is.na(protocolTable$NbRep[i]), 1, protocolTable$NbRep[i]),
        timeUnit = "h"
      )

      admin <- SimpleProtocol$new(
        route = protocolTable$Route[i],
        dose = protocolTable$Dose[i],
        doseUnit = protocolTable$DoseUnit[i],
        infusionTime = if (is.na(protocolTable$`InfusionTime (min)`[i])) {NULL} else {protocolTable$`InfusionTime (min)`[i]},
        infusionTimeUnit = "min",
        waterVolPerBW = if (is.na(protocolTable$`Water Volume/BW (ml/kg)`[i])) {NULL} else {protocolTable$`Water Volume/BW (ml/kg)`[i]},
        waterVolPerBWUnit = "ml/kg"
      )

      if (protocolTable$Route[i] == "Oral") {
        if (protocolTable$FormulationID[i] == "Solution" || is.na(protocolTable$FormulationID[i])) {
          formulation <- createDissolvedFormulation(name = "Dissolved")
        } else {
          form <- TBFormulation[TBFormulation$FormulationID == protocolTable$FormulationID[i], ]

          if (form$`FormulationType` == "Weibull") {
            formulation <- createWeibullFormulation(
              name = "Weibull",
              lagTime = form$`lagTime (min)`,
              lagTimeUnit = "min",
              dissolutionTime50 = form$`disso50 (min)`,
              dissolutionTime50Unit = "min",
              shape = form$`shape`
            )
          }
        }

        admin$setFormulation(formulation = formulation)
      }

      prot$addProtocolToSchema(admin, schemaName = paste0("Schema_", i))
    }
    comp$setProtocol(prot)

    for (PC in c("PK-Sim", "RR", "PT", "Schmitt", "Berezhkovskiy")) {
      comp$PartitionCoefficientMethod <- PC

      for (CP in c("PK-Sim", "Schmitt")) {
        comp$CellularPermeabilityMethod <- CP

        study <- Study$new(ID = paste0(studyId, "_", PC, "_", CP), compounds = list(comp), individual = "Human")

        Studies <- c(Studies, study)
      }
    }
  }
}

results <- vector("list", length = 10)

for (i in 1:10) {
  results[[i]] <- runPredictions(
    Studies[seq(i, 1230, by = 10)], outputFolder = "TB2",
    numberOfCores = 5,
    outputSelections = c("Organism|PeripheralVenousBlood|**|Plasma (Peripheral Venous Blood)"),
    simulationResolution = c(0, max(TBStudies$`EndTime (days)`) * 24 * 60, 1),
    saveResults = TRUE,
    saveSimulation = FALSE,
    queueSize = 200
  )
}

saveRDS(Studies, file = file.path("TB2", "Studies.rds"), compress = TRUE)

.loadData <- function(inVivoData, studyId, importerConfiguration) {
  data <- dplyr::filter(inVivoData, StudyID == studyId)

  # Write data into temp excel file
  filePath <- tempfile(pattern = "file", tmpdir = tempdir(), fileext = ".xlsx")
  writexl::write_xlsx(data, path = filePath, col_names = TRUE)

  # Load data sets
  dataSets <- ospsuite::loadDataSetsFromExcel(
    xlsFilePath = filePath, importerConfigurationOrPath = importerConfiguration,
    importAllSheets = TRUE
  )
  # dataSets[[1]]$name <- studyID
  return(dataSets)
}

importerConfiguration <- ospsuite::createImporterConfigurationForFile("TBStudyInputsForHTPBPK.xlsx", sheet = "ObservedData")
importerConfiguration$sheets <- "ObservedData"
importerConfiguration$timeColumn <- "Time"
importerConfiguration$isTimeUnitFromColumn <- TRUE
importerConfiguration$timeUnit <- "TimeUnit"
importerConfiguration$isMeasurementUnitFromColumn <- TRUE
importerConfiguration$measurementUnit <- "MeasurementUnit"
importerConfiguration$errorColumn <- NULL
importerConfiguration$addGroupingColumn("StudyID")
importerConfiguration$namingPattern <- "{StudyID}"

# reload previous results
outputFolder <- "TB2"
results <- vector("list", length = length(list.dirs(outputFolder, recursive = FALSE)))
for (i in seq_along(results)) {
  dir <- list.dirs(outputFolder, recursive = FALSE)[i]
  sim <- ospsuite::loadSimulation(file.path(dir, "GenericModels", "Model1.pkml"))

  files <- list.files(file.path(dir, "SimulationResults"), pattern = "*.csv")
  results[[i]] <- vector("list", length = length(files))
  names(results[[i]]) <- gsub(x = files, pattern = ".csv$", replacement = "")

  for (j in seq_along(files)) {
    file <- files[j]
    results[[i]][[j]] <- ospsuite::importResultsFromCSV(sim, filePaths = file.path(dir, "SimulationResults", file))
  }
}

results2 <- unlist(results, recursive = F)

pdf("TB2/Plots.pdf", width = 6, height = 5)
for (i in seq_along(TBStudies$StudyID)) {
  studyID <- TBStudies$StudyID[i]
  print(studyID)
  dc <- ospsuite::DataCombined$new()
  obsData <- .loadData(inVivoData = TBDatasets, studyId = studyID, importerConfiguration = importerConfiguration)
  MW <- TBCompounds$`MW (g/mol)`[TBCompounds$Compound == TBStudies$Compound[TBStudies$StudyID == studyID]]
  obsData[[1]]$molWeight <- MW

  dc$addDataSets(obsData)

  studyIds <- apply(expand.grid(studyID , c("PK-Sim", "RR", "PT", "Schmitt", "Berezhkovskiy"), c("PK-Sim", "Schmitt")), 1, paste, collapse = "_")
  # print(studyIds)
  for (studyRes in studyIds) {
    if (!is.null(results2[[studyRes]])) {
      dc$addSimulationResults(results2[[studyRes]], names = studyRes)
    }
  }

  dat <- ospsuite::convertUnits(dc)
  studyLim <- dat %>% filter(dataType == "observed") %>% select(xValues) %>% range()

  p <- ggplot(dat, aes(x = xValues, y = yValues, color = name)) + geom_line(data = dat %>% filter(dataType == "simulated"))
  p <- p + geom_point(data = dat %>% filter(dataType == "observed"))
  p <- p + theme_minimal()
  p <- p + coord_cartesian(xlim = studyLim)
  p <- p + labs(title = studyID, y = unique(dat$yUnit), x = paste0(unique(dat$xDimension), " (", unique(dat$xUnit), ")"))
  print(p)

  # print(ospsuite::plotIndividualTimeProfile(dataCombined = dc, defaultPlotConfiguration = config))
  # tmp <- readline("Press [enter] to continue")
  # if (tmp == "q") {
  #   stop()
  # }
}
dev.off()

# calculate metrics
.calculateMetrics <- function(results, dataSets, outputPath, methodName) {
  # Create a DataCombined holding simulation results and median (imputed) observed
  # data for residuals calculation
  dataCombined <- ospsuite::DataCombined$new()
  dataCombined$addDataSets(dataSets, group = methodName)
  dataCombined$addSimulationResults(results, quantitiesOrPaths = outputPath, groups = methodName)
  # Add observed data
  # dataCombined <- ospsuite::convertUnits(dataCombined)


  # Calculate lin and log residuals
  residualsLogDf <- ospsuite::calculateResiduals(
    dataCombined = dataCombined,
    xUnit = ospsuite::ospUnits$Time$min,
    yUnit = ospsuite::ospUnits$`Concentration [molar]`$`µmol/l`,
    scaling = "log"
  )

  residualsLinDf <- ospsuite::calculateResiduals(
    dataCombined = dataCombined,
    xUnit = ospsuite::ospUnits$Time$min,
    yUnit = ospsuite::ospUnits$`Concentration [molar]`$`µmol/l`,
    scaling = "lin"
  )

  cMaxObs <- max(residualsLinDf$yValuesObserved)
  cMaxSim <- max(ospsuite::getOutputValues(simulationResults = results,
                                           quantitiesOrPaths = outputPath,
                                           addMetaData = FALSE)$data[[outputPath]])

  cMaxSim_obsTime <- max(residualsLinDf$yValuesSimulated)

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

  output <- data.frame(
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
    simCmax_obsTime = cMaxSim_obsTime,
    cMaxFold = cMaxSim / cMaxObs,
    cMaxFold_obsTime = cMaxSim_obsTime / cMaxObs,
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

metric_results <- c()
for (i in seq_along(TBStudies$StudyID)) {
  studyID <- TBStudies$StudyID[i]
  print(studyID)
  obsData <- .loadData(inVivoData = TBDatasets, studyId = studyID, importerConfiguration = importerConfiguration)
  MW <- TBCompounds$`MW (g/mol)`[TBCompounds$Compound == TBStudies$Compound[TBStudies$StudyID == studyID]]
  obsData[[1]]$molWeight <- MW

  groupMethod <- apply(expand.grid(c("PK-Sim", "RR", "PT", "Schmitt", "Berezhkovskiy"), c("PK-Sim", "Schmitt")), 1, paste, collapse = "_")
  studyIds <- apply(expand.grid(studyID , groupMethod), 1, paste, collapse = "_")
  # print(studyIds)
  for (j in seq_along(studyIds)) {
    studyRes <- studyIds[j]
    if (!is.null(results2[[studyRes]])) {
      # modif MW for conversion if needed
      ospsuite::setParameterValuesByPath(parameterPaths = "Compound1|Molecular weight", values = MW, units = "g/mol", simulation = results2[[studyRes]]$simulation)
      dc <- ospsuite::DataCombined$new()
      dc$addDataSets(obsData, groups = groupMethod[j] )
      dc$addSimulationResults(results2[[studyRes]], groups = groupMethod[j])
      metres <- .calculateMetrics(results = results2[[studyRes]], dataSets = obsData, outputPath = "Organism|PeripheralVenousBlood|Compound1|Plasma (Peripheral Venous Blood)", methodName = groupMethod[j])
      metres$metrics$studyID <- studyID
      metres$metrics$method <- groupMethod[j]

      metric_results <- rbind(metric_results, metres$metrics)

    }
  }

  # dat <- ospsuite::convertUnits(dc)
  # .calculateMetrics(results = results2[[1]], dataSets = obsData, outputPath = "Organism|PeripheralVenousBlood|Compound1|Plasma (Peripheral Venous Blood)", methodName = groupMethod[1])
  #
}

metric_results$Compound <- TBStudies$Compound[match(metric_results$studyID, TBStudies$StudyID)]

View(metric_results %>% select(-studyID) %>% group_by(method) %>% summarise_all(mean))
View(metric_results %>% select(-studyID) %>% group_by(method) %>% summarise_all(median))
View(metric_results %>% mutate(AUC2fold = AUCfold <= 2 & AUCfold >= 0.5) %>% select(-studyID) %>% group_by(method) %>% summarize(shareAUC2fold = sum(AUC2fold) / n() * 100))
View(metric_results %>% mutate(Cmax2fold = cMaxFold <= 2 & cMaxFold >= 0.5) %>% group_by(method) %>% summarize(shareCmax2fold = sum(Cmax2fold) / n() * 100))

View(metric_results %>% mutate(AUC4fold = AUCfold <= 4 & AUCfold >= 1/4) %>% select(-studyID) %>% group_by(method) %>% summarize(shareAUC4fold = sum(AUC4fold) / n() * 100))
View(metric_results %>% mutate(Cmax4fold = cMaxFold <= 4 & cMaxFold >= 1/4)  %>% select(-studyID) %>% group_by(method) %>% summarize(shareCmax4fold = sum(Cmax4fold) / n() * 100))


write.csv(metric_results, file = "TB2/metrics.csv", row.names = FALSE)


tmp <- metric_results %>% mutate(AUC2fold = AUCfold <= 2 & AUCfold >= 0.5) %>% group_by(Compound, method) %>% summarize(shareAUC2fold = sum(AUC2fold) / n() * 100)
tmp <- tmp %>% group_by(method) %>% summarize(shareAUC2fold = mean(shareAUC2fold))
tmp

ggplot(metric_results) + geom_boxplot(aes(y=cMaxFold, x= method)) + scale_y_log10(breaks = c(0.01, 0.05, 0.10, 0.2, 0.5, 1, 2, 5, 10, 20)) + geom_hline(yintercept = 0.5, linetype = "dashed") + geom_hline(yintercept = 2, linetype = "dashed") + theme_bw() + theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggplot(metric_results) + geom_boxplot(aes(y=AUCfold, x= method)) + scale_y_log10(breaks = c(0.01, 0.05, 0.10, 0.2, 0.5, 1, 2, 5, 10, 20)) + geom_hline(yintercept = 0.5, linetype = "dashed") + geom_hline(yintercept = 2, linetype = "dashed") + theme_bw() + theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggplot(metric_results) + geom_point(aes(y=AUCfold, x= cMaxFold, color= method)) + geom_hline(yintercept = 0.5) + geom_hline(yintercept = 2) + geom_vline(xintercept = 2) + geom_vline(xintercept = +1)

ggplot(metric_results %>% filter(method == "PT_PK-Sim")) + geom_point(aes(y=log2(AUCfold), x= log2(cMaxFold), color= method), alpha=0.5) + geom_hline(yintercept = -1, linetype = "dashed") + geom_hline(yintercept = +1, linetype = "dashed") + geom_vline(xintercept = -1, linetype = "dashed") + geom_vline(xintercept = +1, linetype = "dashed")

ggplot(metric_results %>% filter(method == "PT_PK-Sim")) + geom_point(aes(y=AUCfold, x=cMaxFold, color= Compound), alpha=0.5) + scale_y_log10(breaks = c(0.01, 0.05, 0.10, 0.2, 0.5, 1, 2, 5, 10, 20)) + scale_x_log10(breaks = c(0.01, 0.05, 0.10, 0.2, 0.5, 1, 2, 5, 10, 20)) + geom_hline(yintercept = 0.5, linetype = "dashed") + geom_hline(yintercept = 2, linetype = "dashed") + geom_vline(xintercept = 0.5, linetype = "dashed") + geom_vline(xintercept = 2, linetype = "dashed") + theme_bw()
ggplot(metric_results %>% filter(method == "PT_PK-Sim")) + geom_boxplot(aes(y=AUCfold, x= Compound)) + scale_y_log10(breaks = c(0.01, 0.05, 0.10, 0.2, 0.5, 1, 2, 5, 10, 20)) + geom_hline(yintercept = 2, linetype = "dashed") + geom_hline(yintercept = 0.5, linetype = "dashed") + theme_bw() + theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggplot(metric_results %>% filter(method == "PT_PK-Sim")) + geom_boxplot(aes(y=cMaxFold, x= Compound)) + scale_y_log10(breaks = c(0.01, 0.05, 0.10, 0.2, 0.5, 1, 2, 5, 10, 20)) + geom_hline(yintercept = 2, linetype = "dashed") + geom_hline(yintercept = 0.5, linetype = "dashed") + theme_bw() + theme(axis.text.x = element_text(angle = 45, hjust = 1))
