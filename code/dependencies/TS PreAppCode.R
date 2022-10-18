# Alana Santana and Rory Spurr
# Script to run prior to running time series app
#install.packages("plotly")
source(paste(getwd(), "/code/dependencies/Reading and Filtering.R", sep = ""))
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
#Summing each variable by year
YT <-df %>%
  group_by(Year, ESU, Production, LifeStage) %>%
  summarise(Yearly_Take = sum(ActTake))
YM <- df %>%
  group_by(Year, ESU, Production, LifeStage) %>%
  summarise(Yearly_Mort = sum(ActMort))
TM <- df %>%
  group_by(Year, ESU, Production, LifeStage) %>%
  summarise(Yearly_TM = sum(TotalMorts))
ET <-df %>%
  group_by(Year, ESU, Production, LifeStage) %>%
  summarise(Yearly_ET = sum(ExpTake))
# #==============================================================
# #Merging data sets
Take <- merge(YT, ET, by = c("Year", "ESU", "Production", "LifeStage"))
Mort <- merge(YM, TM, by = c("Year", "ESU", "Production", "LifeStage"))
df2 <- merge(Take, Mort, by = c("Year", "ESU", "Production", "LifeStage"))
df <- merge(df, df2, by = c("Year", "ESU", "Production", "LifeStage"))
#==============================================================
#Creating proportions
# df <- df %>%
#   mutate(ActualT = df$ActTake/df$Yearly_Take) %>%
#   mutate(AuthT = df$ExpTake/df$Yearly_ET) %>%
#   mutate(ActualM = df$ActMort/df$Yearly_Mort) %>%
#   mutate(AuthM = df$TotalMorts/df$Yearly_TM)
#==============================================================
#Merging columns
 df_T <- pivot_longer(df, Yearly_ET:Yearly_Take, names_to = "Take", values_to = "ProportionT")
 df_M <- pivot_longer(df, Yearly_TM:Yearly_Mort, names_to = "Mortality", values_to = "ProportionM")
# #==============================================================
# #Merging data sets
df <- merge(df_M, df_T, by = c("Year", "ESU", "Production", "LifeStage", 
                              "TotalMorts", "ExpTake", 
                               "CommonName",
                               "ResultCode", "ActMort", "ActTake", 
                               "TakeAction"))
#==============================================================
#Replacing NaN or NA or Inf with 0
df[is.na(df)] <- 0
