library(nlme)
library(ggplot2)
library(patchwork)
library(xts)
# Exercice 5.1 
 
data(renergie, package = "hecmodstat")
cols <- c(gray.colors(n = 16), 2)[c(1:10,17,11:16)]

# Tracer un graphique de la série chronologique 
g1 <- ggplot(data = renergie, 
       aes(y=pmoy, x = date, group = region, col = region)) + 
  geom_line() + 
  theme(legend.position = "none") + 
  ylab("prix moyen au détail (dollars CAD)")
g2 <- ggplot(data = renergie, 
       aes(y=pmoy-pmin, x = date, group = region, col = region)) + 
  geom_line() + 
  theme(legend.position = "none") + 
  ylab("marge de profit moyenne\n des détaillants (dollars CAD)")

g1 + g2
# Alternative à l'aide de la bibliothèque "xts" pour les séries chronologiques
# Transformer de format long vers format court
ren <- renergie
ren$marg <- renergie$pmoy - ren$pmin
ren$pmin <- NULL
ren <- tidyr::pivot_wider(data = ren, values_from = c("pmoy","marg"), names_from = region)
par(mar = c(3,3,1,1), mfrow = c(1,2), bty = "l", pch = 20)
plot(xts(x = ren[,19:35], order.by = ren$date), main =  "marge de profit moyenne")
plot(xts(x = ren[,2:18], order.by = ren$date), main =  "prix moyen de vente")



rener_mod1 <- nlme::gls(I(pmoy-pmin) ~ factor(region), data = renergie, 
                        correlation = corAR1(form=~1 | date))
plot(ACF(rener_mod1, resType = "normalized"), xlab = "décalage", ylab = "autocorrélation")
likH0 <- logLik(rener_mod1)

# Pour faire ce test d'hypothèse, il suffit d'ajuster
# les 17 modèles indépendaments et additionner leurs valeurs de REML
likH1 <- sum(sapply(1:17, function(i){
  logLik(nlme::gls(I(pmoy-pmin) ~ 1, data = renergie[renergie$region==i,],
                   correlation = corAR1(form=~1 | date)))}))
pchisq(2*as.numeric(likH0-likH1), df = 32, lower.tail = FALSE)

# Exercice 5.3

data(tolerance, package = "hecmodstat")
tolerance$sexe <- factor(tolerance$sexe, labels = c("femme","homme"))
# Analyse graphique exploratoire
g1 <- ggplot(data = tolerance) + 
  geom_boxplot(aes(y = tolerance, x = sexe))
g2 <- ggplot(data = tolerance) + 
  geom_point(aes(y = tolerance, x = exposition))
g3 <- ggplot(data = tolerance) + 
  geom_boxplot(aes(y = tolerance, x = factor(age))) + 
  xlab("âge")
g1 + g2 + g3

ggplot(data = tolerance, aes(x = age, y = tolerance, group = id, color=id)) +
  geom_line() + theme(legend.position="none")

mod1 <- gls(tolerance ~ sexe + exposition + age, data = tolerance, 
    correlation = corCompSymm(form= ~ 1 | id))
mod2 <- gls(tolerance ~ sexe + exposition + age, data = tolerance, 
    correlation = corAR1(form= ~ 1 | id))
mod3 <- gls(tolerance ~ sexe + exposition + age, data = tolerance)
anova(mod1, mod3)
anova(mod2, mod3)
cbind("AIC" = c(AIC(mod1), AIC(mod2), AIC(mod3)), 
      "BIC" = c(BIC(mod1), BIC(mod2), BIC(mod3)))


