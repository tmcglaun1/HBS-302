*PS3
*Author: Trinity McGlaun
*Date: 3/3/2026
*----------------------------------------------*

clear 

*IMPORTING PS2 DATASET
use "C:\Users\tdmcg\Downloads\HBS 302\PS2.dta"


*IDENTIFY DV/IV
/***Dependent Variable: Number of Murders***/
/***Independent Variable: Murders Solved***/

*TITLE THE MODEL
/***Model Title: Relationship Between the Number of Murders and Murders Solved***/

*RUN REGRESSION
reg numberofmurders solved
*STATE HYPOTHESIS
/***Hypothesis: States with more murders will also have more murders solved.***/


*CREATE A SCATTERPLOT
/***inserted a scheme***/
mkdir figures
graph export "figures/scatter_tab2.png", replace width(1000)
set scheme s2color
twoway (scatter numberofmurders solved, mcolor(cranberry) msymbol(circle)) ///
       (lfit numberofmurders solved, lcolor(navy) lwidth(medium)), ///
       title("Model 1: Total Murders vs. Murders Solved (2023)") ///
       xtitle("Murders Solved") ///
       ytitle("Total Murders")
	   
*GATHER MORE INSIGHT ON THE SCATTERPLOT 
describe
summarize

*EXPLAIN THE FINDINGS & RELATION TO REGRESSION
/***There is a positive relationship between the number of murders and the number of murders solved. States wih more murders tend to solve more cases. This is consistent with the regression model.***/


*ANALYZE PREDICTED VALUES
margins, at(solved=(0(100)1200))
marginsplot, title("Model 1: Predicted Murders by Murders Solved") ///
             xtitle("Murders Solved") ///
             ytitle("Predicted Total Murders") ///
             graphregion(color(white))  

*INTERPRET THE TRENDS
/***The graph shows that the total number of murders increase as the number of murders solved increases. In other words, there us a positive slope. This is consistent with the regression model. In policy terms, it shows that states with higher murder counts have more cases to solve. This could be combatted with the step of providing more investigative resources.***/


*SAVE THE REGRESSION 
ssc install estout
regress numberofmurders solved
estimates store Model1
esttab Model1 using "regression_table.rtf", replace ///
    se star(* 0.10 ** 0.05 *** 0.01) ///
    label

*INTERPRET REGRESSION RESULTS
/***Coefficient for Murders Solved = 1.721
**This means that for each additional murder solved, there's about 1.721 more total murders. 
P < 0.001
**This means that it is statistically significant. 
R-squared = 0.946
**The number of murders solved explains about 95% of the variation in total murders across states.
Overall, the model is statistically significant. States with more murders tend to have more cases solved.***/

*VISUALIZATION: HELPFUL OR CHALLENGING?
/***The visualization was helpful because it allowed me to see the positive relationship between the number of murders and the number of murders solved. The visualiztion also allowed me to easily compare to the regression.***/
/***The visualization was slightly challenging to read because the values are tightly clustered.***/

*POSSIBLE NEXT STEP
/***A possible next step would be analyzing the variable "top5" with this data. This would allow me to compare the top states more closely and identify any changes.***/