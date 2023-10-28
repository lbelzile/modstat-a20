* Statistical analysis and inference;
* SAS Lab;

* In class examples;
*==================;


*Part 1 : Familiarisation with SAS;
*======================================================================;

*Creating a library ;
*--------------------------;
*button New Library;
*create the library 'multi';


*Importing a comma separated file;
*--------------------------;
*Ex: aapl.csv




*Ex: SAS program;
*--------------------------;


*Creating a dataset: inputting the data lines;
data depart;
  input age age_cat n_visite n_visite_cat sexe;
cards;
32 2 10 2 1
30 2 6 2 1
48 3 11 3 0
17 1 21 3 0
;
run;

/* A SAS program consists of blocks of instructions which generally
start with a DATA command (to create or modify a dataset) or a PROC
command (to use predefined procedures available in SAS) */

*DATA step;
data transforme;
 set depart;
 region="Montreal"; *character chains must be within quotations or apostrophes;
 age_2023=age+4;
run;

*Ex: temporary vs. permanent data tables;
data multi.transforme;
 set transforme;
run;
/* The previous lines will only work if you have write access to the multi library */

*PROC step;
proc freq data=transforme;
 tables age_cat;
run;

/* NOTICE: each line of code ends in a semi-colon!
A missing semi-colon is the MOST COMMON MISTAKE when
starting to code in SAS
*/


*Creating a dataset: inputting the data;
*----------------------------;

/* Data description

100 people coming out of 5 movie theaters in Montreal were asked:
 1- How old are you? ("age" variable)
 2- In the past year, how many times have you been to a
 movie theater? ("n_visite" variable)
 3- How often do you think you'll go to a movie theater
 in the upcoming year? ("n_visite_future" variable)

 Information on the individuals sex was also recorded ("sexe" variable)
 (0=male, 1=female).

 The variable "age_cat" was created by categorizing age into the following
 categories:
 1= age between 14 and 24
 2= age between 25 and 34
 3= age 35 and older

 The variable "n_visite_cat" was created by categorizing the "n_visite" variable
 into the following categories:
 1= 5 or less visits
 2= between 6 and 10 visits
 3= more than 10 visits

*/

data intro_ex1; /* creating a new dataset file called "intro_ex1" */
 input age age_cat n_visite n_visite_cat n_visite_future sexe; /* the names of the 6 variables */
/* the "cards" expression indicates the start of the data lines */
cards;
32 2 10 2 12 1
30 2 6 2 5 1
48 3 11 3 10 0
17 1 21 3 15 0
21 1 1 1 8 1
56 3 7 2 7 0
27 2 8 2 9 0
22 1 2 1 0 0
29 2 11 3 11 1
18 1 2 1 2 1
25 2 10 2 5 0
24 1 4 1 4 1
34 2 10 2 9 0
42 3 6 2 6 0
32 2 7 2 6 0
43 3 7 2 5 1
25 2 7 2 9 0
33 2 4 1 5 0
19 1 17 3 15 0
48 3 10 2 2 0
23 1 3 1 10 1
38 3 9 2 7 0
18 1 2 1 3 0
49 3 13 3 10 0
34 2 6 2 20 1
40 3 12 3 12 1
33 2 11 3 12 0
26 2 9 2 10 0
32 2 11 3 10 0
61 3 7 2 7 1
34 2 9 2 10 1
16 1 22 3 20 0
28 2 10 2 10 0
14 1 9 2 8 0
45 3 9 2 2 1
42 3 7 2 0 0
31 2 9 2 10 1
29 2 9 2 8 0
35 3 5 1 5 0
34 2 10 2 6 1
18 1 19 3 20 1
25 2 7 2 10 0
35 3 9 2 10 0
29 2 9 2 9 0
18 1 3 1 3 0
28 2 6 2 12 0
28 2 9 2 12 1
32 2 9 2 8 0
42 3 9 2 6 0
37 3 13 3 12 0
40 3 12 3 12 0
41 3 6 2 12 0
40 3 7 2 6 1
18 1 10 2 12 0
41 3 7 2 6 1
48 3 7 2 7 0
24 1 1 1 12 1
32 2 6 2 2 0
22 1 14 3 10 1
17 1 14 3 15 0
19 1 11 3 10 0
26 2 10 2 10 0
26 2 9 2 10 0
46 3 6 2 6 0
25 2 7 2 6 1
26 2 7 2 7 1
22 1 6 2 8 1
22 1 15 3 4 0
18 1 16 3 16 1
15 1 18 3 12 0
28 2 8 2 12 1
30 2 12 3 14 0
24 1 1 1 2 1
31 2 6 2 8 0
24 1 6 2 7 0
37 3 9 2 10 0
45 3 8 2 7 1
22 1 8 2 8 0
22 1 18 3 18 0
35 3 8 2 10 1
30 2 6 2 6 0
30 2 9 2 9 1
35 3 9 2 9 1
27 2 7 2 7 1
37 3 10 2 11 1
36 3 9 2 10 1
43 3 9 2 8 1
18 1 21 3 15 0
15 1 25 3 30 0
16 1 19 3 20 0
17 1 1 1 4 0
34 2 5 1 5 1
22 1 6 2 6 0
29 2 10 2 5 0
44 3 8 2 6 1
20 1 4 1 4 1
42 3 6 2 6 1
38 3 9 2 9 1
25 2 8 2 9 1
25 2 7 2 9 0
;
run;


*Part 2 : DATA and PROC steps;
*==============================;

*Modifying an existing dataset;

data intro_ex1_mod;
 set intro_ex1; /*Creating a new dataset called "intro_ex1_mod", from the "intro_ex1" dataset */
 age_2020=age+4; /*Creating a new variable "age_2020" */
run;

*Mathematical functions;
data intro_ex1_mod;
 set intro_ex1_mod;
 n_visite_mois=round(n_visite/12,0.1); /*Calculate the average number of monthly visits */
 n_visite_carre=n_visite**2; /*Calculate the squared number of visits */
run;

* Apply function over multiple columns;
data intro_ex1_mod;
 set intro_ex1_mod;
 n_visite_max=max(n_visite,n_visite_future); /*Calculate the maximum number of cinema visits over both this year
 and next year */
run;



*Conditions;
data intro_ex1_mod;
 set intro_ex1_mod;
 if age <= 17 then adulte=0;
 else adulte=1; /* Set the "adulte" variable to 0 if the individual is 17 or under, and equal to 1 otherwise */
 if (adulte=1 & n_visite_cat = 3) then adulte_fanatique = 1; /* the "&" symbol represents "and"*/
 else adulte_fanatique = 0; /* The "adulte_fanatique" variable is equal to 1 if the individual is an adult who has
 seen more than 10 movies */
 if (n_visite=1 | n_visite=2) then visiteur_frequent=0;
 else visiteur_frequent=1; /* the "|" symbol represents "or" */
run;

* Variable selection;
data intro_ex1_mod2;
 set intro_ex1_mod;
 keep age adulte_fanatique visiteur_frequent; /* allows to only keep specified variables */
run;

* Variable selection;
data intro_ex1_mod3;
 set intro_ex1_mod;
 if (visiteur_frequent=1); /* allows to only keep frequent visitors */
run;


/* We will now explore the three basic procedures in SAS: CONTENTS, MEANS and FREQ. We'll also see SORT. */

/* CONTENTS provides the contents of a dataset */

proc contents data=intro_ex1_mod;
run;

/* FREQ produces frequency tables.
Adding an "*" between two variables produces cross-tabular tables for the two variables.*/

proc freq data=intro_ex1;
 tables sexe age_cat n_visite_cat age_cat*n_visite_cat;
run;


/* MEANS provides several statistical and numerical summaries of the data,
 some of these summaries are: N, NMISS, NOBS, MIN, MAX, RANGE, SUM, SUMWGT, MEAN,
 CSS, USS, VAR, STD, STDERR, CV, SKEWNESS, KURTOSIS.*/

/* proc means - default summaries provided (i.e. without specifying which ones) */
proc means data=intro_ex1_mod;
 var age;
run;

/* proc means - specifying the particular summaries */
proc means data=intro_ex1_mod n nmiss mean std median min max;
 var age n_visite n_visite_carre;
run;

/* SORT allows to order the data by specified variables.
 This procedure is necessary in order to use the BY option
 in the next example. */

proc sort data=intro_ex1_mod;
 by age_cat descending n_visite;
run;

proc sort data=intro_ex1_mod;
 by sexe;
run;

/* The BY statement indicates that the means will be calculated for each
 group of the categorical variable specified in the BY line */

proc means data=intro_ex1_mod n nmiss mean std median min max;
 var age n_visite n_visite_carre;
 by sexe;
run;


*Part 3 : ODS;
*==============;

/* The ODS module allows to present the SAS results in a more convenient format.
 For example, output can be produced in an RTF file which can be edited in word.
 It is also possible to produce PDF or HTML files. */

ods rtf;
/* In SAS Studio (SAS University Edition), 
 you need to set the folder to within virtual machine, e.g.
ods rtf file='/folders/myfolders/tableau1.rtf'; 
alternatively, you could also use the GUI button to export the file
*/

proc freq data=intro_ex1;
 tables age_cat*n_visite_cat;
run;

ods rtf close;

/* The ODS module also allows to select a portion of the SAS output and store it in
 a dataset */

ods trace on; /* Following this command, a description of each part of the output
 will be given in the journal */

proc freq data=intro_ex1;
 tables age;
run;

ods trace off; /* This indicates to stop including the description in the journal. */

proc freq data=intro_ex1;
 tables age;
 ods output Freq.Table1.OneWayFreqs=dist_age; /* The frequency table, called
  Freq.Table1.OneWayFreqs, is being store in
  the dist_age file */
run;

/* It's also possible to print selected tables
   and limit the output using ODS */

ods trace on;  
proc univariate data=multi.elnino;
var zon_winds; 
run;
ods trace off; 

/* Select two tables based on their name (see log) */
ods select BasicMeasures TestsForLocation;
proc univariate data=multi.elnino;
var zon_winds; 
run;



*Part 4 : Graphs;
*=====================;


proc sgplot data=intro_ex1; /* histogram of age variable */
histogram age;
run;

proc sgplot data=intro_ex1; /* boxplot of age variable */
hbox age;
run;

proc sgplot data=intro_ex1; /* scatterplot of number of visits as a function of age */
scatter x=age y=n_visite;
run;



/* Document prepared by Denis Larocque, revised by Marc Fredette and Jean-François Plante. */

/* Additional examples in the slides using the elnino data */
* Code prepared by Michel Keoula and modified by Léo Belzile;


/* PROC PRINT: print observations in Results */
/* print only first five observations */
proc print data=multi.elnino (obs=5);
run;

/* remove the obs column */
proc print data=multi.elnino (obs=10) noobs;
run;

/* remove duplicate entries */
proc sort data=multi.elnino nodupkey;
by obs;
run;

/* Merge two databases */
/* Create a table with Farenheit temp
   Copy the elnino data, create new variable
   Kepp only this variable and the id "obs" */

data multi.farenheit;
set multi.elnino;
air_temp_f=(air_temp*(9/5))+32;
keep obs air_temp_f;
run;

/* Sort data before merging */
proc sort data=multi.elnino;
by obs;
run;

proc sort data=multi.farenheit;
by obs;
run;

data elninomerge;
merge multi.elnino multi.farenheit;
by obs;
run;

/* PROC TRANSPOSE: wide to long format */


proc transpose data=multi.elnino out=elnino_long 
	name=zone prefix=temp; 
by obs--mer_winds; 
var air_temp s_s_temp;
run;

/* Box-and-whiskers plot */

proc sgplot data=multi.elnino;
hbox air_temp;
run;

proc sgplot data=multi.elnino;
vbox air_temp / category = year;
title "Time evolution of air temperature";
yaxis label = "Air temperature (in Celsius)";
run;




