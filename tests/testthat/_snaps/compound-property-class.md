# Property `print` method works

    Code
      prop$print()
    Output
      Property: 
         Name: Solubility 
         Path: Compound|Solubility at reference pH 
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
      [1] "Solubility"
      
      $Parameters
      $Parameters[[1]]
      $Parameters[[1]]$Name
      [1] "Solubility"
      
      $Parameters[[1]]$Value
      [1] 100
      
      $Parameters[[1]]$Unit
      [1] "mg/l"
      
      
      

