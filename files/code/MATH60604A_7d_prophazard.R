library(survival)
data(melanoma, package = "hecstatmod")
summary(melanoma)
str(melanoma)

with(melanoma, table(status, ulcer))
# Cox proportional hazard model
mod1 <- coxph(Surv(time, status) ~ sex + age + thickness +
               ulcer, data = melanoma, ties="exact")
summary(mod1)
# Wald-based confidence intervals for coefficients
confint(mod1)

# Test the proportional hazard hypothesis
# Add interaction term with log(time) and test for global significance 
cox.zph(mod1)
par(mfrow = c(2,2), mar = c(4,4,1,1))
# Spline local estimate of the time trend
plot(cox.zph(mod1))
# Some indications that the proportional hazard doesn't hold 
# (very large thickness associated with lower survival time...)
dev.off()