 /* Evaluation of customer revenge over time */

 /* Print data for first three individuals */


proc print data=statmod.revenge(where=(id<4));
run;


 /* Descriptive statistics and correlation */


proc means data=statmod.revenge(where=(t=1));
var sex age vc wom;
run;
proc corr data=statmod.revenge(where=(t=1));
var sex age vc wom;
run;


/* Plot of revenge as a function of time for each individual */

ods graphics on;

proc sgplot data=statmod.revenge;
series x=t y=revenge / group=id LineAttrs= (pattern=1);
run;

/* Same graph, but only for first ten people */

proc sgplot data=statmod.revenge(where=(id<11));
series x=t y=revenge / group=id LineAttrs= (pattern=1);
run;

ods graphics off;
