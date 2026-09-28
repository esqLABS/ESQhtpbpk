# Create particle FirstOrder formulation

Create a FirstOrder formulation

## Usage

``` r
createFirstOrderFormulation(
  name = "FirstOrder",
  tHalf = 0.01,
  tHalfUnit = "min",
  path = NULL
)
```

## Arguments

- name:

  Name of the formulation to create

- tHalf:

  Half-life of the drug release process (default 0.01)

- tHalfUnit:

  Unit of half-life of the drug release process (default min)

- path:

  prefix of formulation path in the sim. NULL will defaults to
  `{protocolPrefix}|{formulationName}`

## Value

A new `Formulation` object.
