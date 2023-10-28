proc genmod data=statmod.sweden;
class year(ref="1961") day;
model accidents = limit year day / 
	 dist=poisson link=log type3 lrci;
run;


/* Long to wide format */
proc transpose data=statmod.sweden out=sweden1 prefix=accidents;
    by day;
    id year;
    var accidents;
run;

proc transpose data=statmod.sweden out=sweden2 prefix=limit;
    by day;
    id year;
    var limit;
run;

data sweden;
    merge sweden1(drop=_name_) sweden2(drop=_name_);
    by day;
    limit = limit1962-limit1961;
    accidents = accidents1961 + accidents1962;
run;
/* Exactly the same coefficients and confidence intervals */
/* 92 observations and 2 parameters 
(rather than 184 obs and 94 parameters) */
proc genmod data=sweden;
model accidents1962/accidents = limit / 
	dist=binomial link=logit type3 lrci;
run;

