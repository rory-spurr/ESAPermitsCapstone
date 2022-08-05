# Alana Santana
# Leaflet integration into R shiny
library(leaflet)
library(dplyr)
library(tidyr)
library(sf)
library(shiny)
library(tidyverse)
#======================================
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

wcr_new <- read_csv("data/WCRPermitBiOp_Pass report data 4d and S10_22March22.csv")
wcr_filt <- wcr_new %>%
  filter(ResultCode == c("NMFS 10a1A Salmon","4d", "NMFS BiOp DTA", "Tribal 4d"))
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

#========================================

wcrm <- wcr_spatial %>% 
  group_by(huc8, states, Organization, TakeAction, CaptureMethod) %>% 
  count(permit = ResultCode) 
wcrm <- subset(wcrm, permit != FALSE) 

wcrm <- wcrm %>% 
  group_by(huc8, states, Organization, TakeAction, CaptureMethod) %>% 
  summarise(perm_count = sum(n)) 

labels <- paste0(
  "<strong> State: </strong> ",
  wcrm$states, "<br/> ",
  "<strong> HUC: </strong> ",
  wcrm$huc8, "<br/> ",
  "<strong> Organization: </strong> ",
  wcrm$Organization, "<br/> ",
  "<strong> # of Active Permits: </strong> ",
  round(wcr_spatial$perm_count, 1), "<br/> "
) %>%
  lapply(htmltools::HTML)

leaflet(wcrm) %>% 
  addProviderTiles(providers$Stamen.TonerLite) %>% 
  addEasyButton(easyButton(
    icon="fa-crosshairs", title="Locate Me",
    onClick=JS("function(btn, map){ map.locate({setView: true}); }"))) %>%
  addPolygons(
    fillColor = ~pal(perm_count), 
    color = "transparent",
    fillOpacity = 0.9, 
    label = ~labels,
    highlight = highlightOptions(color = "white", bringToFront = T)) %>% 
  addC
  setView(lng = -124.072971, lat = 43.458,
          zoom = 5) %>% 
  leaflet::addLegend( 
    pal = pal, 
    values = ~perm_count,
    opacity = 0.97, 
    title = "Permits per HUC8", 
    position = "bottomleft", 
    labFormat = function(type, cuts, p) {
      paste0(label)})
