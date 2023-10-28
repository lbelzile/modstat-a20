proc glm data=statmod.intention;
ods select ParameterEstimates;
model intention=fixation / ss3 solution clparm;
run;

proc glm data=statmod.tickets;
ods select ParameterEstimates;
model offer=group / ss3 solution clparm;
run;

proc glm data=statmod.intention; 
class revenue educ;
model intention=sex age revenue educ marital fixation emotion age
   /ss3 solution; 
run;

