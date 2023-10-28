data(intention, package = "hecstatmod")
# Logistic regression
form <- "buy ~ sex + age + revenue + educ + marital + fixation + emotion"
mod <- glm(form, data=intention, family=binomial(link="logit"))  
summary(mod)
car::Anova(mod, type = "3")
# 95% confidence intervals for odds (i.e., exp(beta))
exp(cbind(coef(mod), confint(mod)))
