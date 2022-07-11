# Rory Spurr
# Script to read in and filter data
library(tidyverse)
library(sf)

# =================================================================================
# Permit Data
# =================================================================================
# West Coast region read in -> with Alana's filters
wcr.init <- read_csv("data/WCRpermitBiOp_allregns_all_years__7Jan2022.csv")

wcr <- wcr.init %>% 
  filter(PermitStatus == "Issued") %>%
  filter(DateIssued >"2012-01-01") %>%
  filter(DateExpired >= Sys.Date()) %>% #DateField >= Sys.Date() puts it to the date of the system
  filter(ResultCode == c("NMFS 10a1A Salmon","4d", "NMFS BiOp DTA", "Tribal 4d")) %>%
  mutate(LifeStage = recode(LifeStage,
                            "Smolt" = "Juvenile",
                            "Fry" = "Juvenile",
                            "Larvae" = "Juvenile",
                            "Subadult" = "Adult")) %>%
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
  mutate(HUCNumber = recode(HUCNumber,
                            `18020103` = 18020156,
                            `18020109` = 18020163,
                            `18020112` = 18020154,
                            `18020118` = 18020154,
                            `18040005` = 18040012,
                            `18060001` = 18060015,
                            `18060012` = 18060006)) %>% 
  mutate(Species = paste(Population, CommonName, sep = " "))

# check notes below:
# recoding HUCs to account for HUCs that were altered or moved
# broken hucs are 18020103, 18020109, 18020112, 18020118,
# 18040005, 18060001, 18060012

# Notes on what to change them to:
# 18020103 = 18020156 # very certain
# 18020109 = 18020163 # very certain
# 18020112 = 18020154 # very certain based on location descriptions
# 18020118 = 18020154 # very certain based on location descriptions
# 18040005 = 18040012 # very certain based on location descriptions
# 18060001 = 18060015 # split between 18050006 as well, arbitrarily picked
# 18060012 = 18060006 # chose this over Monterrey Bay as population is South-Central Cal Coast

# Separate DF by life stage
adults <- wcr %>% 
  filter(LifeStage == "Adult")
juvenile <- wcr %>% 
  filter(LifeStage == "Juvenile")

# =================================================================================
# Spatial Data
# =================================================================================
# Reading in HUC 8 shape file
wbd.hucs <- read_sf("data/WCR_HUC8/WCR_HUC8.shp")
wbd.hucs$huc8 <- as.double(wbd.hucs$huc8)

# state boundary shape files
state.bound <- read_sf("data/cb_2018_us_state_20m/cb_2018_us_state_20m.shp")
wcr.bound <- state.bound %>%
  filter(NAME == "Washington" | NAME == "Oregon" |
           NAME == "California" | NAME == "Idaho")

# Joining Permit data and spatial data
wcr_spatial <- right_join(x = wbd.hucs, y = wcr, by = c("huc8" = "HUCNumber"))



