proc glm data=statmod.bixicoll;
model lognuser = celcius / ss3;
run;

proc glm data=statmod.bixicoll;
model lognuser = farenheit / ss3;
run;

proc glm data=statmod.bixicoll;
model lognuser = celcius farenheit / ss3;
run;

proc glm data=statmod.bixicoll;
model lognuser = celcius rfarenheit / ss3;
run;

proc corr data=statmod.simcollinear noprob;
var y x1-x5;
run;

proc reg data=statmod.simcollinear; 
model y=x1-x5 / vif; 
run;

proc glm data=statmod.simcollinear;
model y=x1-x5 / ss3 solution tolerance;
run;
