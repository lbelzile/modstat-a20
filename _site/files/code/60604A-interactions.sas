data insurance;
	set statmod.insurance;
	if(bmi >= 30) then obese = 1;
	else obese = 0;
	if(obese = 1 & smoker = "yes") then smobese="smoker/obese";
	else if(obese = 0 & smoker = "yes") then smobese ="smoker/non-obese";
	else smobese="non-smoker";
run;

/* If you change the baseline categories, the test stat and the p-value for the three-way interaction does not change */
proc glm data=insurance;
	class obese(ref="0") smoker(ref="no");
	model charges=age|obese|smoker / ss3 solution;
run;

/* Compute F-test by hand to compare models */

proc glm data=insurance;
	class obese(ref="0") smoker(ref="no");
	model charges=age|obese|smoker / ss3 solution;
	ods select OverallANOVA;
run;

proc glm data=insurance;
	class smobese;
	model charges=age|smobese / ss3 solution;
	ods select OverallANOVA;
run;

/* F statistic - by hand 
Numerator: difference in Sum of Squares (error) of both models, 
 divided by the number of additional parameters in the full model
Denominator: Sum of Squares of full model / (sample size - number of betas)
 corresponds to Mean Square of full model (errors)
*/
data pval;
pval=1-CDF('F',((27739495631-27733794686)/2)/20852477.207,2,1330);
run;
proc print data=pval;
run;






