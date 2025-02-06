test_that("Creating new Single IV Bolus Protocol works.", {
  expect_no_message(
    SimpleProtocol$new(
      route = "IV Bolus",
      dosingInterval = "Single",
      dose = 1,
      doseUnit = "mg",
      startTime = 60,
      startTimeUnit = "min"
    )
  )
})

test_that("Creating new Daily IV Infusion Protocol works.", {
  expect_no_message(
    SimpleProtocol$new(
      route = "IV Infusion",
      dosingInterval = "24",
      dose = 1,
      doseUnit = "mg",
      startTime = 60,
      startTimeUnit = "min",
      endTime = 48,
      endTimeUnit = "h",
      infusionTime = 10,
      infusionTimeUnit = "min"
    )
  )
})

test_that("Creating new TID Oral Protocol works.", {
  expect_no_message(
    SimpleProtocol$new(
      route = "Oral",
      dosingInterval = "8-8-8",
      dose = 10,
      doseUnit = "mg",
      startTime = 60,
      startTimeUnit = "min",
      endTime = 48,
      endTimeUnit = "h",
      waterVolPerBW = 3.5,
      waterVolPerBWUnit = "ml/kg"
    )
  )
})

test_that("Creating protocol with wrong route does not work.", {
  expect_error(
    SimpleProtocol$new(
      route = "a",
      dosingInterval = "Single",
      dose = 1,
      doseUnit = "mg",
      startTime = 60,
      startTimeUnit = "min"
    ),
    "Value 'a' is not allowed for 'route'. Route must be one of `Oral`, `IV Bolus`, and `IV Infusion`, and `Custom`.",
    fixed = TRUE
  )
})

test_that("Creating protocol with custom admin does not work.", {
  expect_error(
    SimpleProtocol$new(
      route = "Custom",
      dosingInterval = "Single",
      dose = 1,
      doseUnit = "mg",
      startTime = 60,
      startTimeUnit = "min"
    ),
    "`Custom` route is not yet supported.",
    fixed = TRUE
  )
})

test_that("Creating protocol with wrong dose interval does not work.", {
  expect_error(
    SimpleProtocol$new(
      route = "IV Bolus",
      dosingInterval = "daily",
      dose = 1,
      doseUnit = "mg",
      startTime = 60,
      startTimeUnit = "min"
    ),
    "Value 'daily' is not allowed for 'dosing interval'. Dosing interval must be one and of `Single`, `24`, `12-12`, `8-8-8`, `6-6-6-6`, and `6-6-12`.",
    fixed = TRUE
  )
})

test_that("Creating protocol with wrong units does not work.", {
  expect_error(
    SimpleProtocol$new(
      route = "IV Bolus",
      dosingInterval = "Single",
      dose = 1,
      doseUnit = "min",
      startTime = 60,
      startTimeUnit = "min"
    ),
    "Supplied dose unit is not valid.",
    fixed = TRUE
  )

  expect_error(
    SimpleProtocol$new(
      route = "IV Bolus",
      dosingInterval = "Single",
      dose = 1,
      doseUnit = "mg",
      startTime = 60,
      startTimeUnit = "minutes"
    ),
    "Supplied start time unit is not valid.",
    fixed = TRUE
  )

  expect_error(
    SimpleProtocol$new(
      route = "IV Bolus",
      dosingInterval = "24",
      dose = 1,
      doseUnit = "mg",
      startTime = 60,
      startTimeUnit = "min",
      endTime = 48,
      endTimeUnit = "hours"
    ),
    "Supplied end time unit is not valid.",
    fixed = TRUE
  )

  expect_error(
    SimpleProtocol$new(
      route = "IV Infusion",
      dosingInterval = "Single",
      dose = 1,
      doseUnit = "mg",
      startTime = 60,
      startTimeUnit = "min",
      infusionTime = 10,
      infusionTimeUnit = "minutes"
    ),
    "Supplied infusion time unit is not valid.",
    fixed = TRUE
  )

  expect_error(
    SimpleProtocol$new(
      route = "Oral",
      dosingInterval = "Single",
      dose = 1,
      doseUnit = "mg",
      startTime = 60,
      startTimeUnit = "min",
      waterVolPerBW = 10,
      waterVolPerBWUnit = "mL/kg"
    ),
    "Supplied Water volume per body weight time unit is not valid.",
    fixed = TRUE
  )
})

test_that("Creating protocol with not numeric dose or time does not work.", {
  expect_error(
    SimpleProtocol$new(
      route = "IV Bolus",
      dosingInterval = "Single",
      dose = "a",
      doseUnit = "mg",
      startTime = 60,
      startTimeUnit = "min"
    ),
    "Dose must be a numeric value.",
    fixed = TRUE
  )

  expect_error(
    SimpleProtocol$new(
      route = "IV Bolus",
      dosingInterval = "Single",
      dose = 1,
      doseUnit = "mg",
      startTime = "a",
      startTimeUnit = "min"
    ),
    "Start time must be a numeric value.",
    fixed = TRUE
  )

  expect_error(
    SimpleProtocol$new(
      route = "IV Bolus",
      dosingInterval = "24",
      dose = 1,
      doseUnit = "mg",
      startTime = 60,
      startTimeUnit = "min",
      endTime = "48",
      endTimeUnit = "h"
    ),
    "End time must be a numeric value.",
    fixed = TRUE
  )

  expect_error(
    SimpleProtocol$new(
      route = "IV Infusion",
      dosingInterval = "Single",
      dose = 1,
      doseUnit = "mg",
      startTime = 60,
      startTimeUnit = "min",
      infusionTime = "10",
      infusionTimeUnit = "min"
    ),
    "Infusion time must be a numeric value.",
    fixed = TRUE
  )

  expect_error(
    SimpleProtocol$new(
      route = "Oral",
      dosingInterval = "Single",
      dose = 1,
      doseUnit = "mg",
      startTime = 60,
      startTimeUnit = "min",
      waterVolPerBW = "10",
      waterVolPerBWUnit = "ml/kg"
    ),
    "Water volume per body weight must be a numeric value.",
    fixed = TRUE
  )
})

test_that("Default setting are set.", {
  expect_snapshot(
    SimpleProtocol$new(
      route = "IV Infusion",
      dosingInterval = "6-6-6-6",
    )
  )

  expect_snapshot(
    SimpleProtocol$new(
      route = "IV Infusion",
      infusionTime = 10
    )
  )

  expect_snapshot(
    SimpleProtocol$new(
      route = "IV Bolus",
      infusionTime = 10
    )
  )

  expect_snapshot(
    SimpleProtocol$new(
      route = "Oral"
    )
  )

  expect_snapshot(
    SimpleProtocol$new(
      route = "Oral",
      waterVolPerBW = 5
    )
  )

  expect_snapshot(
    SimpleProtocol$new(
      route = "IV Bolus",
      waterVolPerBW = 5
    )
  )
})

test_that("Extracting protocol works.", {
  prot <- SimpleProtocol$new(
    route = "IV Infusion",
    dosingInterval = "24",
    dose = 1,
    doseUnit = "mg",
    startTime = 60,
    startTimeUnit = "min",
    endTime = 48,
    endTimeUnit = "h",
    infusionTime = 10,
    infusionTimeUnit = "min"
  )

  tmp <- prot$extractProtocol()
  expect_snapshot(tmp)
  expect_snapshot(tmp$parameters)
})

test_that("getAllParameterPaths works.", {
  prot <- SimpleProtocol$new(
    route = "IV Infusion",
    dosingInterval = "24",
    dose = 1,
    doseUnit = "mg",
    startTime = 60,
    startTimeUnit = "min",
    endTime = 48,
    endTimeUnit = "h",
    infusionTime = 10,
    infusionTimeUnit = "min"
  )
  expect_snapshot(prot$getAllParameterPaths())

  prot <- suppressWarnings({
    SimpleProtocol$new(
      route = "IV Bolus",
      dosingInterval = "24",
      dose = 1,
      doseUnit = "mg/m²",
      startTime = 60,
      startTimeUnit = "min",
   )
  })
  expect_snapshot(prot$getAllParameterPaths())

  suppressWarnings({
    prot <- SimpleProtocol$new(
      route = "Oral",
      dosingInterval = "24",
      dose = 1,
      doseUnit = "mg/kg",
      startTime = 60,
      startTimeUnit = "min",
      endTime = 48,
      endTimeUnit = "h"
    )
  })
  expect_snapshot(prot$getAllParameterPaths())
})

test_that("Print method works.", {
  expect_snapshot(
    SimpleProtocol$new(
      route = "IV Infusion",
      dosingInterval = "24",
      dose = 1,
      doseUnit = "mg",
      startTime = 60,
      startTimeUnit = "min",
      endTime = 48,
      endTimeUnit = "h",
      infusionTime = 10,
      infusionTimeUnit = "min"
    )
  )
  expect_snapshot(
    SimpleProtocol$new(
      route = "Oral",
      dosingInterval = "Single",
      dose = 1,
      doseUnit = "mg",
      startTime = 60,
      startTimeUnit = "min"
    )
  )
})
