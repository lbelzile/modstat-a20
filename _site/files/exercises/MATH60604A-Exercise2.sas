
/* Exercise 2.5 (windturbine) */

data windturbine;
set statmod.windturbine;
invvelo = 1/velocity;
run;

* Exercise 2.5 (a);
/* default plot option when "ods graphics on" is enabled  is "plots=diagnostics" */
ods graphics on;
proc glm data=windturbine plots=fitplot residuals(smooth);
model output=velocity / ss3 solution;
store model1;
run;

proc glm data=windturbine plots=fitplot residuals(smooth);
model output=invvelo / ss3 solution;
output out=resid predicted=fitted r=ores rstudent=jsr;
store model2;
run;

* Exercise 2.5 (b);
data newdata;
   input velocity invvelo;
   datalines;
5 0.2
; 

proc plm restore=model1;
score data=newdata out=prediction1 predicted lcl ucl;
run; 
proc plm restore=model2;
score data=newdata out=prediction2 predicted lcl ucl;
run; 

proc print data=prediction1;
run;
proc print data=prediction2;
run;

/* Quantile-quantile plot */
* Create copy of dataset;
data QQdata;
set resid;
keep jsr;
run; 

* Exercise 2.5 (c);
proc glm data=windturbine noprint plots=none;
model output=velocity / ss3 solution noint;
output out=nointercept r=ores;
run;

proc means data=nointercept mean;
var ores;
run;

* Exercise 2.5 (d);
* Sort jackknife studentized residuals;
proc sort data=QQdata;
by jsr;
run;

data QQdata;
set QQdata nobs = n;
/* plotting positions */
u = _N_ / (n + 1); 
/* Degrees of freedom is n-k-1
where k is number of betas (2 for SLR) */
q = quantile("T", u, n - 3); 
drop u;
run;
 
proc sgplot data=QQdata noautolegend aspect=1;
scatter x=q y=jsr;
lineparm x=0 y=0 slope=1;
xaxis label="Theoretical Student quantiles" grid; 
yaxis label="Observed quantiles" grid;
run;

/* Exercise 2.6 */

data intention;
set statmod.intention;
if(revenue=1) then revenue1=1; else revenue1=0;
if(revenue=2) then revenue2=1; else revenue2=0;
run;

proc glm data=intention;
model intention=revenue1 revenue2  / ss3 solution;
run;

proc glm data=intention;
class revenue;
model intention=revenue / ss3 solution;
run;


proc glm data=intention;
model intention=revenue / ss3 solution;
run;

/* Exercise 2.7 */
proc glm data=statmod.auto plots=diagnostics;
model mpg=horsepower / ss3 solution;
run;

proc glm data=statmod.auto plots=diagnostics;
model mpg=horsepower horsepower*horsepower / ss3 solution;
run;

proc glm data=statmod.auto plots=diagnostics;
model mpg=horsepower horsepower*horsepower
 horsepower*horsepower*horsepower / ss3 solution;
run;

/* Exercise 2.8 */

proc glm data=statmod.intention;
class educ;
model intention=fixation educ / ss3 solution;
run;

proc glm data=statmod.intention;
class educ;
model intention=fixation educ fixation*educ/ ss3 solution;
run;

proc glm data=statmod.intention;
class educ revenue;
model intention=revenue educ fixation emotion marital age sex / ss3 solution;
run;

/* Exercise 2.9 */

data airpass;
set statmod.airpassengers;
yt = year-1949;
lnpassengers = log(passengers);
run;

proc glm data=airpass plots=diagnostics;
model passengers=year / ss3 solution;
run;

proc glm data=airpass;
model passengers=yt / ss3 solution;
run;

proc glm data=airpass plots=diagnostics;
class month;
model passengers=yt month / ss3 solution;
run;

proc glm data=airpass plots=diagnostics;
class month;
model lnpassengers=yt month / ss3 solution;
run;
