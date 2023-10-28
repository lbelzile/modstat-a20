data(intention, package = "hecstatmod")
# Fitting Poisson model
form <- "nitem ~ sex + age + revenue + educ + marital + fixation + emotion"
mod <- glm(form, data=intention, family=poisson)
# Coefficients table with Wald tests
summary(mod)
# Type 3 effects - likelihood ratio tests
car::Anova(mod, 3)
# Likelihood-based 95% confidence intervals for parameters
confint(mod)
AIC(mod); BIC(mod); deviance(mod); df.residual(mod)
# The Pearson chi-square statistic is obtained
# by summing the Pearson residuals
sum(residuals(mod, type = "pearson")^2)
