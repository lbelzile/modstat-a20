/* Test of independence for contingency tables */

proc genmod data=statmod.polaff;
class party gender;
model count = gender party / dist=poisson link=log type3;
run;

