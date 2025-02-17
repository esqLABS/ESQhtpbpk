createGenericPKMLs <- function(studyList, outputFolder) {
  genericStudies <- list()
  studyStructureSummary <- tibble::tibble(
    "StudyID" = character(),
    "Individuals" = character(),
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
        "Compounds" = list(paste0("Compound", seq_along(study$Compounds))),
        "PC" = list(purrr::map(study$Compounds, \(x) {names(PCMethods)[PCMethods == x$PartitionCoefficientMethod]})),
        "CP" = list(purrr::map(study$Compounds, \(x){names(CPMethods)[CPMethods ==x$CellularPermeabilityMethod]})),
        "FormulationsProtocols" = list(
          purrr::map(study$Compounds, ~ .x$Protocol$extractProtocol() %>%
                       group_by(type, formulationType, formulationKey) %>%
                       summarise(nAdmins = n(), .groups = "drop") %>%
                       group_by(type, formulationType) %>% arrange(desc(nAdmins), .by_group = TRUE) %>%
                       mutate(formulationKey = ifelse(is.na(formulationKey), NA, paste(type, na.omit(formulationType), row_number())))
                     )
        ) # ,
        # "Processes" = list()
      )
    )
  }

  # for (study in studyList) {
    genericStudyStructure <- studyStructureSummary %>% select(-StudyID, -FormulationsProtocols) %>% unique()

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
            group_by(type, formulationType, formulationKey) %>%
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
            form <- fun(name = paste(admins$formulationKey[i]))
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

    # create pkml for each study
    for (study in genericStudies) {
      study$exportPKML(file.path(outputFolder, paste0(study$ID, ".pkml")))
    }

    # add Model path to each study from studyList
}
