
/* Alternative methods for fitting logistic model */

proc glimmix data=statmod.intention;
class educ revenue;
model buy(ref="0")=sex age revenue educ marital 
    fixation emotion / dist=binary link=logit solution;
run;

proc genmod data=statmod.intention;
class educ revenue;
model buy(ref="0")=sex age revenue educ marital 
    fixation emotion / dist=binomial link=logit lrci type3;
run;

proc logistic data=statmod.intention;
class educ revenue / param=glm;
model buy(ref="0")=sex age revenue educ marital 
    fixation emotion / clparm=pl clodds=pl expb;
run;


/* Prediction from the logistic model */
proc logistic data=statmod.intention outmodel=binom_intention;
class educ revenue / param=glm;
model buy(ref="0")=sex age revenue educ marital 
    fixation emotion / clparm=pl clodds=pl expb;
run;

proc logistic inmodel=binom_intention;
score clm data=statmod.intention out=pred;
/* Supply your own data above for out-of-sample prediction */
run;

