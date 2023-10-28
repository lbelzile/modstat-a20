 /* Create a copy of 't' because we need both continuous (for mean model) and categorical (for "repeated" command) */

data revenge; 
set statmod.revenge;
tcat=t;
run;

/* Linear regression with AR(1) structure for the errors */

proc mixed data=revenge method=reml;
class id tcat;
model revenge = sex age vc wom t / solution;
repeated tcat / subject=id type=ar(1) r=1 rcorr=1; 
run;

