/* Descriptive statistics */
proc means data=statmod.melanoma ;
var time age year thickness;
run;

proc freq data=statmod.melanoma;
  tables status ulcer;
run;

/* Cox proportional hazards model */
proc phreg data=statmod.melanoma ;
model time*status(0)= sex age thickness ulcer / ties=exact; 
run;

