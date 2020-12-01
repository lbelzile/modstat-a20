# Exercice 6.2
data(gsce, package = "hecmodstat")
library(nlme)
# Modèle d'équicorrélation intra-centre
mod1 <- gls(resultat ~ score + sexe, 
    data = gsce, 
    correlation = corCompSymm(form = ~1 | centre))
# Modèle avec effet principal pour centre
mod2 <- gls(resultat ~ score + sexe + centre, 
            data = gsce)
# Modèle linéaire mixte avec ordonnée à l'origine aléatoire par centre
mod3 <- lme(fixed = resultat ~ score + sexe, 
            data = gsce,
            random = ~1 | centre)
# Covariance des erreurs
getVarCov(mod3, levels = rep(1,3), type = "conditional")
# Covariance de Y
getVarCov(mod3, levels = rep(1,3), type = "marginal")
# Prédictions - level=0 pour marginale, level=1 pour conditionnelle (incluant effets aléatoires)
predict(mod3, newdata = data.frame(score = 91, centre = 2, sexe=1), 
        level = 0:1)
predict(mod3, newdata = data.frame(score = 100, sexe=1),
        level = 0)

