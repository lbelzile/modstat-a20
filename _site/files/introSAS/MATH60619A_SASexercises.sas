
/* -------------------------------------- */
/* Solutions for exercises for class 2 */

/* Exercise 1 */
/* ---------- */
/*  Questions 1 to 4 don't require any code. The consequences of each
	operation will nonetheless be listed as they will be considered
	in subsequent exercises.  */

/* Creating the multi library */

/* Exercise 2 */
/* ---------- */
/* The dataset ELNINO is now available in the multi library. */

/* Exercise 3 */
/* ---------- */
/* The dataset AAPL is now available in the multi library. */

/* Exercise 5 */
/* ---------- */

 data aapl;
  set multi.aapl;
 run;

  proc sort data=aapl;
    by date;
  run;

  data aapl2; /* a temporary dataset is created in the "Work" library */
    set multi.aapl;
	diff = high - low;  							/* Question a) */
	aug  = (close-open)/open*100;   				/* Question b) */
    if (close GT open) then aaug = 1; else aaug = 0;  /* Question c) */
    adj_aug = dif(adj_close) / lag(adj_close) * 100;	/* Question d) */
  run;


/* Exercise 6 */
/* ---------- */
  proc means data=aapl2 N NMISS MIN MAX RANGE MEAN VAR STD;
    var diff aug aaug adj_aug;
  run;

/* Exercise 7 */
/* ---------- */
  ods rtf;
  proc means data=aapl2 N NMISS MIN MAX RANGE MEAN VAR STD;
    var diff aug aaug adj_aug;
  run;
  ods rtf close;

  /* Note: there exist other formats for the output. For example, we could 
  	 replace rtf by html or pdf. */
  /* These commands only work on Windows with a write-access to folders
  on SAS UE and SAS onDemand, you must use the GUI interface to export the files */

/* Exercise 8 */
/* ---------- */
  ods trace on;
  proc means data=aapl2 mean;
    var diff aug aaug adj_aug;
  run;
  ods trace off;
/* In the log the following is noted:

  Output Added:
-------------
Name:       Summary
Label:      Summary statistics
Template:   base.summary
Path:       Means.Summary

*/

  proc means data=aapl2 mean;
    var diff aug aaug adj_aug;
    ods output  Means.Summary=moyennes;
  run;

/* the dataset "moyennes" is created in the work library */
/* To determine the name of the variables in the dataset, 
   we can use proc contents */

  proc contents data=moyennes;
  run;


/* Exercise 9 */
/* ---------- */

proc sgplot data=aapl2;          
histogram aug;
run;



  
