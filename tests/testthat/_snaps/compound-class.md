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
    Output
      <Property>
        * Property Name: Plasma protein binding partner
        * Parameter name: Plasma protein binding partner
        * Path: {compoundName}|Plasma protein binding partner
        * Value: Albumin

# `getAllProperty` works 

    Code
      myCompound$getAllProperty()
    Output
      $Lipophilicity
      <Property>
        * Property Name: Lipophilicity
        * Parameter name: Lipophilicity
        * Path: {compoundName}|Lipophilicity
        * Value: 0
        * Unit: Log Units
      
      $`Fraction unbound`
      <Property>
        * Property Name: Fraction unbound
        * Parameter name: Fraction unbound (plasma, reference value)
        * Path: {compoundName}|Fraction unbound (plasma, reference value)
        * Value: 1
      
      $`Plasma protein binding partner`
      <Property>
        * Property Name: Plasma protein binding partner
        * Parameter name: Plasma protein binding partner
        * Path: {compoundName}|Plasma protein binding partner
        * Value: Albumin
      
      $`Is small molecule`
      <Property>
        * Property Name: Is small molecule
        * Parameter name: Is small molecule
        * Path: {compoundName}|Is small molecule
        * Value: 1
      
      $`Molecular weight`
      <Property>
        * Property Name: Molecular weight
        * Parameter name: Molecular weight
        * Path: {compoundName}|Molecular weight
        * Value: 100
        * Unit: g/mol
      
      $`Bromine count`
      <Property>
        * Property Name: Bromine count
        * Parameter name: Br
        * Path: {compoundName}|Br
        * Value: 0
      
      $`Chlorine count`
      <Property>
        * Property Name: Chlorine count
        * Parameter name: Cl
        * Path: {compoundName}|Cl
        * Value: 0
      
      $`Fluorine count`
      <Property>
        * Property Name: Fluorine count
        * Parameter name: F
        * Path: {compoundName}|F
        * Value: 0
      
      $`Iodine count`
      <Property>
        * Property Name: Iodine count
        * Parameter name: I
        * Path: {compoundName}|I
        * Value: 0
      
      $`pKa value 0`
      <Property>
        * Property Name: pKa value 0
        * Parameter name: pKa value 0
        * Path: {compoundName}|pKa value 0
        * Value: 0
      
      $`Compound type 0`
      <Property>
        * Property Name: Compound type 0
        * Parameter name: Compound type 0
        * Path: {compoundName}|Compound type 0
        * Value: Neutral
      
      $`pKa value 1`
      <Property>
        * Property Name: pKa value 1
        * Parameter name: pKa value 1
        * Path: {compoundName}|pKa value 1
        * Value: 0
      
      $`Compound type 1`
      <Property>
        * Property Name: Compound type 1
        * Parameter name: Compound type 1
        * Path: {compoundName}|Compound type 1
        * Value: Neutral
      
      $`pKa value 2`
      <Property>
        * Property Name: pKa value 2
        * Parameter name: pKa value 2
        * Path: {compoundName}|pKa value 2
        * Value: 0
      
      $`Compound type 2`
      <Property>
        * Property Name: Compound type 2
        * Parameter name: Compound type 2
        * Path: {compoundName}|Compound type 2
        * Value: Neutral
      
      $`Reference pH`
      <Property>
        * Property Name: Reference pH
        * Parameter name: Reference pH
        * Path: {compoundName}|Reference pH
        * Value: 7
      
      $`Total Hepatic Clearance half life`
      <Property>
        * Property Name: Total Hepatic Clearance half life
        * Parameter name: t1/2 (microsomal assay)
        * Path: {compoundName}-Total Hepatic Clearance-In vitro microsomes Rat|t1/2
        (microsomal assay)
        * Value: 0.1
        * Unit: 1/min
      

# `setProperty` works

    Code
      myCompound$getProperty("Lipophilicity")
    Output
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
    Output
      <Property>
        * Property Name: Thalf
        * Parameter name: t1/2 (microsomal assay)
        * Path: {compoundName}-Total Hepatic Clearance-Liver Mic T1/2|t1/2
        (microsomal assay)
        * Value: 0.1
        * Unit: min

# `getAllProcessProperty` works

    Code
      myCompound$getAllProcessProperty(processType = "Liver Mic T1/2")
    Output
      $`Fu assay`
      <Property>
        * Property Name: Fu assay
        * Parameter name: Fraction unbound (assay)
        * Path: {compoundName}-Total Hepatic Clearance-Liver Mic T1/2|Fraction
        unbound (assay)
        * Value: 0.5
      
      $Thalf
      <Property>
        * Property Name: Thalf
        * Parameter name: t1/2 (microsomal assay)
        * Path: {compoundName}-Total Hepatic Clearance-Liver Mic T1/2|t1/2
        (microsomal assay)
        * Value: 0.1
        * Unit: min
      

---

    Code
      myCompound$getAllProcessProperty()
    Output
      $`Liver Mic T1/2`
      $`Liver Mic T1/2`$`Fu assay`
      <Property>
        * Property Name: Fu assay
        * Parameter name: Fraction unbound (assay)
        * Path: {compoundName}-Total Hepatic Clearance-Liver Mic T1/2|Fraction
        unbound (assay)
        * Value: 0.5
      
      $`Liver Mic T1/2`$Thalf
      <Property>
        * Property Name: Thalf
        * Parameter name: t1/2 (microsomal assay)
        * Path: {compoundName}-Total Hepatic Clearance-Liver Mic T1/2|t1/2
        (microsomal assay)
        * Value: 0.1
        * Unit: min
      
      

# `setProcessProperty` works

    Code
      myCompound$getProcessProperty(propertyName = "Thalf", processType = "Liver Mic T1/2")
    Output
      <Property>
        * Property Name: Thalf
        * Parameter name: t1/2 (microsomal assay)
        * Path: {compoundName}-Total Hepatic Clearance-Liver Mic T1/2|t1/2
        (microsomal assay)
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

