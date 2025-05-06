#' @title Create generic pkml from a list of study
#' @description
#' Create generic pkmls from a list of study
#' @param studyList list of Study for which to create generic pkmls
#' @param outputFolder Folder were to write the generic pkmls
#' @param overwrite If TRUE, overwrite existing files
#' @return The update studyList with model to use, and adjusted paths.
#' @export
createGenericPKMLs <- function(studyList, outputFolder, overwrite = FALSE) {
  options(cli.progress_show_after = 0)
  # extracting study structure for each study
  studyStructureSummary <- tryCatch(
    {
      .extractStudyStructure(studyList)
    },
    error = function(e) {
      cli::cli_abort(
        c(
          "x" = messages$stgWrong("the extraction of the study structure"),
          "Original error message:",
          "{e$message}"
        ),
        parent = NA
      )
    }
  )


  # extracting unique structures
  genericStudyStructure <- tryCatch(
    {
      .createGenericStudyStructure(studyStructureSummary)
    },
    error = function(e) {
      cli::cli_abort(
        c(
          "x" = messages$stgWrong("the creation of the generic study structure"),
          "Original error message:",
          "{e$message}"
        ),
        parent = NA
      )
    }
  )

  # add generic model to each study structure summary
  studyStructureSummary <- dplyr::left_join(
    studyStructureSummary,
    genericStudyStructure,
    by = c("Individuals", "Compounds", "PC", "CP", "HepaticProcesses", "RenalProcesses")
  )

  ## adding required protocol/formulation for each generic structure
  genericStudies <- tryCatch(
    {
      .addReqProtocols(
        genericStudyStructure,
        studyStructureSummary
      )
    },
    error = function(e) {
      cli::cli_abort(
        c(
          "x" = messages$stgWrong("the addition of required protocols/formulations for each generic structure"),
          "Original error message:",
          "{e$message}"
        ),
        parent = NA
      )
    }
  )

  # create pkml for each generic study and update the model path and simulation of corresponding user studies
  tryCatch(
    {
      .setGenericModel(
        genericStudies,
        studyList,
        studyStructureSummary,
        outputFolder = outputFolder,
        overwrite = overwrite
      )
    },
    error = function(e) {
      cli::cli_abort(
        c(
          "x" = messages$stgWrong("the creation of the generic pkmls"),
          "Original error message:",
          "{e$message}"
        ),
        parent = NA
      )
    }
  )

  # adjust protocol names and formulation to match generic studies
  studyList <- tryCatch(
    {
      .remapStudyProtocols(studyList, genericStudies, studyStructureSummary)
    },
    error = function(e) {
      cli::cli_abort(
        c(
          "x" = messages$stgWrong("renaming of compound/protocol/formulation to match the generic models"),
          "Original error message:",
          "{e$message}"
        ),
        parent = NA
      )
    }
  )

  return(studyList)
}

#' @title Extract study structure for all studies in a list
#' @description
#' Create generic pkmls from a list of study
#' @param studyList list of Study objects for which to extract a model structure
#' @return A summary tibble of all the study structure (PC/CP, Individual, Administration type, compounds numbers) .
#' @noRd
.extractStudyStructure <- function(studyList) {
  # start progress bar
  cli::cli_progress_bar(
    name = "Extracting study structure for all studies:",
    total = length(studyList),
    format = "{cli::pb_name} {cli::pb_bar} {cli::pb_percent} ({study$ID})",
    clear = FALSE
  )

  studyStructureSummary <- tibble::tibble(
    "StudyID" = character(),
    "Individuals" = character(),
    "CompoundsID" = list(),
    "Compounds" = list(),
    "PC" = list(),
    "CP" = list(),
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
    cli::cli_progress_update()

    studyStructureSummary <- rbind(
      studyStructureSummary,
      tibble::tibble(
        "StudyID" = study$ID,
        "Individuals" = study$Individual,
        "CompoundsID" = list(purrr::list_c(purrr::map(study$Compounds, \(x) as.character(x$ID)))),
        "Compounds" = list(paste0("Compound", seq_along(study$Compounds))),
        "PC" = list(purrr::map(study$Compounds, \(x) {
          names(PCMethods)[PCMethods == x$PartitionCoefficientMethod]
        })),
        "CP" = list(purrr::map(study$Compounds, \(x) {
          names(CPMethods)[CPMethods == x$CellularPermeabilityMethod]
        })),
        "FormulationsProtocols" = list(
          purrr::map(study$Compounds, \(x) {
            x$Protocol$extractProtocol() |>
              dplyr::group_by(type, formulationType, formulationKey, formulationName) |>
              dplyr::summarise(nAdmins = dplyr::n(), .groups = "drop") |>
              dplyr::group_by(type, formulationType) |>
              dplyr::arrange(dplyr::desc(nAdmins), .by_group = TRUE) |>
              dplyr::mutate(
                formulationKeySim = ifelse(
                  is.na(formulationKey),
                  NA,
                  paste(type, na.omit(formulationType), dplyr::row_number())
                )
              )
          })
        ),
        "HepaticProcesses" = list(
          purrr::map(study$Compounds, \(x) {
            procNames <- names(x$.__enclos_env__$private$.allProcessProperties)
            if (!is.null(procNames) && any(ProcessTypes[procNames] == "Hepatic")) {
              procNames[ProcessTypes[procNames] == "Hepatic"]
            } else {
              NULL
            }
          })
        ),
        "RenalProcesses" = list(
          purrr::map(study$Compounds, \(x) {
            procNames <- names(x$.__enclos_env__$private$.allProcessProperties)
            if (!is.null(procNames) && any(ProcessTypes[procNames] == "Renal")) {
              procNames[ProcessTypes[procNames] == "Renal"]
            } else {
              NULL
            }
          })
        ),
        "GFRProcesses" = list(
          purrr::map(study$Compounds, \(x) {
            procNames <- names(x$.__enclos_env__$private$.allProcessProperties)
            if (!is.null(procNames) && any(ProcessTypes[procNames] == "GFR")) {
              procNames[ProcessTypes[procNames] == "GFR"]
            } else {
              NULL
            }
          })
        ),
        "BiliaryProcesses" = list(
          purrr::map(study$Compounds, \(x) {
            procNames <- names(x$.__enclos_env__$private$.allProcessProperties)
            if (!is.null(procNames) && any(ProcessTypes[procNames] == "Biliary")) {
              procNames[ProcessTypes[procNames] == "Biliary"]
            } else {
              NULL
            }
          })
        )
      )
    )
  }

  cli::cli_progress_done()
  return(studyStructureSummary)
}

#' @title Summarise a list of study structures to a few generic study structures
#' @description
#' Summarise a list of study structures to a few generic study structures
#' @param studyStructureSummary A study structure tibble, usually the result of .extractStudyStructure
#' function
#' @return A summary tibble of the generic study structure needed
#' (PC/CP, Individual, Administration type, compounds numbers) .
#' @noRd
.createGenericStudyStructure <- function(studyStructureSummary) {
  # for (study in studyList) {
  genericStudyStructure <- studyStructureSummary |>
    dplyr::select(-StudyID, -FormulationsProtocols, -CompoundsID, -GFRProcesses, -BiliaryProcesses) |>
    dplyr::distinct(.keep_all = TRUE)

  # get generic model based on structure
  genericStudyStructure <- genericStudyStructure |>
    dplyr::mutate(GenericModel = paste0("Model", dplyr::row_number()))

  return(genericStudyStructure)
}

#' @title Add the required administration and formulation needed for a generic model structure
#' @description
#' Add the required administration and formulation needed for a generic model structure to cover all
#' studies in a list of study structures
#' @param genericStudyStructure A study structure tibble of the generic models,
#' usually the result of .createGenericStudyStructure function
#' @param studyStructureSummary A study structure tibble of all studies to be covered by the generic models,
#' usually the result of .extractStudyStructure function
#' @return A list of the generic Study objects needed (PC/CP, Individual, Administration type, compounds numbers) .
#' @noRd
.addReqProtocols <- function(genericStudyStructure, studyStructureSummary) {
  genericStudies <- list()

  for (model in genericStudyStructure$GenericModel) {
    studySubset <- studyStructureSummary |>
      dplyr::filter(GenericModel == model) |>
      dplyr::select(-GenericModel, -StudyID, -Individuals, -PC, -CP, -HepaticProcesses, -RenalProcesses) |>
      tidyr::unnest(cols = tidyselect::everything())

    # summarise protocol x formulation needed for each compound accross studies using the same generic model
    studySubset <- studySubset |>
      dplyr::group_by(Compounds) |>
      dplyr::summarise(
        FormulationsProtocols = list(
          dplyr::bind_rows(FormulationsProtocols) |>
            dplyr::group_by(type, formulationType, formulationKeySim) |>
            dplyr::summarise(nAdmins = max(nAdmins))
        ),
        GFRProcesses = unique(GFRProcesses),
        BiliaryProcesses = unique(BiliaryProcesses)
      )

    # summarise processes needed for each compound accross studies using the same generic model
    compounds <- lapply(studySubset$Compounds, \(x) {
      comp <- Compound$new(ID = x, name = x)

      compIdx <- which(
        unlist(genericStudyStructure |> dplyr::filter(GenericModel == model) |> dplyr::pull(Compounds)) == x
      )
      # add PC
      comp$PartitionCoefficientMethod <- unlist(
        genericStudyStructure |> dplyr::filter(GenericModel == model) |> dplyr::pull(PC)
      )[[compIdx]]
      # add CP
      comp$CellularPermeabilityMethod <- unlist(
        genericStudyStructure |> dplyr::filter(GenericModel == model) |> dplyr::pull(CP)
      )[[compIdx]]
      # add hepatic process
      hepProc <- unlist(
        genericStudyStructure |>
          dplyr::filter(GenericModel == model) |>
          dplyr::pull(HepaticProcesses),
        recursive = FALSE
      )[[compIdx]]

      if (length(hepProc) > 0) {
        comp$addProcessProperty(
          processType = hepProc,
          propertyName = MainProcessProperty[[hepProc]]$Name,
          parName = MainProcessProperty[[hepProc]]$Name,
          dimension = MainProcessProperty[[hepProc]]$dimension,
          value = MainProcessProperty[[hepProc]]$value,
          unit = NULL,
          enum = NULL,
          check = NULL,
          path = NULL
        )
      }
      # add renal process
      renProc <- unlist(
        genericStudyStructure |>
          dplyr::filter(GenericModel == model) |>
          dplyr::pull(RenalProcesses),
        recursive = FALSE
      )[[compIdx]]
      if (length(renProc) > 0) {
        comp$addProcessProperty(
          processType = renProc,
          propertyName = MainProcessProperty[[renProc]]$Name,
          parName = MainProcessProperty[[renProc]]$Name,
          dimension = MainProcessProperty[[renProc]]$dimension,
          value = MainProcessProperty[[renProc]]$value,
          unit = NULL,
          enum = NULL,
          check = NULL,
          path = NULL
        )
      }
      # add gfr process
      gfrProc <- unlist(
        studySubset |> dplyr::filter(Compounds == x) |> dplyr::pull(GFRProcesses)
      )
      if (length(gfrProc) > 0) {
        comp$addProcessProperty(
          processType = gfrProc,
          propertyName = MainProcessProperty[[gfrProc]]$Name,
          parName = MainProcessProperty[[gfrProc]]$Name,
          dimension = MainProcessProperty[[gfrProc]]$dimension,
          value = MainProcessProperty[[gfrProc]]$value, unit = NULL, enum = NULL, check = NULL, path = NULL
        )
      }
      # add biliary process
      bilProc <- unlist(
        studySubset |> dplyr::filter(Compounds == x) |> dplyr::pull(BiliaryProcesses)
      )
      if (!is.null(bilProc)) {
        comp$addProcessProperty(
          processType = bilProc,
          propertyName = MainProcessProperty[[bilProc]]$Name,
          parName = MainProcessProperty[[bilProc]]$Name,
          dimension = MainProcessProperty[[bilProc]]$dimension,
          value = MainProcessProperty[[bilProc]]$value, unit = NULL, enum = NULL, check = NULL, path = NULL
        )
      }
      # add protocol
      prot <- AdvancedProtocol$new(name = paste(x, "Protocol"))

      admins <- (studySubset |> dplyr::filter(Compounds == x) |> dplyr::pull(FormulationsProtocols))[[1]]

      for (i in seq_len(nrow(admins))) {
        prot$addSchema(
          schemaName = paste("Schema", i),
          startTime = i,
          numberOfRepetitions = admins$nAdmins[i],
          timeBetweenRepetitions = 0,
          timeUnit = "h"
        )

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
      Study$new(
        ID = model,
        individual = genericStudyStructure |> dplyr::filter(GenericModel == model) |> dplyr::pull(Individuals),
        compounds = compounds
      )
    )
  }

  return(genericStudies)
}

#' @title Create the pkml of the generic models and set it to the studies using that generic model
#' @description
#' Create the pkml of the generic models and set it to the studies using that generic model
#' @param genericStudies A list of generic Study objects for the generic models,
#' usually the result of .createGenericStudyStructure function
#' @param studyList list of Study objects for which to add the generic pkmls
#' @param studyStructureSummary A study structure tibble of all studies to be covered by the generic models,
#' usually the result of .extractStudyStructure function to know which model should be used for which study
#' @param outputFolder Folder were to write the generic pkmls
#' @param overwrite If TRUE, overwrite existing files
#' @return It creates the generic pkmls in the defined outpuFolder and updates the studyList accordingly.
#' But it return nothing nothing.
#' @noRd
.setGenericModel <- function(genericStudies, studyList, studyStructureSummary, outputFolder, overwrite) {
  cli::cli_progress_bar(
    "Creating generic models:",
    total = length(genericStudies),
    clear = FALSE,
    format = "{cli::pb_name} {cli::pb_bar} {cli::pb_percent} ({genStudy$ID})",
  )

  # load pkmls and add reference to user studies
  for (genStudy in genericStudies) {
    cli::cli_progress_update()
    pkmlFile <- file.path(outputFolder, paste0(genStudy$ID, ".pkml"))

    # capture export message to no show them
    cli::cli_fmt(genStudy$exportPKML(file = pkmlFile, overwrite = overwrite))

    # load generic simulation once and add reference to user study
    sim <- ospsuite::loadSimulation(pkmlFile)

    # update simulation administration start time all to 0 (was set differently for easier mapping of admin path) and resave
    ospsuite::setParameterValues(
      parameters = ospsuite::getAllParametersMatching("Events|**|Start time", sim),
      values = 0
    )
    ospsuite::saveSimulation(sim, file.path(outputFolder, paste0(genStudy$ID, ".pkml")))

    # add Model path to each study from studyList
    studyIDs <- studyStructureSummary |>
      dplyr::filter(GenericModel == genStudy$ID) |>
      dplyr::pull(StudyID)

    for (idx in which(sapply(studyList, \(x) {x$ID}) %in% studyIDs)) {
      studyList[[idx]]$setGenericModel(file.path(outputFolder, paste0(genStudy$ID, ".pkml")))
    }
  }
  cli::cli_progress_done()

  return(invisible(NULL))
}

#' @title Rename compounds, protocol and formulations in the original studyList.
#' @description
#' Rename compounds, protocol and formulations in the original studyList to match the names used in the generic model.
#' @param studyList list of Study objects to be updated
#' @param genericStudies A list of generic Study objects for the generic models,
#' usually the result of .createGenericStudyStructure function
#' @param studyStructureSummary A study structure tibble of all studies to be covered by the generic models,
#' usually the result of .extractStudyStructure function to know which model should be used for which study
#' @return The updated studyList with names matching the generic models
#' @noRd
.remapStudyProtocols <- function(studyList, genericStudies, studyStructureSummary) {
  cli::cli_progress_bar(
    "Updating protocols and formulations to match generic models:",
    total = length(studyList),
    format = "{cli::pb_name} {cli::pb_bar} {cli::pb_percent} ({study$ID})",
    clear = FALSE
  )

  for (idx in seq_along(studyList)) {
    study <- studyList[[idx]]
    cli::cli_progress_update()

    genericModel <- studyStructureSummary |>
      dplyr::filter(StudyID == study$ID) |>
      dplyr::pull(GenericModel)
    genStudy <- genericStudies[[which(purrr::map(genericStudies, \(x) x$ID) == genericModel)]]

    for (compID in purrr::list_c(purrr::map(study$Compounds, \(x) as.character(x$ID)))) {
      compIdx1 <- which(
        purrr::list_c(
          purrr::map(study$Compounds, \(x) as.character(x$ID))
        ) == compID
      )
      compIdx2 <- which(
        unlist(
          studyStructureSummary |> dplyr::filter(StudyID == study$ID) |> dplyr::pull(CompoundsID)
        ) == compID
      )

      compound <- study$Compounds[[compIdx1]]

      # update compounds names in the study based on the generic model
      compound$Name <- unlist(
        studyStructureSummary |> dplyr::filter(StudyID == study$ID) |> dplyr::pull(Compounds)
      )[compIdx2]

      # update formulation name in the study based on the generic model
      compound$Protocol$Name <- paste(compound$Name, "Protocol")
      if (!is.null(compound$Protocol$FormulationKey)) {
        for (formKey in compound$Protocol$FormulationKey) {
          formKeySim <- unlist(
            studyStructureSummary |>
              dplyr::filter(StudyID == study$ID) |>
              dplyr::pull(FormulationsProtocols),
            recursive = FALSE
          )[[compIdx2]] |>
            dplyr::filter(formulationKey == formKey) |>
            dplyr::pull(formulationKeySim)

          if ("AdvancedProtocol" %in% class(compound$Protocol)) {
            for (scIdx in seq_along(compound$Protocol$Schemas)) {
              for (sciIdx in seq_along(compound$Protocol$Schemas[[scIdx]]$SchemaItems)) {
                if (isTRUE(compound$Protocol$Schemas[[scIdx]]$SchemaItems[[sciIdx]]$FormulationKey == formKey)) {
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

      compProtIdx <- which(purrr::map_chr(genStudy$Compounds, \(x) x$Name) == compound$Name)
      genericProtocol <- genStudy$Compounds[[compProtIdx]]$Protocol$extractProtocol()
      if ("AdvancedProtocol" %in% class(compound$Protocol)) {
        for (scIdx in seq_along(compound$Protocol$Schemas)) {
          for (sciIdx in seq_along(compound$Protocol$Schemas[[scIdx]]$SchemaItems)) {
            studyProt <- compound$Protocol$Schemas[[scIdx]]$SchemaItems[[sciIdx]]
            studyProt$Path <- .extractAllowedPaths(genericProtocol, studyProt)
          }
        }
      } else if ("SimpleProtocol" %in% class(compound$Protocol)) {
        studyProt <- compound$Protocol
        studyProt$Path <- .extractAllowedPaths(genericProtocol, studyProt)
      }
    }
  }
  cli::cli_progress_done()

  return(invisible(studyList))
}

#' @title Extract allowed path corresponding to a wanted protocol based on the generic model used
#' @description
#' Extract allowed path corresponding to a wanted protocol based on the generic model used
#' @param studyList list of Study objects to be updated
#' @param genericProtocol generic protocol for which to extract all allowed path
#' @param studyProt the study protocol for which to extract the correct possible path
#' @return A vector of the paths for a possible in the generic model for given study protocol
#' @noRd
.extractAllowedPaths <- function(genericProtocol, studyProt) {
  allowedPath <- unlist(
    genericProtocol |>
      dplyr::filter(
        type == studyProt$Route,
        identical(formulationName, ifelse(is.null(studyProt$Formulation), NA, studyProt$Formulation$Name))
      ) |>
      dplyr::pull(path)
  )
  return(allowedPath)
}
