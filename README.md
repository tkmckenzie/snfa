
<!-- README.md is generated from README.Rmd. Please edit that file -->
snfa: Smooth Non-Parametric Frontier Analysis
=============================================

[![Travis build status](https://travis-ci.org/tkmckenzie/snfa.svg?branch=master)](https://travis-ci.org/tkmckenzie/snfa) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/snfa)](https://cran.r-project.org/package=snfa)

Overview
========

Fitting of non-parametric production frontiers for use in efficiency analysis. Methods are provided for both a smooth analogue of Data Envelopment Analysis (DEA) and a non-parametric analogue of Stochastic Frontier Analysis (SFA). Frontiers are constructed for multiple inputs and a single output using constrained kernel smoothing as in Racine et al. (2009), which allow for the imposition of monotonicity and concavity constraints on the estimated frontier. Additional methods are provided to use constructed frontiers to estimate allocative efficiency, technical efficiency, and efficiency/productivity changes over time.

Installation
============

``` r
# The latest release version of snfa can be installed from CRAN:
install.packages("snfa")

# The development version of snfa can also be installed from github:
# install.packages("devtools")
devtools::install_github("tkmckenzie/snfa", build_opts = "--no-resave-data")
install.packages(c("ggplot2", "knitr", "lpSolve", "Rdpack", "rmarkdown")) # Install suggested packages
```

Usage
=====

snfa contains methods for estimating smooth frontiers and various types of efficiency. The best way to get an overview of the package and its motivation is to go through the vignette (currenlty only available in development version from github):

``` r
vignette("snfa")
```

It can also be helpful to look through examples (shown in Examples below):

``` r
example("fit.boundary")
example("allocative.efficiency")
```

Examples
========

Boundary fitting
----------------

``` r
example("fit.boundary")
#> Warning in example("fit.boundary"): no help found for 'fit.boundary'
```

Allocative efficiency estimation
--------------------------------

``` r
example("allocative.efficiency")
#> Warning in example("allocative.efficiency"): no help found for
#> 'allocative.efficiency'
```

Getting help and reporting bugs
===============================

snfa is young and still under development. If you run into any issues or find any bugs, please email at <tkmckenzie@gmail.com>.
