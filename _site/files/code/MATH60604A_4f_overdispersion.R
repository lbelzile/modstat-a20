# Fitting Poisson model
data(intention, package = "hecstatmod")
form <- "nitem ~ sex + age + revenue + educ + marital + fixation + emotion"
m1 <- glm(form, data=intention, family=poisson)
# Negative binomial regression 
# note that theta estimated is 1/k
m2 <- MASS::glm.nb(form, data=intention)
# P-value of the likelihood ratio test H0:k=0 vs H1:k>0 
lrtstat <- 2*as.numeric(logLik(m2)-logLik(m1))
pchisq(lrtstat, df = 1, lower.tail = FALSE)/2
#ratio of deviance to dof
deviance(m2)/ df.residual(m2)
