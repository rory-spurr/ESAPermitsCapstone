# Rory Spurr
# Script #2 to run before Shiny App
# =================================================
# Summary:
# Creates a new data table for display under the Leaflet map in the Shiny app.
# Table only includes fields that are of interest, while omitting those that aren't 

# =================================================
library("DT") # package that helps with data table manipulation
# install.packages("naniar")
library(naniar) # helps with replacing NA values
# =================================================

wcr <- wcr %>%
  replace_with_na(replace = list(WaterbodyName = "N/A",
                                 BasinName = "N/A"))

Location <- wcr$WaterbodyName
for (i in 1:nrow(wcr)){
  if(is.na(Location[i] == T)){
    Location[i] <- wcr$BasinName[i]
  }
}
for (i in 1:nrow(wcr)){
  if(is.na(Location[i] == T)){
    Location[i] <- wcr$StreamName[i]
  }
}
wcr <- cbind(wcr, Location)
wcr <- wcr %>%
  replace_with_na(replace = list(Location = "."))
for (i in 1:nrow(wcr)){
  if(is.na(wcr$Location[i] == T)){
    wcr$Location[i] <- wcr$LocationDescription[i]
  }
}

# ===================================================
# Creating a FW/SW column
# ===================================================
Locations <- wcr$Location
SW_strings <- c("Sound", "Bay", "Ocean", "Strait", "Admiralty",
                "Whidbey", "Canal", "shelf", "Cape", "estuary", 
                "Estuary","lagoon", "Lagoon", "Delta",
                "estuarine")
FW_strings <- c("Lake", "stream", "freshwaters", "Columbia")

assignWaterType <- function(x, strings1 = SW_strings, strings2 = FW_strings){
  result <- "empty"
    ifelse(str_detect(x, paste(strings1, collapse = "|")) & str_detect(x, paste(strings2, collapse = "|")),
         result <- "SW/FW",
         ifelse(str_detect(x, paste(strings1, collapse = "|")), result <- "SW",
            result <- "FW"))
  return(result)
}
assignWaterType(x = Locations[41]) # testing the function

SW_FW <- sapply(Locations, assignWaterType)

if (length(wcr$SW_FW) > 0){
  wcr <- wcr[,1:31]
  wcr <- cbind(wcr, SW_FW)
} else {wcr <- cbind(wcr, SW_FW)}

# Selecting the columns we want for final display in the app
wcr4App <- wcr %>%
  select(FileNumber, # File Number
         ResultCode, # Permit Type
         Organization, # Organization
         HUCNumber, # HUC 8
         Location, # Location
         SW_FW, # water type
         TakeAction:ExpTake, 
         TotalMorts,
         LifeStage,
         Species,
         Prod) %>%
  mutate(HUCNumber = as.character(HUCNumber)) %>%
  replace_na(list(HUCNumber = "No Data"))

# check <- table(wcr4App$Location, wcr4App$SW_FW)
# write.csv(check, "docs/waterTypeCheck.csv") # table for checking values to ensure the
# sorting function works



