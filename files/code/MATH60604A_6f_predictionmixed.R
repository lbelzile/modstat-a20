library(lme4)
data(motivation, package = "hecstatmod")

mixed1 <- lme4::lmer(motiv ~ ( 1 | idunit ) + sex + agemanager + yrserv + nunit, data = motivation)

# Predictions and fitted values
newmotiv <- data.frame(nunit = rep(9, 2), 
                       idunit = factor(c(1,101)), 
                       yrserv = rep(5,2), 
                       sex = rep(0,2),
                       idemployee = c(10,1),
                       agemanager = rep(40,2),
                       motiv = rep(NA, 2))

# Prediction of the population mean, ignoring the random effect
predict(mixed1, newdata = newmotiv, re.form = NA)
# Prediction conditional on the random effect 
# (only available for variables for which the group has been observed)
predict(mixed1, newdata = newmotiv[1,])
