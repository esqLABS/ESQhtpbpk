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
