#' Randomly generated univariate data
#' 
#' A dataset for illustrating univariate non-parametric boundary
#' regressions and various constraints.
#' 
#' @format A data frame with 50 observations of two variables.
#' \describe{
#'   \item{x}{Input}
#'   \item{y}{Output}
#' }
#' @details 
#' Generated with the following code:
#' \preformatted{
#' set.seed(100)
#'
#' N = 50
#' x = runif(N, 10, 100)
#' y = sapply(x, function(x) 500 * x^0.25 - dnorm(x, mean = 70, sd = 10) * 8000) - abs(rnorm(N, sd = 20))
#' y = y - min(y) + 10
#' df = data.frame(x, y)
#' }
#' 
"univariate"

#' US Macroeconomic Data
#' 
#' A dataset of real output, labor force, capital stock,
#' wages, and interest rates for the U.S. between 1929 and 2014, 
#' as available. All nominal values converted to 2010 U.S. dollars
#' using GDP price deflator.
#' 
#' @format A data frame with 89 observations of four variables.
#' \describe{
#'   \item{Year}{Year}
#'   \item{Y}{Real GDP, in billions of dollars}
#'   \item{K}{Capital stock, in billions of dollars}
#'   \item{K.price}{Annual cost of $1 billion of capital, using 10-year treasury}
#'   \item{L}{Labor force, in thousands of people}
#'   \item{L.price}{Annual wage for one thousand people}
#' }
#' @source \url{https://fred.stlouisfed.org/}
#' 
"USMacro"
