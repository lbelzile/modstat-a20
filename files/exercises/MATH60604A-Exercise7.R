library(survival)
# Exercise 7.1
data(breastfeeding, package = "hecstatmod")
mod1 <- survfit(Surv(duration, delta) ~ smoke, 
                type="kaplan-meier", 
                conf.type="log", data = breastfeeding)

plot(mod1, col = c(2,4), conf.int = TRUE)
# Estimated survival up to 36
mod1$surv[mod1$time == 36]
summary(mod1)
# Mean and median
quantile(mod1, 0.5)$quantile
print(mod1, print.rmean=TRUE)
# Here, restricted mean but both estimators are correct
# because largest observations in each group are 
# observed and not censored times

# Test for equality of survival function
survdiff(Surv(duration, delta) ~ smoke, data = breastfeeding)

mod2 <- coxph(Surv(duration, delta) ~ poverty + agemth + smoke + yschool, 
      data = breastfeeding, ties = "exact")
summary(mod2)

# Exercise 7.2
data(shoes, package = "hecstatmod")
# In R, you give a vector with FALSE=right-censored, TRUE=observed
mod3 <- survfit(Surv(time, status == "0") ~ 1, 
               type="kaplan-meier", 
               conf.type="log", data = shoes)
quantile(mod3)$quantile
plot(mod3)
summary(mod3)

mod4 <- coxph(Surv(time, status == "0") ~ gender + price, data = shoes)
summary(mod4)
    