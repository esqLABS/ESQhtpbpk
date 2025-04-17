test_that("Create generic PKMLS from study list", {
  suppressWarnings({
    ### Study 1
    # Compound 1 with IV Bolus
    comp1 <- Compound$new(ID = 1, name = "Alpha")

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

    study1 <- Study$new(ID = "Study1", compounds = list(comp1), individual = "Rat")

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

    study2 <- Study$new(ID = "Study2", compounds = list(comp1, comp2), individual = "Rat")

    ### Study 3 same as study 2 but with more admin of compound 2 with different formulation
    po2 <- SimpleProtocol$new(
      route = "Oral",
      dosingInterval = "Single",
      dose = 10,
      doseUnit = "mg"
    )
    tablet2 <- createWeibullFormulation(name = "TabletFasterRelease", dissolutionTime50 = 60)
    po2$setFormulation(tablet2)

    prot$addSchema(
      schemaName = "Schema 2",
      timeUnit = "h",
      timeBetweenRepetitions = 12,
      numberOfRepetitions = 3,
      startTime = 0
    )
    prot$addProtocolToSchema(schemaName = "Schema 2", protocol = po2)

    study3 <- Study$new(ID = "Study3", compounds = list(comp1, comp2), individual = "Rat")

    ### Study 4 same as study 1 but in Human
    study4 <- Study$new(ID = "Study4", compounds = list(comp1), individual = "Human")

    # study 5 same as study 4 but use simple po
    comp1$setProtocol(po2)
    study5 <- Study$new(ID = "Study5", compounds = list(comp1), individual = "Human")

    studyList <- list(study1, study2, study3, study4, study5)

    rTemp <- tempdir(check = TRUE)
    tempDir <- tempfile(tmpdir = rTemp)
  })

  # expect error if not only Study Objects in studyList
  expect_error(suppressWarnings(createGenericPKMLs(studyList = list(study1, "A"), outputFolder = tempDir)))

  # expect no error if correctly set up
  expect_no_error(suppressWarnings(createGenericPKMLs(studyList, outputFolder = tempDir)))

  expect_snapshot(list.files(tempDir))

  expect_snapshot(
    purrr::map(studyList, \(x) {
      x$getAllParameterPaths()
    })
  )
})
