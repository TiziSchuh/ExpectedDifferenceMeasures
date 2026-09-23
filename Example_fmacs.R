source("lavaan_edm.R")

# Holzinger Swineford
test_model <- ' visual  =~ x1 + x2 + x3
              textual =~ x4 + x5 + x6
              speed   =~ x7 + x8 + x9 '

fit <- cfa(test_model, data = HolzingerSwineford1939, group = "school")
fitGlobal <- cfa(test_model, data = HolzingerSwineford1939, meanstructure = TRUE)

lavaan_edm_fmacs(fit, fitGlobal)