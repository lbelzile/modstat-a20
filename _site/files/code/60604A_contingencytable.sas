/* Table 7.3 from Agresti's Introduction to Categorical Data Analysis
Survey conducted by the Wright State University School of
Medicine and the United Health Services in Dayton, Ohio. 
The survey asked students in their final year of a high
school near Dayton, Ohio whether they had ever used alcohol,
cigarettes, or marijuana.
*/
data drug;
input alc $ cig $ mar $ count;
cards;
yes yes yes 911
yes yes no 538
yes no yes 44
yes no no 456
no yes yes 3
no yes no 43
no no yes 2
no no no 279
;
run;

proc genmod data=drug;
class alc cig mar;
model count = alc cig mar alc|cig alc|mar cig|mar / dist=poisson link=log type3;
store model_output;
run;
/* Prediction, just exp(betahat*x) */
proc plm restore=model_output;
score data=drug out=preds pred=pred / ilink;
run;

