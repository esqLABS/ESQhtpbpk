createGenericPKMLs <- function(studyList, outputFolder) {
  genericStudies <- list()
  studyStructureSummary <- tibble::tibble(
    "StudyID" = character(),
    "Individuals" = character(),
    "CompoundsID" = list(),
    "Compounds" =  list(),
    "PC" = list(),
    "CP" =  list(),
    "FormulationsProtocols" = list() #,
    # "Processes" = list()
  )

  for (study in studyList) {
    studyStructureSummary <- rbind(
      studyStructureSummary,
      tibble::tibble(
        "StudyID" = study$ID,
        "Individuals" = study$Individual,
        "CompoundsID" = list(purrr::list_c(purrr::map(study$Compounds, \(x) {as.character(x$ID)}))),
        "Compounds" = list(paste0("Compound", seq_along(study$Compounds))),
        "PC" = list(purrr::map(study$Compounds, \(x) {names(PCMethods)[PCMethods == x$PartitionCoefficientMethod]})),
        "CP" = list(purrr::map(study$Compounds, \(x){names(CPMethods)[CPMethods == x$CellularPermeabilityMethod]})),
        "FormulationsProtocols" = list(
          purrr::map(study$Compounds, ~ .x$Protocol$extractProtocol() %>%
                       group_by(type, formulationType, formulationKey, formulationName) %>%
                       summarise(nAdmins = n(), .groups = "drop") %>%
                       group_by(type, formulationType) %>% arrange(desc(nAdmins), .by_group = TRUE) %>%
                       mutate(formulationKeySim = ifelse(is.na(formulationKey), NA, paste(type, na.omit(formulationType), row_number())))
                     )
        ) # ,
        # "Processes" = list()
      )
    )
  }

  # for (study in studyList) {
  genericStudyStructure <- studyStructureSummary %>% select(-StudyID, -FormulationsProtocols, -CompoundsID) %>% unique()

  # get generic model based on structure
  genericStudyStructure <- genericStudyStructure %>% mutate(GenericModel = paste0("Model", row_number()))

  # add generic model to each study structure summary
  studyStructureSummary <- left_join(studyStructureSummary, genericStudyStructure, by = c("Individuals","Compounds", "PC", "CP"))

  for (model in genericStudyStructure$GenericModel) {
    studySubset <- studyStructureSummary %>% filter(GenericModel == model)
    studySubset <- studySubset %>% select(-GenericModel, -StudyID, -Individuals, -PC, -CP)
    studySubset <- studySubset %>% tidyr::unnest(cols = everything())

    # summarise protocol x formulation needed for each compound accross studies using the same generic model
    studySubset <- studySubset %>% group_by(Compounds) %>%
      summarise(FormulationsProtocols = list(
        bind_rows(FormulationsProtocols) %>%
          group_by(type, formulationType, formulationKeySim) %>%
          summarise(nAdmins = max(nAdmins))
        )
      )
    # summarise processes needed for each compound accross studies using the same generic model

    compounds <- lapply(studySubset$Compounds, \(x) {
      comp <- Compound$new(ID = x, name = x)

      compIdx <- which(unlist(genericStudyStructure %>% filter(GenericModel == model) %>% pull(Compounds)) == x)
      # add PC
      comp$PartitionCoefficientMethod <- unlist(genericStudyStructure %>% filter(GenericModel == model) %>% pull(PC))[[compIdx]]
      # add CP
      comp$CellularPermeabilityMethod <- unlist(genericStudyStructure %>% filter(GenericModel == model) %>% pull(CP))[[compIdx]]
      # add process

      # add protocol
      prot <- AdvancedProtocol$new(name = paste(x, "Protocol"))

      admins <- (studySubset %>% filter(Compounds == x) %>% pull(FormulationsProtocols))[[1]]

      for (i in 1:nrow(admins)) {
        prot$addSchema(schemaName = paste("Schema", i), startTime = i, numberOfRepetitions = admins$nAdmins[i], timeBetweenRepetitions = 0, timeUnit = "h")

        sp <- SimpleProtocol$new(name = "SimpleProtocol", dosingInterval = "Single", route = admins$type[i])

        if (!is.na(admins$formulationType[i])) {
          fun <- get(paste0("create", admins$formulationType[i], "Formulation"))
          form <- fun(name = paste(admins$formulationKeySim[i]))
          sp$setFormulation(form)
        }
        prot$addProtocolToSchema(protocol = sp, schemaName = paste("Schema", i))
      }
      comp$setProtocol(prot)
    })

    genericStudies <- c(
      genericStudies,
      Study$new(ID = model, individual = genericStudyStructure %>% filter(GenericModel == model) %>% pull(Individuals), compounds = compounds)
    )
  }

  # create pkml for each generic study and update the model path and simulation of corresponding user studies
  for (genStudy in genericStudies) {
    genStudy$exportPKML(file.path(outputFolder, paste0(genStudy$ID, ".pkml")))

    # load generic simulation once and add reference to user study
    sim <- ospsuite::loadSimulation(file.path(outputFolder, paste0(genStudy$ID, ".pkml")))

    # add Model path to each study from studyList
    studyIDs <- studyStructureSummary %>% filter(GenericModel == genStudy$ID) %>% pull(StudyID)

    for (idx in which(sapply(studyList, \(x) {x$ID}) %in% studyIDs)) {
      studyList[[idx]]$setGenericModel(file.path(outputFolder, paste0(model, ".pkml")))
      studyList[[idx]]$setSimulation(sim)
    }
  }

  for (idx in seq_along(studyList)) {
    study <- studyList[[idx]]
    genericModel <- studyStructureSummary %>% filter(StudyID == study$ID) %>% pull(GenericModel)
    genStudy <- genericStudies[[which(purrr::map(genericStudies,  \(x) x$ID) == genericModel)]]

    for (compID in purrr::list_c(purrr::map(study$Compounds, \(x) {as.character(x$ID)}))) {
      compIdx1 <- which(purrr::list_c(purrr::map(study$Compounds, \(x) {as.character(x$ID)})) == compID)
      compIdx2 <- which(unlist(studyStructureSummary %>% filter(StudyID == study$ID) %>% pull(CompoundsID)) == compID)

      compound <- study$Compounds[[compIdx1]]

      # update compounds names in the study based on the generic model
      compound$Name <- unlist(studyStructureSummary %>% filter(StudyID == study$ID) %>% pull(Compounds))[compIdx2]

      # update formulation name in the study based on the generic model
      compound$Protocol$Name <- paste(compound$Name, "Protocol")
      if (!is.null(compound$Protocol$FormulationsKey)) {
        for (formKey in compound$Protocol$FormulationsKey) {
          formIdx <- which(compound$Protocol$FormulationsKey == formKey)
          formKeySim <- unlist(
            studyStructureSummary %>%
              filter(StudyID == study$ID) %>%
              pull(FormulationsProtocols),
            recursive = FALSE
          )[[compIdx2]] %>%
          filter(formulationKey == formKey) %>% pull(formulationKeySim)

          if ("AdvancedProtocol" %in% class(compound$Protocol)) {
            for (scIdx in seq_along(compound$Protocol$Schemas)) {
             for (sciIdx in seq_along(compound$Protocol$Schemas[[scIdx]]$SchemaItems)) {
               if (compound$Protocol$Schemas[[scIdx]]$SchemaItems[[sciIdx]]$FormulationKey == formKey) {
                 form <- compound$Protocol$Schemas[[scIdx]]$SchemaItems[[sciIdx]]$Formulation
                 form$Name <- formKeySim
               }
             }
            }
          } else if ("SimpleProtocol" %in% class(compound$Protocol)) {
            form <- compound$Protocol$Formulation
            form$Name <- formKeySim
          }
        }
      }

      genericProtocol <- genStudy$Compounds[[which(purrr::map_chr(genStudy$Compounds, \(x) x$Name) == compound$Name)]]$Protocol$extractProtocol()
      if ("AdvancedProtocol" %in% class(compound$Protocol)) {
        for (scIdx in seq_along(compound$Protocol$Schemas)) {
          for (sciIdx in seq_along(compound$Protocol$Schemas[[scIdx]]$SchemaItems)) {
            studyProt <- compound$Protocol$Schemas[[scIdx]]$SchemaItems[[sciIdx]]
            allowedPath <- unlist(genericProtocol %>% filter(type == studyProt$Route, identical(formulationName, ifelse(is.null(studyProt$Formulation), NA, studyProt$Formulation$Name))) %>% pull(path))
            studyProt$Path <- allowedPath
          }
        }
      } else if ("SimpleProtocol" %in% class(compound$Protocol)) {
        studyProt <- compound$Protocol
        allowedPath <- unlist(genericProtocol %>% filter(type == studyProt$Route, identical(formulationName, ifelse(is.null(studyProt$Formulation), NA, studyProt$Formulation$Name))) %>% pull(path))
        studyProt$Path <- allowedPath
      }
    }



  }

  return(studyList)
}
