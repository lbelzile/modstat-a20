library(lme4)
library(hecstatmod)


## Example 1: 
data(chicken, package = "hecstatmod")
# Fit a model with diet as fixed effect
# Correlated random effects
mod1 <- lme4::lmer(weight ~ time + diet + (1 + time | chick),
           data = chicken)
# Diagonal covariance matrix for random effects (variance components)
mod2 <- lme4::lmer(weight ~  time + diet + 
                     (1 | chick) +
                     (time - 1 | chick),
           data = chicken)
# Test if the correlation between random intercept/slope is null
# H0: omega_{12}=0 versus H1: omega_{12} NEQ 0
anova(mod1, mod2)


# Fit alternative with a random effect for diet 
# chick is nested within diet
# With categorical variables, you must remove the fixed
# effect in order to estimate the random effect
mod3 <- lme4::lmer(weight ~ time +
                     (1 + time | diet:chick) + 
                     (1 | diet),
                   data = chicken)

res3 <- rescov(mod3)
# Print the covariance matrix of the nested models
plot(res3, corr = FALSE)
# Plot the correlation matrix
plot(res3, corr = TRUE)
# Plot sub-matrix for a given chicken
p38 <- chicken$chick == 38
image(cov2cor(res3$var_y[p38,p38]))

### Example 2 with motivation data
# Why shouldn't we put a random effect for sex?
data(motivation, package = "hecstatmod")
mod1 <- lme4::lmer(motiv ~ yrserv + agemanager + nunit + (1 | sex) + (1 | idunit),
                   data = motivation)

# Plot the correlation matrix of the nested models
image(cov2cor(rescov(mod1, motivation)), sub = "", xlab = "", ylab = "")
# The resulting covariance matrix is dense... such models do not scale in high dimension
