data revenge; 
set statmod.revenge;
tcat=t;
run;

/* Linear regression with heterogeneous first order autoregressive model ARH(1) for the errors */

proc mixed data=revenge method=reml;
class id tcat;
model revenge = sex age vc wom t / solution;
repeated tcat / subject=id type=arh(1) r=1 rcorr=1; 
run;

 /* Linear regression with unstructured covariance for the errors */
proc mixed data=revenge method=reml;
class id tcat;
model revenge = sex age vc wom t / solution;
repeated tcat / subject=id type=un r=1 rcorr=1; 
run;
