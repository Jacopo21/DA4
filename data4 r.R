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

`data_project.(1)` <- read.csv2("C:/Users/Mora_Menta/Downloads/data_project (1).csv")
View(`data_project.(1)`)

#keeping the variables used for the analysis
keeps <- c(1,2,4,5,21,23,24,25,26,27,28,29,30,31)
df = `data_project.(1)`[keeps]

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
my_data = data.frame(df$Country, df$Year, df$Region, df$fundamentalrights, df$civicpart, df$equal_treat, df$right_to_life, df$process, df$freedom_belief, df$freedom_opinion, df$freedom_assembly, df$freedom_choice, df$labour_right, df$final_score)
View(my_data)

#removing observations with all values missing
my_data <- filter(my_data, rowSums(is.na(my_data)) != ncol(my_data))

my_data$avg_freedom <- (df$freedom_assembly + df$freedom_belief + df$freedom_choice + df$freedom_opinion)/4






