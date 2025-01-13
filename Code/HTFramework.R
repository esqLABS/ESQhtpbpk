### This script initializes and sets up the framework for HT-PBPK predictions.
### It must be called before running the predictions.

# load needed packages
library(esqlabsR, quietly = TRUE)
library(uuid, quietly = TRUE)
library(pracma)
library(readr)

## Source the required scripts and create a project configuration
sourceAll(file.path(getwd(), "utils"))
projectConfiguration <- esqlabsR::createDefaultProjectConfiguration("../ProjectConfiguration.xlsx")

#### FRAMEWORK INPUTS####
##### PC_CP methods#####
# Specify combinations of partitioning coefficients (PC) and cellular permeabilities (CP)
# calculation methods
# Comment out methods that should not be simulated
# If NULL, all scenarios defined in the `Scenarios.xlsx` will be loaded.
scenarioNames <- NULL
scenarioNames <- c(
  "Rat_SM_Berezh_PKSim",
  "Rat_SM_Berezh_Schmitt"
  # "Rat_SM_PKSim_PKSim",
  # "Rat_SM_PKSim_Schmitt",
  # "Rat_SM_RR_PKSim",
  # "Rat_SM_RR_Schmitt",
  # "Rat_SM_Schmitt_PKSim",
  # "Rat_SM_Schmitt_Schmitt",
  # "Rat_SM_PT_PKSim",
  # "Rat_SM_PT_Schmitt"
)
# If `saveSimulations` is `TRUE`, a fully parametrized simulation will be saved
# as pkml for each scenario.
saveSimulation <- FALSE
# If `plotFigures` is `TRUE`, a plot will be created for each simulated study and
# stored in the results folder. TIME CONSUMING
plotFigures <- TRUE

# Initialize the HT-PBPK framework by loading the simulations
scenarios <- initHTFramework(projectConfiguration, scenarioNames)

#### Call after initialization
studies <- createStudies(scenarios, projectConfiguration)
runPredictions(
  studies = studies,
  scenarios = scenarios,
  outputFolder = projectConfiguration$outputFolder,
  saveSimulation = saveSimulation,
  plotFigures = plotFigures
)
