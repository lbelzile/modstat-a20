/* Copy time variable t */
data revenge; 
set statmod.revenge;
tcat=t;
run;

/* To compare models with different "fixed" effects (i.e., betas)
 using information criteria, we need to fit them using maximum likelihood
  Fit model with only time effect and AR(1) covariance structure */
proc mixed data=revenge method=ml; 
class tcat id; 
model revenge = id t / solution; 
repeated tcat / subject=id; 
run;

proc mixed data=revenge method=ml; 
class tcat id; 
model revenge = id sex age vc wom t / solution; 
repeated tcat / subject=id type=ar(1); 
run;

