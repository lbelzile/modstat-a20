/* Question 3.3 */
data sales;
input ncustomer sales;
cards;
2 0
5 0
9 0
3 0
6 0
7 0
11 0
12 1
9 1
10 1
9 1
7 1
;
run;

data saleso;
set sales;
saleso = log(5/4)*sales;
run;

proc genmod data=sales;
model ncustomer= sales / dist=poisson link=log covb itprint;
run;

proc genmod  data=saleso;
model ncustomer= / offset=saleso dist=poisson link=log;
run;

data pval;
pval = 1-cdf("chisq", 2*(28.9906-28.5306), 1);
run;

proc print data=pval;
var pval;
run;

