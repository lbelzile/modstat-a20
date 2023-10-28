data college;
set statmod.college;
if(rank="associate") then rank2=1; else rank2=0;
if(rank="full") then rank3=1; else rank3=0;
if(field="applied") then applied=1; else applied=0;
if(sex="woman") then women=1; else women=0;
lnservice = log(service);
lnsalary = log(salary);
run;

data airpassengers;
set statmod.airpassengers;
if(month=1) then month1=1; else month1=0;
if(month=2) then month2=1; else month2=0;
if(month=3) then month3=1; else month3=0;
if(month=4) then month4=1; else month4=0;
if(month=5) then month5=1; else month5=0;
if(month=6) then month6=1; else month6=0;
if(month=7) then month7=1; else month7=0;
if(month=8) then month8=1; else month8=0;
if(month=9) then month9=1; else month9=0;
if(month=10) then month10=1; else month10=0;
if(month=11) then month11=1; else month11=0;
lnpassengers = log(passengers);
run;

proc transreg data=airpassengers plots=(boxcox obp);
model BoxCox(passengers / convenient lambda=-2 to 2 by 0.05) = 
	identity(month1 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 year);
run;

/* Here, we could add an interaction between month and year, 
but this would add 11 parameters... and wouldn't fix the variance */
proc glm data=statmod.airpassengers plots=diagnostics;
class month;
model passengers = month year / solution;
run;

/* Much less artifacts here */
proc glm data=airpassengers plots=diagnostics;
class month;
model lnpassengers = month year / solution;
run;
/* In both cases, the autocorrelation induces dependence - tests unreliable */


/* Look at profile plot for lambda in Box-Cox transform */
proc transreg data=college plots=(boxcox obp);
model BoxCox(salary / convenient lambda=-2 to 2 by 0.05) = 
	identity(rank2 rank3 applied women service years);
run;
/* here, a model for 1/y is better, but it would not make sense... */

/* Comparing log of salary versus salary:
/* Somewhat better, but still a lot of heteroscedasticity 
 Interpretation changes, but adjustment comparable */
proc glm data=college plots=(diagnostics residuals);
model lnsalary = rank2 rank3 applied women service / solution ss3;
run;

proc glm data=college plots=(diagnostics residuals);
model salary = rank2 rank3 applied women service / solution ss3;
run;

