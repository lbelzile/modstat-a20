/* Comparing survival curves */
proc lifetest data=statmod.breastcancer method=km plots=(s) ;
time time*death(0);
strata im;
run;

/* The log rank test is the score test
for the partial likelihood of the Cox proportional
hazard model H0: same hazard -> same survival function */
proc phreg data=statmod.breastcancer;
model time*death(0) = im;
run;

