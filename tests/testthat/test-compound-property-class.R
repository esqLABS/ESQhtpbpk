test_that("compoundProperty creation works", {
  expect_no_error({
    CompoundProperty$new(
      name = "Solubility",
      path = "Compound|Solubility at reference pH",
      dimension = "Concentration (mass)",
      unit = "mg/l",
      value = 100,
      check = function(value, unit) {if (value < 0) {stop("Solubility must be > 0")}}
    )
  })
})

prop <- CompoundProperty$new(
  name = "Solubility",
  path = "Compound|Solubility at reference pH",
  dimension = "Concentration (mass)",
  unit = "mg/l",
  value = 100,
  check = function(value, unit) {if (value < 0) {stop("Solubility must be > 0")}}
)

test_that("compoundProperty `print` method works", {
  expect_snapshot({
    prop$print()
  })
})

test_that("`toBaseUnit` method (transformation to base units) works", {
  expect_snapshot({
    prop$toBaseUnit()
  })
})
