
/* -------------------------------------- */
/* Solutions pour l'introduction à SAS */

/* Exercice 1 */
/* ---------- */
/*  Les questions 1 à 4 ne requiert pas de code.
    Les effets des commandes sont décrits car ils
	servent dans les exercices subséquents.  */

/* Création de la bibliothèque MULTI */

/* Exercice 2 */
/* ---------- */
/* Le jeu de données ELNINO est maintenant disponible dans le bibliothèque "multi". */

/* Exercice 3 */
/* ---------- */
/* Le jeu de données AAPL est maintenant disponible dans la bibliothèque "multi". */

/* Créer une copie locale pour SAS onDemand*/



/* Exercice 5 */
/* ---------- */

 data aapl;
  set multi.aapl;
 run;

  proc sort data=aapl;
    by date;
  run;

  data aapl2; /* jeu de donnée temporaire créé dans la bibliothèque "work" */
    set multi.aapl;
	diff = high - low;  							/* Question a) */
	aug  = (close-open)/open*100;   				/* Question b) */
    if (close GT open) then aaug = 1; else aaug = 0;  /* Question c) */
    adj_aug = dif(adj_close) / lag(adj_close) * 100;	/* Question d) */
  run;


/* Exercice 6 */
/* ---------- */
  proc means data=aapl2 N NMISS MIN MAX RANGE MEAN VAR STD;
    var diff aug aaug adj_aug;
  run;

/* Exercice 7 */
/* ---------- */

  proc means data=aapl2 N NMISS MIN MAX RANGE MEAN VAR STD;
    var diff aug aaug adj_aug;
  run;


  /* Note: il existe d'autres format pour les sorties 
  (on pourrait remplacer rtf par html ou pdf)*/

/* Exercice 8 */
/* ---------- */
  ods trace on;
  proc means data=aapl2 mean;
    var diff aug aaug adj_aug;
  run;
  ods trace off;
/* Le fichier log contient la sortie:

  Output Added:
-------------
Name:       Summary
Label:      Summary statistics
Template:   base.summary
Path:       Means.Summary

*/

  proc means data=aapl2 mean;
    var diff aug aaug adj_aug;
    ods output  Means.Summary=moyennes;
  run;

/* le jeu de données  "moyennes" est créé dans la bibliothèque "work" */
/* Pour déterminer le nom des variables dans le jeu de données, 
    on peut utiliser proc contents */

  proc contents data=moyennes;
  run;


/* Exercice 9 */
/* ---------- */

/* Pour exporter sur une machine Windows avec SAS de base, 
décommentez les fonctions suivantes
ods graphics on; 
ods rtf;
*/
proc sgplot data=aapl2;          
histogram aug;
run;
/* Idem, décommenter
ods rtf close;
ods graphics off; 
*/



  
