# Add simulation batch run to simulation batches

Add simulation batch run to simulation batches

## Usage

``` r
.addBatchRun(
  parameterStartValues,
  simulationBatch,
  simulationName = NULL,
  outputFolder,
  saveSimulation = FALSE
)
```

## Arguments

- parameterStartValues:

  Named list with parameter values to add for the run

- simulationBatch:

  Instance of `SimulationBatch`

- simulationName:

  Name of the simulation. Only used when `saveSimulation` is ` TRUE`.
  Used for saving the simulation instance to .pkml. If `NULL`, the file
  name is composed from the ID of the simulation batch and the ID of the
  run.

- outputFolder:

  Folder where the simulation .pkml will be stored if `saveSimulation`
  is `TRUE`

- saveSimulation:

  Boolean. If `TRUE`, the fully parameterized simulation is stored as
  .pkml. Time consuming, mainly for debugging. Default is `FALSE`.

## Value

Id of the simulation batch run
