exdir <- "../exercices"

## exercise and solution files
fn <- FALSE
ex <- list.files(path = exdir, pattern = "MATH60604-Exercice[[:digit:]].pdf", 
    full.names = fn)
codesas <- list.files(path = exdir, pattern = "MATH60604-Exercice[[:digit:]].sas", 
                 full.names = fn)
coder <- list.files(path = exdir, pattern = "MATH60604-Exercice[[:digit:]].R", 
                      full.names = fn)
so <- list.files(path = exdir, pattern = "MATH60604-Exercice[[:digit:]]-sol.pdf", 
    full.names = fn)



## Numbers + Topics
# exid <- as.numeric(gsub("[^0-9.-]+", "", ex))
topics <- 
  c("Bases de l'inférence statistique", 
    "Régression linéaire",
    "Vraisemblance",
    "Modèles linéaires généralisés",
    "Données corrélées et longitudinales",
    "Modèles linéaires mixtes",
    "Analyse de survie")
exdat <- data.frame(Chapitre = topics)


## Links
linkstring <- "https://nbviewer.jupyter.org/github/lbelzile/modstat/blob/master/exercices/"
linkgithub <- "https://raw.githubusercontent.com/lbelzile/modstat/master/"
exdat$Exercice <- c(paste0("[exercice](", linkstring, ex, ")"),rep("", length.out = 7-length(ex)))
exdat$Solution <- c(paste0("[solution](", linkstring, so, ")"),rep("", length.out = 7-length(so)))
exdat$`Code SAS` <- c(paste0("[SAS](", linkgithub, "exercices/",codesas, ")"),rep("", length.out = 7-length(codesas)))
exdat$`Code R` <- c(paste0("[R](", linkgithub, "exercices/", coder, ")"),rep("", length.out = 7-length(coder)))

