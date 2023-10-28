library(ggplot2)
library(lme4)
library(nlme)

data(revenge, package = "hecstatmod")
revenge$t <- as.integer(revenge$time)
mixed1 <- lmer(revenge ~ sex + age + vc + wom  +  t +
                 (1 | id) + (0 +t | id), data = revenge, 
               REML = TRUE)

mixed2 <- lmer(revenge ~ sex + age + vc + wom +  t +
                (1+t | id), data = revenge,
               REML = TRUE)
# Same as
# nlme::lme(revenge ~ sex + age + vc + wom  +  t, random = ~ 1+t | id, data = revenge)

# Are the slope and intercept correlated?
anova(mixed2, mixed1)
# Strongly reject null that corr=0
# since not on boundary, chisq(1) is correct asymptotic dist
# Variance parameters for random effects and errors
VarCorr(mixed2) # print standard dev and correlation
VarCorr(mixed2)$id #print covariance matrix

# Fixed and random effects
fixef(mixed2)
# Scatterplot of random intercept and slope
plot(ranef(mixed2))



# Because all covariates are fixed in time,
# these added up give a different intercept to each individual
# depending on its characteristics

intercept_fixed <- c(cbind(1, as.matrix(revenge[revenge$time==1,1:4])) %*% fixef(mixed2)[1:5])
slope_fixed <- nlme::fixed.effects(mixed2)["t"]
#random effects
random_effects <- ranef(mixed2)

# Show the fitted line in the revenge score - time scale
ran_lines <- data.frame(intercept = intercept_fixed + random_effects$id[,1],
                        slope = slope_fixed + random_effects$id[,2],
                        id = 1:80)
ggplot(data = revenge, aes(x=t, y=revenge, group=id)) + 
         geom_line(alpha = 0.2) +
    geom_abline(data = ran_lines, 
                aes(intercept = intercept, slope = slope, group = id),  
                col = 4, alpha = 0.2) + 
  scale_x_continuous(expand = c(0,0), limits = c(1,5))


# Same model, but we add an AR(1) covariance model for the errors
# This must be fitted using nlme::lme rather than lme4::lmer
# as the latter doesn't handle covariance models for errors

mixed3 <- lme(revenge ~ sex + age + vc + wom + t, 
              random = ~ 1  | id, 
              data = revenge, 
              correlation = corAR1()) 
mixed4 <- lme(revenge ~ sex +  vc + wom + age +  t, 
              random = ~ 1 + t | id, 
              data = revenge, 
              correlation = corAR1()) 
# null distribution is 0.5 chisq_1 + 0.5chisq_2
# but poor finite-sample properties
anova(mixed4, mixed3)
# With the AR(1) model, there is no more
# need for a random slope for time

plot(ranef(mixed3))
# Check sample mean is indeed zero
isTRUE(all.equal(0, mean(ranef(mixed3)[,1])))
nlme::plot.lme(mixed3)

VarCorr(mixed3)

