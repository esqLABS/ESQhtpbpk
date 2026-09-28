# Formulations

Description of a formulation

## Active bindings

- `Type`:

  Type of Formulation

- `Name`:

  Name of formulation

- `Parameters`:

  Parameters of the formulation

## Methods

### Public methods

- [`Formulation$new()`](#method-Formulation-new)

- [`Formulation$addParameter()`](#method-Formulation-addParameter)

- [`Formulation$getAllPropertyPaths()`](#method-Formulation-getAllPropertyPaths)

- [`Formulation$toSnapshot()`](#method-Formulation-toSnapshot)

- [`Formulation$print()`](#method-Formulation-print)

- [`Formulation$clone()`](#method-Formulation-clone)

------------------------------------------------------------------------

### Method `new()`

Initialize a new instance of the class Formulation

#### Usage

    Formulation$new(type, name = "Formulation")

#### Arguments

- `type`:

  Type of the formulation

- `name`:

  Name of the formulation

#### Returns

A new `Formulation` object.

------------------------------------------------------------------------

### Method `addParameter()`

Add a new property/parameter for the formulation

#### Usage

    Formulation$addParameter(
      name,
      parName,
      dimension,
      value = 0,
      unit = NULL,
      enum = NULL,
      check = NULL,
      pathPrefix = NULL
    )

#### Arguments

- `name`:

  Name of the property to add.

- `parName`:

  Corresponding parameter name of the property to add in the simulation

- `dimension`:

  Dimension of the property to add.

- `value`:

  Value for the property.

- `unit`:

  (Optional) Unit to use for the property. If not given, it is assumed
  to be the baseUnit of the dimension.

- `enum`:

  (Optional) Name list mapping user friendly values to PK-Sim allowed
  values.

- `check`:

  (Optional) Function to check the validity of the supplied value for
  the property.

- `pathPrefix`:

  Corresponding path in the simulation pkml of the property to add.
  Default to `{protocolPrefix}|{formulationName}`

------------------------------------------------------------------------

### Method `getAllPropertyPaths()`

Get the paths of all parameters defined for the formulation, using
protocolName and formulationName

#### Usage

    Formulation$getAllPropertyPaths(
      protocolPrefix = NULL,
      formulationName = self$Name
    )

#### Arguments

- `protocolPrefix`:

  Name of the protocol in the simulation

- `formulationName`:

  Name of the formulation in the simulation

#### Returns

A character vector with the paths of all parameters

------------------------------------------------------------------------

### Method `toSnapshot()`

Convert the object to a snapshot

#### Usage

    Formulation$toSnapshot()

#### Returns

A snapshot representation of the formulation

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print the object to the console

#### Usage

    Formulation$print(...)

#### Arguments

- `...`:

  Rest arguments.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Formulation$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
