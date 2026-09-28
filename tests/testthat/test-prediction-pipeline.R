suppressWarnings({
  ### Study 1
  # Compound 1 with IV Bolus
  comp1 <- Compound$new(ID = 1, name = "Alpha")
  comp1$setPropertyValue("Fraction unbound", value = 50, unit = "%")
  comp1$addProcessProperty(
    processType = "Liver Plasma Clearance",
    propertyName = "Plasma clearance",
    parName = "Plasma clearance",
    dimension = "Flow per weight",
    value = 10,
    unit = "ml/min/kg"
  )

  prot1 <- SimpleProtocol$new(
    route = "IV Bolus",
    dosingInterval = "24",
    dose = 1,
    doseUnit = "mg/kg",
    startTime = 60,
    startTimeUnit = "min",
    endTime = 48,
    endTimeUnit = "h",
    name = "Protocol 1"
  )
  comp1$setProtocol(prot1)

  study1 <- Study$new(
    ID = "Study1",
    compounds = list(comp1),
    individual = "Rat"
  )

  ### Study 2 same as study 1 but with an extra compound
  # Compound 2 with Weibull PO
  comp2 <- Compound$new(ID = 2, name = "Beta")

  po <- SimpleProtocol$new(
    route = "Oral",
    dosingInterval = "Single",
    dose = 1,
    doseUnit = "mg"
  )
  tablet <- createWeibullFormulation(name = "Tablet")
  po$setFormulation(tablet)

  prot <- AdvancedProtocol$new(name = "Protocol 2")
  prot$addSchema(
    schemaName = "Schema 1",
    timeUnit = "h",
    timeBetweenRepetitions = 2,
    numberOfRepetitions = 5,
    startTime = 12
  )
  prot$addProtocolToSchema(schemaName = "Schema 1", protocol = po)

  comp2$setProtocol(prot)

  study2 <- Study$new(
    ID = "Study2",
    compounds = list(comp1, comp2),
    individual = "Rat"
  )

  ### Study 3 same as study 2 but with more admin of compound 2 with different formulation
  po2 <- SimpleProtocol$new(
    route = "Oral",
    dosingInterval = "Single",
    dose = 10,
    doseUnit = "mg"
  )
  tablet2 <- createWeibullFormulation(
    name = "TabletFasterRelease",
    dissolutionTime50 = 60
  )
  po2$setFormulation(tablet2)

  prot$addSchema(
    schemaName = "Schema 2",
    timeUnit = "h",
    timeBetweenRepetitions = 12,
    numberOfRepetitions = 3,
    startTime = 0
  )
  prot$addProtocolToSchema(schemaName = "Schema 2", protocol = po2)

  study3 <- Study$new(
    ID = "Study3",
    compounds = list(comp1, comp2),
    individual = "Rat"
  )

  ### Study 4 same as study 1 but in Human
  study4 <- Study$new(
    ID = "Study4",
    compounds = list(comp1),
    individual = "Human"
  )

  ### Study 5 same as study 3 but with compound1 with different process
  comp1$removeProcessProperty(
    processType = "Liver Plasma Clearance",
    propertyName = "Plasma clearance"
  )
  comp1$addProcessProperty(
    processType = "Liver Mic T1/2",
    propertyName = "Thalf",
    parName = "t1/2 (microsomal assay)",
    dimension = "Time",
    value = 10,
    unit = "min"
  )
  comp1$addProcessProperty(
    processType = "Liver Mic T1/2",
    propertyName = "Conc Incubation",
    parName = "Amount protein/incubation",
    dimension = "Concentration (mass)",
    value = 11,
    unit = "mg/ml"
  )

  study5 <- Study$new(
    ID = "Study5",
    compounds = list(comp1, comp2),
    individual = "Rat"
  )

  studyList <- list(study1, study2, study3, study4, study5)

  rtemp <- tempdir(check = TRUE)
  tempDir <- tempfile(tmpdir = rtemp)
})

test_that("Prediction pipeline works with automatic generic pkml.", {
  expect_no_error({
    suppressWarnings({
      results <- runPredictions(
        studies = studyList,
        outputFolder = tempDir,
        saveResults = FALSE,
        saveSimulation = FALSE,
        plotFigures = FALSE,
        numberOfCores = 1,
        queueSize = 2,
        outputSelections = c(
          "Organism|PeripheralVenousBlood|**|Plasma *(Peripheral Venous Blood)"
        ),
        simulationResolution = c(0, 10 * 24 * 60, 1 / 60)
      )
    })
  })

  createPlot <- function() {
    dc <- ospsuite::DataCombined$new()
    dc$addSimulationResults(
      simulationResults = results$Study1,
      quantitiesOrPaths = results$Study1$allQuantityPaths,
      individualIds = results$Study1$allIndividualIds
    )
    pc <- ospsuite::DefaultPlotConfiguration$new()
    pc$yAxisScale <- "lin"
    plot <- ospsuite::plotIndividualTimeProfile(
      dc,
      defaultPlotConfiguration = pc
    )
    return(print(plot))
  }

  vdiffr::expect_doppelganger("Study1-Comp1", createPlot)
})


test_that("Test saving simulation and results:", {
  rtemp <- tempdir(check = TRUE)
  tempDir <- tempfile(tmpdir = rtemp)

  expect_no_error({
    results <- runPredictions(
      studies = list(study1),
      outputFolder = tempDir,
      saveResults = TRUE,
      saveSimulation = TRUE,
      plotFigures = FALSE,
      numberOfCores = 1,
      queueSize = 2,
      outputSelections = c(
        "Organism|PeripheralVenousBlood|**|Plasma *(Peripheral Venous Blood)"
      ),
      simulationResolution = c(0, 10 * 24 * 60, 1 / 60)
    )
  })

  subdir <- list.dirs(tempDir, recursive = FALSE)
  expect_snapshot(list.files(subdir, recursive = TRUE))
})

test_that("Wrong inputs fails:", {
  expect_error({
    results <- runPredictions(
      studies = list(study1, "a"),
      outputFolder = tempDir,
      saveResults = FALSE,
      saveSimulation = FALSE,
      plotFigures = FALSE,
      numberOfCores = 1,
      queueSize = 2,
      outputSelections = c(
        "Organism|PeripheralVenousBlood|**|Plasma *(Peripheral Venous Blood)"
      ),
      simulationResolution = c(0, 10 * 24 * 60, 1 / 60)
    )
  })

  expect_error({
    results <- runPredictions(
      studies = list(study1),
      outputFolder = 1,
      saveResults = FALSE,
      saveSimulation = FALSE,
      plotFigures = FALSE,
      numberOfCores = 1,
      queueSize = 2,
      outputSelections = c(
        "Organism|PeripheralVenousBlood|**|Plasma *(Peripheral Venous Blood)"
      ),
      simulationResolution = c(0, 10 * 24 * 60, 1 / 60)
    )
  })

  expect_error({
    results <- runPredictions(
      studies = list(study1),
      outputFolder = tempDir,
      saveResults = 1,
      saveSimulation = FALSE,
      plotFigures = FALSE,
      numberOfCores = 1,
      queueSize = 2,
      outputSelections = c(
        "Organism|PeripheralVenousBlood|**|Plasma *(Peripheral Venous Blood)"
      ),
      simulationResolution = c(0, 10 * 24 * 60, 1 / 60)
    )
  })

  expect_error({
    results <- runPredictions(
      studies = list(study1),
      outputFolder = tempDir,
      saveResults = FALSE,
      saveSimulation = 1,
      plotFigures = FALSE,
      numberOfCores = 1,
      queueSize = 2,
      outputSelections = c(
        "Organism|PeripheralVenousBlood|**|Plasma *(Peripheral Venous Blood)"
      ),
      simulationResolution = c(0, 10 * 24 * 60, 1 / 60)
    )
  })

  expect_error({
    results <- runPredictions(
      studies = list(study1),
      outputFolder = tempDir,
      saveResults = FALSE,
      saveSimulation = FALSE,
      plotFigures = 1,
      numberOfCores = 1,
      queueSize = 2,
      outputSelections = c(
        "Organism|PeripheralVenousBlood|**|Plasma *(Peripheral Venous Blood)"
      ),
      simulationResolution = c(0, 10 * 24 * 60, 1 / 60)
    )
  })

  expect_error({
    results <- runPredictions(
      studies = list(study1),
      outputFolder = tempDir,
      saveResults = FALSE,
      saveSimulation = FALSE,
      plotFigures = FALSE,
      numberOfCores = "a",
      queueSize = 2,
      outputSelections = c(
        "Organism|PeripheralVenousBlood|**|Plasma *(Peripheral Venous Blood)"
      ),
      simulationResolution = c(0, 10 * 24 * 60, 1 / 60)
    )
  })

  expect_error({
    results <- runPredictions(
      studies = list(study1),
      outputFolder = tempDir,
      saveResults = FALSE,
      saveSimulation = FALSE,
      plotFigures = FALSE,
      numberOfCores = 1,
      queueSize = "a",
      outputSelections = c(
        "Organism|PeripheralVenousBlood|**|Plasma *(Peripheral Venous Blood)"
      ),
      simulationResolution = c(0, 10 * 24 * 60, 1 / 60)
    )
  })

  expect_error({
    results <- runPredictions(
      studies = list(study1),
      outputFolder = tempDir,
      saveResults = FALSE,
      saveSimulation = FALSE,
      plotFigures = FALSE,
      numberOfCores = 1,
      queueSize = 100,
      outputSelections = c(
        "Organism|PeripheralVenousBlood|**|Plasma *(Peripheral Venous Blood)"
      ),
      simulationResolution = c(0, 10 * 24 * 60, 1 / 60, 10)
    )
  })

  expect_error({
    results <- runPredictions(
      studies = list(study1),
      outputFolder = tempDir,
      saveResults = FALSE,
      saveSimulation = FALSE,
      plotFigures = FALSE,
      numberOfCores = 1,
      queueSize = 100,
      outputSelections = c(
        "Organism|PeripheralVenousBlood|**|Plasma *(Peripheral Venous Blood)"
      ),
      simulationResolution = c(10 * 24 * 60, 1 * 24 * 60, 1 / 60)
    )
  })
})

test_that("Wrong output selection fails:", {
  expect_error(
    {
      expect_warning(
        {
          results <- runPredictions(
            studies = list(study1),
            outputFolder = tempDir,
            saveResults = FALSE,
            saveSimulation = FALSE,
            plotFigures = FALSE,
            numberOfCores = 1,
            queueSize = 2,
            outputSelections = c(
              "Organism|PVB|**|Plasma *(Peripheral Venous Blood)"
            ),
            simulationResolution = c(0, 10 * 24 * 60, 1 / 60)
          )
        },
        "None of the selected outputs were found in the the simulation."
      )
    },
    "No studies to simulate."
  )
})

# test_wrong parameter path
test_that("Skipping study with wrong param path:", {
  # add unexisting property to test error of getAllParameterPaths
  study1$Compounds[[1]]$addProperty(
    name = "Test",
    parName = "Unknown",
    dimension = "Fraction",
    value = 50,
    unit = "%"
  )

  expect_warning(
    {
      results <- runPredictions(
        studies = list(study1, study2),
        outputFolder = tempDir,
        saveResults = FALSE,
        saveSimulation = FALSE,
        plotFigures = FALSE,
        numberOfCores = 1,
        queueSize = 2,
        outputSelections = c(
          "Organism|PeripheralVenousBlood|**|Plasma *(Peripheral Venous Blood)"
        ),
        simulationResolution = c(0, 10 * 24 * 60, 1 / 60)
      )
    },
    "Some paths could not be found in the associated study. Skipping the study."
  )
})

# test with dose per body area and infusion time
test_that("Test dose per body weight and infusion time", {
  prot1 <- SimpleProtocol$new(
    route = "IV Infusion",
    dosingInterval = "24",
    dose = 1,
    doseUnit = "mg/m²",
    infusionTime = 60,
    infusionTimeUnit = "min",
    startTime = 60,
    startTimeUnit = "min",
    endTime = 48,
    endTimeUnit = "h",
    name = "Protocol 1"
  )
  comp1$setProtocol(prot1)

  study1 <- Study$new(
    ID = "Study1",
    compounds = list(comp1),
    individual = "Rat"
  )

  expect_no_error({
    results <- runPredictions(
      studies = list(study1),
      outputFolder = tempDir,
      saveResults = FALSE,
      saveSimulation = FALSE,
      plotFigures = FALSE,
      numberOfCores = 1,
      queueSize = 2,
      outputSelections = c(
        "Organism|PeripheralVenousBlood|**|Plasma *(Peripheral Venous Blood)"
      ),
      simulationResolution = c(0, 10 * 24 * 60, 1 / 60)
    )
  })
})
