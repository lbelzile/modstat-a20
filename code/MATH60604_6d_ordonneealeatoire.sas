data vengeance; 
set modstat.vengeance;
tcat=t;
run;


/* Données sur la mobilisation - l'effet aléatoire sur l'ordonnée à l'origine
induit la même structure de dépendance pour la covariance marginale de Y qu'un modèle d'équicorrélation pour les erreurs */
proc mixed data=modstat.mobilisation method=reml; 
class idunite; 
model mobilisation = sexe anciennete agegest nunite / solution; 
repeated / subject=idunite type=cs r=1 rcorr=1; 
run;

proc mixed data=modstat.mobilisation; 
class idunite; 
model mobilisation = sexe anciennete 
       agegest nunite / solution; 
random intercept / subject=idunite v=1 vcorr=1; 
run;

/* Ordonnée à l'origine aléatoire et erreurs autocorrélées */
proc mixed data=vengeance; 
class id tcat; 
model vengeance = sexe age vc wom t / solution;
random intercept / subject=id v=1 vcorr=1; 
repeated tcat / subject=id type=ar(1) r=1 rcorr=1;
run;
