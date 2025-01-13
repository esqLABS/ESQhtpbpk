#' Load observed data sets for selected studies as `DataSet` objects
#'
#' @param studyIds List of Study IDs for which the data shoul be loaded.
#' @param studiesData Data frame with loaded studies data for all compounds
#' @param importerConfiguration Object of `ImporterConfiguration`
#'
#' @return A set of `DataSet` objects
.loadDataSetForStudies <- function(studyIds, inVivoData, importerConfiguration) {
  # Extract entries for compounds
  data <- dplyr::filter(inVivoData, `STUDY` %in% studyIds)

  # Write data into temp excel file
  filePath <- tempfile(pattern = "file", tmpdir = tempdir(), fileext = ".xlsx")
  esqlabsR:::.writeExcel(data, filePath)

  # Load data sets
  dataSets <- loadDataSetsFromExcel(
    xlsFilePath = filePath, importerConfigurationOrPath = importerConfiguration,
    importAllSheets = TRUE
  )

  return(dataSets)
}
