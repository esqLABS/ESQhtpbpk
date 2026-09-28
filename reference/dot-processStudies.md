# Process all studies in a queued manner

Process all studies in a queued manner

## Usage

``` r
.processStudies(
  studies,
  simulationsBatches,
  queueSize,
  saveSimulation,
  saveResults,
  simResultsFolder,
  plotFigures,
  numberOfCores
)
```

## Arguments

- studies:

  List of prepared studies to be processed

- queueSize:

  Max number of studies to queue before processing them

- saveSimulation:

  Boolean. If `TRUE`, the fully parameterized simulation is stored as
  .pkml.

- saveResults:

  Boolean. If `TRUE`, the simulations results will be saved as csv in a
  subfolder.

- simResultsFolder:

  Folder where the simulation results will be stored if `saveResults` is
  `TRUE`

- plotFigures:

  Boolean If `TRUE`, a plot will be created for each simulated study,
  showing all simulations results of the particular study. If observed
  data are available they will be shown on top. Default is `FALSE`.

- numberOfCores:

  number of cores to use to run the simulations batches

- simulationBatches:

  Instance of `SimulationBatch`

## Value

List of the simulation results, with names being the study IDs
