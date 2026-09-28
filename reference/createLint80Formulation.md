# Create Lint80 tablet formulation

Create a Lint80 formulation

## Usage

``` r
createLint80Formulation(
  name = "Lint80",
  dissolutionTime80 = 240,
  dissolutionTime80Unit = "min",
  lagTime = 0,
  lagTimeUnit = "min",
  suspension = TRUE,
  path = NULL
)
```

## Arguments

- name:

  Name of the formulation to create

- dissolutionTime80:

  Time to achieve 80% dissolution (default 240)

- dissolutionTime80Unit:

  Time unit for dissolutionTime80 (default min)

- lagTime:

  lag time before dissolution starts (default 0)

- lagTimeUnit:

  Time unit for lagTime (default min)

- suspension:

  Boolean, whether to use as suspension (default True)

- path:

  prefix of formulation path in the sim. NULL will defaults to
  `{protocolPrefix}|{formulationName}`

## Value

A new `Formulation` object.
