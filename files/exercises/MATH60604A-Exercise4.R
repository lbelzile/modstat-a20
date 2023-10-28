library(ggplot2)
library(patchwork)

###############################
#######  Exercise 4.1  ########
###############################

data(profsalary, package = "hecstatmod")
profsalary$salbi <- profsalary$salary > 105000
mod1p1 <- glm(salbi ~ degree + sex + yr + yd, 
            data = profsalary, 
            family=binomial(link="logit"))
summary(mod1p1)
mod1p2 <- glm(salbi ~ degree + sex + yr + yd + factor(rank), 
            data = profsalary, 
            family=binomial(link="logit"))

library(ggplot2)
ggplot(data.frame(pred = fitted(mod1p2), 
                  rank = profsalary$rank),
       aes(x = rank, y = pred)) +
  geom_boxplot() + 
  labs(x = "academic rank", 
       y = "fitted probability")


###############################
#######  Exercise 4.2  ########
###############################

data(awards, package = "hecstatmod")
mod2p1 <- glm(nawards ~ prog + math, data = awards, family=poisson(link="log"))
mod2p2 <- MASS::glm.nb(nawards ~ prog + math, data = awards, link='log')
#Testing for overdispersion - don't use deviance, as these are not comparable
pchisq(2*as.numeric(logLik(mod2p2) - logLik(mod2p1)), 
       df = 1, lower.tail = FALSE)/2
# Reject null that k=0
khat <- 1/mod2p2$theta
#Checking adequacy - LRT comparing with saturated model
deviance(mod2p1) / mod2p1$df.residual
#df residuals not taking into account the k parameter
pchisq(deviance(mod2p1), df = mod2p1$df.residual, lower.tail = FALSE)
summary(mod2p1)
# Pearson chi-square statistic for Poisson model
PearsonX2 <- sum(residuals(mod2p1, type = "pearson")^2)
# sum((awards$nawards - fitted(mod2p1))^2/fitted(mod2p1))

###############################
#######  Exercise 4.3  ########
###############################
data(ceb, package = "hecstatmod")
# par(mfrow= c(1,2),mar = c(4,4,1,1), bty = "l", pch = 20)
# with(ceb, plot(log(nwom), log(nceb), 
#                xlab = "number of women per group (log)",
#                ylab = "number of children ever born (log)"))
# with(ceb, plot(nceb/nwom, var, 
#                xlab = "mean number of children ever born",
#                ylab = "variance of number of children"))


g1 <- ggplot(data = ceb, 
             aes(x = log(nwom), y =log(nceb))) +
  geom_point() +
  labs(x="number of women per group (log)",
       y ="number of children ever born (log)")
g2 <- ggplot(data = ceb, 
             aes(x = nceb/nwom, y =var)) +
  geom_point() +
  labs(x = "mean number of children ever born",
       y = "variance of number of children")
g1 + g2

mod3p1 <- glm(nceb ~ dur + res + educ + offset(log(nwom)), data = ceb, family = poisson)

mod3p2 <- glm(nceb ~ dur + res + educ + log(nwom), data = ceb, family = poisson)

# Coefficients
summary(mod3p1)
# Profile likelihood confidence intervals for betas
confint(mod3p1)
# Type 3 LRT for covariates
car::Anova(mod3p1, type = 3)
# Diagnostic plots for residuals
boot::glm.diag.plots(mod3p1)
# LRT test for deviance - versus saturated model
pchisq(deviance(mod3p1), df = mod3p1$df.residual, lower.tail = FALSE)
mod3p3 <- glm(nceb ~ dur * educ + res  + offset(log(nwom)), data = ceb, family = poisson)
anova(mod3p1, mod3p3, test = "LRT")

###############################
#######  Exercise 4.4  ########
###############################
data(bixi, package = "hecstatmod")

mod4p1 <- glm(nusers ~ weekend, data = bixi, family = poisson(link="log")) 
mod4p2 <- glm(nusers ~ weekend + temp + relhumid, data = bixi, family = poisson(link="log")) 
anova(mod4p1, mod4p2)

mod4p3 <- MASS::glm.nb(nusers ~ weekend + temp + relhumid, data = bixi)
# Overdispersion
# Likelihood ratio test: compare neg. binom (Ha) versus Poisson (H0)
# Null distribution is 0.5 chi-square(1). This means we proceed as usual, but halve the p-value
pchisq(q = as.numeric(2*(logLik(mod4p3) - logLik(mod4p2))), df = 1, lower.tail = FALSE)/2
# Rejette H0: Modèle Poisson n'est pas une "simplification adéquate" du modèle binom nég
mod4p4 <- MASS::glm.nb(nusers ~ factor(weekday) + temp + relhumid, data = bixi)
# Compare model with daily effect (Ha) versus model with we/weekdays (H0)
anova(mod4p4, mod4p3)


###############################
#######  Exercice 4.5  ########
###############################

data(socceragg, package = "hecstatmod")
xtabs(counts ~ home + away, data = socceragg)
model_ctab <- glm(data = socceragg, 
                  counts ~ home + away,
                  family=poisson)
pchisq(q = deviance(model_ctab), 
       df = df.residual(model_ctab), 
       lower.tail = FALSE) 

data(soccer, package = "hecstatmod")
mod0 <- glm(score ~ team + opponent + home,
            data = soccer, family=poisson)
coef(mod0)["home"]
confint(mod0)["home",]
car::Anova(mod0, type=3)

set.seed(1234)
B <- 9999
devpval <- rep(0, B)
soccerfake <- soccer
for(i in 1:B){
  soccerfake$score <- rpois(n = nrow(soccer), lambda = exp(mod0$linear.predictors))
  devpval[i] <- deviance(glm(score ~ team + opponent + home,
                             data = soccerfake, family=poisson))
}
mean(devpval > deviance(mod0))
pchisq(deviance(mod0), df.residual(mod0), lower.tail = FALSE)

pdf("deviance_approx.pdf", width = 5, height = 2.5)
par(mar = c(4,4,1,1))
curve(dchisq(x, df = 720), from = 600,to = 950, bty = 'l', ylim = c(0, 0.015), yaxs="i", ylab = "density", xlab= '')
hist(devpval, add = TRUE, freq = FALSE, col = scales::alpha(1, 0.1))
dev.off()

mod1 <- glm(score ~ team + opponent + home + team*home + opponent*home,
            data = soccer, family=poisson)
anova(mod0, mod1, test = "LRT")

newdat <- data.frame(team = c("Manchester United", "Liverpool"), 
                     opponent = c("Liverpool", "Manchester United"),
                     home = c(1,0))
predict(mod0, newdata = newdat, type="response")


###############################
#######  Exercice 4.6  ########
###############################

data(buchanan, package = "hecstatmod")
with(buchanan, sum(buch) / sum(totmb + buch))
library(ggplot2)
col <- rep(1, nrow(buchanan)); col[50] <- 2
g1 <- ggplot(data = buchanan, 
             aes(y = 100*buch/(totmb + buch), x =log(totmb))) +
  geom_point(col = col) + 
  xlab("total population (log scale)") + 
  ylab("Buchanan vote share (%)") + 
  theme_minimal()
g2 <- ggplot(data = buchanan, 
             aes(y = log(buch), x =log(popn))) +
  geom_point(col = col) + 
  xlab("total votes (log scale)") + 
  ylab("number of Buchanan votes (log scale)") +
  theme_minimal()
library(patchwork)
g1 + g2

modfl1 <- glm(data = buchanan, subset = county != "Palm Beach", 
              buch ~ white + log(hisp) + geq65 + highsc + log(coll) + income + offset(log(totmb)), family = poisson)
modfl2 <- MASS::glm.nb(data = buchanan, subset = county != "Palm Beach",
                       buch ~ white + log(hisp) + geq65 + highsc + log(coll) + income + offset(log(totmb)))
pchisq(deviance(modfl2), df.residual(modfl2), lower.tail = FALSE)
anova(modfl1, modfl2)

predict(modfl2, newdata = buchanan[50,], type = "response")
predict(modfl1, newdata = buchanan[50,], type = "response")
# Poor man's prediction interval based on 
# Normal approximation to the sampling distribution of beta
B <- 1e4
xPB <- with(buchanan[50,], c(1, white, log(hisp), geq65, highsc, log(coll),income, log(totmb)))
predc <- apply(MASS::mvrnorm(n=B, mu = coef(modfl2), Sigma = vcov(modfl2)), 1, function(beta){
  mu <- exp(sum(xPB * c(beta,1)))
  pred <- MASS::rnegbin(n = 1, mu = mu, theta = rnorm(1, modfl2$theta, modfl2$SE.theta))
  return(c(mu, pred))
})
quantile(predc[1,], c(0.025, 0.975)) # Monte Carlo confidence interval for the mean
quantile(predc[2,], c(0.025, 0.975)) # Monte Carlo approximate prediction interval

