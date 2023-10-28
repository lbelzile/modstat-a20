/* Fitting linear models using genmod and glimmix */

proc genmod data=statmod.intention;
class educ revenue;
model intention=sex age revenue educ marital
fixation emotion / dist=normal link=identity;
run;

proc glimmix data=statmod.intention;
class educ revenue; 
model intention=sex age revenue educ marital 
  fixation emotion / solution dist=normal link=identity; 
run;

