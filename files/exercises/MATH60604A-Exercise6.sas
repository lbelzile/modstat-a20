/* Exercise 6.1 */
proc mixed data=statmod.goldstein method=reml;
class school denom(ref="other") type(ref="mixed") VR(ref="3");
model score = LRT VR gender type denom / solution;
random intercept / subject=school v=37 vcorr=37 solution cl;
ods output Mixed.SolutionR=re;
run;

/* Quantile-quantile plot of predicted random effects */
proc univariate data=re noprint;
qqplot estimate / normal(mu=est sigma=est l=2)
square;
run;

proc sort data=re;
by estimate;
run;

/* Caterpillar plot */
proc sgplot data=re;
scatter x=estimate y=subject / xerrorlower=lower
xerrorupper=upper
markerattrs=or;
 refline 0 / axis=x;
 xaxis label="predicted random effect with 95% prediction interval ";
 yaxis label="school";
run; 

/* Ranking of schools, including predicted random effect */

/* First sort data and keep only one instance of school */
proc sort nodupkey data=statmod.goldstein out=pred_gold;
by school;
run;

/* Set all individual-specific variables to a common value 
Add missing observations for score */
data pred_gold;
set pred_gold;
lrt = 0;
gender = 0;
VR = 1;
score = .;
run;

/* Merge these with the other database */
data pred_gold;
set pred_gold statmod.goldstein;
run;

/* Re-fit the model and get conditional predictions */
proc mixed data=pred_gold method=reml;
class school denom(ref="other") type(ref="mixed") VR(ref="3");
model score = LRT VR gender type denom / solution outp=pred_gold_score;
random intercept / subject=school solution;
run;

/* Keep only one ranking per school for lambda student */
data pred_gold_score;
set pred_gold_score(where=(score eq .));
run;
/* Sort the predictions from largest to smallest */
proc sort data=pred_gold_score;
by descending pred;
run;
 

/* Exercise 6.2 */
/* Model 1 */

proc mixed data=statmod.gsce;
class center;
model result = coursework sex / solution;
repeated / subject=center type=cs;
run;

/* Model 2 */
proc mixed data=statmod.gsce;
class center;
model result = coursework sex center / solution;
run;

/* Model 3 */
proc mixed data=statmod.gsce;
class center;
model result = coursework sex / solution;
random intercept / subject=center solution;
run;

