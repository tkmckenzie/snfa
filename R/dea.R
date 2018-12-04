#' Data envelopment analysis
#' 
#' Basic data envelopment analysis to replace rDEA::dea due to difficulties
#' installing rDEA on travis-ci
#' 
#' @param XREF Matrix of inputs for observations used for constructing the frontier
#' @param YREF Matrix of outputs for observations used for constructing the frontier
#' @param X Matrix of inputs for observations, for which DEA scores are estimated
#' @param Y Matrix of outputs for observations, for which DEA scores are estimated
#' @param model Orientation of the model; must be "input" or "output"
#' @param RTS Returns-to-scale for the model; must be "constant", "non-increasing" or "variable"
#' 
#' @return Returns a list with the following components
#' \item{thetaOpt}{A vector of efficiency estimates, in [0, 1] interval}
#' \item{lambda}{A matrix of constraint coefficients}
#' \item{lambda_sum}{A vector of sum of lambdas; lambda_sum = 1 for variable RTS, lambda_sum <= for non-increasing RTS}
#' \item{model}{Orientation of the model}
#' \item{RTS}{Returns-to-scale for the model}
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
#' univariate$frontier <- univariate$y / dea.fit$thetaOpt
#' 
#' #Plot technical/allocative efficiency over time
#' library(ggplot2)
#' 
#' ggplot(univariate, aes(x, y)) +
#'   geom_point() +
#'   geom_line(aes(y = frontier), color = "red")
#' 
#' @references
#' \insertRef{FareDEA}{snfa}
#' 
#' @export
dea <-
  function(XREF, YREF, X, Y, model = "output", RTS = "variable"){
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
  if (!(RTS %in% c("constant", "variable", "non-increasing"))) stop("RTS must be \"constant\", \"variable\", or \"non-increasing\".")
  if (!(model %in% c("input", "output"))) stop("model must be \"input\" or \"output\".")
  
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
  
  theta.opt <- rep(NA, num.obs)
  lambda <- matrix(NA, nrow = num.obs, ncol = num.obs.ref)
  
  f.obj <- c(1, rep(0, num.obs.ref))
  
  if (model == "output"){
    for (i in 1:num.obs){
      #Construct constraints
      f.con <- rbind(cbind(Y[i,], -t(YREF)),
                     cbind(0, t(XREF)))
      f.dir <- rep("<=", num.outputs + num.inputs)
      f.rhs <- c(rep(0, num.outputs), X[i,])
      
      #Create constraints for RTS other than constant
      if (RTS == "variable"){
        f.con <- rbind(f.con,
                       c(0, rep(1, num.obs.ref)))
        f.dir <- c(f.dir, "==")
        f.rhs <- c(f.rhs, 1)
      } else if (RTS == "non-increasing"){
        f.con <- rbind(f.con,
                       c(0, rep(1, num.obs.ref)))
        f.dir <- c(f.dir, "<=")
        f.rhs <- c(f.rhs, 1)
      }
      
      lp.result <- lpSolve::lp(direction = "max",
                               f.obj, f.con, f.dir, f.rhs)
      if (lp.result$status != 0) stop(paste0("LP solver failed for observation ", i, "."))
      
      theta.opt[i] <- 1 / lp.result$objval
      lambda[i,] <- lp.result$objective[-1]
    }
  } else{
    for (i in 1:num.obs){
      #Construct constraints
      f.con <- rbind(cbind(X[i,], -t(XREF)),
                     cbind(0, t(YREF)))
      f.dir <- rep(">=", num.outputs + num.inputs)
      f.rhs <- c(rep(0, num.outputs), Y[i,])
      
      #Create constraints for RTS other than constant
      if (RTS == "variable"){
        f.con <- rbind(f.con,
                       c(0, rep(1, num.obs.ref)))
        f.dir <- c(f.dir, "==")
        f.rhs <- c(f.rhs, 1)
      } else if (RTS == "non-increasing"){
        f.con <- rbind(f.con,
                       c(0, rep(1, num.obs.ref)))
        f.dir <- c(f.dir, "<=")
        f.rhs <- c(f.rhs, 1)
      }
      
      lp.result <- lpSolve::lp(direction = "min",
                               f.obj, f.con, f.dir, f.rhs)
      if (lp.result$status != 0) stop(paste0("LP solver failed for observation ", i, "."))
      
      theta.opt[i] <- lp.result$objval
      lambda[i,] <- lp.result$objective[-1]
    }
  }
  
  result <- list(thetaOpt = theta.opt,
                 lambda = lambda,
                 lambda_sum = rowSums(lambda),
                 model = model,
                 RTS = RTS)
  
  return(result)
}
