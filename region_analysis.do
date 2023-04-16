import delimited "C:\Users\Binati_Jacopo\Desktop\project\data_project.csv", varnames(1) asfloat stringcols(1 3 4) numericcols (2 5 6 7 8 9 10 11 12 13 14 15) 


*first step
sort country year
egen country_id = group(country)
order country
sort country_id year
lab var country_id "Country ID"
drop if country == "Belarus"
*variable regarding freedom
gen avg_freedom15 = (freedomofopinionandexpressionise + freedomofbeliefandreligioniseffe + freedomfromarbitraryinterference + freedomofassemblyandassociationi + freedomofassemblyandassociationi) / 5 if year == 2015
gen avg_freedom21 = (freedomofopinionandexpressionise + freedomofbeliefandreligioniseffe + freedomfromarbitraryinterference + freedomofassemblyandassociationi + freedomofassemblyandassociationi) / 5 if year == 2021
gen lnavg_free15 = ln(avg_freedom15)
gen lnavg_free21 = ln(avg_freedom21)
lab var lnavg_free15 "Log of average freedom in 2015"
lab var lnavg_free21 "Log of average freedom in 2021"

*generate before and after var
gen after = year==2015
gen before = year==2021

keep if year==2015 | year==2021
* tell Stata it's xt data with time difference of 5 yearas
local d = 2021-2015
xtset country_id year, delta(`d')
xtdes

* generate variable treated and untreated
sort country_id year
gen treated = L.civicparticipation
 replace treated  = F.treated if treated==.
gen untreated = 1 - L.civicparticipation
 replace untreated  = F.untreated if untreated==.
 
* treatment group defined if observed before only or both before and after
sort country year
gen treatment = civicparticipation if before
 replace treatment = treatment[_n-1] if after & country==country[_n-1]
gen treatmentXafter = treatment*after

* civicparticipation before and after 2019
sort country_id year
gen civicpart_bef = civicparticipation if before
 replace civicpart_bef = L.civicpart_bef if after
gen civicpart_aft = civicparticipation if after
 replace civicpart_aft = F.civicpart_aft if before
 
sort country year
egen balanced = count(country_id), by(country)
 recode balanced 1=0 2=1
 lab var balanced "Balanced panel: country observed both before & after"
 
keep if balanced==1 

tabstat civicparticipation, by(year) s(p50 p75 p90 mean sum n) format(%12.0fc)

*variable regarding civic participation
egen avg_civi15 = mean(civicparticipation) if year ==2015, by(country) 
gen lnavg_civi15 = ln(avg_civi) if year == 2015

egen avg_civi21 = mean(civicparticipation) if year ==2021, by(country)
gen lnavg_civi21 = ln(avg_civi21) 

lab var lnavg_civi15 "Log of average civic participation in 2015"
lab var lnavg_civi21 "Log of average civic participation in 2021"
******
sort country year

gen yq = mdy(1,1,year)
format yq %tq
*****
egen avg_civi = mean(civicparticipation)
tab avg_civi
sort country year
tab region
*collapse (mean) avg_civi15 avg_civi21 avg_freedom15 avg_freedom21 year, by(region)
xtline wjpruleoflawindexoverallscore avg_civi15 avg_civi21, i(region) t(year)

tabstat avg_civi21 avg_civi15, by(region) statistics(count mean sd min max) save
table avg_civi15 region


