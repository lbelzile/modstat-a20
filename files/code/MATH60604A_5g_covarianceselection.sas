/* Collect manually AIC/BIC and REMl -2ll from output */

/* Manual calculation of the p value for rho in the AR(1) model using a likelihood ratio test */

data pval;
pval=1-CDF('CHISQ',94.9,1);
run;
proc print data=pval;
run;
