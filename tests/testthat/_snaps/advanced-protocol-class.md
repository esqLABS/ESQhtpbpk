# extractProtocol works

    Code
      tmp
    Output
      # A tibble: 7 x 7
      # Rowwise: 
        type      time parameters formulationType formulationName formulation
        <chr>    <dbl> <list>     <chr>           <chr>           <list>     
      1 IV Bolus   720 <SmplPrtc> <NA>            <NA>            <NULL>     
      2 IV Bolus   840 <SmplPrtc> <NA>            <NA>            <NULL>     
      3 IV Bolus   960 <SmplPrtc> <NA>            <NA>            <NULL>     
      4 IV Bolus  1080 <SmplPrtc> <NA>            <NA>            <NULL>     
      5 IV Bolus  1200 <SmplPrtc> <NA>            <NA>            <NULL>     
      6 Oral         0 <SmplPrtc> Dissolved       Dissolved       <Formultn> 
      7 Oral       720 <SmplPrtc> Dissolved       Dissolved       <Formultn> 
      # i 1 more variable: formulationKey <chr>

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
      * Formulation: Dissolved
    Output
      
      [[7]]
    Message
      * Route: Oral
      * Dose: 5 mg/kg
      * Dose Interval: Single Dose
      * Start Time: 0 h
      * Volume of water per body weight: 3.5 ml/kg
      * Formulation: Dissolved
    Output
      

# getAllParameterPaths works

    Code
      prot$getAllParameterPaths()
    Output
       [1] "Events|{ProtocolName}|IV Infusion|Application_1|ProtocolSchemaItem|Dose"                         
       [2] "Events|{ProtocolName}|IV Infusion|Application_1|ProtocolSchemaItem|Start time"                   
       [3] "Events|{ProtocolName}|IV Infusion|Application_1|ProtocolSchemaItem|Infusion time"                
       [4] "Events|{ProtocolName}|IV Infusion|Application_2|ProtocolSchemaItem|Dose"                         
       [5] "Events|{ProtocolName}|IV Infusion|Application_2|ProtocolSchemaItem|Start time"                   
       [6] "Events|{ProtocolName}|IV Infusion|Application_2|ProtocolSchemaItem|Infusion time"                
       [7] "Events|{ProtocolName}|IV Infusion|Application_3|ProtocolSchemaItem|Dose"                         
       [8] "Events|{ProtocolName}|IV Infusion|Application_3|ProtocolSchemaItem|Start time"                   
       [9] "Events|{ProtocolName}|IV Infusion|Application_3|ProtocolSchemaItem|Infusion time"                
      [10] "Events|{ProtocolName}|IV Infusion|Application_4|ProtocolSchemaItem|Dose"                         
      [11] "Events|{ProtocolName}|IV Infusion|Application_4|ProtocolSchemaItem|Start time"                   
      [12] "Events|{ProtocolName}|IV Infusion|Application_4|ProtocolSchemaItem|Infusion time"                
      [13] "Events|{ProtocolName}|IV Infusion|Application_5|ProtocolSchemaItem|Dose"                         
      [14] "Events|{ProtocolName}|IV Infusion|Application_5|ProtocolSchemaItem|Start time"                   
      [15] "Events|{ProtocolName}|IV Infusion|Application_5|ProtocolSchemaItem|Infusion time"                
      [16] "Events|{ProtocolName}|IV Bolus|Application_1|ProtocolSchemaItem|DosePerBodySurfaceArea"          
      [17] "Events|{ProtocolName}|IV Bolus|Application_1|ProtocolSchemaItem|Start time"                      
      [18] "Events|{ProtocolName}|IV Bolus|Application_2|ProtocolSchemaItem|DosePerBodySurfaceArea"          
      [19] "Events|{ProtocolName}|IV Bolus|Application_2|ProtocolSchemaItem|Start time"                      
      [20] "Events|{ProtocolName}|IV Bolus|Application_3|ProtocolSchemaItem|DosePerBodySurfaceArea"          
      [21] "Events|{ProtocolName}|IV Bolus|Application_3|ProtocolSchemaItem|Start time"                      
      [22] "Events|{ProtocolName}|IV Bolus|Application_4|ProtocolSchemaItem|DosePerBodySurfaceArea"          
      [23] "Events|{ProtocolName}|IV Bolus|Application_4|ProtocolSchemaItem|Start time"                      
      [24] "Events|{ProtocolName}|IV Bolus|Application_5|ProtocolSchemaItem|DosePerBodySurfaceArea"          
      [25] "Events|{ProtocolName}|IV Bolus|Application_5|ProtocolSchemaItem|Start time"                      
      [26] "Events|{ProtocolName}|OralDissolved|Application_1|ProtocolSchemaItem|DosePerBodyWeight"          
      [27] "Events|{ProtocolName}|OralDissolved|Application_1|ProtocolSchemaItem|Start time"                 
      [28] "Events|{ProtocolName}|OralDissolved|Application_1|ProtocolSchemaItem|Volume of water/body weight"
      [29] "Events|{ProtocolName}|OralDissolved|Application_2|ProtocolSchemaItem|DosePerBodyWeight"          
      [30] "Events|{ProtocolName}|OralDissolved|Application_2|ProtocolSchemaItem|Start time"                 
      [31] "Events|{ProtocolName}|OralDissolved|Application_2|ProtocolSchemaItem|Volume of water/body weight"

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
      Schema item 3
        * Route: Oral
        * Dose: 5 mg/kg
        * Dose Interval: Single Dose
        * Start Time: 0 h
        * Volume of water per body weight: 3.5 ml/kg
        * Formulation: Weibull1
      
      Schema: Schema 2
      * Start time: 0 h
      * Number of repetitions: 2
      * Time between repetitions: 12 h
      Schema item 1
        * Route: Oral
        * Dose: 1 mg/kg
        * Dose Interval: Single Dose
        * Start Time: 0 h
        * Volume of water per body weight: 3.5 ml/kg
        * Formulation: Weibull2
      

---

    Code
      prot$extractProtocol()
    Output
      # A tibble: 17 x 7
      # Rowwise: 
         type         time parameters formulationType formulationName formulation
         <chr>       <dbl> <list>     <chr>           <chr>           <list>     
       1 IV Infusion   720 <SmplPrtc> <NA>            <NA>            <NULL>     
       2 IV Infusion   840 <SmplPrtc> <NA>            <NA>            <NULL>     
       3 IV Infusion   960 <SmplPrtc> <NA>            <NA>            <NULL>     
       4 IV Infusion  1080 <SmplPrtc> <NA>            <NA>            <NULL>     
       5 IV Infusion  1200 <SmplPrtc> <NA>            <NA>            <NULL>     
       6 IV Bolus      720 <SmplPrtc> <NA>            <NA>            <NULL>     
       7 IV Bolus      840 <SmplPrtc> <NA>            <NA>            <NULL>     
       8 IV Bolus      960 <SmplPrtc> <NA>            <NA>            <NULL>     
       9 IV Bolus     1080 <SmplPrtc> <NA>            <NA>            <NULL>     
      10 IV Bolus     1200 <SmplPrtc> <NA>            <NA>            <NULL>     
      11 Oral          720 <SmplPrtc> Weibull         Weibull1        <Formultn> 
      12 Oral          840 <SmplPrtc> Weibull         Weibull1        <Formultn> 
      13 Oral          960 <SmplPrtc> Weibull         Weibull1        <Formultn> 
      14 Oral         1080 <SmplPrtc> Weibull         Weibull1        <Formultn> 
      15 Oral         1200 <SmplPrtc> Weibull         Weibull1        <Formultn> 
      16 Oral            0 <SmplPrtc> Weibull         Weibull2        <Formultn> 
      17 Oral          720 <SmplPrtc> Weibull         Weibull2        <Formultn> 
      # i 1 more variable: formulationKey <chr>

