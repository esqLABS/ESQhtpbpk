# Property

Property of a compound, of a formulation

## Active bindings

- `name`:

  Name of the property

- `dimension`:

  Dimension of the property

- `value`:

  Value of the property.

- `unit`:

  Unit of the property

- `parName`:

  Parameter name of the property in the simulation pkmls

- `path`:

  Path of the property in the simulation pkmls

- `enum`:

  Enums to convert from user friendly value to PK-Sim allowed value

- `check`:

  Function to check validity of given value, must take value and unit as
  arguments and must return an error if value is not valid

## Methods

### Public methods

- [`Property$new()`](#method-Property-new)

- [`Property$toBaseUnit()`](#method-Property-toBaseUnit)

- [`Property$toSnapshot()`](#method-Property-toSnapshot)

- [`Property$print()`](#method-Property-print)

- [`Property$clone()`](#method-Property-clone)

------------------------------------------------------------------------

### Method `new()`

Initialize a new instance of the class.

#### Usage

    Property$new(
      name,
      parName,
      dimension,
      value = 0,
      unit = NULL,
      enum = NULL,
      check = NULL,
      min = NULL,
      max = NULL,
      rangeUnit = NULL,
      path = NULL
    )

#### Arguments

- `name`:

  Name of the property.

- `parName`:

  Parameter name of the property in the simulation pkmls.

- `dimension`:

  Dimension of the property.

- `value`:

  Value of the property

- `unit`:

  Unit of the property.

- `enum`:

  (Optional) Enum to convert from user friendly value to PK-Sim allowed
  value

- `check`:

  (Optional) Function to check validity of given value, must take value
  and unit as arguments and must return an error if the value is not
  valid

- `min`:

  (Optional) Min value allowed to check validity of given value

- `max`:

  (Optional) Max value allowed to check validity of given value

- `rangeUnit`:

  (Optional) Unit in which the min/max range is given

- `path`:

  path of the property in the simulation pkmls. Default to
  `CompoundName|parName` (if not given, the unit is assumed to be the
  same as the unit of the property). valid).

#### Returns

A new `Property` object.

------------------------------------------------------------------------

### Method `toBaseUnit()`

Return the value of the property in base unit

#### Usage

    Property$toBaseUnit()

------------------------------------------------------------------------

### Method `toSnapshot()`

Convert to snapshot

#### Usage

    Property$toSnapshot()

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print the object to the console

#### Usage

    Property$print(compoundName = NULL)

#### Arguments

- `compoundName`:

  compoundName in the simulation to replace placeholder in the path

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Property$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
