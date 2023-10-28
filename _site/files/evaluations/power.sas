proc iml;
/* SAS/IML code by Rick Wicklin for a two-sample t-test
Formulas from the SAS documentation: https://bit.ly/30rr2GV
*/
  start TTestH0(x, y, alpha=0.05);
n1 = nrow(x);    n2 = nrow(y);             /* sample sizes */
  meanX = mean(x); varX = var(x);            /* mean & var of each sample */
  meanY = mean(y); varY = var(y);
DF = n1 + n2 - 2;
/* unbiased estimator of the pooled variance: https://blogs.sas.com/content/iml/2020/06/29/pooled-variance.html */
  poolVar = ((n1-1)*varX + (n2-1)*varY) / DF;
/* Compute test statistic, critical value, and whether we reject H0 */
  t = (meanX - meanY) / sqrt(poolVar*(1/n1 + 1/n2));
t_crit = quantile('t', 1-alpha/2, DF); 
RejectH0 = (abs(t) > t_crit);              /* binary 0|1 for 2-sided test */
  powerS = RejectH0[:]; /* Average fraction of rejection */
  return powerS;                           
finish;

/* Simulate two groups; Count what fraction rejects H0: delta=0 */
  start SimTTest(L);                     /* function takes list as argument  */
  x = j(L$'n1', L$'B');               /* allocate space for Group 1        */
  y = j(L$'n2', L$'B');               /* allocate space for Group 2        */
  call randgen(x, 'Normal', 0,         1);   /* simulate X ~ N(0,1)                 */
  call randgen(y, 'Normal', L$'delta', 1);   /* simulate Y ~ N(delta,1)             */
  return TTestH0(x, y, L$'alpha');          /* count the percentage of rejection of H0          */
  finish;

/* ----- Main Program ----- */
  %let NumSamples = 1e5; /* Number of replications */
  %let n1 = 10; /* sample size of group 1*/
  %let n2 = 10;
L = [#'delta' = .,
  #'n1' = &n1,
  #'n2' = &n2,
  #'B'  =  &NumSamples,
  #'alpha' = 0.05]; /* level of the test*/
  
  /* Create list of arguments. Each arg gets different value of delta */
    delta = T(do(-2, 2, 0.1));
  power = j(nrow(delta),1,.); /* Create container with missing values */
    do i = 1 to nrow(delta); /* For loop: for each delta, run program */
    L$'delta' = delta[i];
  power[i] = SimTTest(L);
  end; 
  
  *print power;
  create simulation from delta power;  /* specify multiple matrices */
    append from delta power;             /* repeat matrix names */
    close;
  
  data simulation; 					/* Rename columns for more meaningful labels */
    set simulation;
  rename col1=meandiff col2=power;
  run;
  
  title "Power of the two-sample t test";
  title2 "Samples are N(0,1) and N(delta,1), n1=&n1, n2=&n2";
  proc sgplot data=simulation noautolegend;
  series x=meandiff y=power;
  inset ("Number of Samples"="&NumSamples") / border;
  refline  0.05 0.1 / axis=y; 
  yaxis min=0 max=1 label="Power (1 - P[Type II Error])" grid;
  xaxis label="Difference in population means" grid;
  run;
  QUIT;
  