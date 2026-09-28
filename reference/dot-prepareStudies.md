# Prepare studies to be run

Prepare studies to be run. Create generic pkml if not set, load and
update generic simulation with output selections and simulation
resolution. Assign simulation object to studies and ensure output
selection and required path exist in simulation. Remove studies that are
not correctly set up

## Usage

``` r
.prepareStudies(studies, outputFolder, outputSelections, simulationResolution)
```

## Arguments

- studies:

  list of study defined as Study objects

- outputFolder:

  folder where the results will be saved.

- outputSelections:

  list of output selections to be used for all simulations (default is
  all compounds plasma concentration in the PeripheralVenousBlood
  compartement)

- simulationResolution:

  vector of start time (min), end time (min) and resolution (pts/min)
  for all simulations

## Value

List of prepared simulations
