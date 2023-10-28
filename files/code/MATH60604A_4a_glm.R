data(intention, package = "hecstatmod")

mod <- lm(intention ~ fixation + emotion + revenue + 
             educ + marital + sex, data = intention)
# Fit a linear model using GLM machinery
mod <- glm(intention ~ fixation + emotion + revenue + 
      educ + marital + sex, data = intention, family=gaussian)
summary(mod)
#Diagnostic plots
boot::glm.diag.plots(mod)
