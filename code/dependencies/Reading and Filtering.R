# Rory Spurr and Alana Santana
# Script to read in and filter data
library(shiny)
library(ggplot2)
library(tidyr)
library(sf)
library(dplyr)
library(tidyverse)
library(leaflet)
library(NMFSResPermits)
library(plotly)
library(viridis)
sf_use_s2(FALSE)
# =================================================================================
# Permit Data
# =================================================================================
# West Coast region read in -> with Alana's filters


wcr <- permitFilter(WestCoastPermitData)

wcr_act <- reportFilter(WestCoastReportData)

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
juveniles <- wcr %>% 
  filter(LifeStage == "Juvenile")

# =================================================================================
# Reading in abundance Data
# =================================================================================
abund <- read_csv("data/Abundance_2022-03-17.csv")
abund <- abund %>%
  mutate(LifeStage = recode(LifeStage,
                            "Subadult" = "Juvenile")) %>%
  mutate(Production = recode(Production,
                             "Listed Hatchery Intact Adipose" = "Listed Hatchery",
                             "Listed Hatchery Adipose Clip" = "Listed Hatchery"))
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

# Puget Sound areas Shapefile
PS_bound <- read_sf("data/WAPSP_Nearshore_Credits_Marine_Basins/Nearshore_MarineBasins_wm.shp")

# Joining Permit data and spatial data
wcr_spatial <- right_join(x = wbd.hucs, y = wcr, by = c("huc8" = "HUCNumber"))

# ESU spatial Data
# esuBound <- read_sf("data/esu_boundaries.shp") 
# commented as we may not use this data, and due to size constraints, 
# the shapefile is not pushed to github but stored locally on Rory's computer

# =================================================================================
# ESU Species with Basins -> for creation of ESU Boundaries
# =================================================================================
ESUBasins <- read_csv("data/APPS_HUCassignments_24Oct22.csv")
ESUBasins <- ESUBasins %>%
  filter(Species %in% c("Eulachon", "Salmon, Chinook", "Salmon, chum",
                        "Salmon, coho", "Salmon, sockeye", "Steelhead",
                        "Sturgeon, green"))


