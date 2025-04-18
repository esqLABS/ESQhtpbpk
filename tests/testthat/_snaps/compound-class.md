# `print` method of compound class works

    Code
      myCompound$print()
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

# `addProperty` method works

    Code
      myCompound$print()
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
        * Total Hepatic Clearance half life: 0.1 1/min
      * Compound Methods:
        * Partition Coefficient Method: PK-Sim Standard
        * Cellular Permeability Method: PK-Sim Standard

# `removeProperty` works

    Code
      myCompound$print()
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
        * Total Hepatic Clearance half life: 0.1 1/min
      * Compound Methods:
        * Partition Coefficient Method: PK-Sim Standard
        * Cellular Permeability Method: PK-Sim Standard

# `getProperty` works

    Code
      myCompound$getProperty("Plasma protein binding partner")
    Message
      <Property>
      * Property Name: Plasma protein binding partner
      * Parameter name: Plasma protein binding partner
      * Path: {compoundName}|Plasma protein binding partner
      * Value: Albumin

# `setProperty` works

    Code
      myCompound$getProperty("Lipophilicity")
    Message
      <Property>
      * Property Name: Lipophilicity
      * Parameter name: Lipophilicity
      * Path: {compoundName}|Lipophilicity
      * Value: 0.5
      * Unit: Log Units

# `addProcessProperty` method works

    Code
      myCompound$print()
    Message
      * Compound Properties:
        * Lipophilicity: 0.5 Log Units
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
        * Total Hepatic Clearance half life: 0.1 1/min
      * Compound Processes:
        * Liver Mic T1/2
          * Thalf: 0.1 min
      * Compound Methods:
        * Partition Coefficient Method: PK-Sim Standard
        * Cellular Permeability Method: PK-Sim Standard

# `removeProcessProperty` works

    Code
      myCompound$print()
    Message
      * Compound Properties:
        * Lipophilicity: 0.5 Log Units
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
        * Total Hepatic Clearance half life: 0.1 1/min
      * Compound Processes:
        * Liver Mic T1/2
          * Fu assay: 0.5
      * Compound Methods:
        * Partition Coefficient Method: PK-Sim Standard
        * Cellular Permeability Method: PK-Sim Standard

# `getProcessProperty` works

    Code
      myCompound$getProcessProperty(propertyName = "Thalf", processType = "Liver Mic T1/2")
    Message
      <Property>
      * Property Name: Thalf
      * Parameter name: t1/2 (microsomal assay)
      * Path: {compoundName}-Total Hepatic Clearance-Liver Mic T1/2|t1/2 (microsomal
      assay)
      * Value: 0.1
      * Unit: min

# `setProcessProperty` works

    Code
      myCompound$getProcessProperty(propertyName = "Thalf", processType = "Liver Mic T1/2")
    Message
      <Property>
      * Property Name: Thalf
      * Parameter name: t1/2 (microsomal assay)
      * Path: {compoundName}-Total Hepatic Clearance-Liver Mic T1/2|t1/2 (microsomal
      assay)
      * Value: 0.5
      * Unit: min

# `getAllPropertyPaths` works

    Code
      myCompound$getAllPropertyPaths()
    Output
       [1] "Compound|Lipophilicity"                                                          
       [2] "Compound|Fraction unbound (plasma, reference value)"                             
       [3] "Compound|Plasma protein binding partner"                                         
       [4] "Compound|Is small molecule"                                                      
       [5] "Compound|Molecular weight"                                                       
       [6] "Compound|Br"                                                                     
       [7] "Compound|Cl"                                                                     
       [8] "Compound|F"                                                                      
       [9] "Compound|I"                                                                      
      [10] "Compound|pKa value 0"                                                            
      [11] "Compound|Compound type 0"                                                        
      [12] "Compound|pKa value 1"                                                            
      [13] "Compound|Compound type 1"                                                        
      [14] "Compound|pKa value 2"                                                            
      [15] "Compound|Compound type 2"                                                        
      [16] "Compound|Reference pH"                                                           
      [17] "Compound-Total Hepatic Clearance-In vitro microsomes Rat|t1/2 (microsomal assay)"
      [18] "Compound-Total Hepatic Clearance-Liver Mic T1/2|Fraction unbound (assay)"        
      [19] "Compound-Total Hepatic Clearance-Liver Mic T1/2|t1/2 (microsomal assay)"         

