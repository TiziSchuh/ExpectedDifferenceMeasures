library(pracma) # erf() needed in \code(exp_response_diff)
library(lavaan)


#' \code(exp_response_diff) calculates the expected response difference of
#' two given group-specific FA models assuming a joint normal distribution
#' of the latent factors
#'
#' diffType="signed" returns E[Y_1-Y_2]
#' diffType="absolute" returns E[|Y_1-Y_2|]
#' diffType="squared" returns E[|Y_1-Y_2|^2]
#'
#' where Y_g denotes the linear FA model with parameters estimated using the
#' data of group g


exp_response_diff <- function(loading1, loading2,
                              intercept1, intercept2,
                              latentMean, latentCov,
                              diffType = "signed") {

  # calculate mean and var of model difference Y_1-Y_2
  interceptDiff <- intercept1 - intercept2
  loadingDiff <- matrix(loading1) - matrix(loading2)

  mean <- interceptDiff + t(loadingDiff) %*% matrix(latentMean)
  var <- t(loadingDiff) %*% latentCov %*% loadingDiff

  # calculate expected value
  if (diffType == "signed") {
    exp <- mean
  } else if (diffType == "absolute") {
    exp <- (sqrt(var) * sqrt(2/pi) * exp(-((mean^2) / (2 * var)))
            + mean * erf(mean / sqrt(2 * var)))
  } else if (diffType == "squared") {
    exp <- mean^2 + var
  } else {
    stop("exp_diff only supported for \"signed\", \"absolute\" and \"squared\"")
  }

  # get rid of matrix
  exp[1, 1]
}


colSd <- function(x, ...) {
  apply(X = x, MARGIN = 2, FUN = sd, ...)
}


lavaan_edm <- function(fit, refGroup = 1, focGroup = 2,
                               sdType = "pooled", edType = "squared") {
  fitEst <- lavaan::lavInspect(fit, "est")
  fitData <- lavaan::lavInspect(fit, "data")

  lambdaList <- lapply(fitEst, function(x) {
    x$lambda
  })
  nuList <- lapply(fitEst, function(x) {
    x$nu
  })
  alphaList <- lapply(fitEst, function(x) {
    x$alpha
  })
  psiList <- lapply(fitEst, function(x) {
    x$psi
  })

  # get raw paramters
  loadingsRef <- unname(lambdaList[[refGroup]])
  loadingsFoc <- unname(lambdaList[[focGroup]])
  interceptsRef <- unname(nuList[[refGroup]])
  interceptsFoc <- unname(nuList[[focGroup]])
  latentMeanFoc <- unname(alphaList[[focGroup]])
  latentCovFoc <- unname(psiList[[focGroup]])
  nItem <- length(interceptsRef)

  if (sdType == "pooled") {
    sdRef <- colSd(fitData[[refGroup]], na.rm = TRUE)
    nRef <- colSums(!is.na(fitData[[refGroup]]))
    sdFoc <- colSd(fitData[[focGroup]], na.rm = TRUE)
    nFoc <- colSums(!is.na(fitData[[focGroup]]))
    sd <- ((nFoc - 1) * sdFoc + (nRef - 1) * sdRef) /
      ((nFoc - 1) + (nRef - 1))
    sd <- unname(sd)
  } else if (sdType == "ref") {
    sd <- unname(colSd(fitData[[refGroup]], na.rm = TRUE))
  } else if (sdType == "foc") {
    sd <- unname(colSd(fitData[[focGroup]], na.rm = TRUE))
  } else if (sdType == NULL) {
    sd <- rep(1, nItem)
  } else {
    stop("sdType must be \"pooled\", \"ref\", \"foc\" or NULL")
  }

  # calculate effect size
  unsignedIndex <- sapply(1:nItem, function(i){
    sqrt(
      exp_response_diff(loadingsRef[i, ], loadingsFoc[i, ],
                        interceptsRef[i], interceptsFoc[i],
                        latentMeanFoc, latentCovFoc,
                        diffType = edType)
    ) / sd[i]
  })
  signedIndex <- sapply(1:nItem, function(i){
    exp_response_diff(loadingsRef[i, ], loadingsFoc[i, ],
                      interceptsRef[i], interceptsFoc[i],
                      latentMeanFoc, latentCovFoc,
                      diffType = "signed") / sd[i]
  })

  # create dataframe
  if (sdType == "pooled" && edType == "squared") {
    dataFrame <- data.frame(
      "dmacs" = unsignedIndex,
      "dmacs_signed" = signedIndex,
      row.names = rownames(nuList[[refGroup]])
    )
  } else if (sdType == "ref" && edType == "squared") {
    dataFrame <- data.frame(
      "deltamacs" = unsignedIndex,
      "deltamacs_signed" = signedIndex,
      row.names = rownames(nuList[[refGroup]])
    )
  } else if (sdType == "foc" && edType == "absolute") {
    dataFrame <- data.frame(
      "UDI" = unsignedIndex,
      "SDI" = signedIndex,
      row.names = rownames(nuList[[refGroup]])
    )
  } else {
    dataFrame <- data.frame(
      "unsigned" = unsignedIndex,
      "signed" = signedIndex,
      row.names = rownames(nuList[[refGroup]])
    )
  }

  groups <- names(nuList)
  if (is.numeric(refGroup)) {
    message("ref: ", groups[refGroup])
  } else {
    message("ref: ", refGroup)
  }
  if (is.numeric(focGroup)) {
    message("foc: ", groups[focGroup])
  } else {
    message("foc: ", focGroup)
  }

  dataFrame
}


lavaan_edm_dmacs <- function(fit, refGroup = 1, focGroup = 2) {
  lavaan_edm(fit, refGroup, focGroup)
}


lavaan_edm_deltamacs <- function(fit, refGroup = 1, focGroup = 2) {
  lavaan_edm(fit, refGroup, focGroup, sdType = "ref")
}


lavaan_edm_DI <- function(fit, refGroup = 1, focGroup = 2) {
  lavaan_edm(fit, refGroup, focGroup, sdType = "foc", edType = "absolute")
}