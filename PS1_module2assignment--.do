****************************************************************************
*PS1
*Author: Trinity McGlaun
****************************************************************************
/* 2 sources: Murder Accountability Project "UCR65_23a"
              PolicyMap "U.S.2023_murdersbymetroarea"
   The datasets I have chosen focuses on the # of murders in the United States. As a fan of true crime, I have always been interested in crime, specificlly the topic of murder and its impact on communities. By using these datasets, I can better gauge the risk levels around areas of the United States. */
   
clear


***IMPORT DATASET
import delimited ///
"https://drive.google.com/uc?export=download&id=1ZvY75c1QOFhfaixnFteXbFUoeSzI1xPE", /// 
varnames(1) rowrange(3) clear
*used chatgpt to get an import file link 


***CLEAN UP DATASET
drop geoid_description sitsinstate geoid geoid_formatted geovintage source 
*dropped variables i did not need

rename geoid_name state
rename murder numberofmurders
rename timeframe year 
*renamed variables to better understand the dataset

label variable state ///
"state"
label variable numberofmurders ///
"murdersreported"
label variable year ///
"yearoccurred"
label variable location ///
"country"
*relabeled the variables for better format and understanding of the dataset 

***CHECK
describe 

browse in 1/10

browse

*changing the variables listed as string into numeric variables 
destring state, replace
destring numberofmurders, replace
destring year, replace
destring location, replace 

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

misstable summarize state
misstable summarize numberofmurders 
misstable summarize year 
misstable summarize location 
*no missing variables 


save "PolicyMapPS1.dta", replace 

*------------------------------------------------------------------------*
***IMPORT DATASET 
import delimited ///
"https://docs.google.com/spreadsheets/d/1OSMfiVglsit0ScjOPJCdqe5SAvfqd9Cn/export?format=csv", ///
varnames(1) rowrange (3) clear
**used chatgpt to get an import file link


***CLEAN UP DATASET
drop ori name source county agency 
*dropped variables i did not need

keep if year == 2023

rename mrd numberofmurders
rename clr solved 
*renamed variables to better understand the dataset

label variable year ///
"yearoccurred"
label variable numberofmurders ///
"murdersreported"
label variable solved ///
"clearance"
label variable state ///
"state"
*relabeled the variables for better format and understanding of the dataset 

collapse (sum) numberofmurders solved (first) year, by (state)
*reformatting the data editor to become more concise and easier to read 

replace state = "Rhode Island" if state == "Rhodes Island"
*spelling correction 

drop if state == "District of Columbia"
*dropped D.C. because it is not a state


***CHECK
describe 

browse in 1/10

browse 


*changing the variables listed as string into numeric variables 
destring state, replace
destring numberofmurders, replace
destring year, replace
destring solved, replace

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

misstable summarize state
misstable summarize numberofmurders 
misstable summarize year 
misstable summarize solved
*no missing variables 

save "MAP_PS1.dta", replace 
*-----------------------------------------------------------------------*

sort state year
duplicates report state year
*setting up variables to merge correctly without duplicates 

***MERGE
use "PolicyMapPS1.dta", clear
merge 1:1 state year using "MAP_PS1.dta"

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
              
tabulate state
/*after merge: 52 total 
               100% */
tabulate numberofmurders
/*after merge: 52 total 
               100% */
tabulate year
*the year 2023 is consistent for both datasets
tabulate location
*50 total states in the U.S.
tabulate solved 
*50 states have solved murder cases 

save "PS1assignment_module2.dta", replace

export delimited using "PS1assignment_module2.csv", replace

