#installing packages used 
install.packages("ggplot2")
library(ggplot2)
install.packages("tidyverse")
install.packages("haven")
library('tidyverse')
library('haven')

install.packages("magrittr")
library('magrittr')
install.packages("dplyr")
library('dplyr')

#loading the data
'data_project.(1)` <- read.csv2("C:/Users/Mora_Menta/Downloads/data_project (1).csv")
View(`data_project.(1)`)

#keeping the variables used for the analysis
keeps <- c(1,2,4,5,21,23,24,25,26,27,28,29,30,31)
df = `data_project.(1)`[keeps]

#list of variables kept:
ls(df)

[1] "Country"                                                                        
 [2] "Factor.4..Fundamental.Rights"                                                   
 [3] "Region"                                                                         
 [4] "WJP.Rule.of.Law.Index..Overall.Score"                                           
 [5] "X3.3.Civic.participation"                                                       
 [6] "X4.1.Equal.treatment.and.absence.of.discrimination"                             
 [7] "X4.2.The.right.to.life.and.security.of.the.person.is.effectively.guaranteed"    
 [8] "X4.3.Due.process.of.the.law.and.rights.of.the.accused"                          
 [9] "X4.4.Freedom.of.opinion.and.expression.is.effectively.guaranteed"               
[10] "X4.5.Freedom.of.belief.and.religion.is.effectively.guaranteed"                  
[11] "X4.6.Freedom.from.arbitrary.interference.with.privacy.is.effectively.guaranteed"
[12] "X4.7.Freedom.of.assembly.and.association.is.effectively.guaranteed"             
[13] "X4.8.Fundamental.labor.rights.are.effectively.guaranteed"                       
[14] "Year"  

#Basic OLS to get an overview of the relationship between civic participation and equal treatment and ansence of discrimination


ols1 = lm(X3.3.Civic.participation ~ X4.1.Equal.treatment.and.absence.of.discrimination, data = df)
summary(ols1)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.40948 -0.09766  0.01870  0.10915  0.36627 

Coefficients:
                                                   Estimate Std. Error t value Pr(>|t|)    
(Intercept)                                          0.1150     0.0239   4.811 1.78e-06 ***
X4.1.Equal.treatment.and.absence.of.discrimination   0.7575     0.0394  19.229  < 2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.1435 on 857 degrees of freedom
Multiple R-squared:  0.3014,	Adjusted R-squared:  0.3006 
F-statistic: 369.8 on 1 and 857 DF,  p-value: < 2.2e-16

