# extractProtocol works

    Code
      tmp
    Output
      # A tibble: 7 x 9
      # Rowwise: 
        type   time parameters formulationType formulationName formulation allowedPath
        <chr> <dbl> <list>     <chr>           <chr>           <list>      <list>     
      1 Oral      0 <SmplPrtc> Dissolved       Dissolved       <Formultn>  <NULL>     
      2 IV B~   720 <SmplPrtc> <NA>            <NA>            <NULL>      <NULL>     
      3 Oral    720 <SmplPrtc> Dissolved       Dissolved       <Formultn>  <NULL>     
      4 IV B~   840 <SmplPrtc> <NA>            <NA>            <NULL>      <NULL>     
      5 IV B~   960 <SmplPrtc> <NA>            <NA>            <NULL>      <NULL>     
      6 IV B~  1080 <SmplPrtc> <NA>            <NA>            <NULL>      <NULL>     
      7 IV B~  1200 <SmplPrtc> <NA>            <NA>            <NULL>      <NULL>     
      # i 2 more variables: path <list>, formulationKey <chr>

---

    Code
      tmp$parameters
    Output
      [[1]]
    Message
      * Route: Oral
      * Dose: 5 mg/kg
      * Dose Interval: Single Dose
      * Start Time: 0 h
      * Volume of water per body weight: 3.5 ml/kg
      * Formulation: Dissolved
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
      * Route: Oral
      * Dose: 5 mg/kg
      * Dose Interval: Single Dose
      * Start Time: 0 h
      * Volume of water per body weight: 3.5 ml/kg
      * Formulation: Dissolved
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
      * Route: Intravenous bolus
      * Dose: 10 mg/kg
      * Dose Interval: Single Dose
      * Start Time: 0 h
    Output
      
      [[7]]
    Message
      * Route: Intravenous bolus
      * Dose: 10 mg/kg
      * Dose Interval: Single Dose
      * Start Time: 0 h
    Output
      

# getAllParameterPaths works

    Code
      prot$getAllParameterPaths()
    Output
       [1] "Events|Protocol|Dissolved|Application_01|ProtocolSchemaItem|DosePerBodyWeight"          
       [2] "Events|Protocol|Dissolved|Application_01|ProtocolSchemaItem|Start time"                 
       [3] "Events|Protocol|Dissolved|Application_01|ProtocolSchemaItem|Volume of water/body weight"
       [4] "Events|Protocol|Application_02|ProtocolSchemaItem|Dose"                                 
       [5] "Events|Protocol|Application_02|ProtocolSchemaItem|Start time"                           
       [6] "Events|Protocol|Application_02|ProtocolSchemaItem|Infusion time"                        
       [7] "Events|Protocol|Application_03|ProtocolSchemaItem|DosePerBodySurfaceArea"               
       [8] "Events|Protocol|Application_03|ProtocolSchemaItem|Start time"                           
       [9] "Events|Protocol|Dissolved|Application_04|ProtocolSchemaItem|DosePerBodyWeight"          
      [10] "Events|Protocol|Dissolved|Application_04|ProtocolSchemaItem|Start time"                 
      [11] "Events|Protocol|Dissolved|Application_04|ProtocolSchemaItem|Volume of water/body weight"
      [12] "Events|Protocol|Application_05|ProtocolSchemaItem|Dose"                                 
      [13] "Events|Protocol|Application_05|ProtocolSchemaItem|Start time"                           
      [14] "Events|Protocol|Application_05|ProtocolSchemaItem|Infusion time"                        
      [15] "Events|Protocol|Application_06|ProtocolSchemaItem|DosePerBodySurfaceArea"               
      [16] "Events|Protocol|Application_06|ProtocolSchemaItem|Start time"                           
      [17] "Events|Protocol|Application_07|ProtocolSchemaItem|Dose"                                 
      [18] "Events|Protocol|Application_07|ProtocolSchemaItem|Start time"                           
      [19] "Events|Protocol|Application_07|ProtocolSchemaItem|Infusion time"                        
      [20] "Events|Protocol|Application_08|ProtocolSchemaItem|DosePerBodySurfaceArea"               
      [21] "Events|Protocol|Application_08|ProtocolSchemaItem|Start time"                           
      [22] "Events|Protocol|Application_09|ProtocolSchemaItem|Dose"                                 
      [23] "Events|Protocol|Application_09|ProtocolSchemaItem|Start time"                           
      [24] "Events|Protocol|Application_09|ProtocolSchemaItem|Infusion time"                        
      [25] "Events|Protocol|Application_10|ProtocolSchemaItem|DosePerBodySurfaceArea"               
      [26] "Events|Protocol|Application_10|ProtocolSchemaItem|Start time"                           
      [27] "Events|Protocol|Application_11|ProtocolSchemaItem|Dose"                                 
      [28] "Events|Protocol|Application_11|ProtocolSchemaItem|Start time"                           
      [29] "Events|Protocol|Application_11|ProtocolSchemaItem|Infusion time"                        
      [30] "Events|Protocol|Application_12|ProtocolSchemaItem|DosePerBodySurfaceArea"               
      [31] "Events|Protocol|Application_12|ProtocolSchemaItem|Start time"                           

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
      # A tibble: 17 x 9
      # Rowwise: 
         type         time parameters formulationType formulationName formulation
         <chr>       <dbl> <list>     <chr>           <chr>           <list>     
       1 Oral            0 <SmplPrtc> Weibull         Weibull2        <Formultn> 
       2 IV Infusion   720 <SmplPrtc> <NA>            <NA>            <NULL>     
       3 IV Bolus      720 <SmplPrtc> <NA>            <NA>            <NULL>     
       4 Oral          720 <SmplPrtc> Weibull         Weibull1        <Formultn> 
       5 Oral          720 <SmplPrtc> Weibull         Weibull2        <Formultn> 
       6 IV Infusion   840 <SmplPrtc> <NA>            <NA>            <NULL>     
       7 IV Bolus      840 <SmplPrtc> <NA>            <NA>            <NULL>     
       8 Oral          840 <SmplPrtc> Weibull         Weibull1        <Formultn> 
       9 IV Infusion   960 <SmplPrtc> <NA>            <NA>            <NULL>     
      10 IV Bolus      960 <SmplPrtc> <NA>            <NA>            <NULL>     
      11 Oral          960 <SmplPrtc> Weibull         Weibull1        <Formultn> 
      12 IV Infusion  1080 <SmplPrtc> <NA>            <NA>            <NULL>     
      13 IV Bolus     1080 <SmplPrtc> <NA>            <NA>            <NULL>     
      14 Oral         1080 <SmplPrtc> Weibull         Weibull1        <Formultn> 
      15 IV Infusion  1200 <SmplPrtc> <NA>            <NA>            <NULL>     
      16 IV Bolus     1200 <SmplPrtc> <NA>            <NA>            <NULL>     
      17 Oral         1200 <SmplPrtc> Weibull         Weibull1        <Formultn> 
      # i 3 more variables: allowedPath <list>, path <list>, formulationKey <chr>

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
      
      
      
      
      

