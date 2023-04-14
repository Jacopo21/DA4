ssc install estout

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

hist civicparticipation if before, percent col(navy*0.8) lcol(white) ylab(,grid) xlab(,grid)
graph export "C:\Users\Binati_Jacopo\Desktop\project\hist_civicpart.png",replace

*TABS OF EACH REGION
tab region
twoway line civicparticipation year if region == "EU + EFTA + North America", by(country) legend(label(1 "2015") label(2 "2021"))
       xtitle("Year") ytitle("Civic Participation") ytitle(`"`: variable label country'"')
graph export "C:\Users\Binati_Jacopo\Desktop\project\GRAPHS\EU-EFTA-NA_BEFAFTcivi.png",replace

twoway line civicparticipation year if region == "East Asia & Pacific", by(country) legend(label(1 "2015") label(2 "2021"))
       xtitle("Year") ytitle("Civic Participation") ytitle(`"`: variable label country'"')
graph export "C:\Users\Binati_Jacopo\Desktop\project\GRAPHS\EASTASIA-PACIFIC_BEFAFTcivi.png",replace

twoway line civicparticipation year if region == "Eastern Europe & Central Asia", by(country) legend(label(1 "2015") label(2 "2021"))
       xtitle("Year") ytitle("Civic Participation") ytitle(`"`: variable label country'"')
graph export "C:\Users\Binati_Jacopo\Desktop\project\GRAPHS\EASTEURO-CENTRALASIA_BEFAFTcivi.png",replace

twoway line civicparticipation year if region == "Latin America & Caribbean", by(country) legend(label(1 "2015") label(2 "2021"))
       xtitle("Year") ytitle("Civic Participation") ytitle(`"`: variable label country'"')
graph export "C:\Users\Binati_Jacopo\Desktop\project\GRAPHS\LATINAMERICA_BEFAFTcivi.png",replace

twoway line civicparticipation year if region == "Middle East & North Africa", by(country) legend(label(1 "2015") label(2 "2021"))
       xtitle("Year") ytitle("Civic Participation") ytitle(`"`: variable label country'"')
graph export "C:\Users\Binati_Jacopo\Desktop\project\GRAPHS\MIDDEAST-NORTHAFRICA_BEFAFTcivi.png",replace

twoway line civicparticipation year if region == "Sub-Saharan Africa", by(country) legend(label(1 "2015") label(2 "2021"))
       xtitle("Year") ytitle("Civic Participation") ytitle(`"`: variable label country'"')
graph export "C:\Users\Binati_Jacopo\Desktop\project\GRAPHS\SUBSAHARAAFRICA_BEFAFTcivi.png",replace

twoway line civicparticipation year if region == "South Asia", by(country) legend(label(1 "2015") label(2 "2021"))
       xtitle("Year") ytitle("Civic Participation") ytitle(`"`: variable label country'"')
graph export "C:\Users\Binati_Jacopo\Desktop\project\GRAPHS\SOUTHASIA_BEFAFTcivi.png",replace

*************************************************************************
sort country year

gen yq = mdy(1,1,year)
format yq %tq


******
*REGRESSIONS
reg avg_civi15 avg_freedom15 fundamentalrights therighttolifeandsecurityofthepe dueprocessofthelawandrightsofthe fundamentallaborrightsareeffecti if year == 2015, robust
/*

Linear regression                               Number of obs     =         94
                                                F(5, 88)          =     516.24
                                                Prob > F          =     0.0000
                                                R-squared         =     0.9435
                                                Root MSE          =     .03865

--------------------------------------------------------------------------------------------------
                                 |               Robust
                        avg_civi | Coefficient  std. err.      t    P>|t|     [95% conf. interval]
---------------------------------+----------------------------------------------------------------
                     avg_freedom |   1.168089   .1887828     6.19   0.000     .7929224    1.543255
               fundamentalrights |  -.4952918    .406736    -1.22   0.227    -1.303594    .3130106
therighttolifeandsecurityofthepe |  -.1869234   .0830514    -2.25   0.027    -.3519706   -.0218762
dueprocessofthelawandrightsofthe |   .2804991   .0905022     3.10   0.003      .100645    .4603533
fundamentallaborrightsareeffecti |   .1707381   .0851498     2.01   0.048     .0015208    .3399553
                           _cons |   .0188354   .0195657     0.96   0.338    -.0200475    .0577182
--------------------------------------------------------------------------------------------------
*/
reg avg_civi21 avg_freedom21 fundamentalrights therighttolifeandsecurityofthepe dueprocessofthelawandrightsofthe fundamentallaborrightsareeffecti if year == 2021, robust
/*

Linear regression                               Number of obs     =         95
                                                F(5, 89)          =     464.61
                                                Prob > F          =     0.0000
                                                R-squared         =     0.9605
                                                Root MSE          =     .03479

--------------------------------------------------------------------------------------------------
                                 |               Robust
                      avg_civi21 | Coefficient  std. err.      t    P>|t|     [95% conf. interval]
---------------------------------+----------------------------------------------------------------
                   avg_freedom21 |   1.340385   .1710148     7.84   0.000     1.000582    1.680188
               fundamentalrights |  -.7454817   .3680036    -2.03   0.046    -1.476697   -.0142663
therighttolifeandsecurityofthepe |  -.1165904   .0656448    -1.78   0.079    -.2470251    .0138443
dueprocessofthelawandrightsofthe |     .24893   .0781269     3.19   0.002     .0936936    .4041665
fundamentallaborrightsareeffecti |   .2343447   .0930557     2.52   0.014     .0494451    .4192444
                           _cons |   .0139718   .0177809     0.79   0.434    -.0213585    .0493021
--------------------------------------------------------------------------------------------------
*/

reg lnavg_civi treatmentXafter treatment after $RHS $RHSXafter [w=civicpart_bef], cluster(country) robust
/*
note: treatmentXafter omitted because of collinearity.
note: after omitted because of collinearity.

Linear regression                               Number of obs     =         95
                                                F(1, 94)          =     529.57
                                                Prob > F          =     0.0000
                                                R-squared         =     0.9110
                                                Root MSE          =     .07968

                                  (Std. err. adjusted for 95 clusters in country)
---------------------------------------------------------------------------------
                |               Robust
     lnavg_civi | Coefficient  std. err.      t    P>|t|     [95% conf. interval]
----------------+----------------------------------------------------------------
treatmentXafter |          0  (omitted)
      treatment |    1.58682   .0689548    23.01   0.000     1.449909    1.723732
          after |          0  (omitted)
          _cons |  -1.472636   .0454141   -32.43   0.000    -1.562806   -1.382465
---------------------------------------------------------------------------------
*/

reg lnavg_civi treatmentXafter treatment after lnavg_free $RHS $RHSXafter [w=civicpart_bef], cluster(country) robust
/*
note: treatmentXafter omitted because of collinearity.
note: after omitted because of collinearity.

Linear regression                               Number of obs     =         95
                                                F(2, 94)          =     595.13
                                                Prob > F          =     0.0000
                                                R-squared         =     0.9437
                                                Root MSE          =     .06371

                                  (Std. err. adjusted for 95 clusters in country)
---------------------------------------------------------------------------------
                |               Robust
     lnavg_civi | Coefficient  std. err.      t    P>|t|     [95% conf. interval]
----------------+----------------------------------------------------------------
treatmentXafter |          0  (omitted)
      treatment |   .8229461    .084569     9.73   0.000     .6550324    .9908598
          after |          0  (omitted)
     lnavg_free |   .4091795   .0491467     8.33   0.000     .3115975    .5067614
          _cons |  -.7984224    .073365   -10.88   0.000    -.9440903   -.6527546
---------------------------------------------------------------------------------
*/

**GRAPHS 
twoway line avg_civi15 year, by(region) legend(label(1 "2015") label(2 "2021"))
       xtitle("Year") ytitle("Civic Participation") ytitle(`"`: variable label country'"')
graph export "C:\Users\Binati_Jacopo\Desktop\project\before_after-civi.png",replace
