library(survival)
library(survminer) # graphics

data(breastcancer, package = "hecstatmod")
summary(breastcancer)
with(breastcancer, table(death, im))

# Kaplan-Meier estimator
# The response is packed in "Surv" with 
# survival time and right-censoring indicator
kapm1 <- survfit(Surv(time, death) ~ 1, 
                type="kaplan-meier", 
                conf.type="log", data = breastcancer)

summary(kapm1)
print(kapm1, print.rmean=TRUE)
plot(kapm1, ylab = "survival function", xlab = "time (in days)") 
ggsurvplot(fit = kapm1,
           conf.int = TRUE, 
           data = breastcancer,
           legend = "none", 
           xlab = "time (in days)")
quantile(kapm1)

data(breastfeeding, package = "hecstatmod")
kapm2 <- survfit(Surv(duration, delta) ~ 1, 
                type="kaplan-meier", 
                conf.type="log", data = breastfeeding)

plot(kapm2, ylab = "survival function", xlab = "time (in weeks)") 
quantile(kapm2)
print(kapm2, print.rmean=TRUE)