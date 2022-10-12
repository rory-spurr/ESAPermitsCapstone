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
#Creating proportion calculations
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

Take <- merge(YT, ET, by = c("Year", "ESU", "Production", "LifeStage"))
Mort <- merge(YM, TM, by = c("Year", "ESU", "Production", "LifeStage"))

PropT <- Take %>% 
  mutate(PropT = Take$Yearly_Take/Take$Yearly_ET)

PropM <- Mort %>% 
  mutate(PropM = Mort$Yearly_Mort/Mort$Yearly_TM)
  
df2 <- merge(PropM, PropT, by = c("Year", "ESU", "Production", "LifeStage"))
df <- merge(df, df2, by = c("Year", "ESU", "Production", "LifeStage"))




