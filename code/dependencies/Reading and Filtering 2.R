# Alana Santana and Rory Spurr
# Script to read in and filter data for time series 
library(tidyverse)
library(sf)
# =================================================================================
# Permit Data
# =================================================================================
# West Coast region read in -> with Alana's filters
wcr_act <- read_csv("data/WCRPermitBiOp_Pass report data 4d and S10_18Aug2022.csv")


wcr.ts <- wcr_act %>% 
  filter(ResultCode == c("NMFS 10a1A Salmon","4d", "NMFS BiOp DTA", "Tribal 4d")) %>%
  mutate(LifeStage = recode(LifeStage,
                            "Smolt" = "Juvenile",
                            "Kelt" = "Juvenile",
                            "Yearling" = "Juvenile",
                            "Sub-Yearling" = "Juvenile",
                            "Egg" = "Juvenile",
                            "Fry" = "Juvenile",
                            "Larvae" = "Juvenile",
                            "Subadult" = "Adult",
                            "Spawned Adult/ Carcass" = "Adult")) %>%
  mutate(CommonName = recode(CommonName,
                             "Salmon, coho" = "coho salmon",
                             "Steelhead" = "steelhead", #steelhead respawn
                             "Eulachon" = "eulachon",
                             "Salmon, Chinook" = "Chinook salmon",
                             "Salmon, chum" = "chum salmon",
                             "Salmon, sockeye" = "sockeye salmon",
                             "Sturgeon, green" = "green sturgeon",
                             "Rockfish, Canary" = "canary rockfish",
                             "Rockfish, Bocaccio" = "bocaccio",
                             "Rockfish, Yelloweye" = "yelloweye rockfish")) %>%
  mutate(Species = paste(Population, CommonName, sep = " ")) %>% 
  mutate(Prod = recode(Production, 
                       "Natural" = "Natural", 
                       "Listed Hatchery" = "Listed Hatchery", 
                       "Listed Hatchery, Clipped and Intact" = "Listed Hatchery",  
                       "Listed Hatchery Intact Adipose" = "Listed Hatchery", 
                       "Listed Hatchery Adipose Clip" = "Listed Hatchery",
                       "Unlisted Hatchery" = "Unlisted Hatchery")) %>%
  filter(Prod != "Unlisted Hatchery") %>%
  filter(TakeAction != c( "Observe/Harass", "Observe/Sample Tissue Dead Animal",
                          "N/A", "NA"))
