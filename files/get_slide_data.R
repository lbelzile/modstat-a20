index <- c("0_","1a","1b","1c", 
           paste0(2,letters[1:9]), 
           "3_", paste0(4,letters[1:8]),
           paste0(5, letters[1:8]),
           paste0(6, letters[1:6]),
           paste0(7, letters[1:5]))
index0 <- c("0","1a","1b","1c", 
            paste0(2,letters[1:9]), 
            "3", paste0(4,letters[1:8]),
            paste0(5, letters[1:8]),
            paste0(6, letters[1:6]),
            paste0(7, letters[1:5]))
names <- c("Course Outline",
           "Hypothesis Tests",
           "Central Limit Theorem",
           "Exploratory Data Analysis",
           "Parameter interpretation",
           "Linear transformations",
           "Geometry of least squares",
           "Hypothesis tests",
           "Coefficient of determination",
           "Predictions",
           "Interactions",
           "Collinearity",
           "Diagnostic plots",
           "Likelihood-based inference",
           "Generalized linear models",
           "Logistic regression",
           "Example of logistic regression",
           "Poisson regression",
           "Contingency tables",
           "Overdispersion",
           "Rates and offsets",
           "Logistic model for proportions",
           "Introduction to correlated data",
           "Example of longitudinal data",
           "Model formulation",
           "Compound symmetry covariance",
           "Autoregressive covariance",
           "Other covariance models",
           "Selection of covariance structures",
           "Group heteroscedasticity",
           "Group effects",
           "Clustered data example",
           "Random effects",
           "Random intercept",
           "Random slope",
           "Prediction for mixed models",
           "Survival analysis and censoring",
           "Likelihood for survival data",
           "Kaplan-Meier estimator",
           "Cox proportional hazard model",
           "Log rank test"
           )
ns <- length(index)
url <- "https://lbelzile.github.io/MATH60604A-slides/"
codedir <- "../files/code"


get_github_list <- function(user, repo, pattern){
  req <- httr::GET(paste0("https://api.github.com/repos/", user, "/", repo, "/git/trees/main?recursive=1"))
  httr::stop_for_status(req)
  filelist <- unlist(lapply(httr::content(req)$tree,
                            "[", "path"), 
                     use.names = FALSE)
  grep(x = filelist, value = TRUE, pattern = pattern)
}


slides <- get_github_list(user = "lbelzile", 
                          repo = "MATH60604A-slides",
                          pattern = "MATH60604A_w.*\\.html")
sl <- rep("", ns)
pmasl <- na.omit(pmatch(substr(slides, start = 13, stop = 14), index))
sl[pmasl] <- paste0("[<span style='color: #4b5357;'><i class='fas fa-desktop fa-lg'></i></span>](",url, slides,")")

slidespdf <- get_github_list(user = "lbelzile", 
                             repo = "MATH60604A-slides",
                             pattern = "MATH60604A_w.*.pdf")
slpdf <- rep("", ns)
pmaslp <- na.omit(pmatch(substr(slidespdf, start = 13, stop = 14), index))
slpdf[pmaslp] <- paste0("[<span style='color: #4b5357;'><i class='fas fa-file-pdf fa-lg'></i></span>](",url, slidespdf,")")[1:ns]



video <- paste0("[<span style='color: red;'><i class='fab fa-youtube fa-lg'></i></span>](", 
          c("https://youtu.be/luOkCcpDSjs",
            "https://youtu.be/TSMuEX8FqYo",
            "https://youtu.be/nCUT05szKwQ",
            "https://youtu.be/5Yc46pAQpFk",
            "https://youtu.be/4jOnZrnPlUM",
            "https://youtu.be/MzmS9r-77lI",
            "https://youtu.be/F9dR6mpOVtI",
            "https://youtu.be/PatlZ9mlVuk",
            "https://youtu.be/3rVrZDReDCk",
            "https://youtu.be/AubAJT6fSHs",
            "https://youtu.be/dtpJ3pn_GmQ",
            "https://youtu.be/ENOVNBOdl6E",
            "https://youtu.be/iqfr_VK520M",
            "https://youtu.be/IO3et3Uk4mQ",
            "https://youtu.be/Ru9OXJTsToY", #4a
            "https://youtu.be/MabdSIYexmg", #4b
            "https://youtu.be/oGFsv1eBl6Y", #4c
            "https://youtu.be/ErqXeY4nGgk", #4d
            "https://youtu.be/1-F5vPk7_78", #4e
            "https://youtu.be/c5oQOIPBAeU", #4f
            "https://youtu.be/FLSAaWpHQso", #4g
            "https://youtu.be/pqkjnA708c8", #4h
            "https://youtu.be/2LRzsxZPatQ", #5a
            "https://youtu.be/MC1_W2G6Pos", #5b
            "https://youtu.be/bl0hI-YSWDQ", #5c
            "https://youtu.be/rhXjdr8vYzE", #5d
            "https://youtu.be/0o2p3lLUtBo", #5e
            "https://youtu.be/0-QR5EYnkGg", #5f
            "https://youtu.be/_LDX9RnF7A0", #5g
            "https://youtu.be/K2xJy2J6-ws", #5h
            "https://youtu.be/CVpRY1LYwU8", #6a
            "https://youtu.be/4yXP8B9mYzQ", #6b
            "https://youtu.be/HLYSs2lxFj8", #6c
            "https://youtu.be/oCuZajuIymk", #6d
            "https://youtu.be/IAzgrldsY48", #6e
            "https://youtu.be/-56kPe2FPwE", #6f
            "https://youtu.be/zs1LrAyHcco", #7a
            "https://youtu.be/-iQKIhUi65U", #7b
            "https://youtu.be/gpJY8JQhn6A", #7c
            "https://youtu.be/k6IUg3n0tiw", #7d
            "https://youtu.be/FK6Zr0MwhPs" #7e 
           ), ")")
if(length(names) - length(video) > 0){
  video <- c(video, rep("", length(names) - length(video)))
}
linkgithub <- "https://raw.githubusercontent.com/lbelzile/statmod/main/"

codesas <- list.files(path = codedir, pattern = "MATH60604A.*.sas")
codestr <- rep("", ns)
nid <- sapply(substr(codesas,12,13), function(x){which(x == index)})
codestr[nid] <- paste0("[<span style='color: #4b5357;'><i class='fas fa-file-code fa-lg'></i></span>](",linkgithub, "code/", codesas,")")

codeR <- list.files(path = codedir, pattern = "MATH60604A.*.R")
codeRstr <- rep("", ns)
nid <- sapply(substr(codeR,12,13), function(x){pmatch(x, index)})
codeRstr[nid] <- paste0("[<span style='color: #276dc2;'><i class='fab fa-r-project fa-lg'></i></span>](",linkgithub,"code/", codeR,")")


sldat <- data.frame('S' = index0, 
                    Content = names,
                    Slides = sl,
                    PDF = slpdf,
                    Videos =  video,
                    SAS = codestr,
                    R = codeRstr)
