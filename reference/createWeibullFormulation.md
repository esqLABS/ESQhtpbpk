# Create Weibull tablet formulation

Create a Weibull formulation

## Usage

``` r
createWeibullFormulation(
  name = "Weibull",
  dissolutionTime50 = 240,
  dissolutionTime50Unit = "min",
  lagTime = 0,
  lagTimeUnit = "min",
  shape = 0.92,
  suspension = TRUE,
  path = NULL
)
```

## Arguments

- name:

  Name of the formulation to create

- dissolutionTime50:

  Time to achieve 50% dissolution (default 240)

- dissolutionTime50Unit:

  Time unit for dissolutionTime50 (default min)

- lagTime:

  lag time before dissolution starts (default 0)

- lagTimeUnit:

  Time unit for lagTime (default min)

- shape:

  dissolution shape parameter (default 0.92)

- suspension:

  Boolean, whether to use as suspension (default True)

- path:

  prefix of formulation path in the sim. NULL will defaults to
  `{protocolPrefix}|{formulationName}`

## Value

A new `Formulation` object.
