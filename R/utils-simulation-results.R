#' Save simulation results to CSV files
#'
#' @param simulationResults List of simulation results already remapped
#' @param outputFolder Folder where the outputs will be written to
#' @export
.saveResults <- function(simulationResults, outputFolder) {
  for (res in names(simulationResults)) {
    outputPath <- file.path(
      outputFolder, paste0(.clearPath(res), ".csv")
    )
    tryCatch(
      {
        # Create a new folder if it does not exist
        if (!dir.exists(paths = dirname(outputPath))) {
          dir.create(path = dirname(outputPath), recursive = TRUE)
        }
        results <- simulationResults[[res]]
        if (!is.null(results)) {
          ospsuite::exportResultsToCSV(results = results, filePath = outputPath)
        }
      },
      error = function(cond) {
        warning(paste0("Cannot save to path '", dirname(outputPath), "'"))
        message("Original error message:")
        warning(cond)
      },
      warning = function(cond) {
        warning(cond)
      }
    )
  }
}

.clearPath <- function(string) {
  # Replace "\" and "/" by "_" so the file name does not result in folders
  string <- gsub(pattern = "\\", "_", string, fixed = TRUE)
  string <- gsub(pattern = "/", "_", string, fixed = TRUE)

  return(string)
}
