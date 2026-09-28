# Using custom PKML models with ESQhtpbpk

## Introduction

This framework enables the use of predefined PKML models for simulations
with specific requirements.

First, the package needs to be loaded:

``` r

library(ESQhtpbpk)
```

## Creating Studies

Next, the user needs to define studies to be simulated. A study
encompasses everything that is required for the simulation, protocol and
formulation for each compound administration and compound properties.

To simplify this task, various functions have been implemented in the
framework easing the creation of all required parts of a study.

Additionally, the user can create their custom function to generate a
list of all `Study` object to be simulated, tailored to their specific
data structure, as this part is highly dependent on it.

While the overall process is similar to the one used for the automatic
generation of generic models, when using predefined PKML models, the
user must take care of specifying the correct path for each property to
be updated based on their supplied PKML file.

### Example

This example shows how to create a single study. In practice, this
mechanism can be wrapped into a function to create a list of all studies
to be simulated, allowing integration with user databases or data
structure for parameter assignment.

When working with predefined PKML files, the user must provide the
correct paths for each property.

#### Compound Definition

First, the user creates a compound object using the `Compound$new()`
function and assign a unique compound ID and gives the actual name of
the compound to be updated from the predefined PKML file (here
`MyCompoundNameInPKML`)

``` r

compound <- Compound$new(ID = "Acetaminophen", name = "MyCompoundNameInPKML")
```

The compound is initialized with the main properties that are required
for the simulation. Those can be easily adjusted with the
`setPropertyValue` method.

``` r

compound$setPropertyValue("Molecular weight", 151.16, unit = "g/mol")
compound$setPropertyValue("Solubility", 4.15, unit = "mg/ml")
compound$setPropertyValue("Lipophilicity", 0.91)
compound$setPropertyValue("pKa value 0", 9.46)
compound$setPropertyValue("Compound type 0", "Acidic")
compound$setPropertyValue("Fraction unbound", 80, unit = "%")
```

To add additional processes related properties when using predefined
PKML files, the user can simply used the `addProperty` method (instead
of `addProcessProperty`) while providing the correct path in the
predefined PKML model.

``` r

compound$addProperty(
  name = "THC - Plasma clearance", 
  path = "MyCompoundNameInPKML-Total Hepatic Clearance-Liver Plasma Clearance|Plasma clearance",
  parName = "THC - Plasma clearance",
  dimension = "Flow per weight",
  value = 0.27,
  unit = "L/h/kg"
)
compound$addProperty(
  name = "THC - Lipo", 
  path = "MyCompoundNameInPKML-Total Hepatic Clearance-Liver Plasma Clearance|Lipophilicity (experiment)",
  parName = "THC - Lipo",
  dimension = "Log Units",
  value = 0.91
)
compound$addProperty(
  name = "THC - Fu", 
  path = "MyCompoundNameInPKML-Total Hepatic Clearance-Liver Plasma Clearance|Fraction unbound (experiment)",
  parName = "THC - Fu",
  dimension = "Fraction",
  value = 80,
  unit = "%"
)
```

The defined compound can be visualized for verification:

``` r

compound
#> • Compound Properties:
#>   • Lipophilicity: 0.91 Log Units
#>   • Fraction unbound: 80 %
#>   • Plasma protein binding partner: Albumin
#>   • Is small molecule: 1
#>   • Molecular weight: 151.16 g/mol
#>   • Bromine count: 0
#>   • Chlorine count: 0
#>   • Fluorine count: 0
#>   • Iodine count: 0
#>   • pKa value 0: 9.46
#>   • Compound type 0: Acidic
#>   • pKa value 1: 0
#>   • Compound type 1: Neutral
#>   • pKa value 2: 0
#>   • Compound type 2: Neutral
#>   • Reference pH: 7
#>   • Solubility: 4.15 mg/ml
#>   • THC - Plasma clearance: 0.27 L/h/kg
#>   • THC - Lipo: 0.91 Log Units
#>   • THC - Fu: 80 %
#> • Compound Methods:
#>   • Partition Coefficient Method: PK-Sim Standard
#>   • Cellular Permeability Method: PK-Sim Standard
```

The partition coefficient and cellular permeability methods are set by
default but not used in the case of a predefined PKML model, as it is
already defined in the supplied model and cannot be modified.

#### Administration Definition

Administration protocol can be defined, but again, the corresponding
path in the PKML model must be specified.

If multiple administrations are defined in the PKML model (e.g. 10 oral
administrations are allowed in the PKML model), then the user should
supply all relevant administration paths. Only the ones needed will be
used in the simulation.

``` r

protocol <- SimpleProtocol$new(
  route = "Oral",
  dosingInterval = "24",
  dose = 1,
  doseUnit = "mg/kg",
  startTime = 0,
  startTimeUnit = "h",
  endTime = 48,
  endTimeUnit = "h", 
  path = paste0("Events|MyAdminNameInPKML|Application_", 1:10), 
)        
#> Warning: No `WaterVolPerBW` provided, using default value of 3.5 ml/kg.
#> Warning: No `Formulation` provided, using default of dissolved.
#> Formulation can be changed with `protocolObject$setFormulation(formulation)`.
```

Formulations can be defined the same way as for the automatic generation
of generic models, but the user must supply the correct path to the
formulation in the PKML model and also associate it to the protocol.

``` r

formulation <- createWeibullFormulation(
  name = "Weibull",
  lagTime = 30,
  lagTimeUnit = "min",
  dissolutionTime50 = 60,
  dissolutionTime50Unit = "min",
  path = "Events|MyAdminNameInPKML|MyFormNameInPKML",
)

protocol$setFormulation(formulation = formulation)
```

The defined protocol can be visualized:

``` r

protocol
#>   • Route: Oral
#>   • Dose: 1 mg/kg
#>   • Dose Interval: Once each 24 hours
#>   • Start Time: 0 h
#>   • End Time: 48 h
#>   • Volume of water per body weight: 3.5 ml/kg
#>   • Formulation: Weibull
```

The protocol is then associated with the compound:

``` r

compound$setProtocol(protocol)
```

The user should make sure that all the supplied paths are indeed
consistent with the PKML model, and if not correct them before
proceeding.

``` r

compound$getAllPropertyPaths()
#>  [1] "MyCompoundNameInPKML|Lipophilicity"                                                               
#>  [2] "MyCompoundNameInPKML|Fraction unbound (plasma, reference value)"                                  
#>  [3] "MyCompoundNameInPKML|Plasma protein binding partner"                                              
#>  [4] "MyCompoundNameInPKML|Is small molecule"                                                           
#>  [5] "MyCompoundNameInPKML|Molecular weight"                                                            
#>  [6] "MyCompoundNameInPKML|Br"                                                                          
#>  [7] "MyCompoundNameInPKML|Cl"                                                                          
#>  [8] "MyCompoundNameInPKML|F"                                                                           
#>  [9] "MyCompoundNameInPKML|I"                                                                           
#> [10] "MyCompoundNameInPKML|pKa value 0"                                                                 
#> [11] "MyCompoundNameInPKML|Compound type 0"                                                             
#> [12] "MyCompoundNameInPKML|pKa value 1"                                                                 
#> [13] "MyCompoundNameInPKML|Compound type 1"                                                             
#> [14] "MyCompoundNameInPKML|pKa value 2"                                                                 
#> [15] "MyCompoundNameInPKML|Compound type 2"                                                             
#> [16] "MyCompoundNameInPKML|Reference pH"                                                                
#> [17] "MyCompoundNameInPKML|Solubility at reference pH"                                                  
#> [18] "MyCompoundNameInPKML-Total Hepatic Clearance-Liver Plasma Clearance|Plasma clearance"             
#> [19] "MyCompoundNameInPKML-Total Hepatic Clearance-Liver Plasma Clearance|Lipophilicity (experiment)"   
#> [20] "MyCompoundNameInPKML-Total Hepatic Clearance-Liver Plasma Clearance|Fraction unbound (experiment)"
#> [21] "Events|MyAdminNameInPKML|Application_1|ProtocolSchemaItem|DosePerBodyWeight"                      
#> [22] "Events|MyAdminNameInPKML|Application_1|ProtocolSchemaItem|Start time"                             
#> [23] "Events|MyAdminNameInPKML|Application_1|ProtocolSchemaItem|Volume of water/body weight"            
#> [24] "Events|MyAdminNameInPKML|Application_2|ProtocolSchemaItem|DosePerBodyWeight"                      
#> [25] "Events|MyAdminNameInPKML|Application_2|ProtocolSchemaItem|Start time"                             
#> [26] "Events|MyAdminNameInPKML|Application_2|ProtocolSchemaItem|Volume of water/body weight"            
#> [27] "Events|MyAdminNameInPKML|MyFormNameInPKML|Dissolution time (50% dissolved)"                       
#> [28] "Events|MyAdminNameInPKML|MyFormNameInPKML|Lag time"                                               
#> [29] "Events|MyAdminNameInPKML|MyFormNameInPKML|Dissolution shape"                                      
#> [30] "Events|MyAdminNameInPKML|MyFormNameInPKML|Use as suspension"
```

#### Study definition

Finally, the user creates the study object with the `Study$new()`
function. The user must supply the path to the PKML file to be used for
the simulation.

``` r

study <- Study$new(ID = "Acetaminophen_PO_QD", compounds = list(compound), 
                   genericModel = "path/to/your/pkml/MyGenericPKML.pkml")
```

Note: An individual is not needed in this case, as it is already defined
in the PKML file.

## Running the studies

Once the user has created the list of studies to be simulated, the
simulations can be run using the `runPredictions` function. All
simulations results can be saved under a `SimulationResults`
time-stamped subfolder by setting the `saveResults` parameter to `TRUE`.
Additionally the user can save the update PKML files for each study with
the `saveSimulation` parameter.

During this step the user should also defined the output paths to be
simulated with the `outputSelections` parameter, as well as the
`simulationResolution` defined by
`c(start time (min), end time (min), resolution in pts/min)` to cover
the longest simulation needed with the wanted time resolution.

Additionally, the user can also define the number of cores to be used
for the simulations and the number studies to be queued (which can be
needed to reduce the memory usage).

``` r

myresult <- runPredictions(
    studies = list(study), 
    outputFolder = "HT-PBPK",
    numberOfCores = 5,
    outputSelections = c("Organism|PeripheralVenousBlood|**|Plasma (Peripheral Venous Blood)"),
    simulationResolution = c(0, 10 * 24 * 60, 1),
    saveResults = TRUE,
    saveSimulation = FALSE,
    queueSize = 200
  )
```
