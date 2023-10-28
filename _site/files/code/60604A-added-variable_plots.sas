/* Added variable plot */
/* Regress Y (salary) on all X, but service */
proc glm data=statmod.college;
class rank(ref="assistant") field(ref="applied") sex(ref="man");
model salary=rank field sex / solution;
output out=ymodel r=residparty;
run;

/* Regress service on other X */
proc glm data=statmod.college;
class rank(ref="assistant") field(ref="applied") sex(ref="man");
model service=rank field sex / solution;
output out=xmodel residual=residpartx;
run;

/* Merge database and keep only residuals*/
data merged;
set ymodel(keep=residparty);
set xmodel(keep=residpartx);
run;

proc sgplot data=merged noautolegend;
scatter x=residpartx y=residparty;
reg x=residpartx y=residparty;
xaxis label="service | rest";
yaxis label="salary | rest";
run;

proc glm data=statmod.college;
class rank(ref="assistant") field(ref="applied") sex(ref="man");
model salary=rank field sex service / solution;
ods select ParameterEstimates;
run;

/* Check that the coefficients for service match and that the intercept is zero */
/* This is a consequence of Frisch-Waugh-Lovell theorem*/
proc glm data=merged;
model residparty=residpartx;
ods select ParameterEstimates;
run;



