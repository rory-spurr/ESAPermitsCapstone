# Alana Santana and Rory Spurr
# Script to run prior to running time series app
#install.packages("plotly")
source(paste(getwd(), "/code/dependencies/Reading and Filtering.R", sep = ""))
# =================================================================================
#Setting up data - Changing time factor
a<-as.factor(wcr_act$DateReportPeriodEnd)
b<-strptime(a,format="%Y-%m-%d") 
Year <- format(as.Date(b, format ="%Y-%m-%d" ), "%Y")
Year <- as.data.frame(Year)
wcr.v <- cbind(wcr_act, Year) #look into annual time start vs annual start end
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
 #df <- df %>%  filter(LifeStage == "Adult", ESU == "Puget Sound Chinook salmon", Production == "Natural") # comment out for real app code
#==============================================================
#Summing each variable by year
YT <-df %>%
  group_by(Year, ESU, Production, LifeStage) %>%
  summarise(Total_Take = sum(ActTake))
YM <- df %>%
  group_by(Year, ESU, Production, LifeStage) %>%
  summarise(Total_Mort = sum(ActMort))
TM <- df %>%
  group_by(Year, ESU, Production, LifeStage) %>%
  summarise(Total_TM = sum(TotalMorts))
ET <-df %>%
  group_by(Year, ESU, Production, LifeStage) %>%
  summarise(Total_ET = sum(ExpTake))
# #==============================================================
# #Merging data sets
Take <- merge(YT, ET, by = c("Year", "ESU", "Production", "LifeStage"))
Mort <- merge(YM, TM, by = c("Year", "ESU", "Production", "LifeStage"))
df2 <- merge(Take, Mort, by = c("Year", "ESU", "Production", "LifeStage"))
#==============================================================
#Anne's Code (lines 46-54)
df2 <- df2 %>%
  mutate(AuthTakeMinusRepTake = Total_ET - Total_Take) %>%
  mutate(AuthMortMinusRepMort = Total_TM - Total_Mort) 
#==============================================================
df_TM2 <- df2 %>%
  gather("Take_Type1","N", 5,9) 
df_TM2 <- df_TM2 %>% 
  gather("Take_Type2", "n", 6,8)
#==============================================================
#Replacing NaN or NA or Inf with 0
df_TM2[is.na(df_TM2)] <- 0
#==============================================================
#Original Code (lines 59-65)
# df <- df2 %>%
#   mutate(Take = (df2$Yearly_Take/df2$Yearly_ET)*100) %>%
#   mutate(Lethal_Take = (df2$Yearly_Mort/df2$Yearly_TM)*100)
# #==============================================================
# #Merging columns
# df_TM <- pivot_longer(df, Lethal_Take:Take, names_to = "Take_Type", values_to = "Proportion")
# #==============================================================
# #Replacing NaN or NA or Inf with 0
# df_TM[is.na(df_TM)] <- 0
