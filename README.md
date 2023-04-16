# DA4
Finale assignment for data 4

our question: is freedom of choices influenced by civic participation (we could take in consideration a policy specific)? 
We will use the Database from WPJ on the quality of democracy over 140 countries worldwide for a time period that goes from 2012 until 2022. 
N = 140 / T = 10

The code will be done in R (Menta Mora) and STATA (Jacopo Binati)

Good morning
I am writing this email to propose a question for the final project which will be done by Menta Mora and me, Jacopo Binati together. The question we would like to analyse is if freedom of choices influeced by civic participation over different countries worldwide and from 2012 until 2022. In the case study we will take in consideration confounders such as Freedom of opinion and expression, freedom from arbitrary interference with privacy. Moreover we would like to see how, and if, Covid-19 influenced and changed the trend of countries over the years. 

                    ------------------------------------

In the first file, the database was cleaned of variables unrelated to the research. then they were renamed.
two variables 'after' and 'before' were generated for the years 2021 and 2015. the choice was made to understand whether the covid-19 period had an impact on civic participation. 
the variables 'treated' and 'untreated' were created for the years.

The regressions performed analyse the relationship between the average civic participation between 2015 and 2021 with the other confounders.
The second regression is a diff-in-diff relating the variables treatment-after, treatment and after. 

//The first regression analysis the impact of the variables taken into account in 2015, including average freedom, foundamental rights, due process, fundamental labour rights and the right to life and security on civic participation in the 94 countries. 
The analysis showed how civic participation between 2015 and 2021 generally increased globally. In particular, we can conclude that in all regions with the exception of East Asia, there has been an overall average increase in civic participation. The most incident factor in this regard is certainly freedoms: in our case this variable takes into account 5 different types of freedoms. In the first regression for the year 2015, an increase of 0.1 units of freedoms corresponds to an increase of 0.129 in the score. the coefficient changes radically in 2021 showing how an increase of 0.1 units of freedoms corresponds to an increase of 0.134 in the score of civic participation.





avg_freedom: The coefficient of 1.168089 suggests that, holding all other variables constant, a one-unit increase in avg_freedom is associated with a 1.168089 unit increase in avg_civi.

fundamentalrights: The coefficient of -0.4952918 suggests that, holding all other variables constant, a one-unit increase in fundamentalrights is associated with a 0.4952918 unit decrease in avg_civi.

therighttolifeandsecurityofthepe: The coefficient of -0.1869234 suggests that, holding all other variables constant, a one-unit increase in therighttolifeandsecurityofthepe is associated with a 0.1869234 unit decrease in avg_civi.

dueprocessofthelawandrightsofthe: The coefficient of 0.2804991 suggests that, holding all other variables constant, a one-unit increase in dueprocessofthelawandrightsofthe is associated with a 0.2804991 unit increase in avg_civi.

fundamentallaborrightsareeffecti: The coefficient of 0.1707381 suggests that, holding all other variables constant, a one-unit increase in fundamentallaborrightsareeffecti is associated with a 0.1707381 unit increase in avg_civi.
