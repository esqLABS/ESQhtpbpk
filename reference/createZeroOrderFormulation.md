# Create particle ZeroOrder formulation

Create a ZeroOrder formulation

## Usage

``` r
createZeroOrderFormulation(
  name = "ZeroOrder",
  endTime = 60,
  endTimeUnit = "min",
  path = NULL
)
```

## Arguments

- name:

  Name of the formulation to create

- endTime:

  Time of administration end (default 60)

- endTimeUnit:

  Unit for time of administration end (default min)

- path:

  prefix of formulation path in the sim. NULL will defaults to
  `{protocolPrefix}|{formulationName}`

## Value

A new `Formulation` object.
