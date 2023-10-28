library(nlme)
data(revenge, package = "hecstatmod")
revenge$t <- as.integer(revenge$time)
# Vanilla linear model, fitted with REML
model0 <- gls(revenge ~ sex + age + vc + wom + t, 
              data = revenge)
summary(model0)

# Compound symmetry model
model1 <- gls(revenge ~ sex + age + vc + wom + t,
              correlation= corCompSymm(form=~1|id),
              data = revenge)
# Summary of coefficients table
summary(model1)
# Table of type III effects
car::Anova(model1, type=3)
# Likelihood ratio test comparing independence (linear model) with CS
anova(model0, model1)

vcid1 <- getVarCov(model1, individual = 1,
          type = "marginal")
vcid1
cov2cor(vcid1)
