# Rory Spurr
# Script #2 to run before Shiny App
# =================================================
# Summary:
# Creates a new data table for display under the Leaflet map in the Shiny app.
# Table only includes fields that are of interest, while omitting those that aren't 
# or break confidentiality issues.

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

wcr4App <- wcr %>%
  select(FileNumber, # File Number
         ResultCode, # Permit Type
         Organization, # Organization
         HUCNumber, # HUC 8
         Location, # Location
         TakeAction:ExpTake, 
         TotalMorts,
         LifeStage,
         Species,
         Prod)
