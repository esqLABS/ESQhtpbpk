# Study field can be accessed

    Code
      study$Compounds
    Output
      [[1]]
    Message
      * Compound Properties:
        * Lipophilicity: 0 Log Units
        * Fraction unbound: 1
        * Plasma protein binding partner: Albumin
        * Is small molecule: 1
        * Molecular weight: 100 g/mol
        * Bromine count: 0
        * Chlorine count: 0
        * Fluorine count: 0
        * Iodine count: 0
        * pKa value 0: 0
        * Compound type 0: Neutral
        * pKa value 1: 0
        * Compound type 1: Neutral
        * pKa value 2: 0
        * Compound type 2: Neutral
        * Reference pH: 7
        * Solubility: 1 mg/l
      * Compound Processes:
        * Liver Plasma Clearance
          * Plasma clearance: 10 ml/min/kg
      * Compound Methods:
        * Partition Coefficient Method: PK-Sim Standard
        * Cellular Permeability Method: PK-Sim Standard
      * Protocol Properties:
          * Route: Intravenous bolus
          * Dose: 1 mg/kg
          * Dose Interval: Once each 24 hours
          * Start Time: 60 min
          * End Time: 48 h
    Output
      
      [[2]]
    Message
      * Compound Properties:
        * Lipophilicity: 0 Log Units
        * Fraction unbound: 1
        * Plasma protein binding partner: Albumin
        * Is small molecule: 1
        * Molecular weight: 100 g/mol
        * Bromine count: 0
        * Chlorine count: 0
        * Fluorine count: 0
        * Iodine count: 0
        * pKa value 0: 0
        * Compound type 0: Neutral
        * pKa value 1: 0
        * Compound type 1: Neutral
        * pKa value 2: 0
        * Compound type 2: Neutral
        * Reference pH: 7
        * Solubility: 1 mg/l
      * Compound Methods:
        * Partition Coefficient Method: PK-Sim Standard
        * Cellular Permeability Method: PK-Sim Standard
      * Protocol Properties:
        Schema: Schema 1
          * Start time: 12 h
          * Number of repetitions: 5
          * Time between repetitions: 2 h
          Schema item 1
            * Route: Oral
            * Dose: 10 mg
            * Dose Interval: Single Dose
            * Start Time: 0 h
            * Volume of water per body weight: 3.5 ml/kg
            * Formulation: Tablet
    Output
      

---

    Code
      study$Individual
    Output
      [1] "Rat"

# print method works

    Code
      study
    Output
      Study: 
    Message
      ID: Study1
      Individual: Rat
      Compounds:
      
      * Compound 1 with protocol Protocol 1
        * Compound Properties:
          * Lipophilicity: 0 Log Units
          * Fraction unbound: 1
          * Plasma protein binding partner: Albumin
          * Is small molecule: 1
          * Molecular weight: 100 g/mol
          * Bromine count: 0
          * Chlorine count: 0
          * Fluorine count: 0
          * Iodine count: 0
          * pKa value 0: 0
          * Compound type 0: Neutral
          * pKa value 1: 0
          * Compound type 1: Neutral
          * pKa value 2: 0
          * Compound type 2: Neutral
          * Reference pH: 7
          * Solubility: 1 mg/l
        * Compound Processes:
          * Liver Plasma Clearance
            * Plasma clearance: 10 ml/min/kg
        * Compound Methods:
          * Partition Coefficient Method: PK-Sim Standard
          * Cellular Permeability Method: PK-Sim Standard
        * Protocol Properties:
            * Route: Intravenous bolus
            * Dose: 1 mg/kg
            * Dose Interval: Once each 24 hours
            * Start Time: 60 min
            * End Time: 48 h
      * Compound 2 with protocol Protocol 2
        * Compound Properties:
          * Lipophilicity: 0 Log Units
          * Fraction unbound: 1
          * Plasma protein binding partner: Albumin
          * Is small molecule: 1
          * Molecular weight: 100 g/mol
          * Bromine count: 0
          * Chlorine count: 0
          * Fluorine count: 0
          * Iodine count: 0
          * pKa value 0: 0
          * Compound type 0: Neutral
          * pKa value 1: 0
          * Compound type 1: Neutral
          * pKa value 2: 0
          * Compound type 2: Neutral
          * Reference pH: 7
          * Solubility: 1 mg/l
        * Compound Methods:
          * Partition Coefficient Method: PK-Sim Standard
          * Cellular Permeability Method: PK-Sim Standard
        * Protocol Properties:
          Schema: Schema 1
            * Start time: 12 h
            * Number of repetitions: 5
            * Time between repetitions: 2 h
            Schema item 1
              * Route: Oral
              * Dose: 10 mg
              * Dose Interval: Single Dose
              * Start Time: 0 h
              * Volume of water per body weight: 3.5 ml/kg
              * Formulation: Tablet

# getAllParameterPaths method works

    Code
      study$getAllParameterPaths()
    Output
       [1] "Compound 1|Lipophilicity"                                                             
       [2] "Compound 1|Fraction unbound (plasma, reference value)"                                
       [3] "Compound 1|Plasma protein binding partner"                                            
       [4] "Compound 1|Is small molecule"                                                         
       [5] "Compound 1|Molecular weight"                                                          
       [6] "Compound 1|Br"                                                                        
       [7] "Compound 1|Cl"                                                                        
       [8] "Compound 1|F"                                                                         
       [9] "Compound 1|I"                                                                         
      [10] "Compound 1|pKa value 0"                                                               
      [11] "Compound 1|Compound type 0"                                                           
      [12] "Compound 1|pKa value 1"                                                               
      [13] "Compound 1|Compound type 1"                                                           
      [14] "Compound 1|pKa value 2"                                                               
      [15] "Compound 1|Compound type 2"                                                           
      [16] "Compound 1|Reference pH"                                                              
      [17] "Compound 1|Solubility at reference pH"                                                
      [18] "Compound 1-Total Hepatic Clearance-Liver Plasma Clearance|Plasma clearance"           
      [19] "Events|Protocol 1|Application_1|ProtocolSchemaItem|DosePerBodyWeight"                 
      [20] "Events|Protocol 1|Application_1|ProtocolSchemaItem|Start time"                        
      [21] "Events|Protocol 1|Application_2|ProtocolSchemaItem|DosePerBodyWeight"                 
      [22] "Events|Protocol 1|Application_2|ProtocolSchemaItem|Start time"                        
      [23] "Compound 2|Lipophilicity"                                                             
      [24] "Compound 2|Fraction unbound (plasma, reference value)"                                
      [25] "Compound 2|Plasma protein binding partner"                                            
      [26] "Compound 2|Is small molecule"                                                         
      [27] "Compound 2|Molecular weight"                                                          
      [28] "Compound 2|Br"                                                                        
      [29] "Compound 2|Cl"                                                                        
      [30] "Compound 2|F"                                                                         
      [31] "Compound 2|I"                                                                         
      [32] "Compound 2|pKa value 0"                                                               
      [33] "Compound 2|Compound type 0"                                                           
      [34] "Compound 2|pKa value 1"                                                               
      [35] "Compound 2|Compound type 1"                                                           
      [36] "Compound 2|pKa value 2"                                                               
      [37] "Compound 2|Compound type 2"                                                           
      [38] "Compound 2|Reference pH"                                                              
      [39] "Compound 2|Solubility at reference pH"                                                
      [40] "Events|Protocol 2|Tablet|Application_1|ProtocolSchemaItem|Dose"                       
      [41] "Events|Protocol 2|Tablet|Application_1|ProtocolSchemaItem|Start time"                 
      [42] "Events|Protocol 2|Tablet|Application_1|ProtocolSchemaItem|Volume of water/body weight"
      [43] "Events|Protocol 2|Tablet|Application_2|ProtocolSchemaItem|Dose"                       
      [44] "Events|Protocol 2|Tablet|Application_2|ProtocolSchemaItem|Start time"                 
      [45] "Events|Protocol 2|Tablet|Application_2|ProtocolSchemaItem|Volume of water/body weight"
      [46] "Events|Protocol 2|Tablet|Application_3|ProtocolSchemaItem|Dose"                       
      [47] "Events|Protocol 2|Tablet|Application_3|ProtocolSchemaItem|Start time"                 
      [48] "Events|Protocol 2|Tablet|Application_3|ProtocolSchemaItem|Volume of water/body weight"
      [49] "Events|Protocol 2|Tablet|Application_4|ProtocolSchemaItem|Dose"                       
      [50] "Events|Protocol 2|Tablet|Application_4|ProtocolSchemaItem|Start time"                 
      [51] "Events|Protocol 2|Tablet|Application_4|ProtocolSchemaItem|Volume of water/body weight"
      [52] "Events|Protocol 2|Tablet|Application_5|ProtocolSchemaItem|Dose"                       
      [53] "Events|Protocol 2|Tablet|Application_5|ProtocolSchemaItem|Start time"                 
      [54] "Events|Protocol 2|Tablet|Application_5|ProtocolSchemaItem|Volume of water/body weight"
      [55] "Events|Protocol 2|Tablet|Dissolution time (50% dissolved)"                            
      [56] "Events|Protocol 2|Tablet|Lag time"                                                    
      [57] "Events|Protocol 2|Tablet|Dissolution shape"                                           
      [58] "Events|Protocol 2|Tablet|Use as suspension"                                           

