data(bixicoll, package = "hecstatmod")

mod1 <- lm(lognuser ~ celcius, data = bixicoll)
mod2 <- lm(lognuser ~ farenheit, data = bixicoll)
isTRUE(all.equal(resid(mod1), resid(mod2)))
mod3 <- lm(lognuser ~ celcius + farenheit, data = bixicoll)
summary(mod3)
# One of the parameters is not estimated
mod4 <- lm(lognuser ~ celcius + rfarenheit, data = bixicoll)
summary(mod4)
# Estimates, but none of the two temperature coef are significant
# given the other is already in the model
car::vif(mod4)
car::avPlots(mod4)

data(simcollinear, package = "hecstatmod")
cor(simcollinear)
mod5 <- lm(Y ~ ., data = simcollinear)
# Variance inflation factor
car::vif(mod5)
