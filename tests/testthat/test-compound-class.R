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
      dimension = "Inversed time",
      value = 0.1,
      unit = "1/min"
    )
  )
  expect_snapshot(myCompound$print())
})

test_that("`addProperty` method throws an error when adding a new property with an already existing name", {
  expect_error(
    myCompound$addProperty(
      name = "Lipophilicity",
      parName = "Lipo",
      dimension = "Log Units",
      value = 0.1
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

test_that("`getAllProperty` works ", {
  expect_snapshot(myCompound$getAllProperty())
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
  expect_error(myCompound$setPropertyValue(
    "Plasma protein binding partner",
    "Albunim"
  ))
})


test_that("`addProcessProperty` method works", {
  expect_no_error(
    myCompound$addProcessProperty(
      processType = "Liver Mic T1/2",
      propertyName = "Thalf",
      parName = "t1/2 (microsomal assay)",
      dimension = "Time",
      value = 0.1,
      unit = "min"
    )
  )
  expect_snapshot(myCompound$print())
})

test_that("`addProcessProperty` method throws an error when adding a new property with an already existing name", {
  expect_error(
    myCompound$addProcessProperty(
      processType = "Liver Mic T1/2",
      propertyName = "Thalf",
      parName = "t1/2 (microsomal assay)",
      dimension = "Time",
      value = 0.1,
      unit = "min"
    )
  )
})

test_that("`addProcessProperty` method throws an error when adding property to a wrong process type", {
  expect_error(
    myCompound$addProcessProperty(
      processType = "Liver Mic",
      propertyName = "Thalf",
      parName = "t1/2 (microsomal assay)",
      dimension = "Time",
      value = 0.1,
      unit = "min"
    )
  )
})

test_that(
  desc = paste(
    "`addProcessProperty` method throws an error when adding property multiple",
    "processes of the same type (e.g. hepatic clearance)"
  ),
  code = {
    expect_error(
      myCompound$addProcessProperty(
        processType = "Liver Plasma Clearance",
        propertyName = "CL",
        parName = "plasma clearance",
        dimension = "Flow per weight",
        value = 10,
        unit = "ml/min/kg"
      )
    )
  }
)


test_that("`removeProcessProperty` works", {
  myCompound$addProcessProperty(
    processType = "Liver Mic T1/2",
    propertyName = "Fu assay",
    parName = "Fraction unbound (assay)",
    dimension = "Fraction",
    value = 0.5,
    unit = ""
  )
  expect_no_error(myCompound$removeProcessProperty(
    processType = "Liver Mic T1/2",
    propertyName = "Thalf"
  ))
  expect_snapshot(myCompound$print())
})


test_that("`getProcessProperty` throws an error if the property is not found", {
  myCompound$addProcessProperty(
    processType = "Liver Mic T1/2",
    propertyName = "Thalf",
    parName = "t1/2 (microsomal assay)",
    dimension = "Time",
    value = 0.1,
    unit = "min",
    check = function(value, unit) {
      if (value < 0) {
        stop("Value must be positive")
      }
    }
  )
  expect_error(myCompound$getProcessProperty(
    processType = "Liver Mic T1/2",
    propertyName = "PPB"
  ))
  expect_error(myCompound$getProcessProperty(
    processType = "Liver Mic",
    propertyName = "Thalf"
  ))
})

test_that("`getProcessProperty` works", {
  expect_snapshot(
    myCompound$getProcessProperty(
      propertyName = "Thalf",
      processType = "Liver Mic T1/2"
    )
  )
})

test_that("`getAllProcessProperty` works", {
  expect_snapshot(
    myCompound$getAllProcessProperty(processType = "Liver Mic T1/2")
  )
})

test_that("`getAllProcessProperty` throws an error if the property is not found", {
  expect_error(
    myCompound$getAllProcessProperty(processType = "Liver Mic"),
    "not found"
  )
})

test_that("`getAllProcessProperty` works", {
  expect_snapshot(
    myCompound$getAllProcessProperty()
  )
})

test_that("`setProcessProperty` works", {
  expect_no_error(
    myCompound$setProcessPropertyValue(
      propertyName = "Thalf",
      processType = "Liver Mic T1/2",
      value = 0.5
    )
  )
  expect_snapshot(
    myCompound$getProcessProperty(
      propertyName = "Thalf",
      processType = "Liver Mic T1/2"
    )
  )
})

test_that("`setProcessProperty` throws an error when removing unknown thinks or setting wrong values", {
  expect_error(
    myCompound$setProcessPropertyValue(
      propertyName = "T1/2",
      processType = "Liver Mic T1/2",
      value = 0.5
    )
  )
  expect_error(
    myCompound$setProcessPropertyValue(
      propertyName = "Thalf",
      processType = "Liver Mic",
      value = 0.5
    )
  )
  expect_error(
    myCompound$setProcessPropertyValue(
      propertyName = "Thalf",
      processType = "Liver Mic T1/2",
      value = 0.5,
      unit = "l"
    )
  )
  expect_error(
    myCompound$setProcessPropertyValue(
      propertyName = "Thalf",
      processType = "Liver Mic T1/2",
      value = -5
    )
  )
})

test_that("`getAllPropertyPaths` works", {
  expect_snapshot(myCompound$getAllPropertyPaths())
})

test_that("`removeProcess` method works", {
  expect_no_message(
    myCompound$removeProcess(
      processType = "Liver Mic T1/2"
    )
  )
})

test_that("`removeProcess` method throws an error when removing an unexisting processType", {
  expect_error(
    myCompound$removeProcess(
      processType = "Liver Mic"
    )
  )
})
