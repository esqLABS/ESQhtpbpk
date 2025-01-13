#' Initialize HT-PBPK framework
#'
#' @description Initialize the HT-PBPK framework by loading the simulations
#'
#' @param projectConfiguration A `ProjectConfiguration` object.
#'
#' @return
#' @export
#'
#' @examples
initHTFramework <- function(projectConfiguration, scenarioNames = NULL) {
  # Create `ScenarioConfiguration` objects from excel files
  scenarioConfigurations <- esqlabsR::readScenarioConfigurationFromExcel(
    scenarioNames = scenarioNames,
    projectConfiguration = projectConfiguration
  )

  # Adjust simulation run options, if necessary.
  # E.g. disable check for negative values if required
  simulationRunOptions <- SimulationRunOptions$new()
  # simulationRunOptions$checkForNegativeValues <- FALSE
  # Create scenarios
  scenarios <- esqlabsR::createScenarios(scenarioConfigurations = scenarioConfigurations)

  return(scenarios)
}
