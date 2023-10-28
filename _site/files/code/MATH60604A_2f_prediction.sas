data newdata;
   set infe.intention(obs=1);
   do fixation=0 to 6;
      output;
   end;
run;

proc glm data=infe.intention noprint;
class sex educ revenue;
model intention= fixation emotion 
    sex age revenue educ / ss3 solution;
store modelinfo; 
run;

proc plm restore=modelinfo; 
score data=newdata out=prediction predicted 
    lclm uclm lcl ucl; 
run;

proc sgplot data=prediction;
band x=fixation upper=ucl lower=lcl / 
        fill transparency=.5 
        legendlabel="individual";
band x=fixation upper=uclm lower=lclm / 
        fill transparency=.1 legendlabel="mean";
series x=fixation y=predicted;
yaxis label="intention score";
xaxis label="fixation time (in seconds)";
run;



/* More realistic example with the college data */

ods exclude all;
ods noresults;
proc glm data=statmod.college;
class field rank sex;
model salary = field rank service sex;
store model1;
run;

data newcollege;
length rank $ 10; 
length field $ 12; 
/* SAS troncates the variables name exceeding 8 character (default) 
The above thus declares the categorical variable ($) "rank" of length at most 10.*/
   input year field $ rank $ service sex $;
   datalines;
5 applied associate 3 man
; 

proc plm restore=model1 alpha=0.05;
score data=newcollege out=prediction predicted lcl ucl;
run; 
ods exclude none;
ods results;

proc print data=prediction;
var predicted lcl ucl;
run;
