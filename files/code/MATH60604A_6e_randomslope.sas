/* Random slope model for revenge */

proc mixed data=statmod.revenge;
class id;
model revenge = sex age vc wom t /  solution;
random intercept t /  subject=id  type=un v=1 vcorr=1;
run;

/*Same model, with uncorrelated random effects */
proc mixed data=statmod.revenge;
class id;
model revenge = sex age vc wom t / solution;
random intercept t /  subject=id  v=1 vcorr=1; 
run;
