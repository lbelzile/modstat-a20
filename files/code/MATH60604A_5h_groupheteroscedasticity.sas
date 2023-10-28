
 /* Group heteroscedasticity */
proc mixed data=statmod.college plots=studentpanel;
class field rank sex;
model salary = sex field rank;
repeated / group = rank;
run;


