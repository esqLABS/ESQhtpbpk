# AdvancedProtocol

Description of an advanced administration protocol

## Active bindings

- `UUID`:

  Unique identifier (read-only)

- `Name`:

  Protocol name

- `Schemas`:

  List of schemas for the advanced protocol

- `Path`:

  Prefix path for the administration to create default path, otherwise
  for custom pkmls path should be provided for each schema item protocol

- `Formulations`:

  Formulations used with protocol

- `FormulationKey`:

  Formulations Key used with protocol

## Methods

### Public methods

- [`AdvancedProtocol$new()`](#method-AdvancedProtocol-new)

- [`AdvancedProtocol$addSchema()`](#method-AdvancedProtocol-addSchema)

- [`AdvancedProtocol$addProtocolToSchema()`](#method-AdvancedProtocol-addProtocolToSchema)

- [`AdvancedProtocol$extractProtocol()`](#method-AdvancedProtocol-extractProtocol)

- [`AdvancedProtocol$getAllParameterPaths()`](#method-AdvancedProtocol-getAllParameterPaths)

- [`AdvancedProtocol$toSnapshot()`](#method-AdvancedProtocol-toSnapshot)

- [`AdvancedProtocol$print()`](#method-AdvancedProtocol-print)

- [`AdvancedProtocol$clone()`](#method-AdvancedProtocol-clone)

------------------------------------------------------------------------

### Method `new()`

Initialize a new instance of the class

#### Usage

    AdvancedProtocol$new(name = "Protocol", path = NULL)

#### Arguments

- `name`:

  Name of the protocol

- `path`:

  Prefix for the path of administration in the simulations

#### Returns

A new `AdvancedProtocol` object.

------------------------------------------------------------------------

### Method `addSchema()`

Add a schema of administration

#### Usage

    AdvancedProtocol$addSchema(
      startTime,
      numberOfRepetitions,
      timeBetweenRepetitions,
      timeUnit,
      schemaName
    )

#### Arguments

- `startTime`:

  Starting time of the schema

- `numberOfRepetitions`:

  Number of repetitions of the schema

- `timeBetweenRepetitions`:

  Time between repetitions of the schema

- `timeUnit`:

  Time unit for `startTime` and `timeBetweenRepetitions` of the schema

- `schemaName`:

  Name of the schema

#### Returns

The updated `AdvancedProtocol` object.

------------------------------------------------------------------------

### Method `addProtocolToSchema()`

Add a protocol of administration to an existing schema

#### Usage

    AdvancedProtocol$addProtocolToSchema(protocol, schemaName)

#### Arguments

- `protocol`:

  The protocol to add to the schema

- `schemaName`:

  Name of the schema to add the protocol to

#### Returns

The updated `AdvancedProtocol` object.

------------------------------------------------------------------------

### Method `extractProtocol()`

Extract all single administration to be applied by a protocol. For
easier mapping to path in the simulation pkml.

#### Usage

    AdvancedProtocol$extractProtocol(path = self$Path)

#### Arguments

- `path`:

  Prefix path for the administration.

#### Returns

A tibble with the type of administration, time of administration,
parameters of the administration and the formulation name.

------------------------------------------------------------------------

### Method `getAllParameterPaths()`

Extract all parameter paths needed to be changed in the simulation

#### Usage

    AdvancedProtocol$getAllParameterPaths(path = self$Path)

#### Arguments

- `path`:

  Prefix path for the administration.

#### Returns

A character vector with all parameter paths.

------------------------------------------------------------------------

### Method `toSnapshot()`

Convert to snapshot

#### Usage

    AdvancedProtocol$toSnapshot()

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print the object to the console

#### Usage

    AdvancedProtocol$print()

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    AdvancedProtocol$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
