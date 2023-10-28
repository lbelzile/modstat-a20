* Global options;
options nodate nonumber;
* Create grid to arrange output tables;
ods layout gridded columns=2;
ods noproctitle;
ods region;
proc means data=statmod.intention mean std min max maxdec=2;
var intention sex age marital fixation emotion;
run;
proc freq data=statmod.intention;
tables revenue educ / nocum;
run;
ods region;
proc freq data=statmod.intention;
tables intention / nocum;
run;
ods layout end;

* Create a layout for multiple plots;
ods layout Start width=10in height=6in;
ods region x=0 y=0% width=50% height=50%;
ods graphics / noborder;
* Repeat for variables age, fixation and emotion; 
proc sgplot data=statmod.intention noborder;
histogram intention;
run;

ods region x=50% y=0% width=50% height=50%;
proc sgplot data=statmod.intention noborder;
histogram age;
run;
ods region x=0 y=50% width=50% height=50%;
proc sgplot data=statmod.intention noborder;
histogram emotion;
run;
ods region x=50% Y=50% width=50% height=50%;
proc sgplot data=statmod.intention noborder;
histogram fixation;
run;
quit;
ods layout end; 

options nodate nonumber;
ods layout Start width=10in height=5in;
ods noproctitle;
ods region x=0% y=0% width=50% height=100%;
proc sgplot data=statmod.intention noborder noautolegend;
scatter y=intention x=fixation;
reg y=intention x=fixation / nolegfit;
yaxis label="intention to buy";	
xaxis label="fixation time (in seconds)";	
run;
ods region x=50% y=0% width=50% height=100%;
proc sgplot data=statmod.intention noborder noautolegend;
scatter y=intention x=emotion;
reg y=intention x=emotion / nolegfit;
yaxis label="intention to buy";	
xaxis label="emotion score";
run;
ods layout end; 


proc glm data=statmod.intention;
ods select ParameterEstimates;
model intention=fixation / ss3 solution;
run;

proc glm data=statmod.intention;
ods select ParameterEstimates;
class sex(ref="0");
model intention=sex / ss3 solution;
run;

data temp; 
set statmod.intention; 
educ1=(educ=1); 
educ2=(educ=2); 
run;

proc glm data=temp; 
ods select ParameterEstimates;
model intention=educ1 educ2 / ss3 solution; 
run;

proc glm data=statmod.intention; 
ods select ParameterEstimates;
class educ(ref="3"); 
model intention=educ / ss3 solution; 
run;

proc glm data=statmod.intention; 
class revenu(ref="1") educ(ref="1");
model intention=sex age revenue educ marital fixation emotion age
     /ss3 solution; 
run;


