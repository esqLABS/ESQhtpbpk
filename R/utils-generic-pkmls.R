#' @title Create generic pkml from a list of study
#' @description
#' Create generic pkmls from a list of study
#' @param studyList list of Study for which to create generic pkmls
#' @param outputFolder Folder were to write the generic pkmls
#' @param overwrite If TRUE, overwrite existing files
#' @return The update studyList with model to use, and adjusted paths.
#' @importFrom dplyr %>%
#' @export
createGenericPKMLs <- function(studyList, outputFolder, overwrite = FALSE) {
  genericStudies <- list()
  studyStructureSummary <- tibble::tibble(
    "StudyID" = character(),
    "Individuals" = character(),
    "CompoundsID" = list(),
    "Compounds" =  list(),
    "PC" = list(),
    "CP" =  list(),
    "FormulationsProtocols" = list(),
    "HepaticProcesses" = list(),
    "RenalProcesses" = list(),
    "GFRProcesses" = list(),
    "BiliaryProcesses" = list()
  )

  for (study in studyList) {
    if (!("Study" %in% class(study))) {
      cli::cli_abort("All elements of studyList must be of `Study` class.")
    }
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
          purrr::map(study$Compounds, \(x) {
            x$Protocol$extractProtocol() %>%
              dplyr::group_by(type, formulationType, formulationKey, formulationName) %>%
              dplyr::summarise(nAdmins = dplyr::n(), .groups = "drop") %>%
              dplyr::group_by(type, formulationType) %>% dplyr::arrange(desc(nAdmins), .by_group = TRUE) %>%
              dplyr::mutate(formulationKeySim = ifelse(is.na(formulationKey), NA, paste(type, na.omit(formulationType), dplyr::row_number())))
          })
        ),
        "HepaticProcesses" = list(
          purrr::map(study$Compounds, \(x) {
            procName <- names(x$.__enclos_env__$private$.allProcessProperties)
            if (is.null(procName) || ProcessTypes[procName] != "Hepatic") {
              NULL
            } else {
              procName
            }
          })
        ),
        "RenalProcesses" = list(
          purrr::map(study$Compounds, \(x) {
            procName <- names(x$.__enclos_env__$private$.allProcessProperties)
            if (is.null(procName) || ProcessTypes[procName] != "Renal") {
              NULL
            } else {
              procName
            }
          })
        ),
        "GFRProcesses" = list(
          purrr::map(study$Compounds, \(x) {
            procName <- names(x$.__enclos_env__$private$.allProcessProperties)
            if (is.null(procName) || ProcessTypes[procName] != "GFR") {
              NULL
            } else {
              procName
            }
          })
        ),
        "BiliaryProcesses" = list(
          purrr::map(study$Compounds, \(x) {
            procName <- names(x$.__enclos_env__$private$.allProcessProperties)
            if (is.null(procName) || ProcessTypes[procName] != "Biliary") {
              NULL
            } else {
              procName
            }
          })
        )
      )
    )
  }

  # for (study in studyList) {
  genericStudyStructure <- studyStructureSummary %>% dplyr::select(-StudyID, -FormulationsProtocols, -CompoundsID, -GFRProcesses, -BiliaryProcesses) %>% unique()

  # get generic model based on structure
  genericStudyStructure <- genericStudyStructure %>% dplyr::mutate(GenericModel = paste0("Model", dplyr::row_number()))

  # add generic model to each study structure summary
  studyStructureSummary <- dplyr::left_join(studyStructureSummary, genericStudyStructure, by = c("Individuals","Compounds", "PC", "CP", "HepaticProcesses", "RenalProcesses"))

  for (model in genericStudyStructure$GenericModel) {
    studySubset <- studyStructureSummary %>% dplyr::filter(GenericModel == model)
    studySubset <- studySubset %>% dplyr::select(-GenericModel, -StudyID, -Individuals, -PC, -CP, -HepaticProcesses, -RenalProcesses)
    studySubset <- studySubset %>% tidyr::unnest(cols = everything())

    # summarise protocol x formulation needed for each compound accross studies using the same generic model
    studySubset <- studySubset %>% dplyr::group_by(Compounds) %>%
      dplyr::summarise(FormulationsProtocols = list(
        dplyr::bind_rows(FormulationsProtocols) %>%
          dplyr::group_by(type, formulationType, formulationKeySim) %>%
          dplyr::summarise(nAdmins = max(nAdmins))
        ),
        GFRProcesses  = unique(GFRProcesses),
        BiliaryProcesses = unique(BiliaryProcesses)
      )
    # summarise processes needed for each compound accross studies using the same generic model
    compounds <- lapply(studySubset$Compounds, \(x) {
      comp <- Compound$new(ID = x, name = x)

      compIdx <- which(unlist(genericStudyStructure %>% dplyr::filter(GenericModel == model) %>% dplyr::pull(Compounds)) == x)
      # add PC
      comp$PartitionCoefficientMethod <- unlist(genericStudyStructure %>% dplyr::filter(GenericModel == model) %>% dplyr::pull(PC))[[compIdx]]
      # add CP
      comp$CellularPermeabilityMethod <- unlist(genericStudyStructure %>% dplyr::filter(GenericModel == model) %>% dplyr::pull(CP))[[compIdx]]
      # add hepatic process
      hepProc <- unlist(genericStudyStructure %>% dplyr::filter(GenericModel == model) %>% dplyr::pull(HepaticProcesses), recursive = FALSE)[[compIdx]]
      if (length(hepProc) > 0) {
        comp$addProcessProperty(
          processType = hepProc,
          propertyName = MainProcessProperty[[hepProc]]$Name,
          parName = MainProcessProperty[[hepProc]]$Name,
          dimension = MainProcessProperty[[hepProc]]$dimension,
          value = MainProcessProperty[[hepProc]]$value, unit = NULL, enum = NULL, check = NULL,  path = NULL
        )
      }
      # add renal process
      renProc <- unlist(genericStudyStructure %>% dplyr::filter(GenericModel == model) %>% dplyr::pull(RenalProcesses), recursive = FALSE)[[compIdx]]
      if (length(renProc) > 0) {
        comp$addProcessProperty(
          processType = renProc,
          propertyName = MainProcessProperty[[renProc]]$Name,
          parName = MainProcessProperty[[renProc]]$Name,
          dimension = MainProcessProperty[[renProc]]$dimension,
          value = MainProcessProperty[[renProc]]$value, unit = NULL, enum = NULL, check = NULL,  path = NULL
        )
      }
      # add gfr process
      gfrProc <- unlist(studySubset %>% dplyr::filter(Compounds == x) %>% dplyr::pull(GFRProcesses))
      if (length(gfrProc) > 0) {
        comp$addProcessProperty(
          processType = gfrProc,
          propertyName = MainProcessProperty[[gfrProc]]$Name,
          parName = MainProcessProperty[[gfrProc]]$Name,
          dimension = MainProcessProperty[[gfrProc]]$dimension,
          value =  MainProcessProperty[[gfrProc]]$value, unit = NULL, enum = NULL, check = NULL,  path = NULL
        )
      }
      # add biliary process
      bilProc <- unlist(studySubset %>% dplyr::filter(Compounds == x) %>% dplyr::pull(BiliaryProcesses))
      if (!is.null(bilProc)) {
        comp$addProcessProperty(
          processType = bilProc,
          propertyName = MainProcessProperty[[bilProc]]$Name,
          parName = MainProcessProperty[[bilProc]]$Name,
          dimension = MainProcessProperty[[bilProc]]$dimension,
          value = MainProcessProperty[[bilProc]]$value, unit = NULL, enum = NULL, check = NULL,  path = NULL
        )
      }
      # add protocol
      prot <- AdvancedProtocol$new(name = paste(x, "Protocol"))

      admins <- (studySubset %>% dplyr::filter(Compounds == x) %>% dplyr::pull(FormulationsProtocols))[[1]]

      for (i in 1:nrow(admins)) {
        prot$addSchema(schemaName = paste("Schema", i), startTime = i, numberOfRepetitions = admins$nAdmins[i], timeBetweenRepetitions = 0, timeUnit = "h")

        sp <- SimpleProtocol$new(name = "SimpleProtocol", dosingInterval = "Single", route = admins$type[i], waterVolPerBW = 0)

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
      Study$new(ID = model, individual = genericStudyStructure %>% dplyr::filter(GenericModel == model) %>% dplyr::pull(Individuals), compounds = compounds)
    )
  }

  # create pkml for each generic study and update the model path and simulation of corresponding user studies
  for (genStudy in genericStudies) {
    genStudy$exportPKML(file = file.path(outputFolder, paste0(genStudy$ID, ".pkml")), overwrite = overwrite)

    # load generic simulation once and add reference to user study
    sim <- ospsuite::loadSimulation(file.path(outputFolder, paste0(genStudy$ID, ".pkml")))

    # update simulation administration start time all to 0 (was set differently for easier mapping of admin path) and resave
    ospsuite::setParameterValues(
      parameters = ospsuite::getAllParametersMatching("Events|**|Start time", sim),
      values = 0
    )
    ospsuite::saveSimulation(sim, file.path(outputFolder, paste0(genStudy$ID, ".pkml")))

    # add Model path to each study from studyList
    studyIDs <- studyStructureSummary %>% dplyr::filter(GenericModel == genStudy$ID) %>% dplyr::pull(StudyID)

    for (idx in which(sapply(studyList, \(x) {x$ID}) %in% studyIDs)) {
      studyList[[idx]]$setGenericModel(file.path(outputFolder, paste0(genStudy$ID, ".pkml")))
      # studyList[[idx]]$setSimulation(sim)
    }
  }

  for (idx in seq_along(studyList)) {
    study <- studyList[[idx]]
    genericModel <- studyStructureSummary %>% dplyr::filter(StudyID == study$ID) %>% dplyr::pull(GenericModel)
    genStudy <- genericStudies[[which(purrr::map(genericStudies,  \(x) x$ID) == genericModel)]]

    for (compID in purrr::list_c(purrr::map(study$Compounds, \(x) {as.character(x$ID)}))) {
      compIdx1 <- which(purrr::list_c(purrr::map(study$Compounds, \(x) {as.character(x$ID)})) == compID)
      compIdx2 <- which(unlist(studyStructureSummary %>% dplyr::filter(StudyID == study$ID) %>% dplyr::pull(CompoundsID)) == compID)

      compound <- study$Compounds[[compIdx1]]

      # update compounds names in the study based on the generic model
      compound$Name <- unlist(studyStructureSummary %>% dplyr::filter(StudyID == study$ID) %>% dplyr::pull(Compounds))[compIdx2]

      # update formulation name in the study based on the generic model
      compound$Protocol$Name <- paste(compound$Name, "Protocol")
      if (!is.null(compound$Protocol$FormulationsKey)) {
        for (formKey in compound$Protocol$FormulationsKey) {
          formIdx <- which(compound$Protocol$FormulationsKey == formKey)
          formKeySim <- unlist(
            studyStructureSummary %>%
              dplyr::filter(StudyID == study$ID) %>%
              dplyr::pull(FormulationsProtocols),
            recursive = FALSE
          )[[compIdx2]] %>%
          dplyr::filter(formulationKey == formKey) %>% dplyr::pull(formulationKeySim)

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
            allowedPath <- unlist(genericProtocol %>% dplyr::filter(type == studyProt$Route, identical(formulationName, ifelse(is.null(studyProt$Formulation), NA, studyProt$Formulation$Name))) %>% dplyr::pull(path))
            studyProt$Path <- allowedPath
          }
        }
      } else if ("SimpleProtocol" %in% class(compound$Protocol)) {
        studyProt <- compound$Protocol
        allowedPath <- unlist(genericProtocol %>% dplyr::filter(type == studyProt$Route, identical(formulationName, ifelse(is.null(studyProt$Formulation), NA, studyProt$Formulation$Name))) %>% dplyr::pull(path))
        studyProt$Path <- allowedPath
      }
    }
  }

  return(invisible(studyList))
}
