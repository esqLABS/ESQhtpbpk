# Run prediction simulations

Run prediction simulations

## Usage

``` r
runPredictions(
  studies,
  outputFolder,
  saveResults = TRUE,
  saveSimulation = FALSE,
  plotFigures = FALSE,
  numberOfCores = ospsuite::getOSPSuiteSetting("numberOfCores"),
  queueSize = 1000,
  outputSelections =
    c("Organism|PeripheralVenousBlood|**|Plasma*(Peripheral Venous Blood)"),
  simulationResolution = c(0, 10 * 24 * 60, 1/3)
)
```

## Arguments

- studies:

  list of study defined as Study objects

- outputFolder:

  folder where the results will be saved (a subfolder called DateTime
  with DateTime being the run date and time will be created).

- saveResults:

  Boolean. If `TRUE`, the simulations results will be saved as csv in a
  subfolder.

- saveSimulation:

  Boolean. If `TRUE`, the fully parameterized simulation is stored as
  .pkml. Time consuming, mainly for debugging. Default is `FALSE`.

- plotFigures:

  Boolean If `TRUE`, a plot will be created for each simulated study,
  showing all simulations results of the particular study. If observed
  data are available they will be shown on top. Default is `FALSE`.

- numberOfCores:

  number of cores to use to run the simulations batches

- queueSize:

  number of runs to queue before processing them

- outputSelections:

  list of output selections to be used for all simulations (default is
  all compounds plasma concentration in the PeripheralVenousBlood
  compartement)

- simulationResolution:

  vector of start time (min), end time (min) and resolution (pts/min)
  for all simulations
