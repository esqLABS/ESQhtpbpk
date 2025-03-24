# `print` method of compound class works

    Code
      myCompound$print()
    Message
      * Compound properties:
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
        * Partition Coefficient Method: PK-Sim Standard
        * Cellular Permeability Method: PK-Sim Standard

# `addProperty` method works

    Code
      myCompound$print()
    Message
      * Compound properties:
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
        * Partition Coefficient Method: PK-Sim Standard
        * Cellular Permeability Method: PK-Sim Standard

# `removeProperty` works

    Code
      myCompound$print()
    Message
      * Compound properties:
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

