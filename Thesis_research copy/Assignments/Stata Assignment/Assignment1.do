* Sanjay Satish 
* Economics 495S; Professor Connolly
* Stata Assignment
* September 20, 2021
***************

clear all 
capture log close 
set more off

cd "/Users/Sanscubed/Desktop/Fall 21/Thesis/Assignments/Stata Assignment"
 
log using StataAssignment.log, replace
	 use "/Users/Sanscubed/Desktop/Fall 21/Thesis/Assignments/Stata Assignment/census13.dta"

save  census13, replace

** Problem 1
	*a. What are the units of observation?
		browse 
		
	*b. How many variables? 
		describe 
	*c. summarize variables
		summarize
	
	*d. Tabulate the census divisions by region.
		tabulate region 
	
	*e.	Create a table of the mean birthrate, marriage rate, and divorce rate by division.
		tabstat brate mrgrate dvcrate, by(division) 
		
		* eii. Make table of marriage rate by state
		tabstat mrgrate region, by(state)
		
	*f.	Create a variable that is the ratio of the marriage rate to divorce rate. Generate, 
	* label, and save a histogram of this new variable.
		gen mar_to_div = mrgrate/dvcrate
		label variable mar_to_div "Ratio of Marriage Rate to Divorce Rate"
		histogram mar_to_div
	
save  census13, replace	
clear all 

** Problem 2.	The file wage_educ.dct contains education and salary data for respondents of the National Longitudinal Study of Youth 1997 (NLSY97). The data are in a dictionary file (.dct), which is a text format. wage_educ.cdb is the codebook. Import the data into Stata (Hint: use the infile command).
		infile using "wage_educ.dct" 

	* a.	Generate new names for all of the variables (Hint: rename “T3602100” as “region”).
	rename  (R0000100 R0536300 R0536401 R0536402 R1235800 R1302400 R1302500 R1482600 T3600100 T3602100 T3731100 T4406000) (pubid gender birthdate1 birthdate2 sampletype father mother race release region highestdegree salary)

	* b.	Create a variable named “year” and set it equal to the year before the 
	* respondents were surveyed about their income and education.
	gen year = 2008
	* c.	How many respondents did not provide answers to the questions about their 
	* father’s and mother’s highest grades completed, respectively? (Hint: use the codebook)
	codebook 
	* d.	Create a table of the mean and standard deviation of income by highest degree
	* ever received. Which degree level has the largest variance in income? Does this make 
	* sense?
	tabstat salary, by(highestdegree) stat(mean sd)
	* e. Save the dataset as a stata dile
	save wage_educ, replace
	
	
clear 

** Problem 3.The file unemp_rate.csv contains historic information on unemployment rates by region. The data are in a wide format. The goal of this problem is to reshape and merge the data with the previous dataset. Read the data into Stata.
	import delimited "unemp_rate.csv"
	
* a.	Reshape the data so that it is long. Each row should contain a region-year observation of the unemployment rate.
	reshape long unemp_rate@, i(region) j(year)
	
* b.	To merge these data with the dataset in question 2., you need a numeric variable that identifies the region in both datasets which has the same name and is coded the same way. 
* Using the NLSY97 codebook, rename (if required) and recode “region” so that it is coded the same way as the region variable you renamed in 2.a. in the NLSY97 (e.g. 1 = “Northeast”).
	encode region, gen(region2)
	drop region
	recode region2 (2 = 1 "Northeast")(1 = 2 "North Central")(3 = 3 "South")(4 = 4 "West"), gen(region) 
	save unemp_rate, replace
* c.	Merge the NLSY97 data from question 2. into the dataset on “region” and “year.” To check whether the merge did what you expect, tabulate “_merge.”
	use unemp_rate.dta, clear
	save unemp_rate.dta, replace
	use wage_educ.dta, clear
	merge m:1 region year using "unemp_rate.dta"
	
	* i.	What does 3 represent?
	tablulate _merged
	* ii.	What do 1 and 2 represent? Do the totals make sense? For the NLSY97 respondents for which “_merge” = 2, why?
	
	* iii.	Keep only the observations matched in both datasets.
	drop if _merge != 3
* d.	Create a table displaying the means of the unemployment rates and income by region.
	tabstat unemp_rate salary, by(region) 
	

clear all 
capture log close 
set more off
