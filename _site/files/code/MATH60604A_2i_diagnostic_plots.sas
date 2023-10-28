data insurance;
	set statmod.insurance;
	if(bmi >= 30) then obese = 1;
	else obese = 0;
	if(obese = 1 & smoker = "yes") then smobese="smoker/obese";
	else if(obese = 0 & smoker = "yes") then smobese ="smoker/non-obese";
	else smobese="non-smoker";
run;

proc glm data=insurance;
class smobese sex region;
model charges = smobese|bmi age sex region / solution ss3;
output out=resid predicted=fitted 
    r=ores rstudent=jsr;
run;

* Plot ordinary residuals against fitted values;
proc sgplot data=resid noautolegend;
scatter y=ores x=fitted;
loess y=ores x=fitted; 
xaxis label="fitted values";
yaxis label="ordinary residuals";
run;

* Plot ordinary residuals against body mass index;
proc sgpanel data=resid noautolegend;
panelby smoker / uniscale=row;
scatter y=ores x=bmi;
loess y=ores x=bmi; 
rowaxis label="ordinary residuals";
colaxis label ="body mass index";
run;

/* Plot residuals against omitted variable */
proc sgpanel data=resid noautolegend;
panelby sex / uniscale=row;
vbox  ores / category=children;
scatter  x=children y=ores / jitter transparency=0.6;
colaxis label="number of children";
rowaxis label="ordinary residuals"; 
run;



data resid;
set resid;
ajsr = abs(jsr);
run;

/* Checking heteroscedasticity 
We will cover tests for equality of variance in groups later
*/
proc sgplot data=resid noautolegend;
scatter y=ajsr x = fitted;
loess y=ajsr x = fitted;
yaxis label = "|jackknife studentized residuals|";
xaxis label = "fitted values";
run;


proc sgplot data=resid noautolegend;
vbox jsr / category=smobese;
yaxis label = "jackknife studentized residuals";
xaxis label = "smoker/obese status";
run;

data residqq; 
set resid;
keep jsr;
run;

proc sort data=residqq; by jsr; run; /* 1 */
data residqq;
set residqq nobs=nobs;
pp = _N_  / (nobs + 1);
/* Compute quantiles of order statistics
back-transform the latter to obtain 'approximate'
95% pointwise confidence intervals */
pplow = quantile("beta", 0.025, _N_, nobs + 1 - _N_);
pphigh = quantile("beta", 0.975, _N_, nobs + 1 - _N_);
q = quantile("t", pp, 1329);
qlow = quantile("t", pplow, 1329);
qhigh = quantile("t", pphigh, 1329);
qdet = jsr - q;
qdethigh = qhigh - q;
qdetlow = qlow - q;
run;
 
proc sgplot data=residqq noautolegend; 
band x=q upper=qhigh lower=qlow / fill transparency=.5 legendlabel="pointwise confidence intervals";
scatter x=q y=jsr;
lineparm x=0 y=0 slope=1; 
xaxis label="theoretical Student quantiles" grid; 
yaxis label="jackknife studentized residuals" grid;
run;

 
proc sgplot data=residqq noautolegend; 
band x=q upper=qdethigh lower=qdetlow / fill transparency=.5 legendlabel="pointwise confidence intervals";
lineparm x=0 y=0 slope=0; 
scatter x=q y=qdet;
xaxis label="theoretical Student quantiles" grid; 
yaxis label="jackknife studentized residuals (detrended)" grid;
run;

/* Create a correlogram of the data */
data airpassengers;
set statmod.airpassengers;
lnpassenger = log(passengers);
run;

proc glm data=airpassengers;
model lnpassenger = month year;
output out=airpassresid r=ores;
run;

proc timeseries data=airpassresid plots=(acf pacf);
var ores;
run;
