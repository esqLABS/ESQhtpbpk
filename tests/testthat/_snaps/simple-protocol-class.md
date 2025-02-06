# Default setting are set.

    Code
      SimpleProtocol$new(route = "IV Infusion", dosingInterval = "6-6-6-6", )
    Condition
      Warning:
      No `endTime` provided, using default value of 24 hours.
      Warning:
      No `infusionTime` provided, using default value of 60 minutes.
    Message
      * Route: Intravenous infusion
      * Dose: 0 mg/kg
      * Dose Interval: Every 6 hours
      * Start Time: 0 h
      * End Time: 24 h
      * Infusion Time: 60 min

---

    Code
      SimpleProtocol$new(route = "IV Infusion", infusionTime = 10)
    Condition
      Warning:
      No `infusionTimeUnit` provided, using default unit of `minutes`.
    Message
      * Route: Intravenous infusion
      * Dose: 0 mg/kg
      * Dose Interval: Single Dose
      * Start Time: 0 h
      * Infusion Time: 10 min

---

    Code
      SimpleProtocol$new(route = "IV Bolus", infusionTime = 10)
    Condition
      Warning:
      Removing `InfusionTime` or `InfusionTimeUnit` from protocol as they are only used for `IV Infusion` route.
    Message
      * Route: Intravenous bolus
      * Dose: 0 mg/kg
      * Dose Interval: Single Dose
      * Start Time: 0 h

---

    Code
      SimpleProtocol$new(route = "Oral")
    Condition
      Warning:
      No `WaterVolPerBW` provided, using default value of 3.5 ml/kg.
    Message
      * Route: Oral
      * Dose: 0 mg/kg
      * Dose Interval: Single Dose
      * Start Time: 0 h
      * Volume of water per body weight: 3.5 ml/kg

---

    Code
      SimpleProtocol$new(route = "Oral", waterVolPerBW = 5)
    Condition
      Warning:
      No `WaterVolPerBWUnit` provided, using default unit of `ml/kg`.
    Message
      * Route: Oral
      * Dose: 0 mg/kg
      * Dose Interval: Single Dose
      * Start Time: 0 h
      * Volume of water per body weight: 5 ml/kg

---

    Code
      SimpleProtocol$new(route = "IV Bolus", waterVolPerBW = 5)
    Condition
      Warning:
      Removing `WaterVolPerBW` or `WaterVolPerBWUnit` from protocol as they are only used for `Oral` route.
    Message
      * Route: Intravenous bolus
      * Dose: 0 mg/kg
      * Dose Interval: Single Dose
      * Start Time: 0 h

# Extracting protocol works.

    Code
      tmp
    Output
      # A tibble: 2 x 4
        type         time parameters formulationName
        <chr>       <dbl> <list>     <lgl>          
      1 IV Infusion    60 <SmplPrtc> NA             
      2 IV Infusion  1500 <SmplPrtc> NA             

---

    Code
      tmp$parameters
    Output
      [[1]]
    Message
      * Route: Intravenous infusion
      * Dose: 1 mg
      * Dose Interval: Once each 24 hours
      * Start Time: 60 min
      * End Time: 48 h
      * Infusion Time: 10 min
    Output
      
      [[2]]
    Message
      * Route: Intravenous infusion
      * Dose: 1 mg
      * Dose Interval: Once each 24 hours
      * Start Time: 60 min
      * End Time: 48 h
      * Infusion Time: 10 min
    Output
      

# getAllParameterPaths works.

    Code
      prot$getAllParameterPaths()
    Output
      [1] "Events|AdvancedProtocol|IV Infusion|Application_1|ProtocolSchemaItem|Dose"         
      [2] "Events|AdvancedProtocol|IV Infusion|Application_1|ProtocolSchemaItem|Start time"   
      [3] "Events|AdvancedProtocol|IV Infusion|Application_1|ProtocolSchemaItem|Infusion time"
      [4] "Events|AdvancedProtocol|IV Infusion|Application_2|ProtocolSchemaItem|Dose"         
      [5] "Events|AdvancedProtocol|IV Infusion|Application_2|ProtocolSchemaItem|Start time"   
      [6] "Events|AdvancedProtocol|IV Infusion|Application_2|ProtocolSchemaItem|Infusion time"

---

    Code
      prot$getAllParameterPaths()
    Output
      [1] "Events|AdvancedProtocol|IV Bolus|Application_1|ProtocolSchemaItem|DosePerBodySurfaceArea"
      [2] "Events|AdvancedProtocol|IV Bolus|Application_1|ProtocolSchemaItem|Start time"            

---

    Code
      prot$getAllParameterPaths()
    Output
      [1] "Events|AdvancedProtocol|OralDissolved|Application_1|ProtocolSchemaItem|DosePerBodyWeight"          
      [2] "Events|AdvancedProtocol|OralDissolved|Application_1|ProtocolSchemaItem|Start time"                 
      [3] "Events|AdvancedProtocol|OralDissolved|Application_1|ProtocolSchemaItem|Volume of water/body weight"
      [4] "Events|AdvancedProtocol|OralDissolved|Application_2|ProtocolSchemaItem|DosePerBodyWeight"          
      [5] "Events|AdvancedProtocol|OralDissolved|Application_2|ProtocolSchemaItem|Start time"                 
      [6] "Events|AdvancedProtocol|OralDissolved|Application_2|ProtocolSchemaItem|Volume of water/body weight"

# Print method works.

    Code
      SimpleProtocol$new(route = "IV Infusion", dosingInterval = "24", dose = 1,
        doseUnit = "mg", startTime = 60, startTimeUnit = "min", endTime = 48,
        endTimeUnit = "h", infusionTime = 10, infusionTimeUnit = "min")
    Message
      * Route: Intravenous infusion
      * Dose: 1 mg
      * Dose Interval: Once each 24 hours
      * Start Time: 60 min
      * End Time: 48 h
      * Infusion Time: 10 min

---

    Code
      SimpleProtocol$new(route = "Oral", dosingInterval = "Single", dose = 1,
        doseUnit = "mg", startTime = 60, startTimeUnit = "min")
    Condition
      Warning:
      No `WaterVolPerBW` provided, using default value of 3.5 ml/kg.
    Message
      * Route: Oral
      * Dose: 1 mg
      * Dose Interval: Single Dose
      * Start Time: 60 min
      * Volume of water per body weight: 3.5 ml/kg

