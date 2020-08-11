slides <- list.files(path = "/home/lbelzile/Documents/Dropbox/website/MATH60604-diapos", pattern = "*.html")
ns <- length(slides)
codedir <- "../code"
names <- c("Plan de cours",
           "Tests d'hypothèses",
           "Théorème central limite",
           "Analyse exploratoire")
semaine <- as.numeric(substr(slides, 12,12))
video <- rep("", length(names))

linkgithub <- "https://raw.githubusercontent.com/lbelzile/modstat/master/"

codesas <- list.files(path = codedir, pattern = "*.sas")
codestr <- rep("", ns)
nid <- sapply(substr(codesas,11,12), function(x){which(x == substr(slides[-1], 12,13))})
codestr[nid+1L] <- paste0("[SAS](",linkgithub, "code/", codesas,")")

codeR <- list.files(path = codedir, pattern = "*.R")
codeRstr <- rep("", ns)
nid <- sapply(substr(codeR,11,12), function(x){which(x == substr(slides[-1], 12,13))})
codeRstr[nid+1L] <- paste0("[R](",linkgithub,"code/", codeR,")")


url <- "https://lbelzile.github.io/MATH60604-diapos/"
sldat <- data.frame('S' = semaine, 
                    Diapositives = paste0("[",names,"](",url, slides,")"),
                    Vidéos = video,
                    SAS = codestr,
                    R = codeRstr)
