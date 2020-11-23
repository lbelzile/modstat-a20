/* Statistiques descriptives, données "melanome" */
proc means data=modstat.melanome;
var temps age annee epaisseur;
run;

proc freq data=modstat.melanome;
  tables statut ulcere;
run;

/* Estimateur de Kaplan-Meier */
proc lifetest data=modstat.melanome method=km plots=(s(cl)) rmst;
time temps*statut(0);
run;

/* Modèle de Cox à risques proportionnels */
proc phreg data=modstat.melanome;
model temps*statut(0)= sexe age epaisseur ulcere / ties=exact; 
run;
