/* Linear regression with compound symmetry correlation structure for the errors */

proc mixed data=revenge method=reml;
class id tcat;
model revenge = sex age vc wom t / solution;
repeated / subject=id type=cs r=1 rcorr=1; 
run;
