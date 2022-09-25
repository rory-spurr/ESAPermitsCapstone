# Alana Santana and Rory Spurr
# Script to run prior to running time series app
#install.packages("plotly")
library(tidyverse)
# =================================================================================
#Setting up data - Changing time factor
a<-as.factor(wcr_act$AnnualTimeStart)
b<-strptime(a,format="%Y-%m-%d") 
Year <- format(as.Date(b, format ="%Y-%m-%d" ), "%Y")
Year <- as.data.frame(Year)
wcr.v <- cbind(wcr_act, Year)
#==============================================================
#Setting up data - Creating totalmorts and QC NA values
wcr.v <-wcr.v %>% 
  create_totalmorts() %>%
  order_table() %>% 
  replace_na(list(ExpTake = 0, ActTake = 0, TotalMorts = 0, ActMort = 0))
#==============================================================
#Aggregating Authorized Take 
df <- aggregate(wcr.v$ExpTake, 
                by = list(wcr.v$CommonName, wcr.v$ResultCode, wcr.v$ActMort, wcr.v$ActTake, wcr.v$TakeAction, wcr.v$Species, wcr.v$LifeStage, wcr.v$Prod, 
                          wcr.v$Year, wcr.v$TotalMorts), FUN = sum) 

names(df) <- c("CommonName", "ResultCode", "ActMort", "ActTake", "TakeAction", "ESU", "LifeStage", "Production", "Year", "TotalMorts", "ExpTake")
#==============================================================