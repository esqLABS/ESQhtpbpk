# Compound

Description of a compound

## Public fields

- `ID`:

  Id of the compound

- `Name`:

  Name of the compound as used in the generic simulation

## Active bindings

- `PartitionCoefficientMethod`:

  Method used to calculate the partition coefficient

- `CellularPermeabilityMethod`:

  Method used to calculate the cellular permeability coefficient

- `Protocol`:

  Protocol used for compoud

## Methods

### Public methods

- [`Compound$new()`](#method-Compound-new)

- [`Compound$getProperty()`](#method-Compound-getProperty)

- [`Compound$getAllProperty()`](#method-Compound-getAllProperty)

- [`Compound$setPropertyValue()`](#method-Compound-setPropertyValue)

- [`Compound$addProperty()`](#method-Compound-addProperty)

- [`Compound$removeProperty()`](#method-Compound-removeProperty)

- [`Compound$addProcessProperty()`](#method-Compound-addProcessProperty)

- [`Compound$removeProcessProperty()`](#method-Compound-removeProcessProperty)

- [`Compound$removeProcess()`](#method-Compound-removeProcess)

- [`Compound$getProcessProperty()`](#method-Compound-getProcessProperty)

- [`Compound$getAllProcessProperty()`](#method-Compound-getAllProcessProperty)

- [`Compound$setProcessPropertyValue()`](#method-Compound-setProcessPropertyValue)

- [`Compound$setProtocol()`](#method-Compound-setProtocol)

- [`Compound$toSnapshot()`](#method-Compound-toSnapshot)

- [`Compound$getAllPropertyPaths()`](#method-Compound-getAllPropertyPaths)

- [`Compound$print()`](#method-Compound-print)

- [`Compound$clone()`](#method-Compound-clone)

------------------------------------------------------------------------

### Method `new()`

Initialize a new instance of the class Compound

#### Usage

    Compound$new(ID, name = "Compound", PCMethod = "PK-Sim", CPMethod = "PK-Sim")

#### Arguments

- `ID`:

  Id of the compound

- `name`:

  Name of the compound in the simulation pkmls

- `PCMethod`:

  Partition coefficient method to use for the compound

- `CPMethod`:

  Cellular permeability method to use for the compound

#### Returns

A new `Compound` object.

------------------------------------------------------------------------

### Method `getProperty()`

Get specific property of the compound

#### Usage

    Compound$getProperty(name)

#### Arguments

- `name`:

  Name of the property to retrieve.

#### Returns

The corresponding property object.

------------------------------------------------------------------------

### Method `getAllProperty()`

Get all defined properties of the compound

#### Usage

    Compound$getAllProperty()

#### Returns

A list of all compound properties.

------------------------------------------------------------------------

### Method `setPropertyValue()`

Update specific property value for the compound.

#### Usage

    Compound$setPropertyValue(name, value, unit = NULL)

#### Arguments

- `name`:

  Name of the property to modify.

- `value`:

  New value for the property.

- `unit`:

  New unit to use for the property, if not given the unit is assumed to
  be the same as previously.

------------------------------------------------------------------------

### Method `addProperty()`

Add a new property for the compound.

#### Usage

    Compound$addProperty(
      name,
      parName,
      dimension,
      value = 0,
      unit = NULL,
      enum = NULL,
      check = NULL,
      path = NULL
    )

#### Arguments

- `name`:

  Name of the property to add.

- `parName`:

  Corresponding parameter name in the simulation pkml of the property to
  add.

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
  the property, must take value, unit as argument an retrun an error if
  the test fails.

- `path`:

  Corresponding full path of the parameter in the simulation pkml of the
  property to add (default to NULL to create it automatically based on
  parName).

------------------------------------------------------------------------

### Method `removeProperty()`

Remove a property from the compound.

#### Usage

    Compound$removeProperty(name)

#### Arguments

- `name`:

  Name of the property to remove

------------------------------------------------------------------------

### Method `addProcessProperty()`

Add a new process property for the compound.

#### Usage

    Compound$addProcessProperty(
      propertyName,
      processType,
      parName,
      dimension,
      value = 0,
      unit = NULL,
      enum = NULL,
      check = NULL,
      path = NULL
    )

#### Arguments

- `propertyName`:

  Name of the property to add.

- `processType`:

  Corresponding Process type. Allowed Process types are: "Liver Plasma
  Clearance", "Hep T1/2", "Hep Residuals", "Liver Mic T1/2", "Liver Mic
  Residuals", "Renal Plasma Clearance", "Tub Sec FirstOrder", "Tub Sec
  MM", "GFR", "Biliary Plasma Clearance".

- `parName`:

  Corresponding parameter name in the simulation pkml of the property to
  add.

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

- `path`:

  (Optional) Corresponding full path of the parameter in the simulation
  pkml of the property to add. Needed when using a predefined pkml for
  the HTPBPK simulation.

------------------------------------------------------------------------

### Method `removeProcessProperty()`

Remove a process property from the compound.

#### Usage

    Compound$removeProcessProperty(propertyName, processType)

#### Arguments

- `propertyName`:

  Name of the property to remove

- `processType`:

  Type of the process to remove the property from

------------------------------------------------------------------------

### Method `removeProcess()`

Remove a all process propertys from the compound.

#### Usage

    Compound$removeProcess(processType)

#### Arguments

- `processType`:

  Type of the process to remove the property from

------------------------------------------------------------------------

### Method `getProcessProperty()`

Get specific process property of the compound

#### Usage

    Compound$getProcessProperty(propertyName, processType)

#### Arguments

- `propertyName`:

  Name of the property to get values from

- `processType`:

  Type of the process to get the property from

#### Returns

The corresponding property object.

------------------------------------------------------------------------

### Method `getAllProcessProperty()`

Get all process properties defined in the compound (or from a specific
process type)

#### Usage

    Compound$getAllProcessProperty(processType = NULL)

#### Arguments

- `processType`:

  (optional) process type for which to get all the properties defined in
  compound if NULL or not given all process properties for all process
  types are retuned

#### Returns

List of all process properties defined in the compound (for a specific
process type if supplied).

------------------------------------------------------------------------

### Method `setProcessPropertyValue()`

Update specific process property value for the compound.

#### Usage

    Compound$setProcessPropertyValue(propertyName, processType, value, unit = NULL)

#### Arguments

- `propertyName`:

  Name of the property to set values for

- `processType`:

  Type of the process to set the property from

- `value`:

  New value for the property.

- `unit`:

  New unit to use for the property, if not given the unit is assumed to
  be the same as previously.

------------------------------------------------------------------------

### Method `setProtocol()`

Set the administration protocol to be used for a compound

#### Usage

    Compound$setProtocol(protocol)

#### Arguments

- `protocol`:

  administration protocol to use for the compound. Must be an object of
  class `SimpleProtocol` or `AdvancedProtocol`.

------------------------------------------------------------------------

### Method `toSnapshot()`

Create a snapshot representation of the compound

#### Usage

    Compound$toSnapshot()

------------------------------------------------------------------------

### Method `getAllPropertyPaths()`

Get the paths of all parameters defined for the compound

#### Usage

    Compound$getAllPropertyPaths(compoundName = NULL)

#### Arguments

- `compoundName`:

  name of the compound in the simulations

#### Returns

A character vector with the paths of all parameters

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print the object to the console

#### Usage

    Compound$print(...)

#### Arguments

- `...`:

  Rest arguments.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Compound$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
