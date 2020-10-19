/* Exercice 4.1 */

data salaireprof;
set modstat.salaireprof;
if(salaire > 105000) then salsup=1; else salsup=0;
run;

proc logistic data=salaireprof;
model salsup(ref="0") = diplome sexe anech andi / plrl;
run;

proc logistic data=salaireprof;
class echelon(ref="1");
model salsup(ref="0") = diplome sexe anech andi echelon / plrl;
run;

/* Exercice 4.2 */

proc genmod data=modstat.prix;
class prog(ref="1");
model nprix = prog math / dist=poisson link=log;
run;

proc genmod data=modstat.prix;
class prog(ref="1");
model nprix = prog math / dist=negbin link=log;
run;

data valp;
valp=(1-cdf('chisq', 1.6938, 1))/2;
run;
proc print data=valp;
run;

/* Exercice 4.3 */
data enfantsfiji;
set modstat.enfantsfiji;
lognfemmes = log(nfemmes);
menfants = nenfants/nfemmes;
run;

proc sgplot data=enfantsfiji;
scatter x=nfemmes y=nenfants;
yaxis type=log label="nombre d'enfants nés (log)";
xaxis type=log label="nombre de femmes (log)";
run;

proc sgplot data=enfantsfiji;
scatter x=menfants y=var;
xaxis label="moyenne du nombre d'enfants nés";
yaxis label="variance du nombre d'enfants nés";
run;

proc genmod data=enfantsfiji plots=(resdev(xbeta) leverage cooksd);
class res(ref="1") dur(ref="1") educ(ref="1");
model nenfants = res dur educ / 
	offset=lognfemmes dist=poisson link=log type3 lrci;
output out=residfiji stdresdev=devres;
run;

proc univariate data=residfiji noprint;
qqplot devres;
run;

proc genmod data=enfantsfiji;
class res(ref="1") dur(ref="1") educ(ref="1");
model nenfants = res dur educ lognfemmes / 
	dist=poisson link=log type3 lrci;
run;


proc genmod data=enfantsfiji;
class res(ref="1") dur(ref="1") educ(ref="1");
model nenfants = res dur educ dur*educ / 
	offset=lognfemmes dist=poisson link=log type3;
run;

/* Exercice 4.4 */
data cancer;
set modstat.cancer;
total = non + oui;
run;

proc genmod data=cancer;
class age maligne;
model oui/total = age maligne age*maligne /
 dist=binomial link=logit type3;
run;

proc genmod data=cancer;
class age maligne;
model oui/total = maligne age / 
 dist=binomial link=logit type3;
run;

proc genmod data=cancer;
class age maligne;
model oui/total = maligne / dist=binomial link=logit type1;
run;

/* Exercice 4.5 */

data fumeurs;
set modstat.fumeurs;
logpop = log(pop);
run;

proc genmod data=fumeurs;
class fume age;
model morts/pop = fume age / 
dist=binomial link=logit type3;
output out=predbin pred=predb;
run;

proc genmod data=fumeurs;
class fume age;
model morts = fume age /
 type3 offset=logpop dist=poisson link=log;
output out=predpois pred=predp;
run;

data predfumeurs;
set predpois(keep=predp pop);
set predbin(keep=predb);
predd = predp/pop-predb;
run;

proc sgplot data=predfumeurs;
scatter x=predb y = predd;
xaxis label="Taux de mortalité (modèle binomiale)";
yaxis label="Différence de prédiction du taux de mortalité (Poisson vs binomiale)";
run;

