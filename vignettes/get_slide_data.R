index <- c("0_","1a","1b","1c","2a","2b","2c","2d","2e","2f","2g","3_")
index0 <- c("0","1a","1b","1c","2a","2b","2c","2d","2e","2f","2g","3")
names <- c("Plan de cours",
           "Tests d'hypothèses",
           "Théorème central limite",
           "Analyse exploratoire",
           "Interprétation des paramètres  (modèle linéaire)",
           "Transformations linéaires",
           "Géométrie des moindres carrés",
           "Tests d'hypothèses (modèle linéaire)",
           "Coefficient de détermination",
           "Prédictions",
           "Interactions",
           "Vraisemblance"
           )
ns <- length(index)
url <- "https://lbelzile.github.io/MATH60604-diapos/"
codedir <- "../code"

slides <- list.files(path = "/home/lbelzile/Documents/Dropbox/website/MATH60604-diapos", pattern = "*.html")
slides <- slides[substr(slides, 1, 11) == "MATH60604_d"]
sl <- rep("", ns)
pmasl <- na.omit(pmatch(substr(slides, start = 12, stop = 13), index))
sl[pmasl] <- paste0("[html](",url, slides,")")


slidespdf <- list.files(path = "/home/lbelzile/Documents/Dropbox/website/MATH60604-diapos", pattern = "MATH60604_d.*.pdf")
slpdf <- rep("", ns)
pmaslp <- na.omit(pmatch(substr(slidespdf, start = 12, stop = 13),index))
slpdf[pmaslp] <- paste0("[pdf](",url, slidespdf,")")



video <- c("https://youtu.be/kC5S4h0bIaw", 
           "https://youtu.be/6Qe4mi6A9bU", 
           "https://youtu.be/a2cpzb1EzGk",
           "https://youtu.be/2vK0zEX6dSA",
           "https://youtu.be/-R-5muz1mGY",
           "https://youtu.be/4xczymEfVng",
           "https://youtu.be/2iKH0tBb6w4",
           "https://youtu.be/EjSlJJ5CUJY", #tests 2d
           "https://youtu.be/QtfhZCMHVAo", #correlation 2e
           "https://youtu.be/GZx7_5tmzCg", # prédictions 2f
           "https://youtu.be/0UrxG4hkDcg", #interactions 2g
           "https://youtu.be/VJItA6EX5-s" #vraisemblance 3
           )
videosl <- paste0("[vidéo](",video,")")
if(length(names) - length(video) > 0){
  videosl <- c(videosl, rep("", length(names) - length(video)))
}
linkgithub <- "https://raw.githubusercontent.com/lbelzile/modstat/master/"


codesas <- list.files(path = codedir, pattern = "MATH60604.*.sas")
codestr <- rep("", ns)
nid <- na.omit(pmatch(substr(codesas,11,12), index))
codestr[nid] <- paste0("[SAS](",linkgithub, "code/", codesas,")")

codeR <- list.files(path = codedir, pattern = "MATH60604.*.R")
codeRstr <- rep("", ns)
nid <- na.omit(pmatch(substr(codeR,11,12), index))
codeRstr[nid] <- paste0("[R](",linkgithub,"code/", codeR,")")


sldat <- data.frame('S' = index0, 
                    Contenu = names,
                    Diapos = sl,
                    PDF = slpdf,
                    Vidéos = videosl,
                    SAS = codestr,
                    R = codeRstr)
