# Exercise 2.5

data(windturbine, package = "hecstatmod")
lm_wind1 <- lm(output ~ velocity,
               data = windturbine)
summary(lm_wind1)
lm_wind2 <- lm(output ~ I(1/velocity),
               data = windturbine)
summary(lm_wind2)
# Graphical libraries
library(ggplot2)
library(patchwork)
g1 <- ggplot(data = windturbine, aes(x = velocity, y = output)) +
    geom_point() +
    geom_smooth(formula = 'y ~ x', method='lm', se = FALSE) +
    labs(y = "energy output",
         x = "wind velocity (in mph)")
g2 <- ggplot(data = windturbine, aes(x = 1/velocity, y = output)) +
    geom_point() +
    geom_smooth(formula = 'y ~ x', method='lm', se = FALSE) +
    labs(y = "energy output",
         x = "reciprocal of wind velocity (in mph)")
g1 + g2

g3 <- ggplot(data = data.frame(residuals = scale(resid(lm_wind1), scale = FALSE),
                               fitted = fitted(lm_wind1)),
             aes(x = fitted, y = residuals)) +
    geom_point() +
    geom_hline(yintercept = 0) +
    labs(x = "fitted values",
         y = "ordinary residuals",
         caption = "output ~ velocity")
g4 <- ggplot(data = data.frame(residuals = scale(resid(lm_wind2), scale = FALSE),
                               fitted = fitted(lm_wind2)),
             aes(x = fitted, y = residuals)) +
    geom_point() +
    geom_hline(yintercept = 0) +
    labs(x = "fitted values",
         y = "ordinary residuals",
         caption = "output ~ 1/velocity")
g3 + g4


# Quantile-quantile plots
library(qqplotr)
dfres <- lm_wind1$df.residual
g5 <- ggplot(data = data.frame(rstudent = rstudent(lm_wind1)),
             mapping = aes(sample = rstudent)) +
    stat_qq_band(distribution = "t", detrend = TRUE, dparams = list(df = dfres)) +
    stat_qq_line(distribution = "t", detrend = TRUE, dparams = list(df = dfres)) +
    stat_qq_point(distribution = "t", detrend = TRUE, dparams = list(df = dfres)) +
    labs(x = "theoretical quantiles",
         y = "sample quantiles",
         caption = "output ~ velocity")
g6 <- ggplot(data = data.frame(rstudent = rstudent(lm_wind2)),
             mapping = aes(sample = rstudent)) +
    stat_qq_band(distribution = "t", detrend = TRUE, dparams = list(df = dfres)) +
    stat_qq_line(distribution = "t", detrend = TRUE, dparams = list(df = dfres)) +
    stat_qq_point(distribution = "t", detrend = TRUE, dparams = list(df = dfres)) +
    labs(x = "theoretical quantiles",
         y = "sample quantiles",
         caption = "output ~ velocity")
g5 + g6

# Alternative using base plot
# par(mfrow = c(2, 2), bty = "l", pch = 20)
# #Plot and add line of best fit
# plot(y = windturbine$output,
#      x = windturbine$velocity,
#      ylab = "energy output",
#      xlab = "wind velocity (in mph)")
# abline(lm_wind1)
#Repeat with second dataset
#Note above how we can assign variables inside call to other functions
# plot(y = windturbine$output,
#      x = I(1/windturbine$velocity),
#      ylab = "energy output",
#      xlab = "reciprocal wind velocity (in mph)")
# abline(lm_wind2)
# plot(y = resid(lm_wind1) - mean(resid(lm_wind1)), x = fitted(lm_wind1),
#      ylab = "ordinary residuals", xlab = "fitted values",
#      main = "Residuals vs\nfitted values", sub ="output ~ velocity")
# abline(h = 0, lty = 2)
# plot(y = resid(lm_wind2) - mean(resid(lm_wind2)), x = fitted(lm_wind2),
#      ylab = "ordinary residuals", xlab = "fitted values",
#      main = "Residuals vs\nfitted values", sub ="output ~ 1/velocity")
# abline(h = 0, lty = 2)
# Q-Q plots With base R plots
# car::qqPlot(rstudent(lm_wind2),
#             distribution = "t",
#             df = lm_wind2$df.residual,
#             ylab = "externally studentized residuals")


# Exercice 2.6

# The following code shows how to create categorical variables
# url <- "https://lbelzile.bitbucket.io/MATH60619A/intention.sas7bdat"
# intention <- haven::read_sas(url)
# intention$educ <- factor(intention$educ)
# intention$revenue <- factor(intention$revenue, ordered = FALSE)
# intention$revenue <- relevel(intention$revenue, ref = 3)
data(intention, package = "hecstatmod")


linmod1 <- coef(lm(intention ~ revenue, data = intention))
linmod2 <- coef(lm(intention ~ I(revenue == 1) + I(revenue == 2), data = intention))
linmod3 <- coef(lm(intention ~ as.numeric(revenue), data = intention))
# Print coefficients
linmod1
linmod2
linmod3

linmod4 <- lm(intention ~ fixation + emotion + revenue + educ + age + marital + sex, data = intention)
summary(linmod4)
anova(linmod4)

# Exercise 2.7
data(auto, package = "hecstatmod")

linmod1 <- lm(mpg ~ horsepower, data = auto)
linmod2 <- lm(mpg ~ horsepower + I(horsepower^2), data = auto)
linmod3 <- lm(mpg ~ horsepower + I(horsepower^2) + I(horsepower^3), data = auto)
hps <- seq(from = 40, to = 250, length.out = 100L)
p1 <- data.frame(x = hps,
                 predict(object = linmod1,
                 newdata = data.frame(horsepower=hps),
                 interval = "prediction"))
p2 <- data.frame(x = hps,
                 predict(object = linmod2,
                 newdata = data.frame(horsepower=hps),
                 interval = "prediction"))
p3 <- data.frame(x = hps,
                 predict(object = linmod3,
                 newdata = data.frame(horsepower=hps),
                 interval = "prediction"))


g7 <- ggplot() +
    geom_point(data = auto,
               aes(x=horsepower, y = mpg),
               alpha = 0.5) +
    geom_line(data = p1, aes(x = x, y = fit), col = "gray") +
    geom_ribbon(data = p1,
                aes(x = x, ymin = lwr, ymax = upr),
                col = 1, alpha = 0.1) +
    labs(x = "horsepower",
         y = "fuel consumption \n(in miles per gallon)",
         caption = "linear")
g8 <- ggplot(linmod1) +
    geom_hline(yintercept = 0, col = "gray") +
    geom_point(aes(x=.fitted, y=.resid)) +
    labs(x = "fitted values", y = "ordinary residuals")
g9 <- ggplot() +
    geom_point(data = auto,
               aes(x = horsepower, y = mpg),
               alpha = 0.5) +
    geom_line(data = p2, aes(x = x, y = fit), col = "gray") +
    geom_ribbon(data = p2,
                aes(x = x, ymin = lwr, ymax = upr),
                col = 1, alpha = 0.1) +
    labs(x = "horsepower",
         y = "fuel consumption \n(in miles per gallon)",
         caption = "quadratic")
g10 <- ggplot(linmod2) +
    geom_hline(yintercept = 0, col = "gray") +
    geom_point(aes(x=.fitted, y=.resid)) +
    labs(x = "fitted values", y = "ordinary residuals")
g11 <- ggplot() +
    geom_point(data = auto,
               aes(x=horsepower, y = mpg),
               alpha = 0.5) +
    geom_line(data = p3, aes(x = x, y = fit), col = "gray") +
    geom_ribbon(data = p3,
                aes(x = x, ymin = lwr, ymax = upr),
                col = 1, alpha = 0.1) +
    labs(x = "horsepower",
         y = "fuel consumption \n(in miles per gallon)",
         caption = "cubic")
g12 <- ggplot(linmod3) +
    geom_hline(yintercept = 0, col = "gray") +
    geom_point(aes(x=.fitted, y=.resid)) +
    labs(x = "fitted values", y = "ordinary residuals")
(g7 + g8) / (g9 + g10) / (g11 + g12)

# test if the cubic term is significant
summary(linmod3)
# the quadratic model is the most adequate
ggplot(data = data.frame(rstudent = rstudent(linmod2)),
       mapping = aes(sample = rstudent)) +
    stat_qq_band(distribution = "norm", detrend = TRUE) +
    stat_qq_line(distribution = "norm", detrend = TRUE) +
    stat_qq_point(distribution = "norm", detrend = TRUE,) +
    labs(x = "theoretical quantiles (detrended)",
         y = "sample quantiles",
         caption = "quadratic")
# But model with hp + hp^2 doesn't capture all features


# Exercise 2.8
data(intention, package = "hecstatmod")
lm_intent1 <- lm(intention ~ fixation + educ, data = intention)
lm_intent2 <- lm(intention ~ fixation * educ, data = intention)

#pdf("Exercise_2p8.pdf", width = 8, height = 4)
g1 <- ggplot(data = intention,
             aes(x = fixation, y = intention, col = educ)) +
    geom_line(data = lm_intent1, aes(y = .fitted), lwd = 1) +
    geom_point() + xlab("fixation time (in seconds)")
g2 <- ggplot(data = intention,
       aes(x = fixation, y = intention, col = educ)) +
    geom_line(data = lm_intent2, aes(y = .fitted), lwd = 1) +
    geom_point() + xlab("fixation time (in seconds)")
(g1 + g2) + plot_layout(guides='collect') &
    theme(legend.position='bottom')

#dev.off()


