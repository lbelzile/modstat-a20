library(lme4)
data(poussin, package = "hecmodstat")
# Ajuster un modèle avec regime comme effet fixe
# Effets aléatoires corrélés
mod1 <- lme4::lmer(masse ~ temps + regime + (1 + temps | poussin),
           data = poussin)
# Effets aléatoires indépendants (matrice de covariance diagonale)
mod2 <- lme4::lmer(masse ~  temps + regime + 
                     (1 | poussin) +
                     (temps - 1 | poussin),
           data = poussin)
# Tester si la corrélation entre ordonnée à l'origine et pente
# aléatoires est significative
# H0: omega_{12}=0 versus H1: omega_{12} NEQ 0
anova(mod1, mod2)

# Ajuster un modèle alternatif avec un effet aléatoire pour régime
# les poussins est emboîté dans régime
mod3 <- lme4::lmer(masse ~ temps +
                     (1 + temps | regime:poussin) + 
                     (1 | regime),
                   data = poussin)

# Fonction de StackOverflow pour créer un graphique de la matrice de covariance de Y
# https://stackoverflow.com/questions/45650548/get-residual-variance-covariance-matrix-in-lme4/45655597#45655597
rescov <- function(model, data) {
  var.d <- crossprod(getME(model,"Lambdat"))
  Zt <- getME(model,"Zt")
  vr <- sigma(model)^2
  var.b <- vr*(t(Zt) %*% var.d %*% Zt)
  sI <- vr * Diagonal(nrow(data))
  var.y <- var.b + sI
  invisible(var.y)
}
# Imprimer la matrice de covariance du modèle multi-niveau (emboîtés)
rc3 <- rescov(mod3, poussin)
# Graphique de la matrice de corrélation
image(cov2cor(rc3), sub = "", xlab = "", ylab = "")

### Deuxième exemple: données de mobilisation
# Pourquoi ne faut-il pas mettre d'effet aléatoire sur 
# des variables explicatives catégorielles comme "sexe"?
data(mobilisation, package = "hecmodstat")
mod1 <- lme4::lmer(mobilisation ~ anciennete + agegest + nunite + 
                     (1 | sexe) + (1 | idunite),
                   data = mobilisation)

# Graphique de la matrice de corrélation
image(cov2cor(rescov(mod1, mobilisation)), sub = "", xlab = "", ylab = "")
# On voit que la matrice de corrélation résultante est dense...
# ces modèlesne sont pas ajustables en haute dimension
# on crée de la corrélation inter-groupe
