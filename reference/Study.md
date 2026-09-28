# Study

Description of a study

## Public fields

- `ID`:

  of the study

## Active bindings

- `Compounds`:

  List of administered compounds (with administration protocol), object
  of class `Compound`

- `Individual`:

  Individual used in the study.

## Methods

### Public methods

- [`Study$new()`](#method-Study-new)

- [`Study$getAllParameterPaths()`](#method-Study-getAllParameterPaths)

- [`Study$addDataSets()`](#method-Study-addDataSets)

- [`Study$getDataSets()`](#method-Study-getDataSets)

- [`Study$setOutputInterval()`](#method-Study-setOutputInterval)

- [`Study$addOutputInterval()`](#method-Study-addOutputInterval)

- [`Study$toSnapshot()`](#method-Study-toSnapshot)

- [`Study$exportSnapshot()`](#method-Study-exportSnapshot)

- [`Study$exportPKML()`](#method-Study-exportPKML)

- [`Study$setGenericModel()`](#method-Study-setGenericModel)

- [`Study$getGenericModel()`](#method-Study-getGenericModel)

- [`Study$setSimulation()`](#method-Study-setSimulation)

- [`Study$getSimulation()`](#method-Study-getSimulation)

- [`Study$print()`](#method-Study-print)

------------------------------------------------------------------------

### Method `new()`

Initialize a new instance of the class

#### Usage

    Study$new(ID, compounds, individual, genericModel = NULL)

#### Arguments

- `ID`:

  ID of the study

- `compounds`:

  list of administered compounds, compounds must be object of class
  `Compound`.

- `individual`:

  individual used in the study

- `genericModel`:

  path to a generic model to use if pre-generated (for example from MoBi
  with PD). Keep to NULL if a generic model should be automatically
  generated.

#### Returns

A new `Study` object.

------------------------------------------------------------------------

### Method `getAllParameterPaths()`

Get the paths of all parameters defined for the study. This is a union
of all compounds and administration protocol parameters.

#### Usage

    Study$getAllParameterPaths()

#### Returns

A character vector with the paths of all parameters

------------------------------------------------------------------------

### Method `addDataSets()`

Add DataSet objects to the study

#### Usage

    Study$addDataSets(dataSets)

#### Arguments

- `dataSets`:

  a DataSet object

------------------------------------------------------------------------

### Method `getDataSets()`

Get the DataSet objects of the study

#### Usage

    Study$getDataSets()

#### Returns

A list of DataSet objects

------------------------------------------------------------------------

### Method `setOutputInterval()`

Clears the output interval from the simulation and adds a new one.

#### Usage

    Study$setOutputInterval(startTime, endTime, timeUnit, resolution)

#### Arguments

- `startTime`:

  start time of the interval in time units

- `endTime`:

  end time of the interval in time units

- `timeUnit`:

  time unit of the interval

- `resolution`:

  resolution of the interval in pts/time units

------------------------------------------------------------------------

### Method `addOutputInterval()`

Adds an interval to the output schema of the study

#### Usage

    Study$addOutputInterval(startTime, endTime, timeUnit, resolution)

#### Arguments

- `startTime`:

  start time of the interval in time units

- `endTime`:

  end time of the interval in time units

- `timeUnit`:

  time unit of the interval

- `resolution`:

  resolution of the interval in pts/time units

------------------------------------------------------------------------

### Method `toSnapshot()`

Convert study to a snapshot

#### Usage

    Study$toSnapshot()

------------------------------------------------------------------------

### Method `exportSnapshot()`

Convert study to a snapshot

#### Usage

    Study$exportSnapshot(file)

#### Arguments

- `file`:

  file path to save the snapshot

------------------------------------------------------------------------

### Method `exportPKML()`

Convert study to a pkml

#### Usage

    Study$exportPKML(file, overwrite = FALSE)

#### Arguments

- `file`:

  file path to save the pkml

- `overwrite`:

  if TRUE, overwrite existing file

------------------------------------------------------------------------

### Method `setGenericModel()`

Set generic model to use if pre-generated (for example from MoBi with
PD)

#### Usage

    Study$setGenericModel(modelPath)

#### Arguments

- `modelPath`:

  path of the pkml model to use for the study. Keep to NULL if a generic
  model should be automatically generated.

------------------------------------------------------------------------

### Method `getGenericModel()`

Get generic model path assigned to the study (either from automatic pkml
creation or preassigned by user).

#### Usage

    Study$getGenericModel(silent = FALSE)

#### Arguments

- `silent`:

  if TRUE, do not print a message if the model is not set.

#### Returns

path of the pkml model used for the study, or NULL if not set. If path
is not valid the model is unset.

------------------------------------------------------------------------

### Method `setSimulation()`

Set simulation model to use if pre-generated (for example from MoBi with
PD)

#### Usage

    Study$setSimulation(simulation)

#### Arguments

- `simulation`:

  simulation loaded from pkml (to check )

------------------------------------------------------------------------

### Method `getSimulation()`

Get simulation model used for the study

#### Usage

    Study$getSimulation()

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print the object to the console

#### Usage

    Study$print(...)

#### Arguments

- `...`:

  Rest arguments.
