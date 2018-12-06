# Issues/bugs

This document tracks issues and bugs

1. (**RESOLVED**) Vignette uses DEA to compare with SNFA. Initially, `rDEA::dea` was used for esitmation and `rDEA` package was included in Suggests. However, `rDEA` requires installation of GLPK, and travis-ci had difficulties verifying hash during that installation.
	* **Solution**: Custom dea method using `lpSolve` package was built and included in `snfa`.
2. (**RESOLVED**) Note for snfa v0.0.1:
	```
	checking dependencies in R code ... NOTE
	Namespaces in Imports field not imported from:
	‘Rdpack’ ‘ggplot2’
	All declared Imports should be used.
	```
	* **Solution**: `Rdpack` and `ggplot2` were moved from Imports to Suggests.