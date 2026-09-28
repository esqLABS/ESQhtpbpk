# Create particle dissolution tablet formulation

Create a particle dissolution formulation

## Usage

``` r
createParticleDissolutionFormulation(
  name = "ParticleDissolution",
  thickness = 30,
  thicknessUnit = "µm",
  distributionType = "Monodisperse",
  distribution = "Normal",
  radius = 10,
  radiusUnit = "µm",
  radiusSD = 3,
  radiusCV = 1.5,
  radiusMin = 1,
  radiusMax = 19,
  nBins = 3,
  path = NULL
)
```

## Arguments

- name:

  Name of the formulation to create

- thickness:

  Thickness of unstirred water layer (default 30)

- thicknessUnit:

  Unit for thickness of unstirred water layer (default µm)

- distributionType:

  Type of distribution, either "Monodisperse" or "Polydisperse" (default
  "Monodisperse")

- distribution:

  Distribution for polydisperse type, either "Normal" or "LogNormal"
  (default "Normal")

- radius:

  Particle distribution radius, mean or geomean depending on
  distribution (default 10)

- radiusUnit:

  Unit for particle distribution radius (default µm)

- radiusSD:

  Particle distribution radius standard deviation, for polydisperse
  normal only (default 3)

- radiusCV:

  Particle distribution radius coefficient of variation, for
  polydisperse log-normal only (default 3)

- radiusMin:

  Mininum particle radius, for polydispersed only (default 1)

- radiusMax:

  Maximum particle radius, for polydispersed only (default 19)

- nBins:

  Number of bins for polydisperse only (default 3)

- path:

  prefix of formulation path in the sim. NULL will defaults to
  `{protocolPrefix}|{formulationName}`

## Value

A new `Formulation` object.
