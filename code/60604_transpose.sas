/* Transformer une base de donnée de format court à format long
https://stats.idre.ucla.edu/sas/modules/how-to-reshape-data-wide-to-long-using-proc-transpose
*/
proc print data=modstat.dentaire(where=(id LE 5));
run;

proc transpose data=modstat.dentaire
	out = dentaire_long(rename=(col1=dist)) /* Renommer la réponse */
	name = y;
var y1-y4; /* variables à empiler */
by id genre; /* variables à conserver */
run;

data dentaire_long;
  set dentaire_long;
  time=input(substr(y, 2), 1.);
  drop _label_ y;
run; 

data dentaire;
set modstat.dentaire;
   dist=y1; age=8;  t=1; output;
   dist=y2; age=10; t=2; output;
   dist=y3; age=12; t=3; output;
   dist=y4; age=14; t=4; output;
   drop y1 y2 y3 y4;
run;


