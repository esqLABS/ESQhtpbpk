# Implementation details

## Generic PBPK model structure

A generic PBPK model will be automatically created for each species,
partition coefficient (PC) method, cellular permeability (CP) method, as
well as each required combination of processes for the number of
compounds used. For each generic model structure the required number of
administrations of each type covering all studies using this generic
model will be identified and added.

Note: CP calculation method “Charge dependent Schmitt normalized to
PK-Sim” is not supported as it is not properly implemented in the
current PK-Sim versions (11.3 and 12.0).

## Compound

The `Compound` class is used to create the compound object that will be
used in the studies. Several compound properties are already predefined
and can be directly used.

The predefined compound properties (with their default values) are:

``` r

compound <- Compound$new(ID = "Acetaminophen")
compound
#> • Compound Properties:
#>   • Lipophilicity: 0 Log Units
#>   • Fraction unbound: 1
#>   • Plasma protein binding partner: Albumin
#>   • Is small molecule: 1
#>   • Molecular weight: 100 g/mol
#>   • Bromine count: 0
#>   • Chlorine count: 0
#>   • Fluorine count: 0
#>   • Iodine count: 0
#>   • pKa value 0: 0
#>   • Compound type 0: Neutral
#>   • pKa value 1: 0
#>   • Compound type 1: Neutral
#>   • pKa value 2: 0
#>   • Compound type 2: Neutral
#>   • Reference pH: 7
#>   • Solubility: 1 mg/l
#> • Compound Methods:
#>   • Partition Coefficient Method: PK-Sim Standard
#>   • Cellular Permeability Method: PK-Sim Standard
```

### Compound Properties

Predefined compound properties can be easily changed with the
`setPropertyValue` method

``` r

compound$setPropertyValue("Molecular weight", 151.16, unit = "g/mol")
```

Additional compound properties can be added as needed using
`addProperty` methods (with corresponding paths when using predefined
PKML files). The property `name` serves as an alias for easy access in
the compound object. The `parName` must match the parameter name as
defined in PK-Sim.

``` r

compound$addProperty(
  name = "Pint", 
  parName = "Intestinal permeability (transcellular)",
  dimension = "Velocity",
  value = 2e-5,
  unit = "cm/min"
)

compound
#> • Compound Properties:
#>   • Lipophilicity: 0 Log Units
#>   • Fraction unbound: 1
#>   • Plasma protein binding partner: Albumin
#>   • Is small molecule: 1
#>   • Molecular weight: 151.16 g/mol
#>   • Bromine count: 0
#>   • Chlorine count: 0
#>   • Fluorine count: 0
#>   • Iodine count: 0
#>   • pKa value 0: 0
#>   • Compound type 0: Neutral
#>   • pKa value 1: 0
#>   • Compound type 1: Neutral
#>   • pKa value 2: 0
#>   • Compound type 2: Neutral
#>   • Reference pH: 7
#>   • Solubility: 1 mg/l
#>   • Pint: 2e-05 cm/min
#> • Compound Methods:
#>   • Partition Coefficient Method: PK-Sim Standard
#>   • Cellular Permeability Method: PK-Sim Standard
```

When adding property to compound and using a predefined PKML file, the
user also needs to specify the corresponding path in the PKML model.

### Compound Processes

When creating generic models automatically, the user can add processes
to the compound using the `addProcessProperty` method. This requires to
specify to which process type the parameter belongs to.

``` r

## add various processes to a compound by adding required process properties
compound$addProcessProperty(
  processType = "Liver Plasma Clearance",
  propertyName = "Plasma clearance",
  parName = "Plasma clearance",
  dimension = "Flow per weight",
  value = 0.27, 
  unit = "L/h/kg"
)

compound
#> • Compound Properties:
#>   • Lipophilicity: 0 Log Units
#>   • Fraction unbound: 1
#>   • Plasma protein binding partner: Albumin
#>   • Is small molecule: 1
#>   • Molecular weight: 151.16 g/mol
#>   • Bromine count: 0
#>   • Chlorine count: 0
#>   • Fluorine count: 0
#>   • Iodine count: 0
#>   • pKa value 0: 0
#>   • Compound type 0: Neutral
#>   • pKa value 1: 0
#>   • Compound type 1: Neutral
#>   • pKa value 2: 0
#>   • Compound type 2: Neutral
#>   • Reference pH: 7
#>   • Solubility: 1 mg/l
#>   • Pint: 2e-05 cm/min
#> • Compound Processes:
#>   • Liver Plasma Clearance
#>     • Plasma clearance: 0.27 L/h/kg
#> • Compound Methods:
#>   • Partition Coefficient Method: PK-Sim Standard
#>   • Cellular Permeability Method: PK-Sim Standard
```

## Formulations

Formulations can be defined using the various helper functions
provided: - `createDissolvedFormulation` - `createWeibullFormulation`  
- `createLint80Formulation` - `createParticleDissolutionFormulation` -
`createZeroOrderFormulation` - `createFirstOrderFormulation`

``` r

weibull_form <- createWeibullFormulation(
  name = "Weibull",
  lagTime = 30,
  lagTimeUnit = "min",
  dissolutionTime50 = 60,
  dissolutionTime50Unit = "min"
)

weibull_form
#> Formulation Name: Weibull
#> Formulation Type: Weibull
#>   • Dissolution time (50% dissolved): 60 min
#>   • Lag time: 30 min
#>   • Dissolution shape: 0.92
#>   • Use as suspension: 1
```

## Administration protocols

The `SimpleProtocol` class is used to define simple administration
protocols for the studies. If a formulation is needed it can be
associated with the protocol using the `setFormulation` method.

``` r

protocol <- SimpleProtocol$new(
  route = "Oral",
  dosingInterval = "24",
  dose = 1,
  doseUnit = "mg/kg",
  startTime = 0,
  startTimeUnit = "h",
  endTime = 48,
  endTimeUnit = "h"
)
#> Warning: No `WaterVolPerBW` provided, using default value of 3.5 ml/kg.
#> Warning: No `Formulation` provided, using default of dissolved.
#> Formulation can be changed with `protocolObject$setFormulation(formulation)`.

protocol$setFormulation(formulation = weibull_form)
protocol
#>   • Route: Oral
#>   • Dose: 1 mg/kg
#>   • Dose Interval: Once each 24 hours
#>   • Start Time: 0 h
#>   • End Time: 48 h
#>   • Volume of water per body weight: 3.5 ml/kg
#>   • Formulation: Weibull
```

Additionally, for more complex dosing strategies, advanced protocols can
be created with the `AdvancedProtocol` class. To do so, first an
advanced protocol needs to be initialized with the
`AdvancedProtocol$new` function. Then repetitions schemas need to be
defined with `addSchema` method and associated with single dose protocol
using `addProtocolToSchema` method. These will follow the schema
repetition strategy defined during the `addSchema` step.

``` r

protocol <- AdvancedProtocol$new()
protocol$addSchema(
  schemaName = "Loading Dose", 
  timeUnit = "h", 
  timeBetweenRepetitions = 0, 
  numberOfRepetitions = 1, 
  startTime = 0
)
protocol$addSchema(
  schemaName = "Maintenance Dose", 
  timeUnit = "h", 
  timeBetweenRepetitions = 12, 
  numberOfRepetitions = 5, 
  startTime = 12
)

ivLoading <- SimpleProtocol$new(route = "IV Infusion", dose = 10, doseUnit = "mg")
#> Warning: No `infusionTime` provided, using default value of 60 minutes.
ivMaintenance <- SimpleProtocol$new(route = "IV Bolus", dose = 1, doseUnit = "mg")

protocol$addProtocolToSchema(schemaName = "Loading Dose", protocol = ivLoading)
protocol$addProtocolToSchema(schemaName = "Maintenance Dose", protocol = ivMaintenance)

protocol
#> Schema: Loading Dose
#>   • Start time: 0 h
#>   • Number of repetitions: 1
#>   • Time between repetitions: 0 h
#>   Schema item 1
#>     • Route: Intravenous infusion
#>     • Dose: 10 mg
#>     • Dose Interval: Single Dose
#>     • Start Time: 0 h
#>     • Infusion Time: 60 min
#> Schema: Maintenance Dose
#>   • Start time: 12 h
#>   • Number of repetitions: 5
#>   • Time between repetitions: 12 h
#>   Schema item 1
#>     • Route: Intravenous bolus
#>     • Dose: 1 mg
#>     • Dose Interval: Single Dose
#>     • Start Time: 0 h
```
