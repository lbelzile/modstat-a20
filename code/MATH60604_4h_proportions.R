# Régression logistique pour données binomiales
# taux de succès aux examens pratique de conduite en Grande-Bretagne
data(gbconduite, package = "hecmodstat")
gbconduite$taille <- factor(
  cut(gbconduite$total, c(0, 500, 1000, Inf)),
  labels = c("petit", "moyen", "grand")
)
gbconduite$region <- relevel(factor(gbconduite$region), "London")

with(gbconduite, table(region, taille))
# Argument est succès, échec
mod_gbconduite <- glm(
  cbind(reussite, total - reussite) ~ sexe + region + taille,
  data = gbconduite,
  family = binomial(link = "logit")
)
summary(mod_gbconduite)
exp(cbind(coef(mod_gbconduite), confint(mod_gbconduite)))
# Prédiction du modèle logistique - multiplier par taille!
predlogistic <- fitted(mod_gbconduite) * gbconduite$total
# Pour une nouvelle base de données, utiliser
# predict(mod_gbconduite, newdata = gbconduite, type = "response")
# Cette sortie donnera la probabilité de succès
# pour obtenir le dénombrement, multiplier par le nombre d'essais

data(accident, package = "hecmodstat")
mod_accidents_USA <- glm(
  cbind(nmorts, popn - nmorts) ~ moment + annee,
  family = binomial,
  data = accident
)
summary(mod_accidents_USA)
# Taux estimé par habitant
# est probabilité de décès fois 10^5
plogis(coef(mod_accidents_USA)[1]) * 1e5
