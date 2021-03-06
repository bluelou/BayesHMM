Poisson <- function(lambda = NULL, bounds = list(NULL, NULL),
                    trunc  = list(NULL, NULL), k = NULL, r = NULL, param = NULL) {
  DiscreteDensity(
    "Poisson",
    mget(names(formals()), sys.frame(sys.nframe()))
  )
}

freeParameters.Poisson <- function(x) {
  lambdaStr <-
    if (is.Density(x$lambda)) {
      lambdaBoundsStr <- make_bounds(x, "lambda")
      sprintf(
        "real%s lambda%s%s;",
        lambdaBoundsStr, x$k, x$r
      )
    } else {
      ""
    }

  lambdaStr
}

fixedParameters.Poisson <- function(x) {
  lambdaStr <-
    if (is.Density(x$lambda)) {
      ""
    } else {
      if (!check_scalar(x$lambda)) {
        stop("If fixed, lambda must be a scalar.")
      }

      sprintf(
        "real lambda%s%s = %s;",
        x$k, x$r, x$lambda
      )
    }

  lambdaStr
}

generated.Poisson <- function(x) {
  sprintf(
    "if(zpred[t] == %s) ypred[t][%s] = poisson_rng(lambda%s%s);",
    x$k, x$r,
    x$k, x$r
  )
}

getParameterNames.Poisson <- function(x) {
  return("lambda")
}

logLike.Poisson <- function(x) {
  sprintf(
    "loglike[%s][t] = poisson_lpmf(y[t] | lambda%s%s);",
    x$k,
    x$k, x$r
  )
}

prior.Poisson <- function(x) {
  truncStr <- make_trunc(x, "")
  rStr     <- make_rsubindex(x)
  sprintf(
    "%s%s%s ~ poisson(%s) %s;",
    x$param,
    x$k, rStr,
    x$lambda,
    truncStr
  )
}
