library(nlme)
data(revenge, package = "hecstatmod")
revenge$t <- as.integer(revenge$time)
# Vanilla linear model, fitted with REML
model0 <- gls(revenge ~ sex + age + vc + wom + t, 
              data = revenge)
# Autoregressive model of order 1
model2 <- gls(revenge ~ sex + age + vc + wom + t,
              correlation= corAR1(form=~1|id),
              data = revenge)
summary(model2)
# Likelihood ratio test
anova(model0, model2)

# Covariance and correlation matrix for id=1
vcid1 <- getVarCov(model2, individual = 1,
                   type = "marginal")
vcid1
cov2cor(vcid1)