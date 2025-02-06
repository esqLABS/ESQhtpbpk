# extractProtocol works

    Code
      tmp
    Output
      # A tibble: 7 x 4
        type      time parameters formulationName
        <chr>    <dbl> <list>     <chr>          
      1 IV Bolus   720 <SmplPrtc> <NA>           
      2 IV Bolus   840 <SmplPrtc> <NA>           
      3 IV Bolus   960 <SmplPrtc> <NA>           
      4 IV Bolus  1080 <SmplPrtc> <NA>           
      5 IV Bolus  1200 <SmplPrtc> <NA>           
      6 Oral         0 <SmplPrtc> Dissolved      
      7 Oral       720 <SmplPrtc> Dissolved      

---

    Code
      tmp$parameters
    Output
      [[1]]
    Message
      * Route: Intravenous bolus
      * Dose: 10 mg/kg
      * Dose Interval: Single Dose
      * Start Time: 0 h
    Output
      
      [[2]]
    Message
      * Route: Intravenous bolus
      * Dose: 10 mg/kg
      * Dose Interval: Single Dose
      * Start Time: 0 h
    Output
      
      [[3]]
    Message
      * Route: Intravenous bolus
      * Dose: 10 mg/kg
      * Dose Interval: Single Dose
      * Start Time: 0 h
    Output
      
      [[4]]
    Message
      * Route: Intravenous bolus
      * Dose: 10 mg/kg
      * Dose Interval: Single Dose
      * Start Time: 0 h
    Output
      
      [[5]]
    Message
      * Route: Intravenous bolus
      * Dose: 10 mg/kg
      * Dose Interval: Single Dose
      * Start Time: 0 h
    Output
      
      [[6]]
    Message
      * Route: Oral
      * Dose: 5 mg/kg
      * Dose Interval: Single Dose
      * Start Time: 0 h
      * Volume of water per body weight: 3.5 ml/kg
    Output
      
      [[7]]
    Message
      * Route: Oral
      * Dose: 5 mg/kg
      * Dose Interval: Single Dose
      * Start Time: 0 h
      * Volume of water per body weight: 3.5 ml/kg
    Output
      

# getAllParameterPaths works

    Code
      prot$getAllParameterPaths()
    Output
       [1] "Events|AdvancedProtocol|IV Infusion|Application_1|ProtocolSchemaItem|Dose"                         
       [2] "Events|AdvancedProtocol|IV Infusion|Application_1|ProtocolSchemaItem|Start time"                   
       [3] "Events|AdvancedProtocol|IV Infusion|Application_1|ProtocolSchemaItem|Infusion time"                
       [4] "Events|AdvancedProtocol|IV Infusion|Application_2|ProtocolSchemaItem|Dose"                         
       [5] "Events|AdvancedProtocol|IV Infusion|Application_2|ProtocolSchemaItem|Start time"                   
       [6] "Events|AdvancedProtocol|IV Infusion|Application_2|ProtocolSchemaItem|Infusion time"                
       [7] "Events|AdvancedProtocol|IV Infusion|Application_3|ProtocolSchemaItem|Dose"                         
       [8] "Events|AdvancedProtocol|IV Infusion|Application_3|ProtocolSchemaItem|Start time"                   
       [9] "Events|AdvancedProtocol|IV Infusion|Application_3|ProtocolSchemaItem|Infusion time"                
      [10] "Events|AdvancedProtocol|IV Infusion|Application_4|ProtocolSchemaItem|Dose"                         
      [11] "Events|AdvancedProtocol|IV Infusion|Application_4|ProtocolSchemaItem|Start time"                   
      [12] "Events|AdvancedProtocol|IV Infusion|Application_4|ProtocolSchemaItem|Infusion time"                
      [13] "Events|AdvancedProtocol|IV Infusion|Application_5|ProtocolSchemaItem|Dose"                         
      [14] "Events|AdvancedProtocol|IV Infusion|Application_5|ProtocolSchemaItem|Start time"                   
      [15] "Events|AdvancedProtocol|IV Infusion|Application_5|ProtocolSchemaItem|Infusion time"                
      [16] "Events|AdvancedProtocol|IV Bolus|Application_1|ProtocolSchemaItem|DosePerBodySurfaceArea"          
      [17] "Events|AdvancedProtocol|IV Bolus|Application_1|ProtocolSchemaItem|Start time"                      
      [18] "Events|AdvancedProtocol|IV Bolus|Application_2|ProtocolSchemaItem|DosePerBodySurfaceArea"          
      [19] "Events|AdvancedProtocol|IV Bolus|Application_2|ProtocolSchemaItem|Start time"                      
      [20] "Events|AdvancedProtocol|IV Bolus|Application_3|ProtocolSchemaItem|DosePerBodySurfaceArea"          
      [21] "Events|AdvancedProtocol|IV Bolus|Application_3|ProtocolSchemaItem|Start time"                      
      [22] "Events|AdvancedProtocol|IV Bolus|Application_4|ProtocolSchemaItem|DosePerBodySurfaceArea"          
      [23] "Events|AdvancedProtocol|IV Bolus|Application_4|ProtocolSchemaItem|Start time"                      
      [24] "Events|AdvancedProtocol|IV Bolus|Application_5|ProtocolSchemaItem|DosePerBodySurfaceArea"          
      [25] "Events|AdvancedProtocol|IV Bolus|Application_5|ProtocolSchemaItem|Start time"                      
      [26] "Events|AdvancedProtocol|OralDissolved|Application_1|ProtocolSchemaItem|DosePerBodyWeight"          
      [27] "Events|AdvancedProtocol|OralDissolved|Application_1|ProtocolSchemaItem|Start time"                 
      [28] "Events|AdvancedProtocol|OralDissolved|Application_1|ProtocolSchemaItem|Volume of water/body weight"
      [29] "Events|AdvancedProtocol|OralDissolved|Application_2|ProtocolSchemaItem|DosePerBodyWeight"          
      [30] "Events|AdvancedProtocol|OralDissolved|Application_2|ProtocolSchemaItem|Start time"                 
      [31] "Events|AdvancedProtocol|OralDissolved|Application_2|ProtocolSchemaItem|Volume of water/body weight"

# print method works

    Code
      prot
    Message
      Schema: Schema 1
      * Start time: 12 h
      * Number of repetitions: 5
      * Time between repetitions: 2 h
      Schema item 1
        * Route: Intravenous infusion
        * Dose: 10 mg
        * Dose Interval: Single Dose
        * Start Time: 0 h
        * Infusion Time: 60 min
      Schema item 2
        * Route: Intravenous bolus
        * Dose: 1 mg/m²
        * Dose Interval: Single Dose
        * Start Time: 0 h
      
      Schema: Schema 2
      * Start time: 0 h
      * Number of repetitions: 2
      * Time between repetitions: 12 h
      Schema item 1
        * Route: Oral
        * Dose: 5 mg/kg
        * Dose Interval: Single Dose
        * Start Time: 0 h
        * Volume of water per body weight: 3.5 ml/kg
      

