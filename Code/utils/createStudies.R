#' Create studies
#'
#' @param scenarios `Scenario` objects. The simulation time will be changed for
#' the `Simulation` of each scenario based on the study duration.
#' @param projectConfiguration A `ProjectConfiguration` object.
#'
#' @return
#' @export
#'
#' @examples
createStudies <- function(scenarios, projectConfiguration) {
  # 2DO make species an argument
  species <- "Rat"

  # Load the data file
  dataCompoundProperties <- readExcel(projectConfiguration$dataFile, sheet = "Compound_Properties")
  dataADMEProperties <- readExcel(projectConfiguration$dataFile, sheet = "ADME_Properties")
  dataEXPPk <- readExcel(projectConfiguration$dataFile, sheet = "EXP_PK")

  # Remove duplicate time entries
  dataEXPPk <- distinct(dataEXPPk, `COMPOUND_ID`, `STUDY`, `SPECIES`, `GENDER`, `TREATMENTDESC`, `TIME`, `TIME_UNIT`, .keep_all = TRUE)

  # Create a Study object for each study defined in the excel file
  # 2DO filter for multiple species, if species is provided as a list
  studyIds <- unique(dataEXPPk$STUDY[dataEXPPk$SPECIES == species])
  studies <- lapply(
    studyIds,
    \(studyId){
      # Create the compound for the study
      compound <- .createCompound(dataEXPPk$COMPOUND_ID[dataEXPPk$STUDY == studyId][1], dataCompoundProperties, dataADMEProperties)
      # If the compound could not be created, skip and do not create the study
      if (is.null(compound)) {
        return()
      }

      study <- Study$new(
        ID = studyId,
        compound = compound
      )
      study$Species <- dataEXPPk$SPECIES[dataEXPPk$STUDY == studyId][1]

      study$administrationProtocol <- AdministrationProtocol$new(
        path = "Applications|All_Routes",
        # route = dataEXPPk$ROUTE[dataEXPPk$STUDY == studyId][1],
        route = "IV Bolus",
        dose = dataEXPPk$DOSE[dataEXPPk$STUDY == studyId][1],
        doseUnit = dataEXPPk$DOSE_UNIT[dataEXPPk$STUDY == studyId][1],
        numberOfRepetitions = 1,
        timeBetweenRepetitions = 0
      )

      # Add observed data
      # 2DO currently, only one compound per study is supported
      dataSets <- .loadDataSetForStudies(
        studyId, dataEXPPk,
        projectConfiguration$dataImporterConfigurationFile
      )
      # set the mw of the data set
      tmp <- sapply(dataSets, \(dataSet) {
        dataSet$molWeight <- toUnit(quantityOrDimension = ospDimensions$`Molecular weight`, values = compound$get_MW()$toBaseUnit(), targetUnit = ospUnits$`Molecular weight`$`g/mol`)
      })
      rm(tmp)
      study$addDataSets(dataSets)

      return(study)
    }
  )
  names(studies) <- studyIds
  # Remove NULL entries
  studies <- studies[!sapply(studies, is.null)]

  # Update simulation time based on the study duration
  simTime <- max(dataEXPPk$TIME)
  timeUnit <- dataEXPPk$TIME_UNIT[[which(dataEXPPk$TIME == simTime)[[1]]]]
  # Convert to base unit
  simTime <- ospsuite::toBaseUnit(ospDimensions$Time, simTime, unit = timeUnit)
  for (scenario in scenarios) {
    ospsuite::setOutputInterval(scenario$simulation,
      startTime = 0,
      endTime = simTime, resolution = 1
    )
  }

  return(studies)
}


#'
#' Create a `Compound` from the data
#'
#' 2DO filter for multiple species, if species is provided as a list
#'
#' @param compoundId
#' @param dataCompoundProperties
#' @param dataADMEProperties
#'
#' @return A `Compound` object, `NULL` if the compound could not be created
.createCompound <- function(compoundId, dataCompoundProperties, dataADMEProperties) {
  compound <- Compound$new(
    ID = compoundId
  )

  ### First read the values from the specific structure and proces them
  # Use logD_Lipophilicity for lipophilicity value. Only use LOGD_MOKA if logD_Lipophilicity is not available
  lipValue <- dataCompoundProperties[dataCompoundProperties$COMPOUND_ID == compoundId & dataCompoundProperties$PREDICTION_ENDPOINT == "logD_Lipophilicity", ]$RESULT_NUMERIC
  if (length(lipValue) == 0 || is.na(lipValue)) {
    lipValue <- dataCompoundProperties[dataCompoundProperties$COMPOUND_ID == compoundId & dataCompoundProperties$PREDICTION_ENDPOINT == "LOGD_MOKA", ]$RESULT_NUMERIC
  }

  if (length(lipValue) == 0 || is.na(lipValue)) {
    print(messages$valueNotAvailable(compoundId, "Lipophilicity"))
    return(NULL)
  }

  # If reported binding is >= 100%, set fraction unbound to 0.01%
  fu <- 100 - dataADMEProperties[dataADMEProperties$COMPOUND_ID == compoundId & dataADMEProperties$PREDICTION_ENDPOINT == "Plasma_Protein_Binding", ]$RESULT_NUMERIC
  if (length(fu) == 0 || is.na(fu)) {
    print(messages$valueNotAvailable(compoundId, "Fraction unbound"))
    return(NULL)
  }
  if (fu <= 0) {
    fu <- 0.01
  }
  fuUnit <- ospUnits$Fraction$`%`

  mw <- dataCompoundProperties[dataCompoundProperties$COMPOUND_ID == compoundId & dataCompoundProperties$PREDICTION_ENDPOINT == "MW", ]$RESULT_NUMERIC
  if (length(mw) == 0 || is.na(mw)) {
    print(messages$valueNotAvailable(compoundId, "Molecular Weight"))
    return(NULL)
  }
  mwUnit <- dataCompoundProperties[dataCompoundProperties$COMPOUND_ID == compoundId & dataCompoundProperties$PREDICTION_ENDPOINT == "MW", ]$RESULT_UNIT

  isSmallMolecule <- dataCompoundProperties[dataCompoundProperties$COMPOUND_ID == compoundId, ]$MOLECULE_TYPE[[1]]
  if (isSmallMolecule == "small molecule") {
    isSmallMolecule <- TRUE
  } else {
    isSmallMolecule <- FALSE
  }

  br <- dataCompoundProperties[dataCompoundProperties$COMPOUND_ID == compoundId & dataCompoundProperties$PREDICTION_ENDPOINT == "Br", ]$RESULT_NUMERIC
  if (length(br) == 0 || is.na(br)) {
    br <- 0
  }
  cl <- dataCompoundProperties[dataCompoundProperties$COMPOUND_ID == compoundId & dataCompoundProperties$PREDICTION_ENDPOINT == "Cl", ]$RESULT_NUMERIC
  if (length(cl) == 0 || is.na(cl)) {
    cl <- 0
  }
  f <- dataCompoundProperties[dataCompoundProperties$COMPOUND_ID == compoundId & dataCompoundProperties$PREDICTION_ENDPOINT == "F", ]$RESULT_NUMERIC
  if (length(f) == 0 || is.na(f)) {
    f <- 0
  }
  i <- dataCompoundProperties[dataCompoundProperties$COMPOUND_ID == compoundId & dataCompoundProperties$PREDICTION_ENDPOINT == "I", ]$RESULT_NUMERIC
  if (length(i) == 0 || is.na(i)) {
    i <- 0
  }

  # Get all entries for basic or acidic pka
  pKas <- dataCompoundProperties[dataCompoundProperties$COMPOUND_ID == compoundId & (dataCompoundProperties$PREDICTION_ENDPOINT == "Basic_pKa" | dataCompoundProperties$PREDICTION_ENDPOINT == "Acidic_pKa"), ]
  # ITERATE THROUGH PKAs and add up to three values
  # Not a clean solution
  compoundTypes <- vector("numeric", 3)
  compoundTypeValues <- vector("numeric", 3)
  if (dim(pKas)[[1]] > 0) {
    for (i in 1:min(3, dim(pKas)[[1]])) {
      compoundType <- pKas[i, ]$PREDICTION_ENDPOINT
      compoundTypeValues[[i]] <- pKas[i, ]$RESULT_NUMERIC

      if (compoundType == "Basic_pKa") {
        compoundTypes[[i]] <- 1
      } else {
        compoundTypes[[i]] <- -1
      }
    }
  }
  solubility <- dataCompoundProperties[dataCompoundProperties$COMPOUND_ID == compoundId & dataCompoundProperties$PREDICTION_ENDPOINT == "Solubility", ]$RESULT_NUMERIC
  if (length(solubility) == 0 || is.na(solubility)) {
    print(messages$valueNotAvailable(compoundId, "Solubility"))
    return(NULL)
  }
  solubilityUnit <- dataCompoundProperties[dataCompoundProperties$COMPOUND_ID == compoundId & dataCompoundProperties$PREDICTION_ENDPOINT == "Solubility", ]$RESULT_UNIT
  # Solubility is given in molar concentration and must be converted mass concentration
  solubility <- ospsuite::toUnit(
    quantityOrDimension = ospDimensions$`Concentration (mass)`,
    values = solubility,
    targetUnit = ospsuite::ospUnits$`Concentration [mass]`$`mg/ml`,
    sourceUnit = solubilityUnit,
    molWeight = mw,
    molWeightUnit = ospsuite::ospUnits$`Molecular weight`$`g/mol`
  )
  solubilityUnit <- ospsuite::ospUnits$`Concentration [mass]`$`mg/ml`

  # Intestinal permeability
  pInt <- dataCompoundProperties[dataCompoundProperties$COMPOUND_ID == compoundId & dataCompoundProperties$PREDICTION_ENDPOINT == "Caco2-TC7_Permeability", ]$RESULT_NUMERIC
  pInt_unit <- dataCompoundProperties[dataCompoundProperties$COMPOUND_ID == compoundId & dataCompoundProperties$PREDICTION_ENDPOINT == "Caco2-TC7_Permeability", ]$RESULT_UNIT
  # if intestinal permeability is defined, create a compound property for it
  if (!(length(pInt) == 0 || is.na(pInt))) {
    compound$set_pInt(value = pInt, unit = pInt_unit)
  }

  # Get the clearance half life
  halfLife <- dataADMEProperties[dataADMEProperties$COMPOUND_ID == compoundId & dataADMEProperties$PREDICTION_ENDPOINT == "Microsomal_Half_Life_Full", ]$RESULT_NUMERIC
  if (length(halfLife) == 0 || is.na(halfLife)) {
    halfLife <- dataADMEProperties[dataADMEProperties$COMPOUND_ID == compoundId & dataADMEProperties$PREDICTION_ENDPOINT == "Microsomal_Half_Life_Single", ]$RESULT_NUMERIC
  }
  if (length(halfLife) == 0 || is.na(halfLife)) {
    print(messages$valueNotAvailable(compoundId, "Half life"))
    halfLife <- 0
  }
  halfLifeUnit <- dataADMEProperties[dataADMEProperties$COMPOUND_ID == compoundId & dataADMEProperties$PREDICTION_ENDPOINT == "Microsomal_Half_Life_Full", ]$RESULT_UNIT


  ### Set the values in the Compound.
  compound$set_lipophilicity(lipValue)
  compound$set_fractionUnbound(fu, unit = fuUnit)
  # ppb partner is always Albumin
  compound$set_MW(mw, mwUnit)
  compound$set_isSmallMolecule(isSmallMolecule)
  compound$set_Br(br)
  compound$set_Cl(cl)
  compound$set_F(f)
  compound$set_I(i)
  compound$set_compoundType0(compoundTypes[[1]])
  compound$set_compoundType1(compoundTypes[[2]])
  compound$set_compoundType2(compoundTypes[[3]])
  compound$set_pKa0(compoundTypeValues[[1]])
  compound$set_pKa1(compoundTypeValues[[2]])
  compound$set_pKa2(compoundTypeValues[[3]])
  # Reference pH is always 7
  compound$set_solubility(solubility, unit = solubilityUnit)
  # Add the clearance property
  compound$addProperty(
    name = "Total Hepatic Clearance half life",
    path = "Compound-Total Hepatic Clearance-In vitro microsomes Rat|t1/2 (microsomal assay)",
    dimension = ospDimensions$Time,
    value = halfLife,
    unit = halfLifeUnit
  )
  # Set the lipophilicity value in the clearance reaction
  compound$addProperty(
    name = "Lipophilicity for clearance calculation",
    path = "Compound-Total Hepatic Clearance-In vitro microsomes Rat|Lipophilicity (experiment)",
    dimension = ospDimensions$`Log Units`,
    value = lipValue
  )

  # Add glomerular filtration. Assumption of GFR fraction of 1 for small molecules
  # and 0 for large molecules
  if (compound$get_isSmallMolecule()) {
    gfrFraction <- 1
  } else {
    gfrFraction <- 0
  }
  compound$addProperty(
    name = "GFR Fraction",
    path = "Neighborhoods|Kidney_pls_Kidney_ur|Compound|Glomerular Filtration-GFR Rat|GFR fraction",
    dimension = ospDimensions$Fraction,
    value = gfrFraction
  )

  return(compound)
}
