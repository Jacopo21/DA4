import delimited "C:\Users\Binati_Jacopo\Desktop\project\data_project (1).csv", varnames(1)

save C:\Users\Binati_Jacopo\Desktop\project\data_project.csv, replace
/*
the y:
3.3 civic participation (U)

our xs
4.1 Equal treatment and absence of discrimination (W)
4.2 The right to life and security of the person is effectively guaranteed (X)
4.3 Due process of the law and rights of the accused (Y)
4.4 Freedom of opinion and expression is effectively guaranteed (Z)
4.5 Freedom of belief and religion is effectively guaranteed (AA)
4.6 Freedom from arbitrary interference with privacy is effectively guaranteed (AB)
4.7 Freedom of assembly and association is effectively guaranteed (AC)
4.8 Fundamental labor rights are effectively guaranteed (AD)
*/

*dropping variables which we do not need

drop v7-v20
drop v22
drop factor5orderandsecurity-v57
drop factor1constraintsongovernmentpo
drop countrycode

* dropping country with missing years of observation
tab country
drop if country == "Belarus" | country == "Myanmar"

tab region


*Renaming variables
rename v21 civicpart
rename factor4fundamentalrights foundamentalrights
rename v24 equal_treat
rename v25 right_to_life
rename v26 process 
rename v27 fredom_opinion
rename v28 fredom_belief
rename v29 freedom_choice
rename v30 freedom_assembly
rename v31 labor_right
rename wjpruleoflawindexoverallscore final_score

tab country

replace country = subinstr(country, " ", "_", .)
replace final_score = subinstr(final_score, ",", ".", .)
replace civicpart = subinstr(civicpart, ",", ".", .)
replace foundamentalrights = subinstr(foundamentalrights, ",", ".", .)
replace equal_treat = subinstr(equal_treat, ",", ".", .)
replace right_to_life = subinstr(right_to_life, ",", ".", .)
replace process = subinstr(process, ",", ".", .)
replace fredom_opinion = subinstr(fredom_opinion, ",", ".", .)
replace fredom_belief = subinstr(fredom_belief, ",", ".", .)
replace freedom_choice = subinstr(freedom_choice, ",", ".", .)
replace labor_right = subinstr(labor_right, ",", ".", .)


*organisation dataset
sort country year 
*generating ID variable
egen id = group(country)
tab id
lab var id "ID of each country"
*94 countries all over the world and each countries cover 9 years of observation 

********************************************************************
*
reg civicpart equal_treat if year == 2018, robust