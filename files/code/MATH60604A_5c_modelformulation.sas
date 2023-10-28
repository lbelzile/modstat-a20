/* Fit a linear model with REML (default method)
For maximum likelihood, use method=ml */
proc mixed data=statmod.revenge method=reml;
model revenge = sex age vc wom t / solution;
run;