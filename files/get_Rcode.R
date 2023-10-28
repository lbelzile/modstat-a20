
linkgithub <- "https://raw.githubusercontent.com/lbelzile/math60602/main/files/codeR"

## exercise and solution files
fn <- FALSE

coder <- list.files(path = exdir, pattern = "MATH60602-0",
                      full.names = fn)

rc <- paste0("[<span style='color: #276dc2;'><i class='fab fa-r-project fa-lg'></i></span>](", linkgithub, "/", coder, ")")

topics <-
  c("Analyse exploratoire",
    "Analyse factorielle",
    "Analyse de regroupements",
    "Sélection de modèles",
    "Régression logistique",
    "Analyse de survie",
    "Données manquantes")
Rcode <- data.frame(Chapitre = topics,
                    Code = rc)

