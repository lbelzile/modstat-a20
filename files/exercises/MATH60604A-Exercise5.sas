/* Exercise 5.1 */

data renergie;
set statmod.renergie;
marg = ave-min;
run;

/* Spaghetti plot for longitudinal data */
proc sgplot data=renergie;
series x=date y=marg / group=region;
run;

/* Model with no correlation */
proc mixed data=renergie method=reml;
class date region(ref="11");
model marg=region / solution ddfm=satterth;
run;

/* Model with AR(1) correlation */
proc mixed data=renergie method=reml;
class date region(ref="11");
model marg=region / solution ddfm=satterth;
repeated date / subject=region type=ar(1);
run;

/* Model with AR(1) correlation
  Different parameters for each region */
proc mixed data=renergie method=reml;
ods output Mixed.Diffs=diffs;
class date region(ref="11");
model marg= region / solution ddfm=satterth;
repeated date / group=region subject=region type=ar(1);
/* Compute mean difference, but only relative to Gaspé */
lsmeans region / diff=control("11");
run;

/* Adjusted p-values - Stepdown Sidak */
data unadjustpvals;
set diffs;
keep probt;
rename probt=raw_p;
run;
proc multtest inpvalues=unadjustpvals stepsid;
run;



/* Exercise 5.2 */
/* Pre-process data*/
data baumann; 
set statmod.baumann;
dpp = mpost-mpre;
id = _N_;
run;

/* Transform from wide to long format */
proc transpose data=baumann out = baumann_long(rename=(col1=score)) name = test;
var mpre mpost;
by group id;
run;

/* Pre-test run by Baumann et al. */
proc glm data=baumann;
class group(ref="DR");
model mpre = group;
means group / hovtest welch;
lsmeans group / diff=all adjust=t;
run;

/* Model 5.2.1 */
proc mixed data=baumann;
class group(ref="DR");
model dpp = group / solution;
run;

/* Model 5.2.2 */
proc mixed data=baumann;
class group(ref="DR");
model mpost = group mpre / cl solution;
run;


/* Model 5.2.3 */
proc mixed data=baumann_long method=reml;
class id test group(ref="DR");
model score = group test group*test / solution;
repeated test / subject=id type=cs;
run;

/* Model 5.2.4 */
proc mixed data=baumann_long method=reml;
class id test group(ref="DR");
model score = group test group*test / solution;
repeated test / subject=id type=un;
run;


/* Model 5.2.5 */
proc mixed data=baumann_long method=reml;
class id test group(ref="DR");
model score = group test group*test / solution;
repeated test / group=group subject=id type=cs;
run;


/* Exercise 5.3 */
/* Descriptive statistics */
proc means data=statmod.tolerance(where=(age=11));
var sex exposure;
run;

proc means data=statmod.tolerance;
var tolerance;
run;

proc sgplot data=statmod.tolerance; 
title 'tolerance by sex';
vbox tolerance/ category = sex; 
run;

proc sgplot data=statmod.tolerance; 
title 'tolerance vs. exposure';
scatter y=tolerance x=exposure;
run;

proc sgplot data=statmod.tolerance; 
title 'tolerance vs. age';
vbox tolerance/ category = age;
run;

proc sgplot data=statmod.tolerance; 
title 'Spaghetti plot of tolerance';
series x=age y=tolerance / group=id; 
run;

proc mixed data=statmod.tolerance method=reml;
class id;
model tolerance = sex exposure age / solution;
repeated / subject=id type=cs;	
run;

data tolerance;
set statmod.tolerance;
time = age;
run;

proc mixed data=tolerance method=reml;
class id time;
model tolerance = sex exposure age / solution;
repeated time / subject=id type=ar(1);	
run;

proc mixed data=tolerance method=reml;
class id time;
model tolerance = sex exposure age / solution;
run;

