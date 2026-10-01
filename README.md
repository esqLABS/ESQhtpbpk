<!-- badges: start -->
[![Main-Workflow](https://github.com/esqLABS/ESQhtpbpk/actions/workflows/main-workflow.yaml/badge.svg)](https://github.com/esqLABS/ESQhtpbpk/actions/workflows/main-workflow.yaml)
<!-- badges: end -->

# ESQhtpbpk
R Package for HTPBPK pipeline with ospsuite

## Installation

`{ESQhtpbpk}` is not available on CRAN and must be installed from GitHub. We recommend using [`{pak}`](https://pak.r-lib.org/):

```r
# install.packages("pak")
pak::pak("esqLABS/ESQhtpbpk")
```

This requires R >= 4.1.0. The package relies on the [`{ospsuite}`](https://github.com/Open-Systems-Pharmacology/OSPSuite-R) package to run PK-Sim simulations; `pak` will also install `{ospsuite}` and `{ospsuite.utils}` from GitHub automatically (see the `Remotes` field in the `DESCRIPTION`). Refer to the [OSPSuite-R documentation](https://www.open-systems-pharmacology.org/OSPSuite-R/) for prerequisites such as installing PK-Sim.
