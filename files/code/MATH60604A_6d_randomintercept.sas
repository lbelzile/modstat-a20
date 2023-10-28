data revenge; 
set statmod.revenge;
tcat=t;
run;


/* Random intercept, independent errors */
proc mixed data=statmod.motivation;
class idunit;
model motiv = sex yrserv agemanager nunit / solution;
random intercept / subject=idunit v=1 vcorr=1;
run;

/* Random intercept and AR(1) correlation for the errors */
proc mixed data=revenge; 
class id tcat; 
model revenge = sex age vc wom t / solution;
random intercept / subject=id v=1 vcorr=1 solution;
/* adding a table of predicted random effects in
previous line so we can create a Q-Q plot */
repeated tcat / subject=id type=ar(1) r=1 rcorr=1;
/* Save only this table of predicted random intercepts*/
ods output Mixed.SolutionR=raneff;
run;


/* Quantile-quantile plot of predicted random effects */
proc univariate data=raneff noprint;
qqplot estimate / normal(mu=est sigma=est l=2)
square;
run;
