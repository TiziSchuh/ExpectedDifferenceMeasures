library(lavaan)
library(dmacs)

source("lavaan_edm.R")

# Holzinger Swineford
test_model <- ' visual  =~ x1 + x2 + x3
              textual =~ x4 + x5 + x6
              speed   =~ x7 + x8 + x9 '

fit <- cfa(test_model, data = HolzingerSwineford1939, group = "school")

#' original dmacs
#' lavaan_dmacs(fit, RefGroup = "Pasteur")

# the extended version edm_dmacs
lavaan_edm_dmacs(fit, ref_group = "Pasteur", foc_group = 2)