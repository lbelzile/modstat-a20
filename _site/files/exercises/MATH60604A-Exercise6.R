## Exercise 6.1
data(goldstein, package = "hecstatmod")
goldstein$vr <- relevel(factor(goldstein$vr), ref = 3)
goldstein$denom <- relevel(factor(goldstein$denom), ref = "other")
goldstein$type <- relevel(factor(goldstein$type), ref = "mixed")
# Number of pupils per school
npupils <- summary(factor(goldstein$school))
summary(npupils)

library(lme4)
mod1 <- lmer(score ~ (1|school) + lrt + gender + type + vr + denom,
             data = goldstein)
summary(mod1)
#Type 3 effects with Wald-tests (same as SAS output)
car::Anova(mod1, type = 3)

randeff <- ranef(mod1, condVar = TRUE)
randeffm <- randeff$school[,1]
# Plot gets those by itself, but the command shows how to get pred. std.errors
randeffse <- attr(randeff$school,"postVar")[1,1,]

par(mfrow = c(1,2), mar = c(4,4,1,1), bty = "l")
plot(resid(mod1), fitted(mod1), col = 1, ylab = "ordinary residuals", xlab = "fitted values", pch = 20)
car::qqPlot(randeffm, id=FALSE,
            xlab = "theoretical quantiles",
            ylab = "predicted random effects")


library(lattice)
# Caterpillar plot
trellis.par.set(canonical.theme(color = FALSE))
dotplot(ranef(mod1), main = FALSE)


# Covariance parameters
vars <- VarCorr(mod1)
vars <- c(vars[[1]], attr(vars, "sc")^2)
cov37 <- matrix(vars[1], nrow = 4, ncol = 4) + diag(vars[2], 4)
cov2cor(cov37)

# Ranking using covariates fixed within group and 
# predicted random effects
goldstein_sub <- goldstein[!duplicated(goldstein$school),]
goldstein_sub$lrt <- 0
goldstein_sub$gender <- 0
goldstein_sub$vr <- "1"
pred_rank <- predict(mod1, newdata = goldstein_sub, re.form = NULL)
goldstein_sub$school[order(pred_rank, decreasing = TRUE)][1:5]  



## Exercise 6.2
data(gsce, package = "hecstatmod")
library(nlme)
# Compound symmetry model within center
mod1 <- gls(result ~ coursework + sex, 
    data = gsce, 
    correlation = corCompSymm(form = ~1 | center))
# Model with main effect for factor center
mod2 <- gls(result ~ coursework + sex + center, 
            data = gsce)
# Linear mixed model with random intercept per center
mod3 <- lme(fixed = result ~ coursework + sex, 
            data = gsce,
            random = ~1 | center)
# Covariance of errors epsilon
getVarCov(mod3, levels = rep(1,3), type = "conditional")
# Covariance of Y
getVarCov(mod3, levels = rep(1,3), type = "marginal")
# Predictions - level=0 for marginal, level=1 includes random effect (conditional)
predict(mod3, newdata = data.frame(coursework = 91, center = 2, sex=1), 
        level = 0:1)
predict(mod3, newdata = data.frame(coursework = 100, sex=1),
        level = 0)

