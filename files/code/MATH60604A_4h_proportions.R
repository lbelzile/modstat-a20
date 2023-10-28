# Logistic regression for binomial data
# driving license pass rate in Great-Britain  
data(gbdriving, package = "hecstatmod")
gbdriving$size <- factor(cut(gbdriving$total, c(0, 500, 1000, Inf)), 
                         labels = c("small","medium","large"))
gbdriving$region <- relevel(factor(gbdriving$region), "London")

with(gbdriving, table(region, size))
# Argument is success, failure  
mod_gbdriving <- glm(cbind(pass, total-pass) ~ sex + region + size,
          data=gbdriving, family=binomial(link="logit"))
summary(mod_gbdriving)
exp(cbind(coef(mod_gbdriving), confint(mod_gbdriving)))
# Prediction from the logistic model 
predlogistic <- fitted(mod_gbdriving) * gbdriving$total
# For new datasets, use
# predict(mod_gbdriving, newdata = gbdriving, type = "response")
# This outputs the probabilities of success; 
# to get counts, multiply by the totals


data(crash, package = "hecstatmod")
mod_crash <- glm(cbind(ndeath, popn-ndeath) ~ time + year, family=binomial, data=crash)
summary(mod_crash)
expit <- function(x){ 1/(1+exp(-x))}
# Estimated base rate per 100 000 inhabitants
# is probability of death ("success") times 10^5
expit(coef(mod_crash)[1])*1e5
