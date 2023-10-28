library(ggplot2) #graphics library
library(patchwork) #combine graphs
library(dplyr) #manipulate database
library(viridis) #color-blind palette

theme_set(theme_minimal())
options(ggplot2.continuous.colour="viridis")
options(ggplot2.continuous.fill = "viridis")
scale_colour_discrete <- scale_colour_viridis_d
scale_fill_discrete <- scale_fill_viridis_d

library(qqplotr, warn.conflicts = FALSE)


data(insurance, package = "hecstatmod")
insurance <- insurance %>%
  mutate(obese = factor(bmi >= 30, 
                         labels = c("non-obese","obese")),
          smobese = case_when(
            obese=="obese" & smoker=="yes" ~ "smoker/obese",
            obese=="obese" & smoker=="no" ~ "non-smoker/obese",
            obese=="non-obese" ~ "non-obese"),
          smobese = factor(smobese, 
                            levels = c("smoker/obese","non-smoker/obese","non-obese")),
         )

mod <- lm(charges ~ smoker*obese*bmi + age + sex + region,
          data = insurance)
insurance_lm <- insurance %>% 
  mutate(resid = resid(mod),
         ajustee = fitted(mod),
         rstud = rstudent(mod))
g1 <- ggplot(data = insurance_lm, 
             aes(x = ajustee, y = resid)) + 
  geom_point(aes(col = smobese)) +
  geom_smooth() +
  theme(legend.position = "bottom") + 
  ylab("ordinary residuals") + 
  xlab("fitted values")
  
g2 <- ggplot(data = insurance_lm, 
             aes(x = bmi, y = resid)) + 
  geom_point(aes(col = smoker)) +
  geom_smooth() +
  theme(legend.position = "bottom") + 
  ylab("ordinary residuals") + 
  xlab("body mass index")

g3 <- ggplot(data = insurance_lm, 
             aes(x = factor(children), y = resid)) + 
  see::geom_violindot() + 
  xlab("number of children") + 
  ylab("ordinary residuals")
# seemingly increases with the number of children...

g4 <- ggplot(data = insurance_lm, 
             aes(x = ajustee, y = abs(rstud))) +
  geom_point() + 
  ylab("|externally studentized residuals|") + 
  xlab("fitted values")

(g1 + g2) / (g3 + g4)

g5 <- ggplot(data = insurance_lm, 
             aes(x = smobese, y = rstud)) +
  see::geom_violindot() + 
  ylab("externally studentized residuals") + 
  xlab("indicator smoker / obese")

di <- "t"
dp <- list(df = mod$df.residual)
g6 <- ggplot(data = insurance_lm, mapping = aes(sample = rstud)) +
  # stat_qq_band(distribution = di, dparams = dp, detrend = TRUE, bandType = "boot", B = 9999) +
  stat_qq_line(distribution = di, dparams = dp, detrend = TRUE) +
  stat_qq_point(distribution = di, dparams = dp, detrend = TRUE) +
  labs(x = "quantiles théoriques", 
       y = "quantiles empiriques")
# Here, since df>1000, we could use the normal approximation
# The confidence band (omitted) is weird because it is based on the sample average
# whereas the line of best fit passes through quartiles, which are robust estimators of
# location. Computing the sample mean/variance is a much WORSE approximation


car::qqPlot(rstudent(mod), 
            ylab = "externally studentized residuals",
              distribution = "t", df = mod$df.residual)

g7 <- ggplot(data = insurance_lm, mapping = aes(x = rstud)) +
  geom_density() + 
  geom_histogram(aes(y = ..density..), 
                 bins = 30, 
                 alpha = 0.5)


# Correlogram
library(forecast)
data(airpassengers, package = 'hecstatmod')
mod_ts <- lm(data = airpassengers,
   log(passengers) ~ month + year)
resid(mod_ts) %>% 
  Acf(plot = FALSE) %>% 
  autoplot + 
  labs(title = "ordinary residuals", 
         x = "lag", 
         y = "autocorrelation")

