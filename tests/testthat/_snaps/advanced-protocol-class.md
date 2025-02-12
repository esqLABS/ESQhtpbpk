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
       [1] "Events|Protocol||Application_1|ProtocolSchemaItem|Dose"                                
       [2] "Events|Protocol||Application_1|ProtocolSchemaItem|Start time"                          
       [3] "Events|Protocol||Application_1|ProtocolSchemaItem|Infusion time"                       
       [4] "Events|Protocol||Application_2|ProtocolSchemaItem|DosePerBodySurfaceArea"              
       [5] "Events|Protocol||Application_2|ProtocolSchemaItem|Start time"                          
       [6] "Events|Protocol||Application_3|ProtocolSchemaItem|Dose"                                
       [7] "Events|Protocol||Application_3|ProtocolSchemaItem|Start time"                          
       [8] "Events|Protocol||Application_3|ProtocolSchemaItem|Infusion time"                       
       [9] "Events|Protocol||Application_4|ProtocolSchemaItem|DosePerBodySurfaceArea"              
      [10] "Events|Protocol||Application_4|ProtocolSchemaItem|Start time"                          
      [11] "Events|Protocol||Application_5|ProtocolSchemaItem|Dose"                                
      [12] "Events|Protocol||Application_5|ProtocolSchemaItem|Start time"                          
      [13] "Events|Protocol||Application_5|ProtocolSchemaItem|Infusion time"                       
      [14] "Events|Protocol||Application_6|ProtocolSchemaItem|DosePerBodySurfaceArea"              
      [15] "Events|Protocol||Application_6|ProtocolSchemaItem|Start time"                          
      [16] "Events|Protocol||Application_7|ProtocolSchemaItem|Dose"                                
      [17] "Events|Protocol||Application_7|ProtocolSchemaItem|Start time"                          
      [18] "Events|Protocol||Application_7|ProtocolSchemaItem|Infusion time"                       
      [19] "Events|Protocol||Application_8|ProtocolSchemaItem|DosePerBodySurfaceArea"              
      [20] "Events|Protocol||Application_8|ProtocolSchemaItem|Start time"                          
      [21] "Events|Protocol||Application_9|ProtocolSchemaItem|Dose"                                
      [22] "Events|Protocol||Application_9|ProtocolSchemaItem|Start time"                          
      [23] "Events|Protocol||Application_9|ProtocolSchemaItem|Infusion time"                       
      [24] "Events|Protocol||Application_10|ProtocolSchemaItem|DosePerBodySurfaceArea"             
      [25] "Events|Protocol||Application_10|ProtocolSchemaItem|Start time"                         
      [26] "Events|Protocol|Dissolved|Application_1|ProtocolSchemaItem|DosePerBodyWeight"          
      [27] "Events|Protocol|Dissolved|Application_1|ProtocolSchemaItem|Start time"                 
      [28] "Events|Protocol|Dissolved|Application_1|ProtocolSchemaItem|Volume of water/body weight"
      [29] "Events|Protocol|Dissolved|Application_2|ProtocolSchemaItem|DosePerBodyWeight"          
      [30] "Events|Protocol|Dissolved|Application_2|ProtocolSchemaItem|Start time"                 
      [31] "Events|Protocol|Dissolved|Application_2|ProtocolSchemaItem|Volume of water/body weight"

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

# extractProtocol method works

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

# toSnapshot method works

    Code
      prot$toSnapshot()
    Output
      $Name
      [1] "Protocol"
      
      $DosingInterval
      [1] "Single"
      
      $Schemas
      $Schemas[[1]]
      $Schemas[[1]]$Name
      [1] "Schema 1"
      
      $Schemas[[1]]$SchemaItems
      $Schemas[[1]]$SchemaItems[[1]]
      $Schemas[[1]]$SchemaItems[[1]]$Name
      [1] "Schema Item 1"
      
      $Schemas[[1]]$SchemaItems[[1]]$ApplicationType
      [1] "Intravenous"
      
      $Schemas[[1]]$SchemaItems[[1]]$DosingInterval
      [1] "Single"
      
      $Schemas[[1]]$SchemaItems[[1]]$Parameters
      $Schemas[[1]]$SchemaItems[[1]]$Parameters[[1]]
      $Schemas[[1]]$SchemaItems[[1]]$Parameters[[1]]$Name
      [1] "Start time"
      
      $Schemas[[1]]$SchemaItems[[1]]$Parameters[[1]]$Value
      [1] 0
      
      $Schemas[[1]]$SchemaItems[[1]]$Parameters[[1]]$Unit
      [1] "h"
      
      
      $Schemas[[1]]$SchemaItems[[1]]$Parameters[[2]]
      $Schemas[[1]]$SchemaItems[[1]]$Parameters[[2]]$Name
      [1] "InputDose"
      
      $Schemas[[1]]$SchemaItems[[1]]$Parameters[[2]]$Value
      [1] 10
      
      $Schemas[[1]]$SchemaItems[[1]]$Parameters[[2]]$Unit
      [1] "mg"
      
      
      $Schemas[[1]]$SchemaItems[[1]]$Parameters[[3]]
      $Schemas[[1]]$SchemaItems[[1]]$Parameters[[3]]$Name
      [1] "Infusion time"
      
      $Schemas[[1]]$SchemaItems[[1]]$Parameters[[3]]$Value
      [1] 60
      
      $Schemas[[1]]$SchemaItems[[1]]$Parameters[[3]]$Unit
      [1] "min"
      
      
      
      
      $Schemas[[1]]$SchemaItems[[2]]
      $Schemas[[1]]$SchemaItems[[2]]$Name
      [1] "Schema Item 2"
      
      $Schemas[[1]]$SchemaItems[[2]]$ApplicationType
      [1] "IntravenousBolus"
      
      $Schemas[[1]]$SchemaItems[[2]]$DosingInterval
      [1] "Single"
      
      $Schemas[[1]]$SchemaItems[[2]]$Parameters
      $Schemas[[1]]$SchemaItems[[2]]$Parameters[[1]]
      $Schemas[[1]]$SchemaItems[[2]]$Parameters[[1]]$Name
      [1] "Start time"
      
      $Schemas[[1]]$SchemaItems[[2]]$Parameters[[1]]$Value
      [1] 0
      
      $Schemas[[1]]$SchemaItems[[2]]$Parameters[[1]]$Unit
      [1] "h"
      
      
      $Schemas[[1]]$SchemaItems[[2]]$Parameters[[2]]
      $Schemas[[1]]$SchemaItems[[2]]$Parameters[[2]]$Name
      [1] "InputDose"
      
      $Schemas[[1]]$SchemaItems[[2]]$Parameters[[2]]$Value
      [1] 1
      
      $Schemas[[1]]$SchemaItems[[2]]$Parameters[[2]]$Unit
      [1] "mg/m²"
      
      
      
      
      $Schemas[[1]]$SchemaItems[[3]]
      $Schemas[[1]]$SchemaItems[[3]]$Name
      [1] "Schema Item 3"
      
      $Schemas[[1]]$SchemaItems[[3]]$ApplicationType
      [1] "Oral"
      
      $Schemas[[1]]$SchemaItems[[3]]$DosingInterval
      [1] "Single"
      
      $Schemas[[1]]$SchemaItems[[3]]$Parameters
      $Schemas[[1]]$SchemaItems[[3]]$Parameters[[1]]
      $Schemas[[1]]$SchemaItems[[3]]$Parameters[[1]]$Name
      [1] "Start time"
      
      $Schemas[[1]]$SchemaItems[[3]]$Parameters[[1]]$Value
      [1] 0
      
      $Schemas[[1]]$SchemaItems[[3]]$Parameters[[1]]$Unit
      [1] "h"
      
      
      $Schemas[[1]]$SchemaItems[[3]]$Parameters[[2]]
      $Schemas[[1]]$SchemaItems[[3]]$Parameters[[2]]$Name
      [1] "InputDose"
      
      $Schemas[[1]]$SchemaItems[[3]]$Parameters[[2]]$Value
      [1] 5
      
      $Schemas[[1]]$SchemaItems[[3]]$Parameters[[2]]$Unit
      [1] "mg/kg"
      
      
      $Schemas[[1]]$SchemaItems[[3]]$Parameters[[3]]
      $Schemas[[1]]$SchemaItems[[3]]$Parameters[[3]]$Name
      [1] "Volume of water/body weight"
      
      $Schemas[[1]]$SchemaItems[[3]]$Parameters[[3]]$Value
      [1] 3.5
      
      $Schemas[[1]]$SchemaItems[[3]]$Parameters[[3]]$Unit
      [1] "ml/kg"
      
      
      
      $Schemas[[1]]$SchemaItems[[3]]$FormulationKey
      [1] "Formulation1"
      
      
      
      $Schemas[[1]]$Parameters
      $Schemas[[1]]$Parameters[[1]]
      $Schemas[[1]]$Parameters[[1]]$Name
      [1] "Start time"
      
      $Schemas[[1]]$Parameters[[1]]$Value
      [1] 12
      
      $Schemas[[1]]$Parameters[[1]]$Unit
      [1] "h"
      
      
      $Schemas[[1]]$Parameters[[2]]
      $Schemas[[1]]$Parameters[[2]]$Name
      [1] "NumberOfRepetitions"
      
      $Schemas[[1]]$Parameters[[2]]$Value
      [1] 5
      
      
      $Schemas[[1]]$Parameters[[3]]
      $Schemas[[1]]$Parameters[[3]]$Name
      [1] "TimeBetweenRepetitions"
      
      $Schemas[[1]]$Parameters[[3]]$Value
      [1] 2
      
      $Schemas[[1]]$Parameters[[3]]$Unit
      [1] "h"
      
      
      
      
      $Schemas[[2]]
      $Schemas[[2]]$Name
      [1] "Schema 2"
      
      $Schemas[[2]]$SchemaItems
      $Schemas[[2]]$SchemaItems[[1]]
      $Schemas[[2]]$SchemaItems[[1]]$Name
      [1] "Schema Item 1"
      
      $Schemas[[2]]$SchemaItems[[1]]$ApplicationType
      [1] "Oral"
      
      $Schemas[[2]]$SchemaItems[[1]]$DosingInterval
      [1] "Single"
      
      $Schemas[[2]]$SchemaItems[[1]]$Parameters
      $Schemas[[2]]$SchemaItems[[1]]$Parameters[[1]]
      $Schemas[[2]]$SchemaItems[[1]]$Parameters[[1]]$Name
      [1] "Start time"
      
      $Schemas[[2]]$SchemaItems[[1]]$Parameters[[1]]$Value
      [1] 0
      
      $Schemas[[2]]$SchemaItems[[1]]$Parameters[[1]]$Unit
      [1] "h"
      
      
      $Schemas[[2]]$SchemaItems[[1]]$Parameters[[2]]
      $Schemas[[2]]$SchemaItems[[1]]$Parameters[[2]]$Name
      [1] "InputDose"
      
      $Schemas[[2]]$SchemaItems[[1]]$Parameters[[2]]$Value
      [1] 1
      
      $Schemas[[2]]$SchemaItems[[1]]$Parameters[[2]]$Unit
      [1] "mg/kg"
      
      
      $Schemas[[2]]$SchemaItems[[1]]$Parameters[[3]]
      $Schemas[[2]]$SchemaItems[[1]]$Parameters[[3]]$Name
      [1] "Volume of water/body weight"
      
      $Schemas[[2]]$SchemaItems[[1]]$Parameters[[3]]$Value
      [1] 3.5
      
      $Schemas[[2]]$SchemaItems[[1]]$Parameters[[3]]$Unit
      [1] "ml/kg"
      
      
      
      $Schemas[[2]]$SchemaItems[[1]]$FormulationKey
      [1] "Formulation2"
      
      
      
      $Schemas[[2]]$Parameters
      $Schemas[[2]]$Parameters[[1]]
      $Schemas[[2]]$Parameters[[1]]$Name
      [1] "Start time"
      
      $Schemas[[2]]$Parameters[[1]]$Value
      [1] 0
      
      $Schemas[[2]]$Parameters[[1]]$Unit
      [1] "h"
      
      
      $Schemas[[2]]$Parameters[[2]]
      $Schemas[[2]]$Parameters[[2]]$Name
      [1] "NumberOfRepetitions"
      
      $Schemas[[2]]$Parameters[[2]]$Value
      [1] 2
      
      
      $Schemas[[2]]$Parameters[[3]]
      $Schemas[[2]]$Parameters[[3]]$Name
      [1] "TimeBetweenRepetitions"
      
      $Schemas[[2]]$Parameters[[3]]$Value
      [1] 12
      
      $Schemas[[2]]$Parameters[[3]]$Unit
      [1] "h"
      
      
      
      
      

