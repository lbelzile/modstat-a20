/* Model with random slopes and random intercepts for chicken weight */
proc mixed data=statmod.chicken;
class chick diet;
model weight = diet time / solution;
random intercept time / type=vc subject=chick(diet);
/* Default covariance for random is VC (uncorrelated random effects) */
run; 

/* Should we correlate the random effects? */
proc mixed data=statmod.chicken;
class chick diet;
model weight = diet time / solution;
random intercept time / type=un subject=chick(diet);
/* Components are numbered in the order they appear */
run; 

/* To compare the model with VC (Omega diagonal) versus correlated, 
we can do a likelihood ratio test with H0: omega_{12}=0 */
data pval;
pval = 1-CDF("chisq", 4866.9-4803.8, 1);
run;

proc print data=pval;
var pval;
run;
/* Overwhelming evidence that the slope and intercept are correlated
coefficient omega_{12} is negative here, with correlation of -0.98! */


/* Instead of having a fixed effect for diet, 
we could consider having a random effect
however, chick are nested within diet. 
It's no issue in general as long as ID are unique */
proc mixed data=statmod.chicken;
class chick diet;
model weight = time / outp=pred3 outpm=pred2;
/* outpm is for the marginal mean (Xbeta), outp is for conditional mean */
random intercept time / type=un subject=chick(diet);
/* Chick nested within diet: syntax is ``child(parent)`` */
random intercept / subject=diet solution;
/* Can have multiple random statements on the same line */
run; 

/* Fit different lines for each individual 
(fixed group effect, for illustration purpose only) */
proc mixed data=statmod.chicken;
class chick diet;
model weight = diet chick|time / outpm = pred1;
run; 

/* Creat counters 1...n to merge databases together */
data pred1;
set pred1;
id = _N_;
pred1 = pred;
keep pred1 time diet chick id;
run;

data pred2;
set pred2;
id = _N_;
pred2 = pred;
keep pred2 time diet chick id;
run;

data pred3;
set pred3;
id = _N_;
pred3 = pred;
keep pred3 time diet chick id;
run;
/* Merge databases and map wide to long format*/
data pred;
merge pred1 pred2 pred3;
by id;
pred = pred1; type = "no pooling"; output;
pred = pred2; type = "full pooling"; output;
pred = pred3; type = "partial pooling"; output;
drop pred1 pred2 pred3;
run;

/* Panel plots of predicted values for four selected chicks (one in each diet group) */
proc sgpanel data=pred(where=(chick='18' OR chick='24' OR chick='33' OR chick='44'));
panelby chick;
series x=time y=pred / group=type;
run;

