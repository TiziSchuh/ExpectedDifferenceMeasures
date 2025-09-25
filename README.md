# Expected Difference Measures

This repository implements Expected Difference Measures (EDMs) – a class of effect size measures for measurement non-invariance (including a generalized version of **dMACS** allowing **mutli-factorial models** with **cross-loading** and **factor-correlations**) – as `lavaan` functions for multi-group `fit` objects.

[EDMs](https://osf.io/preprints/psyarxiv/cq9vk_v2): Schuhbeck, T. M. B., Sterner, P., & Goretzko, D. (2025, July 10). Quantifying Measurement Non-Invariance Beyond Simple Structure: The Closed Formulas of Universal Effect Size Measures for MI. https://doi.org/10.31234/osf.io/cq9vk_v2

# Usage

Download the file `lavaan_edm.R` to the same location of your project and include `source("lavaan_edm.R")` in the header of your file.

## EDMs with reference and focal group 
### `lavaan_edm(fit, refGroup = 1, focGroup = 2, sdType = "pooled", edType = "squared")` 
returns the EDM values of two groups `refGroup`, `focGroup` for a multi-group laavan `fit` object.   
- `sdType` defines which standard deviation should be used for normalization: `"pooled"`, `"ref"`, `"foc"` or `NULL` (for a non-normalized version)
- `edType`  defines the type of difference used for calculating the unsigned expected response difference: `"squared"` or `"absolute"`
  
(by default returns the the values of dMACS & dMACS_Signed) 

### `lavaan_edm_dmacs(fit, refGroup = 1, focGroup = 2)` 
returns the values of **dMACS** & **dMACS_Signed** for each item. 

[dMACS](https://www.researchgate.net/profile/Christopher-Nye-2/publication/50998374_Effect_Size_Indices_for_Analyses_of_Measurement_Equivalence_Understanding_the_Practical_Importance_of_Differences_Between_Groups/links/550859a20cf26ff55f816638/Effect-Size-Indices-for-Analyses-of-Measurement-Equivalence-Understanding-the-Practical-Importance-of-Differences-Between-Groups.pdf): Nye, C. D., & Drasgow, F. (2011). Effect size indices for analyses of measurement equivalence: understanding the practical importance of differences between groups. Journal of applied psychology, 96(5), 966.

[dMACS_Signed](https://www.researchgate.net/profile/Fritz-Drasgow/publication/323804009_How_Big_Are_My_Effects_Examining_the_Magnitude_of_Effect_Sizes_in_Studies_of_Measurement_Equivalence/links/5b869e4592851c1e1239e69c/How-Big-Are-My-Effects-Examining-the-Magnitude-of-Effect-Sizes-in-Studies-of-Measurement-Equivalence.pdf?_sg%5B0%5D=started_experiment_milestone&origin=journalDetail): Nye, C. D., Bradburn, J., Olenick, J., Bialko, C., & Drasgow, F. (2019). How big are my effects? Examining the magnitude of effect sizes in studies of measurement equivalence. Organizational Research Methods, 22(3), 678-709.

### `lavaan_edm_deltamacs(fit, refGroup = 1, focGroup = 2)` 
returns the values of **deltaMACS** & **deltaMACS_Signed** (a variant of dMACS & dMACS_Signed using the standard deviation of the reference group for normalization) for each item. 

### `lavaan_edm_DI(fit, refGroup = 1, focGroup = 2)`
returns the values of **UDI** & **SDI** (a variant of dMACS & dMACS_Signed using the standard deviation of the focal group for normalization and absolute instead of squared differences in the unsigned case) for each item. 

[UDI&SDI](https://core.ac.uk/download/pdf/200249537.pdf): Gunn, H. J. (2019). Evaluation of Five Effect Size Measures of Measurement Non-invariance for Continuous Outcomes (Doctoral dissertation, Arizona State University).

## other EDMS 

### WUDI & WSDI
work inprogress...

[WUDI&WSDI](https://core.ac.uk/download/pdf/200249537.pdf): Gunn, H. J. (2019). Evaluation of Five Effect Size Measures of Measurement Non-invariance for Continuous Outcomes (Doctoral dissertation, Arizona State University).

### fMACS
work inprogress...

[fMACS](https://www.tandfonline.com/doi/pdf/10.1080/10705511.2025.2484812): Lai, M. H., Zhang, Y., Ozcan, M., Tse, W. W. Y., & Miles, A. (2025). f MACS: Generalizing d MACS Effect Size for Measurement Noninvariance with Multiple Groups and Multiple Grouping Variables. Structural Equation Modeling: A Multidisciplinary Journal, 1-9.



