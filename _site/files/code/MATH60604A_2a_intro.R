library(hecstatmod)
library(ggplot2)
library(patchwork)
# Summary statistics and frequency table for factors
str(intention)
summary(intention)

g1 <- ggplot(data = intention, aes(x=intention)) + 
  geom_bar()
g2 <- ggplot(data = intention, aes(x=age)) + 
  geom_histogram(bins = 10)
g3 <- ggplot(data = intention, aes(x=emotion)) + 
  geom_histogram(bins = 10)
g4 <- ggplot(data = intention, aes(x=fixation)) + 
  geom_histogram(bins = 10)
(g1 + g2) / (g3 + g4)


g5 <- ggplot(data = intention, 
             aes(x=fixation, y = intention)) + 
  geom_point() +
  geom_smooth(method = "lm", formula = "y ~ x", se = FALSE) + 
  xlab("fixation time (in seconds)") + 
  ylab("intention to buy")
g6 <- ggplot(data = intention, 
             aes(x=emotion, y = intention)) + 
  geom_point() +
  geom_smooth(method = "lm", formula = "y ~ x", se = FALSE) + 
  xlab("emotion score") + 
  ylab("intention to buy")
g5 + g6

lm(intention ~ fixation, data = intention)
lm(intention ~ sex, data = intention)

# Fit categorical variable with dummies
# baseline reference is first alphanumerical values
# use 'relevel' to change
educ2 <- as.integer(intention$educ == 2)
educ3 <- as.integer(intention$educ == 3)

lm(intention ~ educ, data = intention)
lm(intention ~ educ2 + educ3, data = intention)

lm(intention ~ sex + age + revenue + educ + marital + fixation + emotion, data = intention)
