/* FIRST EXAMPLE */

/* Transform from wide to long format 
https://stats.idre.ucla.edu/sas/modules/how-to-reshape-data-wide-to-long-using-proc-transpose
*/
proc print data=statmod.dental(where=(id LE 5));
run;

proc transpose data=statmod.dental
	out = dental_long(rename=(col1=dist)) /* Rename response */
	name = y;
var y1-y4; /* Variables to stack */
by id gender; /* Variables to keep - must be ORDERED */
run;

data dental_long;
  set dental_long;
  time=input(substr(y, 2), 1.);
  drop _label_ y;
run; 

data dental;
set statmod.dental;
   dist=y1; age=8;  t=1; output;
   dist=y2; age=10; t=2; output;
   dist=y3; age=12; t=3; output;
   dist=y4; age=14; t=4; output;
   drop y1 y2 y3 y4;
run;



/* SECOND EXAMPLE */

/* Using proc tranpose */

data beattheblues;
set statmod.beattheblues;
id = _N_;  /* Create indicator variable */
run;

proc sort data=beattheblues;
by id drug length treatment;
run;

proc transpose data=beattheblues out=beattheblues_long;
var bdi0 bdi2 bdi4 bdi6 bdi8;
by id drug length treatment;
run;

data beattheblues_long;
set beattheblues_long;
 month=input(substr(_name_, 4), 3.);
  drop _label_ _name_;
  rename col1=bdi;
run;

/* Manually stack series */
data beattheblues;
set beattheblues;
   bdi=bdi0; month=0; t=1; output;
   bdi=bdi2; month=2; t=2; output;
   bdi=bdi4; month=4; t=3; output;
   bdi=bdi6; month=6; t=4; output;
   bdi=bdi8; month=8; t=5; output;
   drop bdi0 bdi2 bdi4 bdi6 bdi8;
run;

/* Spaghetti plot */
proc sgplot data=beattheblues;
series x=month y=bdi / group = id grouplc= treatment;
run;

