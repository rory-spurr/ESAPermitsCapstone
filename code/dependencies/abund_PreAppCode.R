# Alana Santana and Rory Spurr
# Script to run prior to running time series app
source(paste(getwd(), "/code/dependencies/Reading and Filtering.R", sep = ""))
# =================================================================================
wcr_a <- wcr_act %>% 
  create_totalmorts() %>%
  order_table() %>% 
  replace_na(list(ExpTake = 0, ActTake = 0, TotalMorts = 0, ActMort = 0))

data1<- aggregate(wcr_a$ExpTake, 
                by = list(wcr_a$CommonName, wcr_a$ResultCode, wcr_a$ActMort, 
                          wcr_a$ActTake, wcr_a$TakeAction, wcr_a$Species, 
                          wcr_a$LifeStage, wcr_a$Prod, 
                           wcr.v$TotalMorts), FUN = sum) 

names(data1) <- c("CommonName", "ResultCode", "ActMort", "ActTake", 
               "TakeAction", "Species", "LifeStage", "Production", 
               "TotalMorts", "ExpTake")

Mortalities <- data1 %>%
  group_by(Species, Production, LifeStage) %>%
  summarise(Mortality = sum(ActMort))
Mortalities[is.na(Mortalities)] <- 0

abundance <- left_join(abund, Mortalities, by = c("Species", "Production", "LifeStage"))


