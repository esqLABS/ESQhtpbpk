# createDissolvedFormulation works

    Code
      formulation
    Message
      Formulation Name: Dissolved
      Formulation Type: Dissolved

# createWeibullFormulation works

    Code
      formulation
    Message
      Formulation Name: Weibull
      Formulation Type: Weibull
    Output
         Dissolution time (50% dissolved): 240 min 
         Lag time: 0 min 
         Dissolution shape: 0.92  
         Use as suspension: 1  

# createLint80Formulation works

    Code
      formulation
    Message
      Formulation Name: Lint80
      Formulation Type: Lint80
    Output
         Dissolution time (80% dissolved): 240 min 
         Lag time: 0 min 
         Use as suspension: 1  

# createParticleDissolutionFormulation works

    Code
      formulation
    Message
      Formulation Name: ParticleMono
      Formulation Type: Particle
    Output
         Thickness (unstirred water layer): 30 µm 
         Type of particle size distribution: Monodisperse 
         Particle radius (mean): 10 µm 

---

    Code
      formulation
    Message
      Formulation Name: ParticlePolyNormal
      Formulation Type: Particle
    Output
         Thickness (unstirred water layer): 30 µm 
         Type of particle size distribution: Polydisperse 
         Particle size distribution: Normal 
         Particle radius (mean): 10 µm 
         Particle radius (SD): 3 µm 
         Particle radius (min): 1 µm 
         Particle radius (max): 19 µm 
         Number of bins: 3  

---

    Code
      formulation
    Message
      Formulation Name: ParticlePolyLogNormal
      Formulation Type: Particle
    Output
         Thickness (unstirred water layer): 30 µm 
         Type of particle size distribution: Polydisperse 
         Particle size distribution: LogNormal 
         Particle radius (geomean): 10 µm 
         Coefficient of variation: 1.5  
         Particle radius (min): 1 µm 
         Particle radius (max): 19 µm 
         Number of bins: 3  

# createZeroOrderFormulation works

    Code
      formulation
    Message
      Formulation Name: 0Order
      Formulation Type: ZeroOrder
    Output
         End time: 60 min 

# createFirstOrderFormulation works

    Code
      formulation
    Message
      Formulation Name: 1stOrder
      Formulation Type: ZeroOrder
    Output
         End time: 60 min 

# Export to snapshot works

    Code
      formulation$toSnapshot()
    Output
      $Name
      [1] "OralWeibull"
      
      $FormulationType
      [1] "Formulation_Tablet_Weibull"
      
      $Parameters
      $Parameters$`Dissolution time (50% dissolved)`
      $Parameters$`Dissolution time (50% dissolved)`$Name
      [1] "Dissolution time (50% dissolved)"
      
      $Parameters$`Dissolution time (50% dissolved)`$Parameters
      $Parameters$`Dissolution time (50% dissolved)`$Parameters[[1]]
      $Parameters$`Dissolution time (50% dissolved)`$Parameters[[1]]$Name
      [1] "Dissolution time (50% dissolved)"
      
      $Parameters$`Dissolution time (50% dissolved)`$Parameters[[1]]$Value
      [1] 240
      
      $Parameters$`Dissolution time (50% dissolved)`$Parameters[[1]]$Unit
      [1] "min"
      
      
      
      
      $Parameters$`Lag time`
      $Parameters$`Lag time`$Name
      [1] "Lag time"
      
      $Parameters$`Lag time`$Parameters
      $Parameters$`Lag time`$Parameters[[1]]
      $Parameters$`Lag time`$Parameters[[1]]$Name
      [1] "Lag time"
      
      $Parameters$`Lag time`$Parameters[[1]]$Value
      [1] 0
      
      $Parameters$`Lag time`$Parameters[[1]]$Unit
      [1] "min"
      
      
      
      
      $Parameters$`Dissolution shape`
      $Parameters$`Dissolution shape`$Name
      [1] "Dissolution shape"
      
      $Parameters$`Dissolution shape`$Parameters
      $Parameters$`Dissolution shape`$Parameters[[1]]
      $Parameters$`Dissolution shape`$Parameters[[1]]$Name
      [1] "Dissolution shape"
      
      $Parameters$`Dissolution shape`$Parameters[[1]]$Value
      [1] 0.92
      
      
      
      
      $Parameters$`Use as suspension`
      $Parameters$`Use as suspension`$Name
      [1] "Use as suspension"
      
      $Parameters$`Use as suspension`$Parameters
      $Parameters$`Use as suspension`$Parameters[[1]]
      $Parameters$`Use as suspension`$Parameters[[1]]$Name
      [1] "Use as suspension"
      
      $Parameters$`Use as suspension`$Parameters[[1]]$Value
      [1] 1
      
      
      
      
      

---

    Code
      formulation$toSnapshot()
    Output
      $Name
      [1] "OralDissolved"
      
      $FormulationType
      [1] "Formulation_Dissolved"
      

# getAllPropertyPaths method works

    Code
      formulation$getAllPropertyPaths()
    Output
      [1] "{protocolName}|{formulationName}|Dissolution time (50% dissolved)"
      [2] "{protocolName}|{formulationName}|Lag time"                        
      [3] "{protocolName}|{formulationName}|Dissolution shape"               
      [4] "{protocolName}|{formulationName}|Use as suspension"               

---

    Code
      formulation$getAllPropertyPaths(protocolName = "Protocol", formulationName = formulation$
        Name)
    Output
      [1] "Protocol|OralWeibull|Dissolution time (50% dissolved)"
      [2] "Protocol|OralWeibull|Lag time"                        
      [3] "Protocol|OralWeibull|Dissolution shape"               
      [4] "Protocol|OralWeibull|Use as suspension"               

