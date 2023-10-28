library(ggplot2)

data(intention, package = "hecstatmod")

pred_intent <- intention[rep(1L,7),]
pred_intent$fixation <- 0:6

mod1 <- lm(intention ~ fixation + emotion + sex + age + revenue + educ,
           data = intention)
pred1 <- predict(mod1, newdata = pred_intent, interval = "confidence")
pred2 <- predict(mod1, newdata = pred_intent, interval = "prediction")

# Transform matrix to data.frame for ggplot purposes
pred1 <- data.frame(pred1)
pred2 <- data.frame(pred2)
pred1$x <- pred2$x <- pred_intent$fixation

ggplot(data = pred1, aes(x = x, y = fit)) +
  geom_line() +
  geom_ribbon(data = pred1, 
              mapping = aes(x = x, 
                            ymin = lwr,
                            ymax = upr),
              col = 1, alpha = 0.2) + 
  geom_ribbon(data = pred2, 
              mapping = aes(x = x, 
                            ymin = lwr,
                            ymax = upr),
              col = 1, alpha = 0.1) +
  xlab("fixation time (in seconds)") + 
  ylab("intention to buy")

# More realistic example with the "college" data
data(college, package = "hecstatmod")
mod_college <- lm(salary ~ field + rank + service + sex, 
              data = college)
new_college <- data.frame(years = 5, 
                          field = factor("applied"),
                          rank = factor("full"),
                          service = 3,
                          sex = "man")
predict(mod_college, 
        newdata = new_college, 
        interval = "prediction")

