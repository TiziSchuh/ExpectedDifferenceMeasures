library(pracma) # needed for "erf" function in exp_diff("absolute")


# IMPLEMENT Error Messages!
#
# - loading vector nur \neq 0 Elemente?
# Check if len(LambdaR)==len(dim LambdaF)
# SOLUTION: Require inclusion of all 0 loadings
# - check if input type correct
# - check if categorical? -> in lavaan version?


# ------------------------------------------------------------------------------
# expected difference ("signed", "absolute" and "squared") of group models
# ------------------------------------------------------------------------------


exp_diff <- function(load1, load2,
                     intrcp1, intrcp2,
                     factor_mean, factor_cov,
                     diff_type = "signed") {
  intrcp_diff <- intrcp1 - intrcp2
  load_diff <- matrix(load1) - matrix(load2)

  # calculate mean and variance of model difference
  diff_mean <- intrcp_diff + t(load_diff) %*% matrix(factor_mean)
  diff_var <- t(load_diff) %*% factor_cov %*% load_diff

  # calculate expected value
  if (diff_type == "signed") {
    exp <- diff_mean
  } else if (diff_type == "absolute") {
    exp <- (sqrt(diff_var) * sqrt(2/pi) * exp(-((diff_mean^2) / (2 * diff_var)))
            + diff_mean * erf(diff_mean / sqrt(2 * diff_var)))
  } else if (diff_type == "squared") {
    exp <- diff_mean^2 + diff_var
  } else {
    return(NA)
  }

  # convert to float
  exp[1, 1]
}



# ------------------------------------------------------------------------------
# generalized effect size measures for MNE
# ------------------------------------------------------------------------------


# dMACS ------------------------------------------------------------------------

edm_item_dmacs <- function(load_ref, load_foc,
                           intrcp_ref, intrcp_foc,
                           factor_mean_foc, factor_cov_foc,
                           sd) {
  # error check
  sqrt(
    exp_diff(load_ref, load_foc,
             intrcp_ref, intrcp_foc,
             factor_mean_foc, factor_cov_foc,
             diff_type = "squared")
  ) / sd
}

edm_item_dmacs_signed <- function(load_ref, load_foc,
                                  intrcp_ref, intrcp_foc,
                                  factor_mean_foc, factor_cov_foc,
                                  sd) {
  # error check
  exp_diff(load_ref, load_foc,
           intrcp_ref, intrcp_foc,
           factor_mean_foc, factor_cov_foc) / sd
}



# deltaMACS (orignially UDI and sdI) -------------------------------------------

edm_item_deltamacs <- function(load_ref, load_foc,
                               intrcp_ref, intrcp_foc,
                               factor_mean_foc, factor_cov_foc,
                               sd_foc) {
  # error check
  exp_diff(load_ref, load_foc,
           intrcp_ref, intrcp_foc,
           factor_mean_foc,factor_cov_foc, 
           diff_type = "absolute") / sd_foc
}

edm_item_deltamacs_signed <- function(load_ref, load_foc,
                                      intrcp_ref, intrcp_foc,
                                      factor_mean_foc, factor_cov_foc,
                                      sd_foc) {
  # error check
  exp_diff(load_ref, load_foc,
           intrcp_ref, intrcp_foc,
           factor_mean_foc, factor_cov_foc) / sd_foc
}



# WUDI and SDI -----------------------------------------------------------------

#...



# fmacs and fmacs_weigthed -----------------------------------------------------

#...



# ------------------------------------------------------------------------------
# TESTING
# ------------------------------------------------------------------------------
library(dmacs)


load1 <- .3 # c(.8,.2)
load2 <- .2 # c(.6,.4)
intrcp1 <- 2
intrcp2 <- 3
latentmean <- 2 # c(0.1,0.1)
latentcov <- 1 # matrix(c(1,.5,.5,1),nrow = 2, ncol = 2)
sd <- 1

# dMACS-------------------------------------------------------------------------
print(edm_item_dmacs(load1, load2,
                     intrcp1, intrcp2,
                     latentmean, latentcov,
                     sd))
# original
print(item_dmacs(load1, load2,
                 intrcp1, intrcp2,
                 latentmean, latentcov,
                 sd))

# dMACS_Signed------------------------------------------------------------------
print(edm_item_dmacs_signed(load1, load2,
                            intrcp1, intrcp2,
                            latentmean, latentcov,
                            sd))
# original (accidentaly sign reversed?!)
print(delta_mean_item(load1, load2,
                      intrcp1, intrcp2,
                      latentmean, latentcov,
                      sd))

# deltaMACS---------------------------------------------------------------------
print(edm_item_deltamacs(load1, load2,
                         intrcp1, intrcp2,
                         latentmean, latentcov,
                         sd))