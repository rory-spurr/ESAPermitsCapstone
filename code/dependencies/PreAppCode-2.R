# Rory Spurr
# Script #2 to run before Shiny App
# =================================================
# Summary:
# Creates a new data table for display under the Leaflet map in the Shiny app.
# Table only includes fields that are of interest, while omitting those that aren't 
# or break confidentiality issues.

# =================================================
library("DT") # package that helps with data table manipulation
# =================================================

wcr4App <- wcr %>%
  select(ResultCode, 
         Organization,
         HUCNumber,
         TakeAction:ExpTake,
         TotalMorts,
         LifeStage,
         Species,
         Prod)
