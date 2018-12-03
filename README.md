# snfa: Smooth Non-Parametric Frontier Analysis
[![Travis build status](https://travis-ci.org/tkmckenzie/snfa.svg?branch=master)](https://travis-ci.org/tkmckenzie/snfa)

# Overview
Fitting of non-parametric production frontiers for use in efficiency analysis. Methods are provided for both a smooth analogue of Data Envelopment Analysis (DEA) and a non-parametric analogue of Stochastic Frontier Analysis (SFA). Frontiers are constructed for multiple inputs and a single output using constrained kernel smoothing as in Racine et al. (2009), which allow for the imposition of monotonicity and concavity constraints on the estimated frontier. Additional methods are provided to use constructed frontiers to estimate allocative efficiency, technical efficiency, and efficiency/productivity changes over time.

# Installation
```R
# The latest stable version of snfa can be installed from CRAN:
install.packages("snfa")
# The development version of snfa can also be installed from github:
# install.packages("devtools")
devtools::install_github("tkmckenzie/snfa")
```

# Usage
snfa contains methods for estimating smooth frontiers and various types of efficiency. The best way to get an overview of the package is to go through the vignette:
```R
vignette("snfa")
```
It can also be helpful to look through examples:
```R
example("allocative.efficiency")
example("fit.boundary")
```

# Getting help and reporting bugs
snfa is young and still under development. If you run into any issues or find any bugs, please email at tkmckenzie@gmail.com.
