****************************************************************************
*PS1
*Author: Trinity McGlaun
****************************************************************************
/* 2 sources: Murder Accountability Project "UCR65_23a"
              PolicyMap "U.S.2023_murdersbymetroarea"
   The datasets I have chosen focuses on the study of crime by metro areas in the United States. I have always been interested in crime, specificlly the topic of murder. By using these datasets, I can better gauge the safety levels around the areas I live in. */
   
clear 

*open working directory
cd "C:\Users\tdmcg\Downloads\HBS 302"

capture log close 

*insert the PolicyMap dataset
import delimited "U.S.2023_murdersbymetroarea.csv"

*drop any rows that contain insufficient data 
*remove variables geoid_formatted, geovintage, and source
*rename the variables I plan on examining 
rename geoid_description area_type
rename geoid_name city_state_area
rename timeframe year
rename location country
rename sitsinstate state


*save data just in case 
save "PS1_U.S.2023_murderbymetroarea_revised.dta", replace

*relabeled the variables 
label variable area_type ///
      "metroarea"
label variable city_state_area ///
      "location"
label variable sitsinstate ///
      "state"
label variable murdrt ///
	  "rate"
label variable year ///
      "timeframe"
label variable country ///
      "nation"

*insert the Murder Accoutability Project data 
*get rid of the firstrow because they contain labels 
import excel "UCR65_23a.xlsx", /// 
firstrow clear

*rename the variables
rename Name city 
rename YEAR year
rename murder murders

*get rid of any data that does not apply to the year 2023 
keep if year == 2023

*relabeled the variables
label variable city ///
      "city"
label variable year ///
      "timeframe"
label variable murders ///
      "#ofmurders"
label variable ///
      "state"

*combining both data sets to be able to examine them more clearly 

use "UCR65_23a_trinitymcglaun_PS1"
*i copy and pasted the other data becuase I continued to get an error code when I tried to merge the datasets using the command
*BOTH datasets are now in the data editor

describe 
*total observations: 3,349
*total variables: 11
*7 str variables (city, state, metroarea, location, state, rate, and Location)
*3 int variables (timeframe, #ofmurders, Trimeframe)
*1 long variable (GeoID)

summarize 
*for UCR65_23a_trinitymcglaun_PS1: 3,349 observations, mean of murders is 5.53, std. dev. is 23.17, accounts for the year of 2023 ONLY
*for PS1_U.S.2023_murderbymetroarea_revised2: 332 observations 
*unable to find mean and standard deviation of the murder rates die to error with merge 
tabulate 
*error occurred when trying to tabulate

import delimited ///
https://docs.google.com/spreadsheets/d/1Z99Mmo9FoDn2FEhdJ1wcjji3Gvrk2huYPFENUKyG2X8/edit?usp=sharing ///
varnames(1) rowrange (3) clear 

import delimited /// 
https://docs.google.com/spreadsheets/d/1OSMfiVglsit0ScjOPJCdqe5SAvfqd9Cn/edit?usp=sharing&ouid=110352820737352819115&rtpof=true&sd=true ///
varnames(1) rowrange (3) clear 

import delimited ///
https://docs.google.com/spreadsheets/d/1VOEdZ9eFFpzLH_nxtsBIbmhMgD87FFyC/edit?usp=sharing&ouid=110352820737352819115&rtpof=true&sd=true ///
varnames(1) rowrange (3) clear 