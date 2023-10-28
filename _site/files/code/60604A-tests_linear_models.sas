/* Interpretation of tests for linear regression with the insurance data */
data insurance;
set statmod.insurance;
obese = (bmi GE 30);
if (obese=1 & smoker="yes") then smobese="smoker/obese"; 
else if (obese=0 & smoker="yes") then smobese="smoker/non-obese"; 
else smobese="non-smoker";
run;

proc glm data=insurance;
class smobese(ref="non-smoker") region(ref="northeast") sex;
model charges=sex region smobese age / solution ss3 clparm;
run;

/* Tests as linear regressions 
 Compute Wilcoxon signed rank test using the linear model
*/
proc rank data=statmod.tickets out=tickets;
var offer;
ranks rankoffer;
run;

proc glm data=tickets;
model rankoffer=group;
ods select ParameterEstimates;
run;

proc npar1way data=statmod.tickets wilcoxon;
class group;
var offer;
run;

