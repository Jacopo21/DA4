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
gen avg_freedom15 = (freedomofopinionandexpressionise + freedomofbeliefandreligioniseffe + freedomfromarbitraryinterference + freedomofassemblyandassociationi) / 4 if year == 2015
gen avg_freedom21 = (freedomofopinionandexpressionise + freedomofbeliefandreligioniseffe + freedomfromarbitraryinterference + freedomofassemblyandassociationi) / 4 if year == 2021

gen lnavg_free15 = ln(avg_freedom15)
gen lnavg_free21 = ln(avg_freedom21)

lab var lnavg_free15 "Log of average freedom in 2015"
lab var lnavg_free21 "Log of average freedom in 2021"

*generate before and after var
gen after = year==2021
gen before = year==2015

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

* civicparticipation before and after 2021
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

*********************************************************************

sort country year
gen yq = mdy(1,1,year)
format yq %tq

*******************************************************************
egen avg_civi = mean(civicparticipation)
tab avg_civi
sort country year
tab region
gen lnavg_civi = ln(avg_civi)


******
*REGRESSIONS
reg avg_civi15 avg_freedom15 fundamentalrights therighttolifeandsecurityofthepe dueprocessofthelawandrightsofthe fundamentallaborrightsareeffecti if year == 2015, robust
/*
Linear regression                               Number of obs     =         94
                                                F(5, 88)          =     140.57
                                                Prob > F          =     0.0000
                                                R-squared         =     0.9021
                                                Root MSE          =     .05009

--------------------------------------------------------------------------------------------------
                                 |               Robust
                      avg_civi15 | Coefficient  std. err.      t    P>|t|     [95% conf. interval]
---------------------------------+----------------------------------------------------------------
                   avg_freedom15 |    .609771   .3602912     1.69   0.094    -.1062321    1.325774
               fundamentalrights |   .8479409   .6991739     1.21   0.228    -.5415204    2.237402
therighttolifeandsecurityofthepe |  -.3830558   .0997059    -3.84   0.000    -.5812004   -.1849112
dueprocessofthelawandrightsofthe |  -.0058274   .1196724    -0.05   0.961     -.243651    .2319963
fundamentallaborrightsareeffecti |  -.1407868   .1598014    -0.88   0.381    -.4583585    .1767848
                           _cons |   .0393771   .0259218     1.52   0.132     -.012137    .0908913
--------------------------------------------------------------------------------------------------
*/
reg civicparticipation freedomfromarbitraryinterference freedomofassemblyandassociationi freedomofbeliefandreligioniseffe freedomofopinionandexpressionise if year == 2015, robust
/*
Linear regression                               Number of obs     =         94
                                                F(4, 89)          =     803.12
                                                Prob > F          =     0.0000
                                                R-squared         =     0.9623
                                                Root MSE          =     .03089

--------------------------------------------------------------------------------------------------
                                 |               Robust
              civicparticipation | Coefficient  std. err.      t    P>|t|     [95% conf. interval]
---------------------------------+----------------------------------------------------------------
freedomfromarbitraryinterference |   .0120167   .0195311     0.62   0.540    -.0267912    .0508247
freedomofassemblyandassociationi |   .4894641   .1149713     4.26   0.000     .2610185    .7179097
freedomofbeliefandreligioniseffe |  -.0447818   .0432437    -1.04   0.303    -.1307062    .0411425
freedomofopinionandexpressionise |   .3590919   .1083759     3.31   0.001     .1437514    .5744324
                           _cons |   .0779508   .0194909     4.00   0.000     .0392228    .1166788
--------------------------------------------------------------------------------------------------
*/
reg avg_civi21 avg_freedom21 fundamentalrights therighttolifeandsecurityofthepe dueprocessofthelawandrightsofthe fundamentallaborrightsareeffecti if year == 2021, robust
/*

Linear regression                               Number of obs     =         95
                                                F(5, 89)          =     378.21
                                                Prob > F          =     0.0000
                                                R-squared         =     0.9484
                                                Root MSE          =     .03975

--------------------------------------------------------------------------------------------------
                                 |               Robust
                      avg_civi21 | Coefficient  std. err.      t    P>|t|     [95% conf. interval]
---------------------------------+----------------------------------------------------------------
                   avg_freedom21 |   1.071433   .2472004     4.33   0.000     .5802513    1.562615
               fundamentalrights |  -.1212848   .5004248    -0.24   0.809    -1.115618    .8730485
therighttolifeandsecurityofthepe |  -.2129163   .0764407    -2.79   0.007    -.3648024   -.0610302
dueprocessofthelawandrightsofthe |    .088157   .0972637     0.91   0.367     -.105104     .281418
fundamentallaborrightsareeffecti |   .1577043   .1200154     1.31   0.192    -.0807637    .3961722
                           _cons |   .0061899   .0215964     0.29   0.775    -.0367217    .0491015
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



*collapse (mean) avg_civi15 avg_civi21 avg_freedom15 avg_freedom21 year, by(region)
xtline wjpruleoflawindexoverallscore avg_civi15 avg_civi21, i(region) t(year)

tabstat avg_civi21 avg_civi15, by(region) statistics(count mean sd min max) save

/*
Summary statistics: N, Mean, SD, Min, Max
Group variable: region (Region)

          region |  avg_c~21  avg_c~15
-----------------+--------------------
EU + EFTA + Nort |        24        24 
                 |  .7429167       .75
                 |  .1245681  .1013818
                 |       .42       .51
                 |       .94        .9
-----------------+--------------------
East Asia & Paci |        14        14
                 |  .5528571  .5571429
                 |  .1684056  .1925708
                 |       .18       .21
                 |       .84       .83
-----------------+--------------------
Eastern Europe & |        12        12
                 |       .46  .5083333
                 |  .1070259  .1357024
                 |       .27       .24
                 |       .62       .66
-----------------+--------------------
Latin America &  |        15        15
                 |  .5733333  .6033333
                 |  .1051982   .085077
                 |       .33       .46
                 |       .77       .78
-----------------+--------------------
Middle East & No |         7         7
                 |  .3642857  .4742857
                 |  .1671184  .1386671
                 |       .16       .25
                 |       .61       .65
-----------------+--------------------
      South Asia |         5         5
                 |      .522      .582
                 |   .121326  .0759605
                 |       .31       .49
                 |        .6       .67
-----------------+--------------------
Sub-Saharan Afri |        18        18
                 |  .5105556  .5633333
                 |  .1224491  .1422095
                 |       .28       .23
                 |        .7       .73
-----------------+--------------------
           Total |        95        95
                 |  .5688421  .6033684
                 |  .1702993  .1566512
                 |       .16       .21
                 |       .94        .9
--------------------------------------
*/

********************TABS OF EACH REGION*************************
hist civicparticipation if before, percent col(navy*0.8) lcol(white) ylab(,grid) xlab(,grid)
graph export "C:\Users\Binati_Jacopo\Desktop\project\hist_civicpart.png",replace


tab region
twoway line civicparticipation year if region == "EU + EFTA + North America", by(country) legend(label(1 "2015") label(2 "2021")) xtitle("Year") ytitle("Civic Participation") ytitle(`"`: variable label country'"')
graph export "C:\Users\Binati_Jacopo\Desktop\project\EU-EFTA-NA_BEFAFTcivi.png",replace

twoway line civicparticipation year if region == "East Asia & Pacific", by(country) legend(label(1 "2015") label(2 "2021")) xtitle("Year") ytitle("Civic Participation") ytitle(`"`: variable label country'"')
graph export "C:\Users\Binati_Jacopo\Desktop\project\GRAPHS\EASTASIA-PACIFIC_BEFAFTcivi.png",replace

twoway line civicparticipation year if region == "Eastern Europe & Central Asia", by(country) legend(label(1 "2015") label(2 "2021")) xtitle("Year") ytitle("Civic Participation") ytitle(`"`: variable label country'"')
graph export "C:\Users\Binati_Jacopo\Desktop\project\GRAPHS\EASTEURO-CENTRALASIA_BEFAFTcivi.png",replace

twoway line civicparticipation year if region == "Latin America & Caribbean", by(country) legend(label(1 "2015") label(2 "2021")) xtitle("Year") ytitle("Civic Participation") ytitle(`"`: variable label country'"')
graph export "C:\Users\Binati_Jacopo\Desktop\project\GRAPHS\LATINAMERICA_BEFAFTcivi.png",replace

twoway line civicparticipation year if region == "Middle East & North Africa", by(country) legend(label(1 "2015") label(2 "2021")) xtitle("Year") ytitle("Civic Participation") ytitle(`"`: variable label country'"')
graph export "C:\Users\Binati_Jacopo\Desktop\project\GRAPHS\MIDDEAST-NORTHAFRICA_BEFAFTcivi.png",replace

twoway line civicparticipation year if region == "Sub-Saharan Africa", by(country) legend(label(1 "2015") label(2 "2021")) xtitle("Year") ytitle("Civic Participation") ytitle(`"`: variable label country'"')
graph export "C:\Users\Binati_Jacopo\Desktop\project\GRAPHS\SUBSAHARAAFRICA_BEFAFTcivi.png",replace

twoway line civicparticipation year if region == "South Asia", by(country) legend(label(1 "2015") label(2 "2021")) xtitle("Year") ytitle("Civic Participation") ytitle(`"`: variable label country'"')
graph export "C:\Users\Binati_Jacopo\Desktop\project\GRAPHS\SOUTHASIA_BEFAFTcivi.png",replace

*************************************************************************
