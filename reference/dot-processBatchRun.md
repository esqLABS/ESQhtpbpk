# Process queued runs

Process queued runs

## Usage

``` r
.processBatchRun(
  simulationsBatches,
  resultsIdsMap,
  outputFolder,
  plotFigures,
  numberOfCores,
  saveResults = TRUE
)
```

## Arguments

- resultsIdsMap:

  Mapping between run id and study ids

- outputFolder:

  Folder where the simulation results will be stored if `saveResults` is
  `TRUE`

- plotFigures:

  Boolean If `TRUE`, a plot will be created for each simulated study,
  showing all simulations results of the particular study. If observed
  data are available they will be shown on top. Default is `FALSE`.

- numberOfCores:

  number of cores to use to run the simulations batches

- saveResults:

  Boolean. If `TRUE`, the simulations results will be saved as csv in a
  subfolder.

- simulationBatches:

  Instance of `SimulationBatch`

## Value

List of the simulation results, with names being the study IDs
