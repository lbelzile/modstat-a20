/* Poisson model for intention to buy data */

proc genmod data=statmod.intention;
class educ revenue;
model nitem=sex age revenue educ marital
     fixation emotion / dist=poisson link=log lrci type3;
run;


/* Negative binomial regression */


proc genmod data=statmod.intention;
class educ revenue;
model nitem=sex age revenue educ marital
     fixation emotion / dist=negbin link=log lrci type3;
run;

/* P-value of the likelihood ratio test H0:k=0 vs H1:k>0 */

data pval;
pval=(1-CDF('CHISQ',23.08,1))/2;
run;
proc print data=pval;
run;

/* Ordinary regression for log(1+nitem) */

data temp;
set statmod.intention;
lognitem = log(1+nitem);
run;
 
proc genmod data=temp;
class educ revenue;
model lognitem=sex age revenue educ marital
     fixation emotion / dist=normal link=identity lrci type3;
run;
/* WARNING: cannot compare the log-linear and the Poisson model
because they are not based on the same response (1+nitem) versus nitem */


