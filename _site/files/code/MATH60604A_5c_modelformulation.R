library(nlme)
data(revenge, package = "hecstatmod")
revenge$t <- as.integer(revenge$time)
# Vanilla linear model, fitted with REML
model0 <- gls(revenge ~ sex + age + vc + wom + t, 
              data = revenge)
summary(model0)
