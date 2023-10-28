data(polaff, package = "hecstatmod")
m0 <- glm(count ~ gender + party, 
          data=polaff, family = poisson(link="log"))
pchisq(deviance(m0), df = 2, lower.tail = FALSE)
# No point in fitting the interaction model, 
# but check for yourself the p-value and the statistic
# for beta_interaction=0 are the same as deviance
m1 <- glm(count ~ gender*party, 
          data=polaff, family = poisson(link="log"))
car::Anova(m1, 3)