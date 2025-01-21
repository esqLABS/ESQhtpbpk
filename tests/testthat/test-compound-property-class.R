test_that("Compound property creation", {
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

test_that("Compound property print", {
  expect_snapshot({
    prop$print()
  })
})

test_that("Compound property transformation to base units", {
  expect_snapshot({
    prop$toBaseUnit()
  })
})
