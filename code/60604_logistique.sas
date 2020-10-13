proc genmod data=modstat.massebebe plots=(cleverage);
class fumeuse hypertension irrit prematures;
model faible(ref="0")=fumeuse hypertension irrit prematures mmere/ dist=binomial link=log;
run;
