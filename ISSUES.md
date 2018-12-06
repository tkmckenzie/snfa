# Issues/bugs

This document tracks issues and bugs

1. (**RESOLVED**) Vignette uses DEA to compare with SNFA. Initially, `rDEA::dea` was used for esitmation and `rDEA` package was included in Suggests. However, `rDEA` requires installation of GLPK, and travis-ci had difficulties verifying hash during that installation.
	* Solution: Custom dea method using `lpSolve` package was built and included in `snfa`.
