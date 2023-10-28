*1.1 (e) Histogram of travel time;
data renfe_tgv;
set statmod.renfe;
where type in ("AVE-TGV","AVE");
run;

proc sgplot data=renfe_tgv;
title1 "Histogram of travel time";
histogram duration;
label duree= "travel time";
run;

* 1.1 (e) Quantile-quantile plot;

proc univariate data=renfe_tgv noprint;
qqplot duration / normal(mu=est sigma=est color=red l=2) square ;
title "Normal quantile-quantile plot";
run;


*1.2 (i); Coverage rate;
 
data renfe_coverage;
set statmod.renfe_simu;
if(lbci < -0.28 < ubci) then coverage=1; 
else coverage = 0;
run;

proc means data=renfe_coverage mean;
var coverage;
run;


*1.2 (b) Histogram of mean price difference;


proc sgplot data=statmod.renfe_simu noautolegend;
histogram meandif;
refline -0.28 / axis=x lineattrs=(color=red pattern=dash);
label meandif="Mean price difference (in euros)";
run;

*1.2 (c) Power calculation;

data renfe_power;
set statmod.renfe_simu;
if(pval < 0.05) then reject=1;
 else reject=0;
run;

proc means data=renfe_power mean;
var reject;
run;

* 1.3 one-sample t-test;

data renfe_avetgv;
set statmod.renfe;
where type="AVE-TGV";
drop type;
run;

proc ttest data=renfe_avetgv alpha=0.1 h0=43.25;
var price;
title "One-sample t-test";
run;



/* 1.4(a):  Exploratory data analysis */

data insurance;
set statmod.insurance;
if(bmi >= 30) then obese=1; else obese=0;
run;

proc means data = insurance mean std min max q1 median q3 maxdec=2;
var charges bmi;
run;
ods layout Start width=10in height=6in;
ods region x=0% y=0% width=50% height=33%;
ods graphics / noborder;
proc sgplot data = insurance;
histogram charges;
run;

ods region x=50% y=0% width=50% height=33%;
proc sgplot data = insurance;
histogram bmi;
run;

/* Following plot show clear evidence of subgroups
and linear trend within each cluster + heteroscedasticity */
ods region x=0% y=33% width=50% height=33%;
proc sgplot data=insurance noautolegend;  
scatter y=charges x=age;
run;

ods region x=50% y=33% width=50% height=33%;
proc sgplot data=insurance noautolegend;  
scatter y=charges x=bmi;
run;
ods region x=0% y=66% width=50% height=33%;
proc sgplot data=insurance;
vbox charges / category=region;
run;
ods region x=50% y=66% width=50% height=33%;
proc sgplot data=insurance;
vbox charges / category=smoker;
run;
ods layout end;

proc sgplot data=insurance;
  title "Charges (in dollars) as a function of body mass index for smokers and non-smokers.";
  scatter y=charges x=bmi / group smoker;
run;

/* Three clusters visible on scatterplot age versus charges
    Smokers and obese face higher charges */

data insurance;
set statmod.insurance;
if (obese=1 & smoker="yes") then smobese=1; 
else if (obese=0 & smoker="yes") then smobese=2; 
else smobese=3;
run;

proc sgplot data=insurance;
  title "Charges (in dollars) according to obesity and smoking status";
  scatter y=charges x=bmi / group smoker;
run;



* 1.4(b) compare charges paid by smokers vs non-smokers;
 
proc ttest data=insurance;
class smoker;
var charges;
run;



* 1.4(c): compare charges between obese smokers and non-obese smokers;

/* Extract smokers from database */

data insurance_smoker;
set insurance;
if smoker=1;
run;


proc sgplot data=insurance_smoker;
vbox charges/ category=obese;
run;

proc ttest data=insurance_smoker sides=l alpha=0.05; 
/* change value of alpha to get different confidence intervals*/
class obese;
var charges;
run;



