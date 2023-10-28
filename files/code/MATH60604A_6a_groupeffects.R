library(nlme)
data(revenge, package = "hecstatmod")
revenge$t <- as.integer(revenge$time)

model1 <- gls(revenge ~ sex + age + vc + wom + t,
              correlation= corAR1(form=~1|id),
              data = revenge, method = "ML")
model2 <- gls(revenge ~ id + t,
              data = revenge, 
              method = "ML")
model3 <- gls(revenge ~ id + t,
              data = revenge, 
              correlation= corAR1(form=~1|id),
              method = "ML")

anova(model2, model3) # AR(1) corr coefficient not significative 
# if we have a group effect -> less residual structure
AIC(model1, model2)
BIC(model1, model2)
# All models have been fitted using maximum likelihood here