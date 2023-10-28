library(nlme)
data(college, package = "hecstatmod")
# Vanilla linear model
model1 <- gls(salary/1000 ~ sex + rank + field, data = college)
#Model with different variance per rank
model2 <- gls(salary/1000 ~ sex + rank + field,
              weights = varIdent(form=~1 | rank),
              data = college)
summary(model2)
anova(model1, model2)
# Plot of standardized residuals against fitted values
plot(model2)


# Two-way ANOVA   
data(delay, package = "hecstatmod")
delay$inter <- delay$stage:delay$delay

model3 <- gls(time ~ stage * delay, data = delay)
model4 <- gls(time ~ stage * delay, data = delay,
              weights = varIdent(form=~1 | inter))
#LRT: there is evidence of unequal variance
anova(model3, model4)
#Interaction is not significant
car::Anova(model4, type=3)
