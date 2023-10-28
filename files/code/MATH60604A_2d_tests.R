library(hecstatmod)

# Fit linear model with lm function
# Get coefficient table with "summary"
# Get F-table of SS3 with "Anova" from "car" package
# WARNING: "anova" returns the SS1 parametrization
# Details https://mcfromnz.wordpress.com/2011/03/02/anova-type-iiiiii-ss-explained/
ols <- lm(intention ~ fixation, data = intention)
summary(ols) # parameter estimates table
confint(ols) # confidence intervals for coefficients
car::Anova(ols, type = 3) # type 3 sum of square

intention$sex <- relevel(intention$sex, ref = "woman")
ols_full <- lm(intention ~ fixation + emotion + sex + educ + marital + revenue, data = intention)
summary(ols_full) # parameter estimates table
car::Anova(ols_full, type = 3) # type 3 sum of square


# Output for the two-sample t-test
summary(lm(offer ~ group, data = tickets))
#p-value coincides with that of t-test
t.test(offer ~ group, data = tickets, var.equal = TRUE)

