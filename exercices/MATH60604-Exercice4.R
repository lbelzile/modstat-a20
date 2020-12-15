library(ggplot2)
library(patchwork)
###############################
#######  Exercice 4.1  ########
###############################

data(salaireprof, package = "hecmodstat")
salaireprof$salbi <- salaireprof$salaire > 105000
mod1p1 <- glm(salbi ~ diplome + sexe + anech + andi, 
            data = salaireprof, 
            family=binomial(link="logit"))
summary(mod1p1)
mod1p2 <- glm(salbi ~ diplome + sexe + anech + andi + echelon, 
            data = salaireprof, 
            family=binomial(link="logit"))


ggplot(data.frame(pred = fitted(mod1p2), 
                  echelon = salaireprof$echelon),
       aes(x = echelon, y = pred)) +
  geom_boxplot() + 
   labs(x = "echelon académique", 
        y = "valeurs ajustées")

###############################
#######  Exercice 4.2  ########
###############################

data(prix, package = "hecmodstat")
mod2p1 <- glm(nprix ~ prog + math, data = prix, family=poisson(link="log"))
mod2p2 <- MASS::glm.nb(nprix ~ prog + math, data = prix, link='log')
#Tester pour la surdispersion ATTENTION: ne pas utiliser deviance(), 
# cela ne donne pas la bonne quantité ici
pchisq(2*as.numeric(logLik(mod2p2) - logLik(mod2p1)), 
       df = 1, lower.tail = FALSE)/2
# rejeter l'hypothèse nulle que k=0
kchapeau <- 1/mod2p2$theta
# vérifier l'adéquation - test de rapport de vraisemblance versus modèle saturé
deviance(mod2p1) / mod2p1$df.residual
#les degrés des résidus ne prennent pas en compte k
pchisq(deviance(mod2p1), df = mod2p1$df.residual, lower.tail = FALSE)
summary(mod2p1)
# Statistique khi-deux de Pearson pour le modèle Poisson
PearsonX2 <- sum(residuals(mod2p1, type = "pearson")^2)
# sum((prix$nprix - fitted(mod2p1))^2/fitted(mod2p1))

###############################
#######  Exercice 4.3  ########
###############################
data(enfantsfiji, package = "hecmodstat")
# par(mfrow= c(1,2),mar = c(4,4,1,1), bty = "l", pch = 20)
# with(enfantsfiji, plot(log(nfemmes), log(nenfants), 
#                xlab = "nombre de femme par groupe (log)",
#                ylab = "nombre d'enfants nés (log)"))
# with(enfantsfiji, plot(nenfants/nfemmes, var, 
#                        xlab = "nombre moyen d'enfants nés",
#                        ylab = "variance du nombre d'enfants"))

g1 <- ggplot(data = enfantsfiji, 
       aes(x = log(nfemmes), y =log(nenfants))) +
  geom_point() +
  labs(x="nombre de femmes par groupe (log)",
       y ="nombre d'enfants nés (log)")
g2 <- ggplot(data = enfantsfiji, 
             aes(x = nenfants/nfemmes, y =var)) +
  geom_point() +
  labs(x = "nombre moyen d'enfants nés",
       y = "variance du nombre d'enfants nés")
g1 + g2


mod3p1 <- glm(nenfants ~ dur + res + educ + offset(log(nfemmes)), 
              data = enfantsfiji, family = poisson)

mod3p2 <- glm(nenfants ~ dur + res + educ + log(nfemmes), 
              data = enfantsfiji, family = poisson)

# Coefficients
summary(mod3p1)
# Intervalles de confiance (vraisemblance profilée)
confint(mod3p1)
# Analyse de déviance (Type 3) - 
# Tests de rapport de vraisemblance pour variables explicatives
car::Anova(mod3p1, type = 3)
# Diagnostics graphiques des résidus
boot::glm.diag.plots(mod3p1)
# Deviance := test de rapport modèle ajusté versus modèle saturé
deviance(mod3p1)/mod3p1$df.residual #rapport devrait être approx. 1
pchisq(deviance(mod3p1), df = mod3p1$df.residual, lower.tail = FALSE)

# Comparaison de modèles emboîtés
mod3p3 <- glm(nenfants ~ dur * educ + res  + offset(log(nfemmes)), data = enfantsfiji, family = poisson)
anova(mod3p1, mod3p3, test = "LRT")
###############################
#######  Exercice 4.4  ########
###############################

data(bixi, package = "hecmodstat")

mod4p1 <- glm(nutilisateurs ~ fds, data = bixi, family = poisson(link="log")) 
mod4p2 <- glm(nutilisateurs ~ fds + temp + humid, data = bixi, family = poisson(link="log")) 
anova(mod4p1, mod4p2)

mod4p3 <- MASS::glm.nb(nutilisateurs ~ fds + temp + humid, data = bixi)
# Surdispersion
# Test du rapport de vraisemblance bin nég. versus Poisson 
# loi nulle est 0.5* khi-deux. En pratique, diviser la valeur-p par deux
pchisq(q = as.numeric(2*(logLik(mod4p3) - logLik(mod4p2))), df = 1, lower.tail = FALSE)/2
# Rejette H0: Modèle Poisson n'est pas une "simplification adéquate" du modèle binom nég
mod4p4 <- MASS::glm.nb(nutilisateurs ~ factor(jour) + temp + humid, data = bixi)
# Comparer modèle avec un effet différent pour chaque jour versus H0: semaine/fds
anova(mod4p4, mod4p3)



###############################
#######  Exercice 4.5  ########
###############################

data(socceragg, package = "hecmodstat")
xtabs(total ~ domicile + visiteur, data = socceragg)
model_ctab <- glm(data = socceragg, 
                  total ~ domicile + visiteur,
                  family=poisson)
pchisq(q = deviance(model_ctab), 
       df = df.residual(model_ctab), 
       lower.tail = FALSE) 

data(soccer, package = "hecmodstat")
mod0 <- glm(buts ~ equipe + adversaire + domicile,
            data = soccer, family=poisson)
coef(mod0)["domicile"]
confint(mod0)["domicile",]
car::Anova(mod0, type=3)

set.seed(1234)
B <- 9999
dev_valp <- rep(0, B)
soccerfictif <- soccer
for(i in 1:B){
  soccerfictif$buts <- rpois(n = nrow(soccer), lambda = exp(mod0$linear.predictors))
  dev_valp[i] <- deviance(glm(buts ~ equipe + adversaire + domicile,
                             data = soccerfictif, family=poisson))
}
mean(dev_valp > deviance(mod0))
pchisq(deviance(mod0), df.residual(mod0), lower.tail = FALSE)

pdf("approx_deviance.pdf", width = 5, height = 2.5)
par(mar = c(4,4,1,1))
curve(dchisq(x, df = 720), from = 600,to = 950, bty = 'l', 
      ylim = c(0, 0.015), yaxs="i", ylab = "density", xlab= '')
hist(dev_valp, add = TRUE, freq = FALSE, col = scales::alpha(1, 0.1))
dev.off()

mod1 <- glm(score ~ equipe + adversaire + domicile + equipe*domicile + adversaire*domicile,
            data = soccer, family=poisson)
anova(mod0, mod1, test = "LRT")

nouv_donnees <- data.frame(equipe = c("Manchester United", "Liverpool"), 
                     adversaire = c("Liverpool", "Manchester United"),
                     domicile = c(1,0))
predict(mod0, newdata = nouv_donnees, type = "response")


###############################
#######  Exercice 4.6  ########
###############################

data(buchanan, package = "hecmodstat")
with(buchanan, sum(buch) / sum(totmb + buch))
library(ggplot2)
col <- rep(1, nrow(buchanan)); col[50] <- 2
g1 <- ggplot(data = buchanan, 
             aes(y = 100*buch/(totmb + buch), x =log(totmb))) +
  geom_point(col = col) + 
  xlab("population du comté (échelle log)") + 
  ylab("pourcentage des suffrages\n exprimés pour Buchanan") + 
  theme_minimal()
g2 <- ggplot(data = buchanan, 
             aes(y = log(buch), x =log(popn))) +
  geom_point(col = col) + 
  xlab("nombre de votes valides (échelle log)") + 
  ylab("nombre de votes pour\n Buchanan (échelle log)") +
  theme_minimal()
library(patchwork)
g1 + g2

modfl1 <- glm(data = buchanan, subset = comte != "Palm Beach", 
              buch ~ blanc + log(hisp) + a65 + dsec + log(coll) + revenu + offset(log(totmb)), family = poisson)
modfl2 <- MASS::glm.nb(data = buchanan, subset = comte != "Palm Beach",
                       buch ~ blanc + log(hisp) + a65 + dsec + log(coll) + revenu + offset(log(totmb)))
pchisq(deviance(modfl2), df.residual(modfl2), lower.tail = FALSE)
anova(modfl1, modfl2)

predict(modfl2, newdata = buchanan[50,], type = "response")
predict(modfl1, newdata = buchanan[50,], type = "response")
# Intervalles de prédictions approximatifs
# basés sur l'approximation asymptotique normale
# de la distribution d'échantillonage des betas
B <- 1e4
xPB <- with(buchanan[50,], c(1, blanc, log(hisp), a65, dsec, log(coll), revenu, log(totmb)))
predc <- apply(MASS::mvrnorm(n=B, mu = coef(modfl2), Sigma = vcov(modfl2)), 1, function(beta){
  mu <- exp(sum(xPB * c(beta,1)))
  pred <- MASS::rnegbin(n = 1, mu = mu, theta = rnorm(1, modfl2$theta, modfl2$SE.theta))
  return(c(mu, pred))
})
quantile(predc[1,], c(0.025, 0.975)) 
# Intervalle de confiance pour la moyenne - approximation Monte Carlo
quantile(predc[2,], c(0.025, 0.975)) 
# Intervalle de prédiction - approximation de Monte Carlo



###############################
#######  Exercice 4.7  ########
###############################

# Données tirées de Bishop, Y. M. M. ; Fienberg, S. E. and Holland, P. W. (1975) 
# Discrete Multivariate Analysis: Theory and Practice. MIT Press, Cambridge
data(cancer, package = "hecmodstat")

print(cancer)
# Certaines catégories ont peu d'observations
# les résultats asymptotiques sont à prendre avec des pincettes

cancer.m0 <- glm(cbind(oui, non) ~ 1, family = "binomial", data = cancer)
cancer.m1 <- glm(cbind(oui, non) ~ age, family = "binomial", data = cancer)
cancer.m2 <- glm(cbind(oui, non) ~ maligne, family = "binomial", data = cancer)
cancer.m3 <- glm(cbind(oui, non) ~ age + maligne, family = "binomial", data = cancer)
cancer.m4 <- glm(cbind(oui, non) ~ age * maligne, family = "binomial", data = cancer)

devtab <- data.frame("modèle" = c("M0","M1","M2","M3"), 
                     "déviance" = round(c(deviance(cancer.m0), deviance(cancer.m1), deviance(cancer.m2), deviance(cancer.m3)), 2),
      "p" = c(length(coef(cancer.m0)), length(coef(cancer.m1)),length(coef(cancer.m2)),length(coef(cancer.m3))))
print(devtab)
# Imprimer tableau LaTeX
# xtab <- xtable(devtab, caption = "Analysis of deviance for the \\texttt{fumeur} data set")
# names(xtab) <- c("modèle", "déviance (binom.)", "déviance (Poisson)", "$p$")
# print(xtab, booktabs = TRUE, sanitize.text.function = identity, include.rownames = FALSE)


## Analyse de déviance
# Modèle saturé versus modèle additif (deux variables catégorielles sans interaction)
 1- pchisq(deviance(cancer.m3), df = nrow(cancer) - length(cancer.m3$coef))
# valeur-p de 0.78, on ne rejette pas H0: modèle additif est une simplification adéquate
# Simplifications supplémentaires
# On ne rejette pas que modèle avec tumeur maligneest une simplification adéquate
 1- pchisq(2*(c(logLik(cancer.m4) - logLik(cancer.m2))), df = (length(cancer.m4$coef) - length(cancer.m2$coef)))
  # Ou de manière alternative 
 anova(cancer.m2, cancer.m4, test = "LRT") 
 #Différence de déviance et différence de degrés de liberté dans les deux dernières colonnes
anova(cancer.m1, cancer.m4, test = "LRT")

# Par contre, on rejette l'hypothèse nul que le modèle
# avec uniquement l'ordonnée à l'origine est adéquat
anova(cancer.m0, cancer.m4, test = "LRT")
1- pchisq(2*(c(logLik(cancer.m4) - logLik(cancer.m0))), df = (length(cancer.m4$coef) - length(cancer.m0$coef)))

# Si le modèle est une simplification adéquate, alors déviance approx JK-p 
deviance(cancer.m2) / cancer.m2$df.residual
pchisq(deviance(cancer.m2), df = nrow(cancer) - length(coef(cancer.m2)), lower.tail = FALSE)

###############################
#######  Exercice 4.8  ########
###############################
data(fumeurs, package = "hecmodstat")
fumeur.p.m0 <- glm(morts ~ offset(log(pop)), family = poisson, data = fumeurs)
fumeur.p.m1 <- glm(morts ~ offset(log(pop)) + fume, family = poisson, data = fumeurs)
fumeur.p.m2 <- glm(morts ~ offset(log(pop)) + age, family = poisson, data = fumeurs)
fumeur.p.m3 <- glm(morts ~ offset(log(pop)) + fume + age, family = poisson, data = fumeurs)
#Définir quantités
n <- nrow(fumeurs)
p0 <- length(coef(fumeur.p.m0)); D0p <- deviance(fumeur.p.m0)
p1 <- length(coef(fumeur.p.m1)); D1p <- deviance(fumeur.p.m1)
p2 <- length(coef(fumeur.p.m2)); D2p <- deviance(fumeur.p.m2)
p3 <- length(coef(fumeur.p.m3)); D3p <- deviance(fumeur.p.m3)


pchisq(D3p, df = n - p3, lower.tail = FALSE) # Interaction pas stat. significative
pchisq(D2p - D3p, df = p3 - p2, lower.tail = FALSE) # age significatif
pchisq(D1p - D3p, df = p3 - p1, lower.tail = FALSE) # fumeur significatif
# Si le modèle est correct, D3 approx khi-deux avec (n - p3) ddl
summary(fumeur.p.m3)

# Idem, cette fois avec le modèle binomiale
fumeur.b.m0 <- glm(cbind(morts, pop - morts) ~ 1, family = binomial, data = fumeurs)
fumeur.b.m1 <- glm(cbind(morts, pop - morts) ~ fume, family = binomial, data = fumeurs)
fumeur.b.m2 <- glm(cbind(morts, pop - morts) ~ age, family = binomial, data = fumeurs)
fumeur.b.m3 <- glm(cbind(morts, pop - morts) ~ fume + age, family = binomial, data = fumeurs)

n <- nrow(fumeurs)
D0b <- deviance(fumeur.b.m0)
D1b <- deviance(fumeur.b.m1)
D2b <- deviance(fumeur.b.m2)
D3b <- deviance(fumeur.b.m3)

pchisq(D3b, df = n - p3, lower.tail = FALSE) # Interaction pas stat. significative
pchisq(D2b - D3b, df = p3 - p2, lower.tail = FALSE) # age significatif
pchisq(D1b - D3b, df = p3 - p1, lower.tail = FALSE) # fumeur significatif
summary(fumeur.b.m3)
# Tableau avec le déviance
devtab <- data.frame("modèle" = paste0("M",0:3), 
                     "deviance binom." =round(c(D0p, D1p, D2p, D3p), 2),
                     "deviance Poisson" =round(c(D0b, D1b, D2b, D3b), 2),
                     "p" = c(p0, p1, p2, p3))
# xtab <- xtable(devtab, caption = "Analysis of deviance for the \\texttt{fumeur} data set")
# print(xtab, booktabs = TRUE, sanitize.text.function = identity, include.rownames = FALSE, )
print(devtab)

# Comparer les probabilités ajustées
ggplot(data.frame(x = fitted(fumeur.b.m3),
                  y = fitted(fumeur.b.m3) - fitted(fumeur.p.m3)/fumeurs$pop),
aes(x = x, y = y)) + 
  geom_point() + 
  xlab("probabilité ajustée de mourir \n(modèle logistique)") + 
  ylab("différence de probabilité estimée\n entre logistique et Poisson")
# Différence plus marquée pour les catégories
# groupes avec de grapes probabilités estimées de mourir
# parce que l'approximation Poisson est moins bonne
