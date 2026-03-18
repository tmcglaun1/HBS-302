*MIDTERM PRESENTATION*
*Author: Trinity McGlaun*

/*PS1*/
/*2 sources: Murder Accountability Project "UCR65_23a"
             PolicyMap "U.S.2023_murdersbymetroarea"*/
/*Focus: The datasets I have chosen focuses on the # of murders in the United States. As a fan of true crime, I have always been interested in crime, specificlly the topic of murder and its impact on communities. By using these datasets, I can better gauge the risk levels around areas of the United States. */
*----------------------------------------------------------------*
*DATASET #1

/*STEP 1: IMPORT DATASET*/
clear
import delimited ///
"https://drive.google.com/uc?export=download&id=1ZvY75c1QOFhfaixnFteXbFUoeSzI1xPE", /// 
varnames(1) rowrange(3) clear
*used chatgpt to get an import file link 


/*STEP 2: CLEAN UP DATASET*/
*drop variables not needed
drop geoid_description sitsinstate geoid geoid_formatted geovintage source 

*rename variables to better understand the dataset
rename geoid_name state
rename murder numberofmurders
rename timeframe year 

*relabel the variables for a better format and understanding of the dataset 
label variable state ///
"state"
label variable numberofmurders ///
"murdersreported"
label variable year ///
"yearoccurred"
label variable location ///
"country"


/*STEP 3: CHECK*/
describe 

browse in 1/10

browse

*see what the data tells us
summarize state
summarize numberofmurders
*50 observations
*mean = 383.56 
*std. dev. = 412.84
*minimum # of murders reported = 18 
*maximum # of murders reported = 1929
summarize year
*data only reflects the year 2023
summarize location 

*check for missing variables 
misstable summarize state
misstable summarize numberofmurders 
misstable summarize year 
misstable summarize location 


/*STEP 4: SAVE FILE*/
save "PolicyMapPS1.dta", replace 
*----------------------------------------------------------------*
*DATASET #2


/*STEP 5: IMPORT DATASET*/
import delimited ///
"https://docs.google.com/spreadsheets/d/1OSMfiVglsit0ScjOPJCdqe5SAvfqd9Cn/export?format=csv", ///
varnames(1) rowrange (3) clear


/*STEP 6: CLEAN UP DATASET*/
*drop variables not needed
drop ori name source county agency 
*isolate data to show just the year 2023
keep if year == 2023
*rename variables to better understand the dataset
rename mrd numberofmurders
rename clr solved 
*relabel the variables for a better format and understanding of the dataset 
label variable year ///
"yearoccurred"
label variable numberofmurders ///
"murdersreported"
label variable solved ///
"clearance"
label variable state ///
"state"
*reformat the data editor to become more concise and easier to read
collapse (sum) numberofmurders solved (first) year, by (state)
*spelling correction 
replace state = "Rhode Island" if state == "Rhodes Island"
*dropped D.C. because it is not an independent state
drop if state == "District of Columbia"


/*STEP 7: CHECK*/
describe 
browse in 1/10
browse 

summarize state
summarize numberofmurders
*50 observations
*mean = 364.02
*std. dev. = 404.66
*minimum # of murders reported = 10 
*maximum # of murders reported = 1891
summarize year 
*data only reflects the year 2023
summarize solved  
*50 observations 
*mean = 210.76
*std. dev. = 234.97
*minimum # of murders solved = 9 
*maximum # of murders solved = 1153

*check for missing variables 
misstable summarize state
misstable summarize numberofmurders 
misstable summarize year 
misstable summarize solved


/*STEP 8: SAVE FILE*/
save "MAP_PS1.dta", replace 
*----------------------------------------------------------------*
*BOTH DATASETS

*set up variables to merge correctly without duplicates 
sort state year
duplicates report state year


/*STEP 9: MERGE*/
use "PolicyMapPS1.dta", clear
merge 1:1 state year using "MAP_PS1.dta"


/*STEP 10: ANALYZE MERGED DATASETS*/
tab _merge
*48 values matched fully from both datasets 
*100% matched 
*Master only (1): Alabama & Vermont
*Using only  (2): Puerto Rico & District of Colombia
*52 values identified
describe 
*52 total observations
*6 variables listed 
summarize 
/*after merge: 52 observations 
               mean = 2.88
			   std. dev. = 0.43*/
tabulate numberofmurders
/*after merge: 52 total 
               100% */
tabulate year
*the year 2023 is consistent for both datasets
tabulate location
*50 total states in the U.S.
tabulate solved 
*50 states have solved murder cases 


/*STEP 11: SAVE FILE*/
save "PS1assignment_module2.dta", replace


/*STEP 11: EXPORT FILE*/
export delimited using "PS1assignment_module2.csv", replace

///***------------------------------------------------------***///

/*PS2*/
/*Focus: I will be graphing the 2023 top 5 states by the number of murders ae listed. This will make it easier to see which states were enduring higher murder statistics for the year of 2023.*/

/*STEP 1: IMPORT DATASET*/
clear 
cd "C:\Users\tdmcg\Downloads\HBS 302"
use "PS1_module2assignment (1).dta", clear 
*this is the dataset from the previous assignment that has all of the relevant and up-to-date data 


/*STEP 2: SUMMARIZE DATA*/
summarize 
/*after merge: 52 observations 
               mean = 2.88
			   std. dev. = 0.43*/
			

/*STEP 3: TABULATE THE VARIABLES*/
tab _merge
*48 values matched fully from both datasets 
*100% matched 
*Master only (1): Alabama & Vermont
*Using only  (2): Puerto Rico & District of Colombia
*52 values identified         
tabstat numberofmurders
/*52 total observations with a 100% match */
tabulate year
*the year 2023 is consistent for both datasets
tabulate location
*50 total states in the U.S.
tabulate solved 
*50 states have solved murder cases 

tabstat numberofmurders solved _merge, statistics(mean median sd min max)


/*STEP 4: FREQUENCY TABLE*/
tabstat numberofmurders
/*52 total observations with a 100% match */

		 
/*STEP 5: GENERATE BAR CHART FOR TOP 5 STATES*/
egen rank = rank(numberofmurders), field
*ranks states on the number of murders

gen top5 = rank <= 5
*only shows the top 5 states with the highest number of murders listed for the year of 2023

encode state, gen(state_num)
*converts the variable state into a numeric variable instead of a string variable 

graph bar numberofmurders if top5, over(state) ///
    bar(1, color(ltblue)) ///
    blabel(bar, size(small) color(black)) ///
    title("Number of Murders - Top 5 States", size(medium)) ///
    ylabel(0(200)2000, labsize(small)) ///
    legend(label(1 "Number of Murders") size(small) position(6)) ///
    scheme(s2color)
	
	
/*STEP 6: CLEAN UP BAR CHART*/
graph bar numberofmurders if top5, over(state, sort(1) descending) ///
    bar(1, color(ltblue)) ///
    blabel(bar, size(small) color(black)) ///
    title("Number of Murders - Top 5 States", size(medium)) ///
    ylabel(0(200)2000, labsize(small)) ///
    legend(label(1 "Number of Murders") size(small) position(6)) ///
    scheme(s2color)
*each bar represents one of the top 5 states by the number of murders reported in the year of 2023Expand commentComment on line R92Code has comments. Press enter to view.
*The number of murders for each state are listed at te top of each bar
*On the y-axis, the mean of number of murders for the entire dataset are listed 	

/*STEP 7: SAVE FILE*/
save "PS2.dta", replace


/*STEP 8: EXPORT FILE*/
export delimited using "PS2.csv", replace


/*STEP 9: SUMMARY*/
*These visuals allowed me to better see the comparison of numbers amongst each state. Once I limited the data to the top 5 states, I was more easily able to understand which states endured the highest number of murders. By reflecting on these, it could be extremely useful to see if there have been any improvements concerning the number of murders for the timeframe of more recent/future years.

///***------------------------------------------------------***///

/*PS3*/

/*STEP 1: IMPORTING PS2 DATASET*/
clear 
cd "C:\Users\tdmcg\Downloads\HBS 302"
copy "https://drive.google.com/uc?import=download&id=1Ff9BvHH9snRxcXbt0-7w2vtRUVzzgxgD" "PS2.dta", replace
use "PS2.dta", clear


/*STEP 2: IDENTIFY DV/IV*/
*Dependent Variable: Number of Murders
*Independent Variable: Murders Solved


/*STEP 3: TITLE THE MODEL*/
*Model Title: Relationship Between the Number of Murders and Murders Solved


/*STEP 4: RUN REGRESSION*/
reg numberofmurders solved

/*STEP 5: STATE HYPOTHESIS*/
*Hypothesis: Higher numbers of murders solved are associated with fewer total murders. When a higher probability of being caught is present, offenders are more deterred to commit the crime. 


/*STEP 6: CREATE A SCATTERPLOT*/
*inserted a scheme
mkdir figures
graph export "figures/scatter_tab2.png", replace width(1000)
set scheme s2color
twoway (scatter numberofmurders solved, mcolor(cranberry) msymbol(circle)) ///
       (lfit numberofmurders solved, lcolor(navy) lwidth(medium)), ///
       title("Model 1: Total Murders vs. Murders Solved (2023)") ///
       xtitle("Murders Solved") ///
       ytitle("Total Murders")
	   
	   
/*STEP 7: GATHER MORE INSIGHT ON THE SCATTERPLOT*/
describe
summarize
*Avg. murders solved per state per year = approx. 211
*Avg. total murders per state per year = approx. 378
*Min/max values have a wide variation across different states


/*STEP 8: EXPLAIN THE FINDINGS & RELATION TO REGRESSION*/
*There is a positive relationship between the number of murders and the number of murders solved. States wih more murders tend to solve more cases. This is consistent with the regression model.


/*STEP 9: ANALYZE PREDICTED VALUES*/
margins, at(solved=(0(100)1200))
marginsplot, title("Model 1: Predicted Murders by Murders Solved") ///
             xtitle("Murders Solved") ///
             ytitle("Predicted Total Murders") ///
             graphregion(color(white))  

*revised command option 
margins, dydx(solved) at(solved=(0(100)1200))

marginsplot, title("Model 1: Marginal Effect of Murders Solved") ///
             xtitle("Murders Solved") ///
             ytitle("Marginal Effect on Total Murders") ///
             graphregion(color(olive_teal))
			 
			 
/*STEP 10: INTERPRET THE TRENDS*/
*The graph shows that the total number of murders increase as the number of murders solved increases. In other words, there is a strong, positive slope in predicted murders as solved increases. This is consistent with the regression model. As a result, it shows that as there are more murders solved, more murders will follow. This counters the deterrence aspect of my hypothesis."


/*STEP 11: SAVE REGRESSION*/
ssc install estout
regress numberofmurders solved
estimates store Model1
esttab Model1 using "regression_table.rtf", replace ///
    se star(* 0.10 ** 0.05 *** 0.01) ///
    label

	
/*STEP 12: INTERPRET REGRESSION RESULTS*/
*Coefficient for Murders Solved = 1.721
**This means that for each additional murder solved, there's about 1.721 more total murders. 
*P < 0.001
**This means that it is statistically significant. 
*R-squared = 0.946
**The number of murders solved explains about 95% of the variation in total murders across states.
***Overall, the model is statistically significant. States with more murders tend to have more cases solved.***/


/*STEP 13: VISUALIZATION*/
*The visualization was helpful because it allowed me to see the positive relationship between the number of murders and the number of murders solved. The visualiztion also allowed me to easily compare to the regression.


/*STEP 14: POSSIBLE NEXT STEP*/
*A possible next step would be analyzing the variable "top5" with this data. This would allow me to compare the top states more closely and identify any changes.