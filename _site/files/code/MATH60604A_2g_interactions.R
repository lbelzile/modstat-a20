library(ggplot2)
library(patchwork)

data(interaction, package = "hecstatmod")
interaction$gender = factor(interaction$sex, labels = c("male","female"))
mod1 <- lm(intention ~ gender + fixation, data = interaction)
# In R, a*b = a + b + a:b
mod2 <- lm(intention ~ gender*fixation, data = interaction)
# F-test to compare two nested models
anova(mod1, mod2)

# Scatterplot, with fitted interaction model
g2 <- ggplot(data = interaction, 
       aes(x = fixation, y = intention, col = gender)) + 
  geom_point() + 
  geom_smooth(method = "lm", 
              se = FALSE, 
              formula = "y ~ x",
              show.legend = FALSE,
              fullrange = TRUE) 

# Model without interaction
g1 <- ggplot(data = interaction, 
       aes(x = fixation, y = intention)) + 
  geom_point(aes(col = gender)) + 
  geom_smooth(method = "lm", 
              se = FALSE, 
              formula = "y ~ x", 
              col = "black", 
              fullrange = TRUE)

(g1 + g2) + plot_layout(guides = 'collect') & theme(legend.position = "bottom")

# Graphic of ordinary residuals, colored according to gender
# Global average of zero, but clear positive/negative trend for each gender
ggplot(data.frame(x = interaction$fixation, y = resid(mod1), gender = interaction$gender),
     aes(x = x, y = y, col = gender)) + 
  geom_point() + 
  xlab("fixation time (in seconds)") + 
  ylab("ordinary residuals") + 
  theme(legend.position = "bottom")

