slides <- list.files(path = "/home/lbelzile/Documents/Dropbox/website/MATH60604-diapos", pattern = "*.html")
slides <- slides[substr(slides, 1, 11) == "MATH60604_d"]
ns <- length(slides)
codedir <- "../code"
names <- c("Plan de cours",
           "Tests d'hypothèses",
           "Théorème central limite",
           "Analyse exploratoire",
           "Interprétation des paramètres",
           "Transformations linéaires",
           "Géométrie des moindres carrés")
semaine <- as.numeric(substr(slides, 12,12))
video <- c("https://youtu.be/kC5S4h0bIaw", 
           "https://youtu.be/6Qe4mi6A9bU", 
           "https://youtu.be/a2cpzb1EzGk",
           "https://youtu.be/2vK0zEX6dSA",
           "https://youtu.be/-R-5muz1mGY",
           "https://youtu.be/4xczymEfVng",
           "https://youtu.be/2iKH0tBb6w4"
           )
if(length(names) - length(video) > 0){
  video <- c(video, rep("", length(names) - length(video)))
}
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
                    Vidéos = paste0("[vidéo](",video,")"),
                    SAS = codestr,
                    R = codeRstr)
