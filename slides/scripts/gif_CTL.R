setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
setwd("../img/CLT")

library(gganimate)
#> Loading required package: 
library(ggplot2)
library(viridisLite)
set.seed(1234)
pmix <- 0.6


sampmixt <- function(n){
  ifelse(rbinom(n = n, size = 1, pmix), 
         TruncatedNormal::rtnorm(n = n, mu = 2, sd = 3, lb = 0, ub = Inf),
         TruncatedNormal::rtnorm(n = n, mu = 20, sd = 5, lb = 2, ub = 40))
}


densmixt <- function(x){pmix*TruncatedNormal::dtmvnorm(matrix(x),
                          mu =  2, sigma = matrix(9), lb = 0, ub = Inf) +
  (1-pmix)*TruncatedNormal::dtmvnorm(x = matrix(x),
                                 mu =  20, sigma = matrix(25), lb = 2, ub = 40)     
}

tnormmean <- function(mu, sigma, a, b){
  alpha <- (a-mu)/sigma
  beta <- (b-mu)/sigma
  mu + (dnorm(alpha)-dnorm(beta))/(pnorm(beta) - pnorm(alpha))*sigma
}

tnormvar <- function(mu, sigma, a, b){
  stopifnot(a<b)
  alpha <- (a-mu)/sigma
  beta <- (b-mu)/sigma
  if(is.finite(b) && is.finite(a)){
  Va <- sigma^2*(1+(alpha*dnorm(alpha) - beta*dnorm(beta))/(pnorm(beta)-pnorm(alpha)) -
             ((dnorm(alpha) - dnorm(beta))/(pnorm(beta)-pnorm(alpha)))^2)
  } else if(is.infinite(b) && is.finite(a)){
    Va <- sigma^2*(1+(alpha*dnorm(alpha))/pnorm(alpha, lower.tail = FALSE) -
                     (dnorm(alpha)/pnorm(alpha, lower.tail = FALSE))^2)
  } else if(is.finite(b) && is.infinite(a)){
    Va <- sigma^2*(1 - beta*dnorm(beta)/pnorm(beta) -
                     (dnorm(beta)/pnorm(beta))^2)
  } else{ Va <- sigma^2}
  Va
}

varmixt <- function(w, mui, sigmai, mu){
  mu <- sum(w*mui)
  sum(w*(sigmai^2+mui^2 - mu^2))
}

mu1 <- tnormmean(2, 3, 0, Inf)
mu2 <- tnormmean(20, 5, 2, 40)
sigma1 <- sqrt(tnormvar(2, 3, 0, Inf))
sigma2 <- sqrt(tnormvar(20, 5, 2, 40))

mug <- sum(c(pmix, 1-pmix)*c(mu1, mu2))
sigmag <- sqrt(varmixt(w = c(pmix, 1-pmix), c(mu1, mu2), c(sigma1, sigma2)))

ggplot() +
  geom_function(fun = "densmixt", xlim = c(0, 45), n = 1001) + 
  geom_vline(xintercept = mug, col = "red") +
  theme_minimal() +
  ylab("densité") + xlab("x")
ggsave(filename = "densite.png", width = 8, height = 5)

nsamp <- 20
n <- 10
B <- n*nsamp
dat <- data.frame(x = sampmixt(B), n = factor(rep(1:nsamp, each = n)))
datmean <- data.frame(mean = colMeans(matrix(dat$x, nrow = n)), 
                      n = factor(1:nsamp))

# We'll start with a static plot
p <- ggplot(dat, aes(x = x)) +
  geom_dotplot(binwidth = 1, method = "histodot") +
  geom_vline(data = datmean, aes(xintercept = mean), col = "red", size = 1) + 
  theme_minimal() + 
  theme(legend.position = "none", 
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank()) + 
  scale_y_continuous(name = "", breaks = NULL) +
  xlab("")   +
  transition_states(n, wrap = FALSE,
                    transition_length = 1,
                    state_length = 9) + 
  ease_aes('cubic-in-out') + 
  enter_fade() +
  ggtitle('Échantillon {closest_state}', subtitle = "n = 10")
anim_save(p, filename = "clt_mean_10.gif")



n <- 100
B <- n*nsamp
dat <- data.frame(x = sampmixt(B),
                  n = factor(rep(1:nsamp, each = n))
)

datmean <- data.frame(mean = colMeans(matrix(dat$x, nrow = n)), n = factor(1:nsamp))

# We'll start with a static plot
p <- ggplot(dat, aes(x = x)) +
  geom_dotplot(binwidth = 0.5, method = "histodot") +
  geom_vline(data = datmean, aes(xintercept = mean), col = "red", size = 1) + 
  theme_minimal() + 
  theme(legend.position = "none", 
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank()) + 
  scale_y_continuous(name = "", breaks = NULL) +
  xlab("")   +
  transition_states(n, wrap = FALSE,
                    transition_length = 1,
                    state_length = 9) + 
  ease_aes('cubic-in-out') + 
  enter_fade() +
  ggtitle('Échantillon {closest_state}', subtitle = "n=100")
anim_save(p, filename = "clt_mean_100.gif")




n <- 1000
B <- n*nsamp
dat <- data.frame(x = sampmixt(B),
                  n = factor(rep(1:nsamp, each = n))
)

datmean <- data.frame(mean = colMeans(matrix(dat$x, nrow = n)), n = factor(1:nsamp))

# We'll start with a static plot
p <- ggplot(dat, aes(x = x)) +
  geom_dotplot(binwidth = 0.5, method = "histodot") +
  geom_vline(data = datmean, aes(xintercept = mean), col = "red", size = 1) + 
  theme_minimal() + 
  theme(legend.position = "none", 
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank()) + 
  scale_y_continuous(name = "", breaks = NULL) +
  xlab("")   +
  transition_states(n, wrap = FALSE,
                    transition_length = 1,
                    state_length = 9) + 
  ease_aes('cubic-in-out') + 
  enter_fade() +
  ggtitle('Échantillon {closest_state}', subtitle = "n=1000")
anim_save(p, filename = "clt_mean_1000.gif")


# Mean of different samples

ggplot(data = data.frame(x = replicate(n = 10000, mean(sampmixt(10))))) +
  geom_histogram(aes(x, y = ..density..), binwidth = 4/10, alpha = 0.4) +
  geom_function(fun = "dnorm", args = list(mean = mug, sd = sigmag/sqrt(10)), 
                n = 1001, col = viridis(n = 3)[1]) + 
  theme_minimal() +
  ylab("densité") + xlab("x")
ggsave(filename = "densmean10.png", width = 8, height = 5)
ggplot(data = data.frame(x = replicate(n = 10000, mean(sampmixt(100))))) +
  geom_histogram(aes(x, y = ..density..), binwidth = 6/50, alpha = 0.4) +
  geom_function(fun = "dnorm", args = list(mean = mug, sd = sigmag/10), 
                 n = 1001, col = viridis(n = 3)[2]) + 
  theme_minimal() +
  ylab("densité") + xlab("x")
ggsave(filename = "densmean100.png", width = 8, height = 5)
ggplot(data = data.frame(x = replicate(n = 10000, mean(sampmixt(1000))))) +
  geom_histogram(aes(x, y = ..density..), binwidth = 1/50, alpha = 0.4) +
  geom_function(fun = "dnorm", args = list(mean = mug, sd = sigmag/sqrt(1000)), 
                n = 1001, col = viridis(n = 3)[3]) + 
  theme_minimal() +
  ylab("densité") + xlab("x")
ggsave(filename = "densmean1000.png", width = 8, height = 5)
x0 <- seq(0, 26, length.out = 1001)
ggplot(dat = data.frame(x = rep(x0, 3),
                        n = factor(rep(c(10,100,1000), each = 1001)),
                        y = c(dnorm(x0, mean = mug, sd =  sigmag/sqrt(10)),
                        dnorm(x0, mean = mug, sd =  sigmag/sqrt(100)),
                        dnorm(x0, mean = mug, sd =  sigmag/sqrt(1000)))),
                        aes(x = x, y = y, col = n)) +
  geom_line() + 
  theme_minimal() +
  theme(legend.position = "bottom") + 
  scale_colour_viridis_d() + 
  xlim(c(0,22)) + 
  ylim(c(0,1.5)) +
  ylab("densité") + xlab("x") 
ggsave(filename = "densmeansupp.png", width = 8, height = 5)
