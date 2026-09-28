# Get parameter start values for the given scenario

Get parameter start values for the given scenario

## Usage

``` r
.getParameterStartValues(parametersPaths, study, simulation)
```

## Arguments

- parametersPaths:

  Paths of variable parameters to update in the simulation batch

- study:

  A `Study` object

- simulation:

  A `Simulation` object used for retrieving missing values

## Value

`parameterStartValues` updated with values defined in the `Study` object
