test_that("Default compound creation works", {
  expect_no_error({
    Compound$new(ID = 1)
  })
})

myCompound <- Compound$new(ID = 1)

test_that("`print` method of compound class works", {
  expect_snapshot(myCompound$print())
})

test_that("`addProperty` method works", {
  expect_no_error(
    myCompound$addProperty(
      name = "Total Hepatic Clearance half life",
      parName = "t1/2 (microsomal assay)",
      path = "{compoundName}-Total Hepatic Clearance-In vitro microsomes Rat|t1/2 (microsomal assay)",
      dimension = "Inversed time", value = 0.1, unit = "1/min"
    )
  )
  expect_snapshot(myCompound$print())
})

test_that("`addProperty` method throws an error when adding a new property with an already existing name", {
  expect_error(
    myCompound$addProperty(
      name = "Lipophilicity",
      parName = "Lipo",
      dimension = "Log Units", value = 0.1
    )
  )
})

test_that("`removeProperty` works", {
  expect_no_error(myCompound$removeProperty("Solubility"))
  expect_snapshot(myCompound$print())
})


test_that("`getProperty` throws an error if the propety is not found", {
  expect_error(myCompound$getProperty("PPB"))
})

test_that("`getProperty` works", {
  expect_snapshot(myCompound$getProperty("Plasma protein binding partner"))
})

test_that("`setProperty` works", {
  expect_no_error(myCompound$setPropertyValue("Lipophilicity", 0.5))
  expect_snapshot(myCompound$getProperty("Lipophilicity"))
})

test_that("`setProperty` throws an error is property name is not found", {
  expect_error(myCompound$setPropertyValue("Lipo", 0.5))
})

test_that("`setProperty` throws an error if supplied units is not compatible with property dimension", {
  expect_error(myCompound$setPropertyValue("Lipophilicity", 0.5, "min"))
})

test_that("`setProperty` throws an error if supplied value is not compatible with constraints.", {
  expect_error(myCompound$setPropertyValue("Lipophilicity", 15, "Log Units"))
})

test_that("`setProperty` throws an error if supplied value is not compatible with enums", {
  expect_error(myCompound$setPropertyValue("Plasma protein binding partner", "Albunim"))
})
