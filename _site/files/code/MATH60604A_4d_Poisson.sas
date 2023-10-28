
/* Summary statistics for the count variable, with frequency table */

proc means data=statmod.intention n mean var min max;
var nitem;
run;

proc freq data=statmod.intention;
table nitem;
run;

/* Poisson model for intention to buy  data */

proc genmod data=statmod.intention;
class educ revenue;
model nitem=sex age revenue educ marital
     fixation emotion / dist=poisson link=log lrci type3;
run;
