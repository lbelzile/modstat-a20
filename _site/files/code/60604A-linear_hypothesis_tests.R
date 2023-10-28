data(insurance, package = "hecstatmod")
library(poorman)
insurance <- insurance %>% mutate(obese = bmi >= 30,
                     smobese = factor(1 + I(smoker=="yes") + I(smoker == "yes")*(bmi >= 30)))

mod1 <- lm(charges ~ smoker*obese*age, data = insurance)
mod2 <- lm(charges ~ smobese*age, data = insurance) #merge two non-smokers
# Comparing the two nested models
anova(mod1, mod2)
# Also use contrast matrix: here we set 
# beta obeseTRUE=0 and simultaneously beta obeseTRUE:age = 0
hy_mat <- rbind(c(0,0,1,0,0,0,0,0), c(0,0,0,0,0,0,1,0))
car::linearHypothesis(model = mod1, 
                      hypothesis.matrix = hy_mat,
                      test = "F")
