library(nlme)
data(revenge, package = "hecstatmod")
revenge$t <- as.integer(revenge$time)
# Vanilla linear model, fitted with REML
model0 <- gls(revenge ~ sex + age + vc + wom + t, data = revenge)
# Compound symmetry model
model1 <- gls(revenge ~ sex + age + vc + wom + t,
              correlation= corCompSymm(form=~1|id),
              data = revenge)
# Autoregressive model of order 1
model2 <- gls(revenge ~ sex + age + vc + wom + t,
              correlation= corAR1(form=~1|id),
              data = revenge)
model3 <- gls(revenge ~ sex + age + vc + wom + t,
              corr = corAR1(form = ~ 1 | id),
              weight = varIdent(form = ~ 1 | time),
              data = revenge)
# Unstructured
model4 <- gls(revenge ~ sex + age + vc + wom + t,
              correlation= corSymm(form=~1|id),
              data = revenge)
# Likelihood ratio test
anova(model0, model4) #indep versus unstr
anova(model1, model4) #CS vs unst
anova(model2, model4) #AR(1) vs unstr
anova(model2, model3) #AR(1) vs ARH(1)
anova(model3, model4) #ARH(1) vs unstr

# Information criteria for all of the models
AIC <- AIC(model0, model1, model2, model3, model4)
tab <- data.frame(
  model = c("indep","cs","ar(1)","arh(1)","unstr"),
  df = AIC$df - 6L,
  AIC = AIC$AIC,
  BIC = BIC(model0, model1, model2, model3, model4)$BIC)
print(tab)
