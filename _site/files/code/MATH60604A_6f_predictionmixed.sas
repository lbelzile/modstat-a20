/* Prediction for the motivation data */
proc mixed data=statmod.motivation;
class idunit;
model motiv = sex yrserv agemanager nunit / solution;
random intercept / subject=idunit solution;
ods output Mixed.SolutionR=re;
run;

data newdata; 
input nunit idunit employe yrserv sex motiv agemanager; 
cards; 
9 1 10 5 0 . 40 
9 101 1 5 0 . 40
; 
run; 

/* append newdata to motivation */
data motivation; 
set statmod.motivation newdata; 
run;

proc mixed data=motivation; 
class idunit; 
model motiv = sex yrserv agemanager nunit 
     / solution outp=prediction outpm=mean; 
random intercept / subject=idunit type=vc; 
run;

data tempmean;
set mean;
if _N_ LE 1016 then delete;
run;

proc print data=tempmean noobs;
var idunit pred stderrpred;
run;

data temppred;
set prediction;
if _N_ LE 1016 then delete;
run;

proc print data=temppred noobs;
var idunit pred stderrpred;
run;

