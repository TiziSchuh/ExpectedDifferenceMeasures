# Expected Difference Measures

This repository implements [expected difference measures (EDMs)](https://osf.io/preprints/psyarxiv/cq9vk_v2) as `lavaan` functions for multi-group `fit` objects – in particular the **general version of dMACS** applicable to mutli-factorial models with cross-loading and factor-correlations.   

## Usage

Download the files `edm.R` and `lavaan_edm.R` and include `source("lavaan_edm.R")` in the header of your project.

The syntax of all EDM functions follows the scheme `lavaan_edm_` + specific effect size measure of choice:
### dMACS
`lavaan_edm_dmacs(fit, ref_group, foc_group)` returns the values of dMACS and dMACS_Signed for each item. 

[dMACS](https://www.researchgate.net/profile/Christopher-Nye-2/publication/50998374_Effect_Size_Indices_for_Analyses_of_Measurement_Equivalence_Understanding_the_Practical_Importance_of_Differences_Between_Groups/links/550859a20cf26ff55f816638/Effect-Size-Indices-for-Analyses-of-Measurement-Equivalence-Understanding-the-Practical-Importance-of-Differences-Between-Groups.pdf): Nye, C. D., & Drasgow, F. (2011). Effect size indices for analyses of measurement equivalence: understanding the practical importance of differences between groups. Journal of applied psychology, 96(5), 966.

[dMACS_Signed](https://www.researchgate.net/profile/Fritz-Drasgow/publication/323804009_How_Big_Are_My_Effects_Examining_the_Magnitude_of_Effect_Sizes_in_Studies_of_Measurement_Equivalence/links/5b869e4592851c1e1239e69c/How-Big-Are-My-Effects-Examining-the-Magnitude-of-Effect-Sizes-in-Studies-of-Measurement-Equivalence.pdf?_sg%5B0%5D=started_experiment_milestone&origin=journalDetail): Nye, C. D., Bradburn, J., Olenick, J., Bialko, C., & Drasgow, F. (2019). How big are my effects? Examining the magnitude of effect sizes in studies of measurement equivalence. Organizational Research Methods, 22(3), 678-709.

### deltaMACS (aka UDI & SDI) 
`lavaan_edm_deltamacs(fit, ref_group, foc_group)` returns the values of deltaMACS and deltaMACS_Signed for each item. 

[UDI&SDI](https://core.ac.uk/download/pdf/200249537.pdf): Gunn, H. J. (2019). Evaluation of Five Effect Size Measures of Measurement Non-invariance for Continuous Outcomes (Doctoral dissertation, Arizona State University).

### fMACS
work inprogress...

[fMACS](https://www.tandfonline.com/doi/pdf/10.1080/10705511.2025.2484812): Lai, M. H., Zhang, Y., Ozcan, M., Tse, W. W. Y., & Miles, A. (2025). f MACS: Generalizing d MACS Effect Size for Measurement Noninvariance with Multiple Groups and Multiple Grouping Variables. Structural Equation Modeling: A Multidisciplinary Journal, 1-9.

## Raw `R` functions (not intended for the casual user)
Expected differences can be explicitely calculated using the R function 

`exp_diff(load1, load2,
         intrcp1, intrcp2,
         factor_mean, factor_cov,
         diff_type)`

with options `diff_type` = `"signed"`, `"absolute"` or `"squared"`.

EDMs are implemented using the syntax `edm_item_...` and `edm_item_..._signed` analogous to their respective `lavaan` versions. 

### dMACS
`edm_item_dmacs(load_ref, load_foc, intrcp_ref, intrcp_foc, factor_mean_foc, factor_cov_foc, sd)`
`edm_item_dmacs_signed(load_ref, load_foc,
                                  intrcp_ref, intrcp_foc,
                                  factor_mean_foc, factor_cov_foc,
                                  sd)`
### deltaMACS
`edm_item_deltamacs(load_ref, load_foc,
                               intrcp_ref, intrcp_foc,
                               factor_mean_foc, factor_cov_foc,
                               sd_foc)`
`edm_item_deltamacs_signed(load_ref, load_foc,
                                      intrcp_ref, intrcp_foc,
                                      factor_mean_foc, factor_cov_foc,
                                      sd_foc)`
### fMACS
work in process...


