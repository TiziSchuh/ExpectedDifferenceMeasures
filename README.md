# Expected Difference Measures

This repository implements [expected difference measures (EDMs)](https://osf.io/preprints/psyarxiv/cq9vk_v2) – in particular the **general version of dMACS** applicable to mutli-factorial models with cross-loading and factor-correlations.   

# Raw `R` functions
## Expected Differences
Expected differences can be explicitely calculated using the R function 

`exp_diff(load1, load2,
         intrcp1, intrcp2,
         factor_mean, factor_cov,
         diff_type)`

with options `diff_type` = `"signed"`, `"absolute"` or `"squared"`.
## EDMs
Syntax `edm_item_...` and `edm_item_..._signed`

### dMACS
* dMACS: `edm_item_dmacs(load_ref, load_foc, intrcp_ref, intrcp_foc, factor_mean_foc, factor_cov_foc, sd)`
* dMACS_Signed: `edm_item_dmacs_signed(load_ref, load_foc,
                                  intrcp_ref, intrcp_foc,
                                  factor_mean_foc, factor_cov_foc,
                                  sd)`
### deltaMACS
* deltaMACS: `edm_item_deltamacs(load_ref, load_foc,
                               intrcp_ref, intrcp_foc,
                               factor_mean_foc, factor_cov_foc,
                               sd_foc)`
* deltaMACS_Signed: `edm_item_deltamacs_signed(load_ref, load_foc,
                                      intrcp_ref, intrcp_foc,
                                      factor_mean_foc, factor_cov_foc,
                                      sd_foc)`
### WUDI & SDI
* WUDI: work in process...
* SDI: work in process...
### fMACS
* fMACS: work in process...
* fMACS_Weighted: work in process...

# `lavaan` functions
Syntax `lavaan_edm_...`
## dMACS
* dMACS: `lavaan_edm_dmacs(fit, group1, group2)`

work in process...
