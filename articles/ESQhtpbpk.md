# Getting Started

## Introduction

The high-throughput (HT) physiologically-based (PB) pharmacokinetics
(PK) modeling framework is distributed as an R package that enables the
prediction of pharmacokinetics profiles for various molecules across
different species. It leverages the capability of the [OSP
Suite](https://www.open-systems-pharmacology.org/) PK-Sim software
through the use of
[`{ospsuiteR}`](https://www.open-systems-pharmacology.org/OSPSuite-R/)
package.

## Main Features

The [ESQhtpbpk](https://esqlabs.github.io/ESQhtpbpk/) package is
designed to facilitate the creation of HT-PBPK pipelines and their
simulation. To this end, it:

- Allows efficient and parallel execution of many compound PK
  predictions (via the `{ospsuiteR}` package).
- Can automatically create various generic models as needed (limited to
  PK-Sim components).
- Can be used with custom PKML files for additional specificities.

## Running the framework

To run the framework with the automatic creation of generic models,
refer to the following:
[`vignette("ESQhtpbpk-automatic-models")`](https://esqlabs.github.io/ESQhtpbpk/articles/ESQhtpbpk-automatic-models.md).

To run the framework with custom PKML files, refer to the following:
[`vignette("ESQhtpbpk-custom-pkml")`](https://esqlabs.github.io/ESQhtpbpk/articles/ESQhtpbpk-custom-pkml.md).
