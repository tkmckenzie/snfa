#' Data envelopment analysis
#' 
#' Basic data envelopment analysis to replace rDEA::dea due to difficulties
#' installing rDEA on travis-ci
#' 
#' @param XREF Matrix of inputs for observations used for constructing the frontier
#' @param YREF Matrix of outputs for observations used for constructing the frontier
#' @param X Matrix of inputs for observations, for which DEA scores are estimated
#' @param Y Matrix of outputs for observations, for which DEA scores are estimated
#' @param model Orientation of the model; currently only "output" is supported
#' @param RTS Returns-to-scale for the model; currently only "constant" and "variable" are supported
#' 
#' @return Returns a vector of efficiency estimates corresponding to observations in
#' X and Y.
#' 
#' @details 
#' This function estimates efficiency using data envelopment analysis. The linear program
#' is constructed as in Fare et al. (1985) and optimized using lpSolve::lp. The function
#' was built to swap with rDEA::dea because installation of rDEA presented problems for
#' travis-ci, due to difficulties installing glpk. Should installation of rDEA on travis-ci
#' become possible, this function will be removed.
#' 
#' @examples
#' data(univariate)
#' 
#' dea.fit <- dea(univariate$x, univariate$y,
#'                univariate$x, univariate$y,
#'                model = "output",
#'                RTS = "variable")
#' univariate$frontier <- univariate$y / dea.fit
#' 
#' #Plot technical/allocative efficiency over time
#' library(ggplot2)
#' 
#' ggplot(univariate, aes(x, y)) +
#'   geom_point() +
#'   geom_line(aes(y = frontier), color = "red")
#' 
#' @export
dea <-
  function(XREF, YREF, X, Y, model = "output", RTS = "variable"){
  #Redefine dea to deal with out-of-sample prediction
  #Works only for output oriented models (for now?)
  
  #XREF, YREF constructs frontier
  #Efficiencies evaluated at X, Y
  #Rows differentiate observations
  #Columns differentiate inputs/outputs

  #Type cast to matrix
  XREF <- as.matrix(XREF)
  YREF <- as.matrix(YREF)
  X <- as.matrix(X)
  Y <- as.matrix(Y)
  
  #Input validation
  if (!(RTS %in% c("constant", "variable"))) stop("RTS must be \"constant\" or \"variable\".")
  
  if (ncol(XREF) != ncol(X)){
    stop("XREF and X must have same number of columns.")
  }
  if (ncol(YREF) != ncol(Y)){
    stop("YREF and Y must have same number of columns.")
  }
  if (nrow(XREF) != nrow(YREF)){
    stop("XREF and YREF must have same number of rows.")
  }
  if (nrow(X) != nrow(Y)){
    stop("XREF and YREF must have same number of rows.")
  }
  
  #Problem setup:
  #N = number of reference observations
  #M = number of inputs
  #O = number of outputs
  #pi = [theta, lambda_N]'
  #max f.obj %*% pi
  #s.t. output-oriented DEA constraints
  #Efficiency is inverse of objective function
  
  num.obs.ref <- nrow(XREF)
  num.obs <- nrow(X)
  num.outputs <- ncol(YREF)
  num.inputs <- ncol(XREF)
  
  pi.opt <- rep(NA, num.obs)
  f.obj <- c(1, rep(0, num.obs.ref))
  for (i in 1:num.obs){
    #Construct constraints
    f.con <- rbind(cbind(Y[i,], -t(YREF)),
                   cbind(0, t(XREF)))
    f.dir <- rep("<=", num.outputs + num.inputs)
    f.rhs <- c(rep(0, num.outputs), X[i,])
    
    #Create constraints for RTS other than constant
    if (RTS == "variable"){
      f.con <- rbind(f.con,
                     c(0, rep(1, num.obs)))
      f.dir <- c(f.dir, "==")
      f.rhs <- c(f.rhs, 1)
    }
    
    lp.result <- lpSolve::lp(direction = "max",
                             f.obj, f.con, f.dir, f.rhs)
    if (lp.result$status != 0) stop(paste0("LP solver failed for observation ", i, "."))
    
    pi.opt[i] <- 1 / lp.result$objval
  }
  
  return(pi.opt)
}
