test_that("Property creation works", {
  expect_no_error({
    Property$new(
      name = "Solubility",
      parName = "Solubility at reference pH",
      dimension = "Concentration (mass)",
      unit = "mg/l",
      value = 100,
      check = function(value, unit) {if (value < 0) {stop("Solubility must be > 0")}}
    )
  })
})

prop <- Property$new(
  name = "Solubility",
  parName = "Solubility at reference pH",
  dimension = "Concentration (mass)",
  unit = "mg/l",
  value = 100,
  check = function(value, unit) {if (value < 0) {stop("Solubility must be > 0")}}
)

test_that("Property `print` method works", {
  expect_snapshot({
    prop$print()
  })

  expect_snapshot({
    prop$print(compoundName = "Compound")
  })
})

test_that("`toBaseUnit` method (transformation to base units) works", {
  expect_snapshot({
    prop$toBaseUnit()
  })
})

test_that("`toSnapshot` method works", {
  expect_snapshot({
    prop$toSnapshot()
  })
})
