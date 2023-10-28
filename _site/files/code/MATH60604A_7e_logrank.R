library(survival)
library(coin)
data(breastcancer, package = "hecstatmod")
# chi-square test log-rank test

#p-value based on asymptotic null distribution (chi-square (1)
survdiff(Surv(time, death) ~ im, data = breastcancer)

# Obtain alternative approximation via simulation (permutation test)
coin::logrank_test(Surv(time, death) ~ factor(im), 
                   data = breastcancer, 
                   distribution = coin::approximate(nresample=1e5))

# The log rank test if the two survival curves are equal
# Basic idea: under H0, the labels for group are not relevant
# We can use a permutation and compare the resulting curves

# Plot of the survival function with multiple curves
plot(survfit(Surv(time, death) ~ factor(im), 
             data = breastcancer), 
     conf.int = FALSE,
     col = c(2,4), # red, blue
     xlab = "time (in days)",
     ylab = "survival function",
     bty = "l")

# Cox proportional hazard
cox1 <- coxph(Surv(time, death) ~ im, data = breastcancer)
summary(cox1)
## The log rank test coincides with the global significance
# test statistic of the Cox model
