/* Binomial model for driving license pass rate in Great-Britain */

data gbdriving;
set statmod.gbdriving;
if(total < 500) then size="small"; 
else if (total < 1000) then size="medium";
else size = "large";
run;

proc tabulate data=gbdriving;
class size region;
table region, size;
run;

proc logistic data=gbdriving;
class sex region(ref="London") size / param=glm;
model pass/total = sex region size / link=logit clodds=pl expb;
run;

proc genmod data=gbdriving;
class region(ref="London") sex size;
model pass/total = sex region size / lrci dist=binomial link=logit type3;
run;
