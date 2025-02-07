# Property `print` method works

    Code
      prop$print()
    Output
      Property: 
         Property Name: Solubility 
         Parameter name: Solubility at reference pH 
         Path: {compoundName}|Solubility at reference pH 
         Value: 100 
         Unit: mg/l 

# `toBaseUnit` method (transformation to base units) works

    Code
      prop$toBaseUnit()
    Output
      [1] 1e-04

# `toSnapshot` method works

    Code
      prop$toSnapshot()
    Output
      $Name
      [1] "Solubility at reference pH"
      
      $Value
      [1] 100
      
      $Unit
      [1] "mg/l"
      

