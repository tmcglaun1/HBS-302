*PS2
*Author: Trinity McGlaun 
*Date: 2/17/2026
*Project Summary: I will be graphing the 2023 top 5 states by the number of murders ae listed. This will make it easier to see which states were enduring higher murder statistics for the year of 2023. 


clear 


***IMPORT DATASET
use "PS1_module2assignment (1).dta", clear 
*this is the dataset from the previous assignment that has all of the relevant and up-to-date data 


***SUMMARIZE DATA
summarize 
/*after merge: 52 observations 
               mean = 2.88
			   std. dev. = 0.43*/
			
			
***TABULATE THE VARIABLES
tab _merge
*48 values matched fully from both datasets 
*100% matched 
*Master only (1): Alabama & Vermont
*Using only  (2): Puerto Rico & District of Colombia
*52 values identified         
tabulate state
/*52 total observations with a 100% match */
tabulate numberofmurders
/*52 total observations with a 100% match */
tabulate year
*the year 2023 is consistent for both datasets
tabulate location
*50 total states in the U.S.
tabulate solved 
*50 states have solved murder cases 


tabstat numberofmurders solved _merge, statistics(mean median sd min max)
*more in depth statistics on the data


***FREQUENCY TABLE 
tabulate numberofmurders
/*52 total observations with a 100% match */


***CROSS-TABULATION
tabulate numberofmurders state
/* 52 total observations (plus Puerto Rico) */
/* Each state has one observation becuase it is identifying one observation for one state for one specific year. High variation across states. */
/* Smallest number of murders reported = 16 */
/* Largest number of murders reported = 1929 */


***GENERATE LINE CHART FOR TOP 5 STATES
gen top5 = rank <= 5
*only shows the top 5 states with the highest number of murders listed for the year of 2023

twoway (line numberofmurders rank if top5, lcolor(ltblue) lwidth(large) ///
        mcolor(navy) msize(small) msymbol(circle)) ///
       , xtitle("Top 5 States by Number of Murders") ///
         ytitle("Number of Murders") ///
         title("Murders Across Top 5 States") ///
         xlabel(1 "California" 2 "Florida" 3 "North Carolina" 4 "Pennsylvania" 5 "Texas", ///
                labsize(small) angle(45)) ///
         ylabel(, labsize(small)) ///
         legend(on size(small) position(6)) ///
         scheme(s2color)
*line connects the number of murders for the top 5 states 

		 
***GENERATE BAR CHART FOR TOP 5 STATES
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
*each bar represents one of the top 5 states by the number of murders reported in the year of 2023
*The number of murders for each state are listed at te top of each bar
*On the y-axis, the mean of number of murders for the entire dataset are listed 	

***SUMMARY
*These visuals allowed me to better see the comparison of numbers amongst each state. Once I limited the data to the top 5 states, I was more easily able to understand which states endured the highest number of murders. By reflecting on these, it could be extremely useful to see if there have been any improvements concerning the number of murders for the timeframe of more recent/future years.