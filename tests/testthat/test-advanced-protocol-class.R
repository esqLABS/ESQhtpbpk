test_that("Advanced protocol creation works.", {
  expect_no_message(
    AdvancedProtocol$new()
  )
})

test_that("UUID and Schemas are read-only.", {
  prot <- AdvancedProtocol$new()

  expect_error(
    prot$UUID <- "123",
    "'UUID' is read-only."
  )
  expect_error(
    prot$Schemas <- list(),
    "'Schemas' is read-only."
  )
})

test_that("Path need to be a character", {
  expect_error(
    AdvancedProtocol$new(path = 1),
    "Supplied Path is not valid."
  )
})

test_that("addSchema works", {
  prot <- AdvancedProtocol$new()

  expect_no_message(
    prot$addSchema(schemaName = "Schema 1", timeUnit = "h", timeBetweenRepetitions = 2, numberOfRepetitions = 5, startTime = 12)
  )
})

test_that("addSchema with existing schema name does not work.", {
  prot <- AdvancedProtocol$new()
  prot$addSchema(schemaName = "Schema 1", timeUnit = "h", timeBetweenRepetitions = 2, numberOfRepetitions = 5, startTime = 12)

  expect_error(
    prot$addSchema(schemaName = "Schema 1", timeUnit = "min", timeBetweenRepetitions = 2, numberOfRepetitions = 5, startTime = 12),
    "Schema `Schema 1` already exists."
  )
})

test_that("addProtocolToSchema works.", {
  prot <- AdvancedProtocol$new()
  prot$addSchema(schemaName = "Schema 1", timeUnit = "h", timeBetweenRepetitions = 2, numberOfRepetitions = 5, startTime = 12)

  iv <- SimpleProtocol$new(dose = 10)

  expect_no_message(
    prot$addProtocolToSchema(schemaName = "Schema 1", protocol = iv)
  )
})

test_that("addProtocolToSchema only works with Single dose.", {
  prot <- AdvancedProtocol$new()
  prot$addSchema(schemaName = "Schema 1", timeUnit = "h", timeBetweenRepetitions = 2, numberOfRepetitions = 5, startTime = 12)

  suppressWarnings({iv <- SimpleProtocol$new(dose = 10, dosingInterval = "24")})

  expect_error(
    prot$addProtocolToSchema(schemaName = "Schema 1", protocol = iv),
    "Only `SimpleProtocol` objects with a `Single` dose interval can be added to a schema."
  )
})

test_that("addProtocolToSchema with wrong schemaName does not work", {
  prot <- AdvancedProtocol$new()
  prot$addSchema(schemaName = "Schema 1", timeUnit = "h", timeBetweenRepetitions = 2, numberOfRepetitions = 5, startTime = 12)

  suppressWarnings({iv <- SimpleProtocol$new(dose = 10)})

  expect_error(
    prot$addProtocolToSchema(schemaName = "Schema 2", protocol = iv),
    "Could not find schema `Schema 2`."
  )
})

test_that("extractProtocol works", {
  prot <- AdvancedProtocol$new()
  prot$addSchema(schemaName = "Schema 1", timeUnit = "h", timeBetweenRepetitions = 2, numberOfRepetitions = 5, startTime = 12)
  prot$addSchema(schemaName = "Schema 2", timeUnit = "h", timeBetweenRepetitions = 12, numberOfRepetitions = 2, startTime = 0)

  suppressWarnings({iv <- SimpleProtocol$new(dose = 10)})
  suppressWarnings({po <- SimpleProtocol$new(dose = 5, route = "Oral")})

  prot$addProtocolToSchema(schemaName = "Schema 1", protocol = iv)
  prot$addProtocolToSchema(schemaName = "Schema 2", protocol = po)

  tmp <- prot$extractProtocol()
  expect_snapshot(
    tmp
  )
  expect_snapshot(
    tmp$parameters
  )
})

test_that("getAllParameterPaths works", {
  prot <- AdvancedProtocol$new()
  prot$addSchema(schemaName = "Schema 1", timeUnit = "h", timeBetweenRepetitions = 2, numberOfRepetitions = 5, startTime = 12)
  prot$addSchema(schemaName = "Schema 2", timeUnit = "h", timeBetweenRepetitions = 12, numberOfRepetitions = 2, startTime = 0)

  suppressWarnings({iv <- SimpleProtocol$new(route = "IV Infusion", dose = 10, doseUnit = "mg")})
  suppressWarnings({iv_area <- SimpleProtocol$new(dose = 1, doseUnit = "mg/m²")})
  suppressWarnings({po <- SimpleProtocol$new(dose = 5, doseUnit = "mg/kg", route = "Oral")})

  prot$addProtocolToSchema(schemaName = "Schema 1", protocol = iv)
  prot$addProtocolToSchema(schemaName = "Schema 1", protocol = iv_area)
  prot$addProtocolToSchema(schemaName = "Schema 2", protocol = po)

  expect_snapshot(
    prot$getAllParameterPaths()
  )
})

test_that("Adding a different formulation with the same name doesn't work", {
  prot <- AdvancedProtocol$new()
  prot$addSchema(schemaName = "Schema 1", timeUnit = "h", timeBetweenRepetitions = 2, numberOfRepetitions = 5, startTime = 12)
  prot$addSchema(schemaName = "Schema 2", timeUnit = "h", timeBetweenRepetitions = 12, numberOfRepetitions = 2, startTime = 0)

  suppressWarnings({
    po <- SimpleProtocol$new(dose = 5, doseUnit = "mg/kg", route = "Oral")
    formulation <- createWeibullFormulation(name = "Weibull", lagTime = 60)
    po$setFormulation(formulation)
  })
  suppressWarnings({
    po2 <- SimpleProtocol$new(dose = 1, doseUnit = "mg/kg", route = "Oral")
    formulation <- createWeibullFormulation(name = "Weibull")
    po2$setFormulation(formulation)
  })
  prot$addProtocolToSchema(schemaName = "Schema 1", protocol = po)

  expect_error(
    prot$addProtocolToSchema(schemaName = "Schema 2", protocol = po2),
    "Formulation name `Weibull` is already used for a different formulation."
  )
})

# create complicated protocol to test print, extractProtocol and toSnapshot methods
prot <- AdvancedProtocol$new()
prot$addSchema(schemaName = "Schema 1", timeUnit = "h", timeBetweenRepetitions = 2, numberOfRepetitions = 5, startTime = 12)
prot$addSchema(schemaName = "Schema 2", timeUnit = "h", timeBetweenRepetitions = 12, numberOfRepetitions = 2, startTime = 0)

suppressWarnings({iv <- SimpleProtocol$new(route = "IV Infusion", dose = 10, doseUnit = "mg")})
suppressWarnings({iv_area <- SimpleProtocol$new(dose = 1, doseUnit = "mg/m²")})
suppressWarnings({
  po <- SimpleProtocol$new(dose = 5, doseUnit = "mg/kg", route = "Oral")
  formulation <- createWeibullFormulation(name = "Weibull1", lagTime = 60)
  po$setFormulation(formulation)
})
suppressWarnings({
  po2 <- SimpleProtocol$new(dose = 1, doseUnit = "mg/kg", route = "Oral")
  formulation <- createWeibullFormulation(name = "Weibull2")
  po2$setFormulation(formulation)
})

prot$addProtocolToSchema(schemaName = "Schema 1", protocol = iv)
prot$addProtocolToSchema(schemaName = "Schema 1", protocol = iv_area)
prot$addProtocolToSchema(schemaName = "Schema 1", protocol = po)
prot$addProtocolToSchema(schemaName = "Schema 2", protocol = po2)

test_that("print method works", {
  expect_snapshot(
    prot
  )
})

test_that("extractProtocol method works", {
  expect_snapshot(
    prot$extractProtocol()
  )
})

test_that("toSnapshot method works", {
  expect_snapshot(
    prot$toSnapshot()
  )
})

