Binomial <- function(theta = NULL, N = NULL, bounds = list(NULL, NULL),
                     trunc  = list(NULL, NULL), k = NULL, r = NULL, param = NULL) {
  DiscreteDensity(
    "Binomial",
    mget(names(formals()), sys.frame(sys.nframe()))
  )
}

constants.Binomial <- function(x) {
  sprintf(
    "int<lower = 1> N = %s; // number of trials",
    x$N
  )
}

freeParameters.Binomial <- function(x) {
  thetaStr <-
    if (is.Density(x$theta)) {
      thetaBoundsStr <- make_bounds(x, "theta")
      sprintf(
        "real%s theta%s%s;",
        thetaBoundsStr, x$k, x$r
      )
    } else {
      ""
    }

  thetaStr
}

fixedParameters.Binomial <- function(x) {
  thetaStr <-
    if (is.Density(x$theta)) {
      ""
    } else {
      if (!check_scalar(x$theta)) {
        stop("If fixed, theta must be a scalar.")
      }

      sprintf(
        "real theta%s%s = %s;",
        x$k, x$r, x$theta
      )
    }

  thetaStr
}

generated.Binomial <- function(x) {
  sprintf(
    "if(zpred[t] == %s) ypred[t][%s] = binomial_rng(N, theta%s%s);",
    x$k, x$r,
    x$k, x$r
  )
}

getParameterNames.Binomial <- function(x) {
  return("theta")
}

logLike.Binomial <- function(x) {
  sprintf(
    "loglike[%s][t] = binomial_lpmf(y[t] | N, theta%s%s);",
    x$k,
    x$k, x$r
  )
}

prior.Binomial <- function(x) {
  truncStr <- make_trunc(x, "")
  rStr     <- make_rsubindex(x)
  sprintf(
    "%s%s%s ~ binomial(N, %s) %s;",
    x$param,
    x$k, rStr,
    x$theta,
    truncStr
  )
}
