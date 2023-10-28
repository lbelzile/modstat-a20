# The following two libraries are used in R for fitting mixed models
library(lme4) #generalized mixed models with grouping - more modern, better maintained and more scalable for large problems (but no covariance support)
library(nlme) #linear mixed models with covariance models for the errors
data(revenge, package = "hecstatmod")
revenge$t <- as.integer(revenge$time)

# Compound symmetry model
model1 <- nlme::gls(revenge ~ sex + age + vc + wom + t,
              correlation= corCompSymm(form=~1|id),
              data = revenge, method = "REML")
model2 <- nlme::lme(revenge ~ sex + age + vc + wom + t, 
                    random = ~ 1  | id, 
                    data = revenge, method = "REML")
# Do we get the same estimates?
isTRUE(all.equal(coef(model1), fixef(model2)))
# Print covariance matrices
getVarCov(model1, individual = 1,
          type = "marginal")
getVarCov(model2, individual = 1,
          type = "marginal")

# Marginal covariance is the sum of random effect cov + error
getVarCov(model2, type = "random.effects")
getVarCov(model2, individual = 1, type = "conditional")

