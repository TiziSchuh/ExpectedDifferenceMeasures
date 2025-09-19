library(lavaan)
source("edm.R")


# see \code{colSD} in ddueber/dmacs
# "..." later "na.rm = TRUE" to exlude missing values
col_sd <- function(x, ...) {
  apply(X = x, MARGIN = 2, FUN = sd, ...)
}


lavaan_edm_dmacs <- function(fit, ref_group = 1, foc_group) {
  fit_est <- lavaan::lavInspect(fit, "est")
  fit_data <- lavaan::lavInspect(fit, "data")

  lambda_list <- lapply(fit_est, function(x) {
    x$lambda
  })
  nu_list <- lapply(fit_est, function(x) {
    x$nu
  })
  alpha_list <- lapply(fit_est, function(x) {
    x$alpha
  })
  psi_list <- lapply(fit_est, function(x) {
    x$psi
  })

  # get raw values
  loading_matrix_ref <- unname(lambda_list[[ref_group]])
  loading_matrix_foc <- unname(lambda_list[[foc_group]])
  intercepts_ref <- unname(nu_list[[ref_group]])
  intercepts_foc <- unname(nu_list[[foc_group]])
  latent_mean_foc <- unname(alpha_list[[foc_group]])
  latent_cov_matrix_foc <- unname(psi_list[[foc_group]])

  # pooled standard deviation
  sd_ref <- col_sd(fit_data[[ref_group]], na.rm = TRUE)
  n_ref <- colSums(!is.na(fit_data[[ref_group]]))
  sd_foc <- col_sd(fit_data[[foc_group]], na.rm = TRUE)
  n_foc <- colSums(!is.na(fit_data[[foc_group]]))
  sd_pooled <- ((n_foc - 1) * sd_foc + (n_ref - 1) * sd_ref) /
    ((n_foc - 1) + (n_ref - 1))
  sd_pooled <- unname(sd_pooled)

  item_number <- length(intercepts_ref)

  dmacs_index <- sapply(1:item_number, function(x){
    edm_item_dmacs(loading_matrix_ref[x, ], loading_matrix_foc[x, ],
                   intercepts_ref[x], intercepts_foc[x],
                   latent_mean_foc, latent_cov_matrix_foc,
                   sd_pooled[x])
  })

  dmacs_signed_index <- sapply(1:item_number, function(x){
    edm_item_dmacs_signed(loading_matrix_ref[x, ], loading_matrix_foc[x, ],
                          intercepts_ref[x], intercepts_foc[x],
                          latent_mean_foc, latent_cov_matrix_foc,
                          sd_pooled[x])
  })

  data_frame <- data.frame(
    "dMACS" = dmacs_index,
    "dMACS_Signed" = dmacs_signed_index,
    row.names = rownames(nu_list[[ref_group]])
  )

  data_frame
}


lavaan_edm_deltamacs <- function(fit, ref_group = 1, foc_group) {
  fit_est <- lavaan::lavInspect(fit, "est")
  fit_data <- lavaan::lavInspect(fit, "data")

  lambda_list <- lapply(fit_est, function(x) {
    x$lambda
  })
  nu_list <- lapply(fit_est, function(x) {
    x$nu
  })
  alpha_list <- lapply(fit_est, function(x) {
    x$alpha
  })
  psi_list <- lapply(fit_est, function(x) {
    x$psi
  })

  # get raw values
  loading_matrix_ref <- unname(lambda_list[[ref_group]])
  loading_matrix_foc <- unname(lambda_list[[foc_group]])
  intercepts_ref <- unname(nu_list[[ref_group]])
  intercepts_foc <- unname(nu_list[[foc_group]])
  latent_mean_foc <- unname(alpha_list[[foc_group]])
  latent_cov_matrix_foc <- unname(psi_list[[foc_group]])

  # standard deviation of the reference group
  sd_ref <- unname(col_sd(fit_data[[ref_group]], na.rm = TRUE))

  item_number <- length(intercepts_ref)

  deltamacs_index <- sapply(1:item_number, function(x){
    edm_item_deltamacs(loading_matrix_ref[x, ], loading_matrix_foc[x, ],
                       intercepts_ref[x], intercepts_foc[x],
                       latent_mean_foc, latent_cov_matrix_foc,
                       sd_ref[x])
  })

  deltamacs_signed_index <- sapply(1:item_number, function(x){
    edm_item_deltamacs_signed(loading_matrix_ref[x, ], loading_matrix_foc[x, ],
                              intercepts_ref[x], intercepts_foc[x],
                              latent_mean_foc, latent_cov_matrix_foc,
                              sd_ref[x])
  })

  data_frame <- data.frame(
    "deltaMACS" = deltamacs_index,
    "deltaMACS_Signed" = deltamacs_signed_index,
    row.names = rownames(nu_list[[ref_group]])
  )

  data_frame
}