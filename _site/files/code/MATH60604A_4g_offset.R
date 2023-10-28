# Model for counts with offset
data(crash, package = "hecstatmod")
# Fit an exponential-dispersion model 
mod <- MASS::glm.nb(ndeath ~ time + year + offset(log(popn)), data=crash)
# Base rate of death is exp(intercept) (baseline= 2010-day)
exp(coef(mod))  
