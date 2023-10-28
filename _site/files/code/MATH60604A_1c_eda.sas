proc sgplot data=statmod.renfe;
vbar class / categoryorder=respdesc;
xaxis label="ticket class";
run;

data renfe_promo;
set statmod.renfe;
where fare="Promo";
run;

proc sgplot data=renfe_promo noautolegend;
histogram price;
density price / type=kernel;
xaxis label="Promo tickets price (in euros)";
run;

proc sgplot data=renfe_promo;
vbox price / category=class group=type;
yaxis label="price (in euros)";
run;

data renfe_ave;
set statmod.renfe;
where type NE "REXPRESS";
run;

proc sgplot data=renfe_ave;
scatter y=price x=duration / group=type;
xaxis label="travel duration (in minutes)";
yaxis label="price (in euros)";
run;

