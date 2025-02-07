test_that("createDissolvedFormulation works", {
  expect_no_message({
    formulation <- createDissolvedFormulation(name = "Dissolved")
  })

  expect_snapshot(formulation)
})

test_that("createWeibullFormulation works", {
  expect_no_message({
    formulation <- createWeibullFormulation(name = "Weibull")
  })

  expect_snapshot(formulation)
})

test_that("createLint80Formulation works", {
  expect_no_message({
    formulation <- createLint80Formulation(name = "Lint80")
  })

  expect_snapshot(formulation)
})

test_that("createParticleDissolutionFormulation works", {
  # Monodisperse
  expect_no_message({
    formulation <- createParticleDissolutionFormulation(
      name = "ParticleMono",
      distributionType = "Monodisperse"
    )
  })
  expect_snapshot(formulation)

  # Polydisperse normal
  expect_no_message({
    formulation <- createParticleDissolutionFormulation(
      name = "ParticlePolyNormal",
      distributionType = "Polydisperse",
      distribution = "Normal"
    )
  })
  expect_snapshot(formulation)

  # Polydisperse lognormal
  expect_no_message({
    formulation <- createParticleDissolutionFormulation(
      name = "ParticlePolyLogNormal",
      distributionType = "Polydisperse",
      distribution = "LogNormal"
    )
  })
  expect_snapshot(formulation)
})

test_that("createZeroOrderFormulation works", {
  expect_no_message({
    formulation <- createZeroOrderFormulation(name = "0Order")
  })

  expect_snapshot(formulation)
})

test_that("createFirstOrderFormulation works", {
  expect_no_message({
    formulation <- createZeroOrderFormulation(name = "1stOrder")
  })

  expect_snapshot(formulation)
})

test_that("Create unknown formulation does not works", {
  expect_error(
    Formulation$new(type = "Wrong", name = "Wrong type"),
    regexp = "Value 'Wrong' is not allowed for 'Formulation type'.",
    fixed = TRUE
  )
})

test_that("Create formulation with non character name does not work", {
  expect_error(
    createDissolvedFormulation(name = 1),
    "Supplied Name is not valid.",
    fixed = TRUE
  )
})

test_that("Paremeters are read-only", {
  formulation <- createDissolvedFormulation(name = "Dissolved")
  expect_error(
    formulation$Parameters <- list(),
    "'Parameters' is read-only"
  )
})

test_that("Export to snapshot works", {
  formulation <- createWeibullFormulation(name = "OralWeibull")
  expect_snapshot(
    formulation$toSnapshot()
  )

  formulation <- createDissolvedFormulation(name = "OralDissolved")
  expect_snapshot(
    formulation$toSnapshot()
  )
})

test_that("getAllPropertyPaths method works", {
  formulation <- createWeibullFormulation(name = "OralWeibull")
  expect_snapshot(
    formulation$getAllPropertyPaths()
  )
  expect_snapshot(
    formulation$getAllPropertyPaths(protocolName = "Protocol", formulationName = formulation$Name)
  )
})
