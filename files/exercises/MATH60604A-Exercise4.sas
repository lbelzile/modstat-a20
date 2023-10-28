/* Exercise 4.1 */

data profsalary;
set statmod.profsalary;
if(salary > 105000) then salbi=1; else salbi=0;
run;

proc logistic data=profsalary;
model salbi(ref="0") = degree sex yr yd / plrl;
run;

proc logistic data=profsalary;
class rank(ref="1");
model salbi(ref="0") = degree sex yr yd rank / plrl;
run;

/* Exercise 4.2 */

proc genmod data=statmod.awards;
class prog(ref="1");
model nawards = prog math / dist=poisson link=log;
run;

proc genmod data=statmod.awards;
class prog(ref="1");
model nawards = prog math / dist=negbin link=log;
run;

data pval;
pval=(1-cdf('chisq', 1.6938, 1))/2;
run;
proc print data=pval;
run;

/* Exercise 4.3 */
data ceb;
set statmod.ceb;
lognwom = log(nwom);
mceb = nceb/nwom;
run;

proc sgplot data=ceb;
scatter x=nwom y=nceb;
yaxis type=log label="number of children ever born (log)";
xaxis type=log label="number of women (log)";
run;

proc sgplot data=ceb;
scatter x=mceb y=var;
xaxis label="mean of the number of children ever born";
yaxis label="variance of the number of children ever born";
run;


proc genmod data=ceb plots=(resdev leverage);
class res(ref="1") dur(ref="1") educ(ref="1");
model nceb = res dur educ / 
	offset=lognwom dist=poisson link=log type3 lrci;
run;

proc genmod data=ceb plots=(resdev(xbeta) leverage cooksd);
class res(ref="1") dur(ref="1") educ(ref="1");
model nceb = res dur educ lognwom / 
	dist=poisson link=log type3 lrci;
output out=residceb stdresdev=devres;
run;

proc univariate data=residceb noprint;
qqplot devres;
run;


proc genmod data=ceb;
class res(ref="1") dur(ref="1") educ(ref="1");
model nceb = res dur educ / 
	offset=lognwom dist=poisson link=log type3;
run;

proc genmod data=ceb;
class res(ref="1") dur(ref="1") educ(ref="1");
model nceb = res dur educ dur*educ / 
	offset=lognwom dist=poisson link=log type3;
run;
 /* Exercice 4.4 */
proc genmod data=statmod.bixi;
class weekend;
model nusers = weekend / type3 dist=poisson link=log;
run;

proc genmod data=statmod.bixi;
class weekend;
model nusers = temp relhumid weekend / type3 dist=poisson link=log;
run;

data pval;
pval = 1-CDF("chisq", 2726.9674 - 1954.0018, 2);
run;
proc print data=pval;
var pval;
run;

proc genmod data=statmod.bixi;
class weekend;
model nusers = temp relhumid weekend / type3 dist=negbin link=log;
run;

proc genmod data=statmod.bixi;
class weekday;
model nusers = temp relhumid weekday / type3 dist=negbin link=log;
run;

/* Comparison of the model with a binary indicator per day and week-end
Likelihood ratio test */
data pval;
pval = 1-CDF("chisq", 522.3013 - 521.9627, 496-491);
run;
proc print data=pval;
var pval;
run;


/* Exercise 4.5 */

proc genmod data=statmod.socceragg;
class home away;
model counts= home away / dist=poisson link=log;
run;

data pval;
pval = 1-cdf("chisq", 43.8008, 36);
run;

proc print data=pval;
var pval;
run;


proc genmod data=statmod.soccer;
class team opponent;
model score = team opponent home / lrci type3 dist=poisson link=log;
store model_store;
run;

data newmatch;
length opponent $25;
length team $25;
infile datalines delimiter=",";
input  home team opponent;
datalines;
1, Manchester United, Liverpool
0, Liverpool, Manchester United
;
run;

proc plm source=model_store;
score data=newmatch out=pred pred=pred / ilink;
run;

proc print data=pred;
var pred;
run;
proc genmod data=statmod.soccer;
class team opponent;
model score = team opponent home home*team home*opponent / type3 dist=poisson link=log;
run;

data pval;
pval = 1-cdf("chisq", 2*(1082.6660-1058.7364), 720-682);
run;

proc print data=pval;
var pval;
run;

/* Exercise 4.6 */
data buch;
set statmod.buchanan(keep=buch totmb popn);
tot = buch + totmb;
buchp = buch/(buch + totmb);
lnpopn = log(popn);
run;

proc means data=buch;
var buchp;
run;

proc means data=buch sum;
var buch tot;
run;

proc sgplot data=buch;
scatter x=lnpopn y=buchp;
xaxis label="log of county population";
yaxis label="percentage of ballots cast for Buchanan";
run;

data buchanan;
set statmod.buchanan;
lnhisp = log(hisp);
lncoll = log(coll);
if(county="Palm Beach") then bucha=.; else bucha=buch;
lntotmb = log(totmb);
run;

proc genmod data=buchanan;
model bucha = white lnhisp geq65 highsc lncoll income / offset=lntotmb dist=pois link=log;
run; 

proc genmod data=buchanan;
model bucha = white lnhisp geq65 highsc lncoll income / offset=lntotmb dist=negbin link=log;
store model_store;		
run; 

data pval;
pval = (1-cdf("chisq", 2*(536.1785-328.8532), 1))/2;
run;

proc print data=pval;
var pval;
run;

proc plm source=model_store;
score data=buchanan out=preds pred=pred lclm=lower uclm=upper / ilink;
run;

data preds;
set preds(where=(county="Palm Beach"));
keep county pred lower upper;
run;

proc print data=preds;
var county pred lower upper;
run;



