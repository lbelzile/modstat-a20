proc glm data=statmod.interaction;
class sex(ref="0");
model intention=sex fixation / ss3 solution;
run;

proc glm data=statmod.interaction;
class sex(ref="0");
model intention=sex|fixation / ss3 solution;
run;
