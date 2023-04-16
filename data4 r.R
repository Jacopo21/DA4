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

`data_project.(1)` <- read.csv2("C:/Users/Mora_Menta/Downloads/data_project (1).csv")
View(`data_project.(1)`)

#keeping the variables used for the analysis
keeps <- c(1,2,4,5,21,23,24,25,26,27,28,29,30,31)
df = `data_project.(1)`[keeps]

lm(formula = X3.3.Civic.participation ~ X4.1.Equal.treatment.and.absence.of.discrimination, 
   data = df)

ls(df)

ols1 = lm(X3.3.Civic.participation ~ X4.1.Equal.treatment.and.absence.of.discrimination, data = df)
summary(ols1)
df %>% filter(Year == 2018) %>% ols12 = lm(X3.3.Civic.participation ~ X4.1.Equal.treatment.and.absence.of.discrimination, data = df)
summary(ols2)

