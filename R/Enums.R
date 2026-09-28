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
  "6-6-12" = list(
    pksim = "DI_6_6_12",
    human = "Every 6 hours twice then 12 hours after"
  )
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

#' @keywords internal
ProcessInternalNames <- ospsuite.utils::enum(
  c(
    "Liver Plasma Clearance" = "LiverClearance",
    "Hep T1/2" = "HepatocytesHalfTime",
    "Hep Residuals" = "HepatocytesRes",
    "Liver Mic T1/2" = "LiverMicrosomeHalfTime",
    "Liver Mic Residuals" = "LiverMicrosomeRes",
    "Renal Plasma Clearance" = "KidneyClearance",
    "Tub Sec FirstOrder" = "TubularSecretion_FirstOrder",
    "Tub Sec MM" = "TubularSecretion_MM",
    "GFR" = "GlomerularFiltration",
    "Biliary Plasma Clearance" = "BiliaryClearance"
  )
)

#' @keywords internal
ProcessTypes <- ospsuite.utils::enum(
  c(
    "Liver Plasma Clearance" = "Hepatic",
    "Hep T1/2" = "Hepatic",
    "Hep Residuals" = "Hepatic",
    "Liver Mic T1/2" = "Hepatic",
    "Liver Mic Residuals" = "Hepatic",
    "Renal Plasma Clearance" = "Renal",
    "Tub Sec FirstOrder" = "Renal",
    "Tub Sec MM" = "Renal",
    "GFR" = "GFR",
    "Biliary Plasma Clearance" = "Biliary"
  )
)

#' @keywords internal
ProcessPrefixes <- ospsuite.utils::enum(
  c(
    "Liver Plasma Clearance" = "Total Hepatic Clearance",
    "Hep T1/2" = "Total Hepatic Clearance",
    "Hep Residuals" = "Total Hepatic Clearance",
    "Liver Mic T1/2" = "Total Hepatic Clearance",
    "Liver Mic Residuals" = "Total Hepatic Clearance",
    "Renal Plasma Clearance" = "Renal Clearances",
    "Tub Sec FirstOrder" = "Renal Clearances",
    "Tub Sec MM" = "Renal Clearances",
    "GFR" = "Glomerular Filtration",
    "Biliary Plasma Clearance" = "Biliary Clearance"
  )
)
# Main process parameter for initialising processes for generic pkml
#' @keywords internal
MainProcessProperty <- list(
  "Liver Plasma Clearance" = list(
    Name = "Plasma clearance",
    dimension = "Flow per weight",
    value = 0
  ),
  "Hep T1/2" = list(
    Name = "t1/2 (hepatocyte assay)",
    dimension = "Time",
    value = 1e16
  ),
  "Hep Residuals" = list(
    Name = "Residual fraction",
    dimension = "Fraction",
    value = 1
  ),
  "Liver Mic T1/2" = list(
    Name = "t1/2 (microsomal assay)",
    dimension = "Time",
    value = 1e16
  ),
  "Liver Mic Residuals" = list(
    Name = "Residual fraction",
    dimension = "Fraction",
    value = 1
  ),
  "Renal Plasma Clearance" = list(
    Name = "Plasma clearance",
    dimension = "Flow per weight",
    value = 0
  ),
  "Tub Sec FirstOrder" = list(
    Name = "Tubular secretion",
    dimension = "Flow",
    value = 0
  ),
  "Tub Sec MM" = list(Name = "TSmax", dimension = "Amount per time", value = 0),
  "GFR" = list(Name = "GFR fraction", dimension = "Fraction", value = 0),
  "Biliary Plasma Clearance" = list(
    Name = "Plasma clearance",
    dimension = "Flow per weight",
    value = 0
  )
)
