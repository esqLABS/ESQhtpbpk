test_that("Compound creation", {
  expect_no_error({
    Compound$new(ID = 1)
  })
})

myCompound <- Compound$new(ID = 1)

test_that("Print compound class", {
  expect_snapshot(myCompound$print())
})

test_that("Add property", {
  expect_no_error(
    myCompound$addProperty(
      name = "Total Hepatic Clearance half life",
      path = "Compound-Total Hepatic Clearance-In vitro microsomes Rat|t1/2 (microsomal assay)",
      dimension = "Inversed time", value = 0.1, unit = "1/min"
    )
  )
  expect_snapshot(myCompound$print())

  # check name unicity
  expect_error(
    myCompound$addProperty(
      name = "Lipophilicity",
      path = "Compound|Lipo",
      dimension = "Log Units", value = 0.1
    )
  )
})

test_that("Remove property", {
  expect_no_error(myCompound$removeProperty("Solubility"))
  expect_snapshot(myCompound$print())
})


test_that("Get property value", {
  expect_error(myCompound$getProperty("PPB"))
  expect_snapshot(myCompound$getProperty("Plasma protein binding partner"))
})

test_that("Set property value", {
  expect_no_error(myCompound$setPropertyValue("Lipophilicity", 0.5))
  expect_snapshot(myCompound$getProperty("Lipophilicity"))

  # Check name
  expect_error(myCompound$setPropertyValue("Lipo", 0.5))

  # Check unit
  expect_error(myCompound$setPropertyValue("Lipophilicity", 0.5, "min"))

  # check value
  expect_error(myCompound$setPropertyValue("Lipophilicity", 15, "Log Units"))
  expect_error(myCompound$setPropertyValue("Plasma protein binding partner", "Albunim"))
})
