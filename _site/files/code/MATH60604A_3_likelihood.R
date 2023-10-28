n <- 10
phat <- 0.8
nsuccess <- 8

# Compute MLE numerically (should map up to rounding)
optimize(f = function(x){-dbinom(x = nsuccess, size = 10, prob = x, log = TRUE)}, interval = c(0,1))

# Compute the observed information by finite difference
obsinfo <- -numDeriv::hessian(function(x){dbinom(x = nsuccess, size = n, prob = x, log = TRUE)}, x = 0.8)
sqrt(solve(obsinfo))
# Check with inverse of observed information evaluated at MLE
se_phat <- sqrt(phat*(1-phat)/n)

#Confidence intervals

#Wald
c(phat - qnorm(0.975)*se_phat, phat + qnorm(0.975)*se_phat)
#Likelihood ratio test
lrt <- function(p){2*(dbinom(x = nsuccess, size = n, prob = phat, log = TRUE) - dbinom(x = 8, size = n, prob = p, log = TRUE)) - qchisq(0.95, 1)}
c(uniroot(lrt, interval = c(0.4,phat))$root, uniroot(lrt, interval = c(phat,1))$root)
# Score test
score <- function(p){
  (phat-p)^2/(p*(1-p)/n) - qchisq(0.95, 1)
}
c(uniroot(score, interval = c(0,phat))$root, uniroot(score, interval = c(phat,1))$root)
