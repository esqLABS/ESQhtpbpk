# AdministrationProtocol

Description of an administration protocol

## Active bindings

- `UUID`:

  Unique identifier (read-only)

- `Route`:

  Route of administration

- `DoseInterval`:

  Dosing interval

- `Dose`:

  Dose

- `DoseUnit`:

  Dose unit

- `StartTime`:

  Starting time of administration

- `StartTimeUnit`:

  Time unit of administration starting time

- `EndTime`:

  End time of administration

- `EndTimeUnit`:

  Time unit of administration end time

- `InfusionTime`:

  Duration of infusion

- `InfusionTimeUnit`:

  Time unit of infusion duration

- `WaterVolPerBW`:

  Water volume per body weight

- `WaterVolPerBWUnit`:

  Unit or water volume per body weight

- `Path`:

  Prefix path for the administration (if multiple admin give a vector of
  all available paths)

- `Name`:

  Protocol name for the administration

- `Formulation`:

  Formulation to use with protocol

- `FormulationKey`:

  FormulationKey mapping of the protocol

## Methods

### Public methods

- [`SimpleProtocol$new()`](#method-SimpleProtocol-new)

- [`SimpleProtocol$setFormulation()`](#method-SimpleProtocol-setFormulation)

- [`SimpleProtocol$extractProtocol()`](#method-SimpleProtocol-extractProtocol)

- [`SimpleProtocol$getAllParameterPaths()`](#method-SimpleProtocol-getAllParameterPaths)

- [`SimpleProtocol$toSnapshot()`](#method-SimpleProtocol-toSnapshot)

- [`SimpleProtocol$print()`](#method-SimpleProtocol-print)

- [`SimpleProtocol$clone()`](#method-SimpleProtocol-clone)

------------------------------------------------------------------------

### Method `new()`

Initialize a new instance of the class

#### Usage

    SimpleProtocol$new(
      name = "Protocol",
      path = NULL,
      route = "IV Bolus",
      dosingInterval = "Single",
      dose = 0,
      doseUnit = "mg/kg",
      startTime = 0,
      startTimeUnit = "h",
      endTime = NULL,
      endTimeUnit = NULL,
      infusionTime = NULL,
      infusionTimeUnit = NULL,
      waterVolPerBW = NULL,
      waterVolPerBWUnit = NULL
    )

#### Arguments

- `name`:

  Protocol name for the path of administration in the simulations

- `path`:

  Prefix for the path of administration in the simulations. (Defaults to
  Events\|protocolName)

- `route`:

  Route of administration

- `dosingInterval`:

  Dosing interval

- `dose`:

  Dose

- `doseUnit`:

  Unit of dose

- `startTime`:

  Starting time of administration

- `startTimeUnit`:

  Time unit of administration starting time

- `endTime`:

  End time of administration

- `endTimeUnit`:

  Time unit of administration end time

- `infusionTime`:

  Infusion duration (for IV infusion)

- `infusionTimeUnit`:

  Time unit of infusion duration (for IV infusion )

- `waterVolPerBW`:

  Water volume per body weight (for oral administration)

- `waterVolPerBWUnit`:

  Unit of water volume per body weight (for oral administration)

#### Returns

A new `SimpleProtocol` object.

------------------------------------------------------------------------

### Method `setFormulation()`

Add a formulation to oral or user defined protocol

#### Usage

    SimpleProtocol$setFormulation(formulation)

#### Arguments

- `formulation`:

  Formulation to add to the protocol

#### Returns

The updated `SimpleProtocol` object.

------------------------------------------------------------------------

### Method `extractProtocol()`

Extract all single administration to be applied by a protocol. For
easier mapping to path in the simulation pkml.

#### Usage

    SimpleProtocol$extractProtocol()

#### Returns

A tibble with the type of administration, time of administration,
parameters of the administration and the formulation name.

------------------------------------------------------------------------

### Method `getAllParameterPaths()`

Extract all parameter paths needed to be changed in the simulation

#### Usage

    SimpleProtocol$getAllParameterPaths(path = self$Path)

#### Arguments

- `path`:

  Prefix path for the administration (if multiple admin give a vector of
  all available paths)

#### Returns

A character vector with all parameter paths.

------------------------------------------------------------------------

### Method `toSnapshot()`

Convert to snapshot

#### Usage

    SimpleProtocol$toSnapshot()

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print the object to the console

#### Usage

    SimpleProtocol$print()

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    SimpleProtocol$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
