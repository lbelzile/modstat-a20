library(hecstatmod)
library(patchwork)
library(ggplot2)
library(poorman)

# Exercise 1.2
# Coverage rate
summarise(renfe_simu,
          coverage = mean((cilb < -0.28) & (ciub > -0.28)))
# Histogram of mean price difference as a function of destination
ggplot(data = renfe_simu,
       aes(x = meandif)) +
  geom_histogram(bins = 30) +
  geom_vline(xintercept = -0.28, col = "blue") +
  xlab("mean price difference (in euros)") +
  ylab("count")
# Power of test (alternative is true!)
summarise(renfe_simu, power = mean(pval < 0.05))
# Alternative code
# with(renfe_simu, mean(pval < 0.05))
# mean(renfe_simu$pval < 0.05)

# Exercise 1.3
with(renfe,
     t.test(x = price,
            mu = 43.25,
            conf.level = 0.9,
            subset = type %in% "AVE-TGV"))

# Exercise 1.4
summary(insurance)
insurance <- insurance %>%
  mutate(obesity = factor(bmi >= 30, labels = c("normal","obese"))
)

# Exploratory data analysis
g1 <- ggplot(data = insurance) +
  geom_histogram(bins = 30, aes(x = log(charges), y = ..density..)) +
  # geom_rug(sides = "b") +
  labs(x = "charges (in log USD)",
       y = "density")

g2 <- ggplot(data = insurance, aes(y = charges, x=region)) +
  geom_boxplot() +
  labs(y = "charges (in USD)",
       x = "region")
g3 <- ggplot(data = insurance, aes(y = charges, x=smoker)) +
  geom_boxplot() +
  labs(y = "charges (in USD)",
       x = "smoker")
g4 <- ggplot(data = insurance, aes(y = charges, x=bmi, col = smoker)) +
  geom_point() +
  labs(y = "charges (in USD)",
       x = "body mass index (in kg/m2)",
       col = "smoker") +
  geom_vline(xintercept = 30) +
  theme(legend.position = "bottom")

g5 <- ggplot(data = insurance,
             aes(y = charges, x=age, col = interaction(smoker, obesity))) +
  geom_point() +
  labs(y = "charges (in USD)",
       x = "age (in years)",
       col = "smoker/obesity") +
  theme(legend.position = "bottom") +


g1 / (g2 + g3) / (g4 + g5)

# Comparison of charges for smoker versus non-smoker
t.test(charges ~ smoker,
       data = insurance,
       alternative = "less")


# One-sided confidence intervals for obese smokers versus non-obese smokers
# `sapply` is a function acting like a loop (?sapply)
# apply the function to each elemtn of the vector in turn and return a vector
sapply(c(0.9, 0.95, 0.99),
       function(level){
      with(insurance,
          t.test(charges ~ obesity,
            subset = smoker == "yes",
            alternative = "less",
            conf.level=level)$conf.int[2])})
