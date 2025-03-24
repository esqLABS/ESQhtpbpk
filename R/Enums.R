#' @keywords internal
PPBPartner <- ospsuite.utils::enum(c(
  "Albumin" = 1,
  "Alpha-1-acid glycoprotein" = 0,
  "Unknown" = 2
))

#' @keywords internal
CompoundType <- ospsuite.utils::enum(c(
  "Neutral" = 0,
  "Acidic" = -1,
  "Basic" = 1
))

#' @keywords internal
AdminType <- list(
  "Oral" = list(pksim = "Oral", human = "Oral"),
  "IV Bolus" = list(pksim = "IntravenousBolus", human = "Intravenous bolus"),
  "IV Infusion" = list(pksim = "Intravenous", human = "Intravenous infusion"),
  "Custom" = list(pksim = "UserDefined", human = "User defined")
)

#' @keywords internal
AdminInterval <- list(
  "Single" = list(pksim = "Single", human = "Single Dose"),
  "24" = list(pksim = "DI_24", human = "Once each 24 hours"),
  "12-12" = list(pksim = "DI_12_12", human = "Every 12 hours"),
  "8-8-8" = list(pksim = "DI_8_8_8", human = "Every 8 hours"),
  "6-6-6-6" = list(pksim = "DI_6_6_6_6", human = "Every 6 hours"),
  "6-6-12" = list(pksim = "DI_6_6_12", human = "Every 6 hours twice then 12 hours after")
)

#' @keywords internal
FormulationType <- ospsuite.utils::enum(
  c(
    "Dissolved" = "Formulation_Dissolved",
    "Weibull" = "Formulation_Tablet_Weibull",
    "Lint80" = "Formulation_Tablet_Lint80",
    "Particle" = "Formulation_Particles",
    "Table" = "Formulation_Table",
    "ZeroOrder" = "Formulation_ZeroOrder",
    "FirstOrder" = "Formulation_FirstOrder"
  )
)

#' @keywords internal
ParticleSizeDistributionType <- ospsuite.utils::enum(
  c(
    "Monodisperse" = 0,
    "Polydisperse" = 1
  )
)

#' @keywords internal
ParticleSizeDistribution <- ospsuite.utils::enum(
  c(
    "Normal" = 0,
    "LogNormal" = 1
  )
)

#' @keywords internal
PCMethods <- ospsuite.utils::enum(
  c(
    "PK-Sim" = "PK-Sim Standard",
    "RR" = "Rodgers and Rowland",
    "PT" = "Poulin and Theil",
    "Schmitt" = "Schmitt",
    "Berezhkovskiy" = "Berezhkovskiy"
  )
)

#' @keywords internal
CPMethods <- ospsuite.utils::enum(
  c(
    "PK-Sim" = "PK-Sim Standard",
    "Schmitt" = "Charge dependent Schmitt"
  )
)
