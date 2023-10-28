library(ggplot2)
library(patchwork)
set.seed(1234)
# Simulate fake data from a linear model
n <- 100 #number of observations
X1 <- rpois(n = n, lambda = 2) # covariate (fixed hereafter)


############################################################
#### Sampling distribution of OLS estimators of beta #######
############################################################

# The sampling distribution of the ordinary least squares estimatrs is
# beta_hat ~ N(beta, sigma^2*(X^TX)^(-1))
design_mat <- cbind(1, X1)
# These are the standard dev for betahat (sigma=1)
theo_se <- sqrt(diag(solve(crossprod(design_mat))))
sampling_dist <- 
  replicate(n = 1000, expr = {
  eps <- rnorm(n, mean = 0, sd = 1) #N(0,1) errors
  Y <- 8 + 0.2 * X1 + eps #errors indep of X1
  mod1 <- lm(Y ~ X1)
  coef(mod1)
 })
# Plot sampling distribution with "theoretical one" overlaid in red
g1 <- ggplot(data = data.frame(intercept = sampling_dist[1,])) + 
               geom_histogram(bins = 30, aes(x=intercept, y=..density..)) +
               geom_vline(xintercept = 8) + 
  stat_function(fun = "dnorm", 
                args = list(mean = 8, sd = theo_se[1]), 
                col = "red")
g2 <- ggplot(data = data.frame(slope = sampling_dist[2,])) +
               geom_histogram(bins = 30, aes(x=slope, y=..density..)) +
               geom_vline(xintercept = 0.2) + 
  stat_function(fun = "dnorm", 
                args = list(mean = 0.2, sd = theo_se[2]), 
                col = "red")

g1 + g2

############################################################
####  Profile log-likelihood of the slope parameter #######
############################################################

# Plot profile log-likelihood for a particular dataset
eps <- rnorm(n, mean = 0, sd = 1)
Y <- 8 + 0.2 * X1 + eps
mod1 <- lm(Y ~ X1)

# Maximum likelihood estimates (MLE) = Ordinary least square (OLS)
beta1hat <- coef(mod1)[2]
# Compute the value of the maximum (profile) log-likelihood
# which is value at MLE
mll <- as.numeric(logLik(mod1))

# Profile log-likelihood value
pll <- function(beta){
  sapply(beta, function(b){
    as.numeric(logLik(lm(Y - b*X1 ~ 1)))
  })
}

# Compute the confidence intervals (root finding algorithm)
ci_lrt_lb <- uniroot(function(x){2*(mll - pll(x)) - qchisq(0.95,1)}, 
                     interval = c(beta1hat-3, beta1hat))$root
ci_lrt_ub <- uniroot(function(x){2*(mll - pll(x)) - qchisq(0.95,1)}, 
                     interval = c(beta1hat, beta1hat+3))$root
# Compute the profile on a sensible grid of values for beta1
beta_grid <- seq(from = -2*theo_se[1] + 0.2, to = 2*theo_se[1] + 0.2, length.out = 101)
ggplot(data.frame(beta = beta_grid, 
                pll = pll(beta_grid)-mll),
       aes(x = beta, y = pll)) + 
  geom_line() + 
  geom_vline(xintercept = coef(mod1)[2], col = "red") + 
  geom_hline(yintercept = -qchisq(0.95, 1)/2) + 
  geom_vline(xintercept = ci_lrt_lb, col = "gray", lty = 2) + 
  geom_vline(xintercept = ci_lrt_ub, col = "gray", lty = 2) +
  ylab("profile log-likelihood") + 
  xlab(expression(beta[1]))

############################################################
####   Comparison of benchmarks F versus chi-square  #######
############################################################
# The F distribution F(q, n-p) is intimately linked to the chi-square
# q*chi-square ~ F(q, n-p) for n large
# 
# Examples with data from insurance model
ggplot() + 
  stat_function(fun = "df", 
                args = list(df1=3, df2=1330)) +
  stat_function(fun = function(x, df){df*dchisq(x*df, df = df)}, 
                args = list(df=3),
                col = "yellow", lty = 2) +
  xlim(0, 5)
# Other deep links between Student and Normal
# difference between cutoff values for two-sided 95% confidence intervals
qt(0.975, df = 1330)
qnorm(0.975)
# Fisher(1, n-p) is the same as Student(n-p)^2
isTRUE(all.equal(
  qf(0.95, df1 = 1, df2 = 1330),
  qt(0.975, df = 1330)^2))


     