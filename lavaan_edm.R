library(lavaan)


# include edm.R


lavaan_edm_dmacs <- function(fit, group1, group2) {

  num_items <- lavaan::lavInspect(fit, what = "rsquare") %>%
    .data[[1]] %>%
    names(.data) %>%
    length(.data)


  # get model parameters of reference and focal group

  load1 <- lavaan::inspect(fit, what = "est") %>%
    .data[[1]] %>%
    .data$lambda
  load2 <- lavaan::inspect(fit, what = "est") %>%
    .data[[2]] %>%
    .data$lambda

  intrcp1 <- lavaan::inspect(fit, what = "est") %>%
    .data[[1]] %>%
    .data$nu
  intrcp2 <- lavaan::inspect(fit, what = "est") %>%
    .data[[2]] %>%
    .data$nu


  # get latent mean and covariance estimated from focal group
  # oder using fitted()? i.e. fitted(fit)$mean?

  mean2 <- lavaan::inspect(fit, what = "est") %>%
    .data[[2]] %>%
    .data$WASKOMMTHIERHIN

  cov2 <- lavaan::inspect(fit, what = "est") %>%
    .data[[2]] %>%
    .data$psi


  # calculate pooled standard deviation

  sd_pooled <- function(fit) {
    se <- lavaan::lavInspect(fit, what = "se")
    n <- lavaan::lavInspect(fit, what = "nobs")
    l <- list()
    test <- lavaan::lavInspect(fit, what = "rsquare") %>%
      .data[[1]] %>%
      names(.data) %>%
      length(.data)
    for (i in 1:test) {
      grp1 <- se[[group1]]$nu[i] * sqrt(n[1])
      grp2 <- se[[group2]]$nu[i] * sqrt(n[2])
      numerator <- ((n[1] - 1) * grp1 + (n[2] - 1) * grp2)
      denominator <- (n[1] - 1) + (n[2] - 1)
      sd_pooled <- numerator / denominator
      l[[paste("item", i)]] <- sd_pooled
    }
    result <- matrix(unlist(l), nrow = test, byrow = TRUE)
    return(result)
  }

  sd_p <- sd_pooled(fit)


  # calculate dMACS

  l <- list()   # containing dMACSj for j=1..num_items
  rowlab <- c() # containing "item j" for all j=1..num_items

  for (j in c(1:num_items)) {
    # load1[i] and load2[i] ?!?

    l[[length(l) + 1]] <- edm_item_dmacs(load1[i], load2[i],
                                         intrcp1[i], intrcp2[i],
                                         mean2, cov2,
                                         sd_p)
    rowlab[[length(rowlab) + 1]] <- paste("Item", j)
  }
  m <- matrix(unlist(l), nrow = num_items, dimnames = list(rowlab, "dMAC"))
  return(m)
}





# REFERENCE CODE FOR VANILLA dMCACS

dMACS <- function(fit.cfa, group1, group2) {

  # nitems ------------------------------------------------------------------
  nitems <- lavaan::lavInspect(fit.cfa, what = "rsquare") %>%
    .data[[1]] %>%
    names(.data) %>%
    length(.data)

  # Scale min and max -------------------------------------------------------
  cfa_minmax <- function(fit.cfa) {
    dt <- lavaan::inspect(fit.cfa, what = "data")
    latentMin <- min(dt[[1]]) - 1
    latentMax <- max(dt[[1]]) + 1
    out <- cbind(as.numeric(latentMin), as.numeric(latentMax))
    return(out)
  }
  # Loadings item-----------------------------------------------------------

  reference_load <- lavaan::inspect(fit.cfa, what = "est") %>%
    .data[[1]] %>%
    .data$lambda
  focal_load <- lavaan::inspect(fit.cfa, what = "est") %>%
    .data[[2]] %>%
    .data$lambda

  # Intercept item----------------------------------------------------------

  reference_intrcp <- lavaan::inspect(fit.cfa, what = "est") %>%
    .data[[1]] %>%
    .data$nu
  focal_intrcp <- lavaan::inspect(fit.cfa, what = "est") %>%
    .data[[2]] %>%
    .data$nu

  # Pooled standard deviation -----------------------------------------------

  pool.sd <- function(fit.cfa) {
    cfa.se <- lavaan::lavInspect(fit.cfa, what = "se")
    cfa.n <- lavaan::lavInspect(fit.cfa, what = "nobs")
    l <- list()
    test <- lavaan::lavInspect(fit.cfa, what = "rsquare") %>%
      .data[[1]] %>%
      names(.data) %>%
      length(.data)
    for (i in 1:test) {
      grp1 <- cfa.se[[group1]]$nu[i] * sqrt(cfa.n[1])
      grp2 <- cfa.se[[group2]]$nu[i] * sqrt(cfa.n[2])
      numerator <- ((cfa.n[1] - 1) * grp1 + (cfa.n[2] - 1) * grp2)
      denominator <- (cfa.n[1] - 1) + (cfa.n[2] - 1)
      pooled.sd <- numerator / denominator
      l[[paste("item", i)]] <- pooled.sd
    }
    result <- matrix(unlist(l), nrow = test, byrow = TRUE)
    return(result)
  }

  pld_sd <- pool.sd(fit.cfa)

  # latent variance ---------------------------------------------------------

  fcl_lt_vrnc <- lavaan::inspect(fit.cfa, what = "est") %>%
    .data[[2]] %>%
    .data$psi

  ## create functions to calculate the mean predicted response

  l <- list()
  rowlab <- c()
  for (i in c(1:nitems)) {
    ## focal group predicted value
    focal.fn <- function(x) {
      mpr <- focal_intrcp[i] + focal_load[i] * x
      return(mpr)
    }
    ## reference group predicted value
    reference.fn <- function(x) {
      mpr <- reference_intrcp[i] + reference_load[i] * x
      return(mpr)
    }

    ## part under sqrt (function to integrate)
    diff.fn <- function(x, i = i) {
      d <- ((reference.fn(x) - focal.fn(x))^2) * stats::dnorm(x, mean = 0, sd = sqrt(fcl_lt_vrnc))
      return(d)
    }

    ## final equation (and round to 3dp)
    dMACS <- round((1 / pld_sd[i]) * sqrt(stats::integrate(diff.fn,
      lower = cfa_minmax(fit.cfa)[, 1],
      upper = cfa_minmax(fit.cfa)[, 2]
    )$value), 3)

    l[[length(l) + 1]] <- dMACS
    rowlab[[length(rowlab) + 1]] <- paste("Item", i)
  }
  m <- matrix(unlist(l), nrow = nitems, dimnames = list(rowlab, "dMAC"))
  return(m)
}
