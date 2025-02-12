suppressWarnings({
  # Compound 1 with IV Bolus
  comp1 <- Compound$new(ID = 1, name = "Compound 1")

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

  # Compound 2 with Weibull PO
  comp2 <- Compound$new(ID = 2, name = "Compound 2")

  po <- SimpleProtocol$new(
    route = "Oral",
    dosingInterval = "Single",
    dose = 10,
    doseUnit = "mg"
  )
  tablet <- createWeibullFormulation(name = "Tablet")
  po$setFormulation(tablet)

  prot2 <- AdvancedProtocol$new(name = "Protocol 2")
  prot2$addSchema(schemaName = "Schema 1", timeUnit = "h", timeBetweenRepetitions = 2, numberOfRepetitions = 5, startTime = 12)
  prot2$addProtocolToSchema(schemaName = "Schema 1", protocol = po)

  comp2$setProtocol(prot2)
})

test_that("Study can be created", {
  expect_no_message(Study$new(ID = "Study1", compounds = list(comp1, comp2), individual = "Rat"))
})

test_that("Study field can be accessed", {
  study <- Study$new(ID = "Study1", compounds = list(comp1, comp2), individual = "Rat")
  expect_snapshot(study$Compounds)

  expect_snapshot(study$Individual)
})

test_that("print method works", {
  study <- Study$new(ID = "Study1", compounds = list(comp1, comp2), individual = "Rat")
  expect_snapshot(study)
})

test_that("getAllParameterPaths method works", {
  study <- Study$new(ID = "Study1", compounds = list(comp1, comp2), individual = "Rat")
  expect_snapshot(study$getAllParameterPaths())
})

test_that("toSnapshot method works and can be run", {
  temp_dir <- tempfile()
  dir.create(temp_dir)
  temp_file <- tempfile(fileext = ".json", tmpdir = temp_dir)

  study <- Study$new(ID = "Study1", compounds = list(comp1, comp2), individual = "Rat")
  expect_no_message(study$exportSnapshot(temp_file))

  expect_no_error(ospsuite::runSimulationsFromSnapshot(temp_file, exportPKML = TRUE, exportCSV = FALSE, output = temp_dir))
  expect_true(file.exists(gsub("\\.json$", "-Study1.pkml", temp_file)))
  expect_no_error(study$setGenericModel(modelPath = gsub("\\.json$", "-Study1.pkml", temp_file)))
})

test_that("setOutputInterval method works and can be run", {
  study <- Study$new(ID = "Study1", compounds = list(comp1, comp2), individual = "Rat")
  expect_no_error(study$setOutputInterval(startTime = 0, endTime = 48, timeUnit = "h", resolution = 1))
})
