/* Exercise 7.1 */
proc lifetest data=statmod.breastfeeding method=km plots=(s(cl));
time duration*delta(0);
strata smoke;
run;

proc phreg data=statmod.breastfeeding;
model duration*delta(0) =  poverty smoke yschool agemth / ties=exact;
run;


/* Exercise 7.2 */
proc lifetest data=statmod.shoes method=km plots=(s(cl));
/* You can have multiple values as right-censored indicators */
time time*status(1,2);
/* Exclude the 6807+ lines table */
ods exclude ProductLimitEstimates;
run;

proc phreg data=statmod.shoes;
model time*status(1,2) = gender price / ties=exact;
run;

/* This code is not related to a question, 
but shows you how to obtain survival curves
from the Cox proportional hazard model */

/* Create sets of covariates for which you want the curve */
data shoes_prof;
input price gender;
datalines;
120 0
120 1
;
run;

/* Add plots for the profiles in "covariates=shoes_prof"
save estimated survival in variable s of work.shoes_sp */
proc phreg data=statmod.shoes plots(overlay)=survival;
model time*status(1,2)=gender price / ties=exact;
baseline out=shoes_sp covariates=shoes_prof survival=s; 
run;

