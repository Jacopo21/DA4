ssc install estout

import delimited "C:\Users\Binati_Jacopo\Desktop\project\data_project (3).csv", varnames(1) asfloat stringcols(1 3 4) numericcols (2 5 6 7 8 9 10 11 12 13 14 15) 


*first step
sort country year
egen country_id = group(country)
order country
sort country_id year
lab var country_id "Country ID"
drop if country == "Belarus"
*variable regarding freedom
gen avg_freedom = (freedomofopinionandexpressionise + freedomofbeliefandreligioniseffe + freedomfromarbitraryinterference + freedomofassemblyandassociationi + freedomofassemblyandassociationi) / 5
gen lnavg_free = ln(avg_freedom)
lab var lnavg_free "Log of average freedom"

* tell Stata it's xt data with time difference of 5 yearas
local d = 2021-2015
xtset country_id year, delta(`d')
xtdes

* generate variable treated and untreated
sort country year
gen treated = L.civicparticipation
 replace treated  = F.treated if treated==.
gen untreated = 1 - L.civicparticipation
 replace untreated  = F.untreated if untreated==.
 
*generate before and after var
gen after = year==2015
gen before = year==2021

keep if year==2015 | year==2021


* treatment group defined if observed before only or both before and after
sort country year
gen treatment = civicparticipation if before
 replace treatment = treatment[_n-1] if after & country==country[_n-1]
gen treatmentXafter = treatment*after

* civicparticipation before and after 2019

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
egen avg_civi = mean(civicparticipation), by(country)
gen lnavg_civi = ln(avg_civi)
lab var lnavg_civi "Log of average civic participation"
hist civicparticipation if before, percent col(navy*0.8) lcol(white) ylab(,grid) xlab(,grid)
graph export "C:\Users\Binati_Jacopo\Desktop\project\hist_civicpart.png",replace

twoway line civicparticipation year if region == "EU + EFTA + North America", by(country) legend(label(1 "2015") label(2 "2021"))
       xtitle("Year") ytitle("Civic Participation") ytitle(`"`: variable label country'"')
graph export "C:\Users\Binati_Jacopo\Desktop\project\before_after-civi.png",replace

****
sort country year

gen yq = mdy(1,1,year)
format yq %tq


******
*REGRESSIONS
reg avg_civi avg_freedom fundamentalrights therighttolifeandsecurityofthepe dueprocessofthelawandrightsofthe fundamentallaborrightsareeffecti if year == 2015, robust
/*

Linear regression                               Number of obs     =         95
                                                F(5, 89)          =      11.29
                                                Prob > F          =     0.0000
                                                R-squared         =     0.4199
                                                Root MSE          =     14.373

--------------------------------------------------------------------------------------------------
                                 |               Robust
                        avg_civi | Coefficient  std. err.      t    P>|t|     [95% conf. interval]
---------------------------------+----------------------------------------------------------------
                     avg_freedom |   .4116696   .1117149     3.69   0.000     .1896944    .6336447
               fundamentalrights |   .0447396   .1017456     0.44   0.661    -.1574268     .246906
therighttolifeandsecurityofthepe |  -.0530419   .0590638    -0.90   0.372    -.1704004    .0643166
dueprocessofthelawandrightsofthe |   .2708208   .1240443     2.18   0.032     .0243475    .5172942
fundamentallaborrightsareeffecti |    .019484   .0913382     0.21   0.832    -.1620031    .2009712
                           _cons |   15.14295   5.486638     2.76   0.007     4.241112    26.04478
--------------------------------------------------------------------------------------------------

*/

reg lnavg_civi treatmentXafter treatment after $RHS $RHSXafter [w=civicpart_bef], cluster(country) robust
/*
Linear regression                               Number of obs     =         95
                                                F(1, 94)          =     127.00
                                                Prob > F          =     0.0000
                                                R-squared         =     0.5696
                                                Root MSE          =     .21162

                                  (Std. err. adjusted for 95 clusters in country)
---------------------------------------------------------------------------------
                |               Robust
     lnavg_civi | Coefficient  std. err.      t    P>|t|     [95% conf. interval]
----------------+----------------------------------------------------------------
treatmentXafter |          0  (omitted)
      treatment |   .0137819   .0012229    11.27   0.000     .0113537      .01621
          after |          0  (omitted)
          _cons |   3.199759   .0690479    46.34   0.000     3.062663    3.336855
---------------------------------------------------------------------------------
note: treatmentXafter omitted because of collinearity.
note: after omitted because of collinearity.

*/

reg lnavg_civi treatmentXafter treatment after lnavg_free $RHS $RHSXafter [w=civicpart_bef], cluster(country) robust
/*
note: treatmentXafter omitted because of collinearity.
note: after omitted because of collinearity.

Linear regression                               Number of obs     =         95
                                                F(2, 94)          =      63.22
                                                Prob > F          =     0.0000
                                                R-squared         =     0.5905
                                                Root MSE          =     .20754

                                  (Std. err. adjusted for 95 clusters in country)
---------------------------------------------------------------------------------
                |               Robust
     lnavg_civi | Coefficient  std. err.      t    P>|t|     [95% conf. interval]
----------------+----------------------------------------------------------------
treatmentXafter |          0  (omitted)
      treatment |   .0107261   .0018583     5.77   0.000     .0070364    .0144159
          after |          0  (omitted)
     lnavg_free |    .193921   .1016902     1.91   0.060    -.0079873    .3958293
          _cons |    2.60948   .3268714     7.98   0.000     1.960469    3.258491
---------------------------------------------------------------------------------
*/