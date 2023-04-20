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

install.packages("ggfortify")
library(ggfortify)
install.packages("haven")
library(haven)
install.packages("stargazer")
library(stargazer)
install.packages("estimatr")
library(estimatr)
install.packages("modelsummary")
library(modelsummary)
install.packages("cowplot")
library(cowplot)
install.packages("xts")
library(xts)
library(zoo)


`data_project.(1)` <- read.csv2("C:/Users/Mora_Menta/Downloads/data_project (1).csv")
View(`data_project.(1)`)

#keeping the variables used for the analysis

df = `data_project.(1)`

ls(df)


df$fundamentalrights <- df$Factor.4..Fundamental.Rights
df$civicpart <- df$X3.3.Civic.participation
df$equal_treat <- df$X4.1.Equal.treatment.and.absence.of.discrimination
df$right_to_life <- df$X4.2.The.right.to.life.and.security.of.the.person.is.effectively.guaranteed
df$process <- df$X4.3.Due.process.of.the.law.and.rights.of.the.accused
df$freedom_opinion <- df$X4.5.Freedom.of.belief.and.religion.is.effectively.guaranteed
df$freedom_belief <- df$X4.5.Freedom.of.belief.and.religion.is.effectively.guaranteed
df$freedom_opinion <- df$X4.4.Freedom.of.opinion.and.expression.is.effectively.guaranteed
df$freedom_belief <- df$X4.5.Freedom.of.belief.and.religion.is.effectively.guaranteed
df$labour_right <- df$X4.8.Fundamental.labor.rights.are.effectively.guaranteed
df$final_score <- df$WJP.Rule.of.Law.Index..Overall.Score
df$freedom_choice <- df$X4.6.Freedom.from.arbitrary.interference.with.privacy.is.effectively.guaranteed
df$freedom_assembly <- df$X4.7.Freedom.of.assembly.and.association.is.effectively.guaranteed
df$Country <- df$ï.¿Country
df$Year <- df$Year
df$Region <- df$Region

my_data = df


my_data$avg_freedom <- (my_data$freedom_assembly + my_data$freedom_belief + my_data$freedom_choice + my_data$freedom_opinion)/4
my_data$log_avg_freedom <- log(my_data$avg_freedom)

filtered <- df[which(df$Year==2015),]
model <- lm(filtered$civicpart ~ filtered$labour_right)
summary(model)

Call:
  lm(formula = filtered$civicpart ~ filtered$labour_right)

Residuals:
  Min       1Q   Median       3Q      Max 
-0.36131 -0.06181  0.02384  0.08972  0.20114 

Coefficients:
  Estimate Std. Error t value Pr(>|t|)    
(Intercept)            0.14676    0.04866   3.016   0.0033 ** 
  filtered$labour_right  0.77044    0.08023   9.603 1.28e-15 ***
  ---
  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.1127 on 94 degrees of freedom
Multiple R-squared:  0.4952,	Adjusted R-squared:  0.4898 
F-statistic: 92.22 on 1 and 94 DF,  p-value: 1.284e-15


filtered <- my_data[which(my_data$Year==2015),]
filtered2 <-my_data[which(my_data$Year==2021),]
filtered$avg_freedom15 <- (filtered$freedom_assembly + filtered$freedom_belief + filtered$freedom_choice + filtered$freedom_opinion)/4 
filtered2$avg_freedom21 <- (filtered2$freedom_assembly + filtered2$freedom_belief + filtered2$freedom_choice + filtered2$freedom_opinion)/4


filtered$lnavg_free15 <- log(filtered$avg_freedom15)
filtered2$lnavg_free21 <- log(filtered2$avg_freedom21)

filtered$avg_civi15 <- mean(filtered$civicpart)
filtered2$avg_civi21 <- mean(filtered2$civicpart)
filtered$lnavg_civi15 <- log(filtered$avg_civi15)
filtered2$lnavg_civi21 <- log(filtered2$avg_civi21)
View(filtered)

lm = lm(avg_civi15 ~ avg_freedom15 + filtered$fundamentalrights + filtered$right_to_life + filtered$process + filtered$labour_right, data = filtered)
summary(lm)

Residuals:
  Min         1Q     Median         3Q        Max 
-5.317e-15  1.310e-17  5.050e-17  9.600e-17  2.159e-16 

Coefficients:
  Estimate Std. Error    t value Pr(>|t|)    
(Intercept)                    6.008e-01  3.254e-16  1.846e+15   <2e-16 ***
  avg_freedom15                  8.316e-16  3.063e-15  2.710e-01    0.787    
filtered$df.fundamentalrights -1.515e-15  6.302e-15 -2.400e-01    0.811    
filtered$df.right_to_life     -3.529e-16  1.160e-15 -3.040e-01    0.762    
filtered$df.process            4.835e-16  1.206e-15  4.010e-01    0.690    
filtered$df.labour_right       7.629e-16  1.429e-15  5.340e-01    0.595    
---
  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 5.668e-16 on 90 degrees of freedom
Multiple R-squared:  0.5015,	Adjusted R-squared:  0.4738 
F-statistic: 18.11 on 5 and 90 DF,  p-value: 2.16e-12


lm2 = lm(avg_civi21 ~ avg_freedom21 + filtered2$fundamentalrights + filtered2$right_to_life + filtered2$process + filtered2$labour_right, data = filtered2)
summary(lm2)

Call:
  lm(formula = avg_civi21 ~ avg_freedom21 + filtered2$df.fundamentalrights + 
       filtered2$df.right_to_life + filtered2$df.process + filtered2$df.labour_right, 
     data = filtered2)

Residuals:
  Min         1Q     Median         3Q        Max 
-5.051e-15 -5.140e-17  5.230e-17  1.489e-16  3.368e-16 

Coefficients:
  Estimate Std. Error    t value Pr(>|t|)    
(Intercept)                     5.688e-01  3.302e-16  1.723e+15   <2e-16 ***
  avg_freedom21                   4.021e-15  3.600e-15  1.117e+00   0.2670    
filtered2$df.fundamentalrights -8.100e-15  7.161e-15 -1.131e+00   0.2611    
filtered2$df.right_to_life      9.305e-17  1.150e-15  8.100e-02   0.9357    
filtered2$df.process            1.747e-15  1.480e-15  1.181e+00   0.2409    
filtered2$df.labour_right       2.658e-15  1.438e-15  1.848e+00   0.0679 .  
---
  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 5.541e-16 on 89 degrees of freedom
Multiple R-squared:  0.4963,	Adjusted R-squared:  0.468 
F-statistic: 17.54 on 5 and 89 DF,  p-value: 4.678e-12

lm3 = lm(filtered$civicpart ~ filtered$freedom_choice + filtered$freedom_assembly + filtered$freedom_belief + filtered$freedom_opinion, data = filtered)
summary(lm3)

Call:
  lm(formula = filtered$df.civicpart ~ filtered$df.freedom_choice + 
       filtered$df.freedom_assembly + filtered$df.freedom_belief + 
       filtered$df.freedom_opinion, data = filtered)

Residuals:
  Min        1Q    Median        3Q       Max 
-0.060173 -0.021200  0.001008  0.017173  0.147256 

Coefficients:
  Estimate Std. Error t value Pr(>|t|)    
(Intercept)                   0.07962    0.01397   5.700 1.47e-07 ***
  filtered$df.freedom_choice    0.01415    0.02268   0.624    0.534    
filtered$df.freedom_assembly  0.49350    0.05741   8.597 2.20e-13 ***
  filtered$df.freedom_belief   -0.03875    0.03146  -1.232    0.221    
filtered$df.freedom_opinion   0.34451    0.05836   5.904 6.04e-08 ***
  ---
  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.03093 on 91 degrees of freedom
Multiple R-squared:  0.9632,	Adjusted R-squared:  0.9616 
F-statistic: 595.2 on 4 and 91 DF,  p-value: < 2.2e-16

my_data$caryear <- as.character(my_data$Year)
my_data$num_year <- as.numeric(my_data$caryear)
na.omit(my_data$num_year)

filtered3 <- my_data[which(my_data$num_year==2015 | my_data$num_year==2021),]


library(dplyr)

filtered3 <- filtered3 %>%
  group_by(Country) %>%
  mutate(balanced = as.numeric(n() == 2)) %>%
  ungroup()

filtered3 <- filtered3 %>%
  mutate(
    after = ifelse(num_year == 2021, 1, 0),
    before = ifelse(num_year == 2015, 1, 0)
  )

filtered3 <- filtered3 %>%
  arrange(Country, Year) %>%
  group_by(Country) %>%
  mutate(
    treatment = ifelse(before == 1, before, 0), na.rm = TRUE
  ) %>%
  ungroup()


filtered3$avg_civi <- mean(filtered3$civicpart)
filtered3$ln_avgcivi <- log(filtered3$avg_civi)

filtered3 <- filtered3 %>%
  arrange(Country, Year) %>%
  group_by(Country) %>%
  mutate(
    civicpart_bef = ifelse(before == 1, civicpart, NA)
  ) %>%
  ungroup()


formula <- as.formula(ln_avgcivi ~ treatment*after -1)
fd <- feols(formula, weights = filtered3$civicpart_bef, data = filtered3 , cluster = "Country")
summary(fd)


formula2 <- as.formula(ln_avgcivi ~ (treatment + log_avg_freedom)*after)
fd <- feols(formula, weights = filtered3$civicpart_bef, data = filtered3 , cluster = "Country")
summary(fd)

filtered3 %>%
  group_by(Year, before, after) %>%
  summarise(n(), sum(civicpart), mean(civicpart))
Year  before after `n()` `sum(civicpart)` `mean(civicpart)`
<chr>  <dbl> <dbl> <int>            <dbl>             <dbl>
  1 2015       1     0    95             57.3             0.603
2 2021       0     1    95             54.0             0.569

filtered3 %>%
  group_by(Year, treatment) %>%
  summarise(n(), sum(civicpart), mean(civicpart))

Year  treatment `n()` `sum(civicpart)` `mean(civicpart)`
<chr>     <dbl> <int>            <dbl>             <dbl>
  1 2015          1    95             57.3             0.603
2 2021          0    95             54.0             0.569

filtered3 %>%
  group_by(Year, balanced) %>%
  summarise(n(), sum(civicpart), mean(civicpart))

Year  balanced `n()` `sum(civicpart)` `mean(civicpart)`
<chr>    <dbl> <int>            <dbl>             <dbl>
  1 2015         1    95             57.3             0.603
2 2021         1    95             54.0             0.569

filtered3 %>%
  group_by(Year, Region) %>%
  summarise(n(), sum(civicpart), mean(civicpart))

Year  Region                        `n()` `sum(civicpart)` `mean(civicpart)`
<chr> <chr>                         <int>            <dbl>             <dbl>
  1 2015  EU + EFTA + North America        24            18                0.75 
2 2015  East Asia & Pacific              14             7.8              0.557
3 2015  Eastern Europe & Central Asia    12             6.1              0.508
4 2015  Latin America & Caribbean        15             9.05             0.603
5 2015  Middle East & North Africa        7             3.32             0.474
6 2015  South Asia                        5             2.91             0.582
7 2015  Sub-Saharan Africa               18            10.1              0.563
8 2021  EU + EFTA + North America        24            17.8              0.743
9 2021  East Asia & Pacific              14             7.74             0.553
10 2021  Eastern Europe & Central Asia    12             5.52             0.46 
11 2021  Latin America & Caribbean        15             8.6              0.573
12 2021  Middle East & North Africa        7             2.55             0.364
13 2021  South Asia                        5             2.61             0.522
14 2021  Sub-Saharan Africa               18             9.19             0.511
