library(nlme)
data(revenge, package = "hecstatmod")
revenge$t <- as.integer(revenge$time)
#ARH(1)
model3 <- gls(revenge ~ sex + age + vc + wom + t,
              corr = corAR1(form = ~ 1 | id),
              weight = varIdent(form = ~ 1 | time),
              data = revenge)
summary(model3)
# Unstructured
model4 <- gls(revenge ~ sex + age + vc + wom + t,
              correlation= corSymm(form=~1|id),
              data = revenge)
summary(model4)



# Covariance and correlation matrix for id=1
(vcid1 <- getVarCov(model3, individual = 1,
                   type = "marginal"))
cov2cor(vcid1)
(vcid1 <- getVarCov(model4, individual = 1,
                   type = "marginal"))
cov2cor(vcid1)