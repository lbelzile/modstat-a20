X <- c(5,  6,  3,  7,  1,  2, 11,  8,  7, 34,  1,  7, 10,  1,  0)
n <- length(X)
mle <- 1/mean(X)
hess <- numDeriv::hessian(function(x){sum(dgeom(x = X, prob = x, log = TRUE))}, x = mle)
  
obsinfo <- function(p, X){length(X)*(mean(X)-1)/(1-p)^2 + length(X)/p^2}
jhat <- obsinfo(p = mle, X = X)
se_mle <- sqrt(solve(jhat))

lrt <- 2*(sum(dgeom(x = X, prob = mle, log = TRUE)) - sum(dgeom(x = X, prob = 0.1, log = TRUE)))
pchisq(lrt, df = 1, lower.tail = FALSE)

wald <- (mle - 0.1)/se_mle
pchisq(wald^2, df = 1, lower.tail = FALSE)
