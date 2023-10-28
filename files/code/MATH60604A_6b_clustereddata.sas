
/* Motivation data - random effect and CS induce the same correlation structure */
proc mixed data=statmod.motivation method=reml; 
class idunit; 
model motiv = sex yrserv agemanager nunit / solution; 
repeated / subject=idunit type=cs r=1 rcorr=1; 
run;

proc mixed data=statmod.motivation; 
class idunit; 
model motiv = sex yrserv 
       agemanager nunit / solution; 
random intercept / subject=idunit v=1 vcorr=1; 
run;
