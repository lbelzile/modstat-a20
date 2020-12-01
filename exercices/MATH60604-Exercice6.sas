/* Modèle 1 */
proc mixed data=modstat.gsce;
class centre;
model resultat = score sexe / solution;
repeated / subject=centre type=cs;
run;

/* Modèle 2 */
proc mixed data=modstat.gsce;
class centre;
model resultat = resultat sexe centre / solution;
run;

/* Modèle 3 */
proc mixed data=modstat.gsce;
class centre;
model resultat =  score sexe / solution;
random intercept / subject=centre solution;
run;

