proc genmod data=statmod.birthwgt;
class premature race smoker hypertension irrit;
model low(ref="0")= premature race smoker hypertension 
			irrit wgtmother / dist=binomial link=logit lrci type3;
run;

/* Don't look at type III Wald-based tests, use those from genmod */
proc logistic data=statmod.birthwgt;
class premature race smoker hypertension irrit / param=glm;
model low(ref="0")= premature race smoker hypertension 
			irrit wgtmother / expb plrl;
run;


/* Change the baseline to get odds for normal:low birthweight */
proc genmod data=statmod.birthwgt;
class premature race smoker hypertension irrit;
model low(ref="1")= premature race smoker hypertension 
			irrit wgtmother / dist=binomial link=logit lrci type3;
run;

/* Separation of variable */
proc genmod data=statmod.birthwgt;
class premature race smoker hypertension irrit;
model low(ref="0")= premature race smoker hypertension irrit 
	wgtmother wgtbaby / dist=binomial link=logit lrci type3;
run;

