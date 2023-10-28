/* Descriptive statistics */ 
proc means data=statmod.breastcancer ;
var time;
run;

proc freq data=statmod.breastcancer;
  tables death im;
run;

/* Kaplan-Meier estimator of survival curve */
proc lifetest data=statmod.breastcancer method=km plots=(s(cl)) ;
time time*death(0);
run;

proc lifetest data=statmod.breastfeeding method=km plots=(s(cl)) ;
time duration*delta(0);
run;
