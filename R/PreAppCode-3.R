# Rory Spurr
# Goal of this script is to create large polygons that describe all of the 
# different HUC8's where you could potentially find a given ESU

# Filter the species we want
ESUBasins <- ESUBasins %>%
  filter(Species %in% c("Eulachon", "Salmon, Chinook", "Salmon, chum",
                     "Salmon, coho", "Salmon, sockeye", "Steelhead",
                     "Sturgeon, green")) %>%
  mutate(HUC8 = as.double(HUC8)) %>% # Did not read in as correct data type - fixed here
  mutate(Species = recode(Species,
                          "Salmon, coho" = "coho salmon",
                          "Steelhead" = "steelhead", #steelhead respawn
                          "Eulachon" = "eulachon",
                          "Salmon, Chinook" = "Chinook salmon",
                          "Salmon, chum" = "chum salmon",
                          "Salmon, sockeye" = "sockeye salmon",
                          "Sturgeon, green" = "green sturgeon",
                          "Rockfish, Canary" = "canary rockfish",
                          "Rockfish, Bocaccio" = "bocaccio",
                          "Rockfish, Yelloweye" = "yelloweye rockfish")) # naming consistency with permit data
  

ESUBasinsSpatial <- left_join(ESUBasins, wbd.hucs, by = c("HUC8" = "huc8")) %>%
  st_as_sf() %>%
  mutate(DPS = paste(`Population/Stock`, Species, sep = " ")) # create ESU/DPS column (same unique values 
                                                              # as permit data)

DPSs <- unique(ESUBasinsSpatial$DPS)
nDPS <- length(DPSs)
sf_use_s2(use_s2 = F) # have to shut this off so loop works (due to some vertices being used in multiple shapes)

temp <- ESUBasinsSpatial %>% filter(DPS == DPSs[1])
temp <- st_union(temp)
esuBound <- temp
for (i in 2:nDPS){
  temp <- ESUBasinsSpatial %>% filter(DPS == DPSs[i])
  temp <- st_union(temp)
  esuBound <- rbind(esuBound, temp)
  rm(temp)
} # loop to combine all polygons for each DPS -> creates ESU boundary polygons


# This chunk re-formats, provides informative column names 
# and sets up spatial data
esuBound <- cbind(DPSs, esuBound)
esuBound <- as.data.frame(esuBound)
names(esuBound) <- c("DPS", "geometry")
esuBound$geometry <- st_as_sfc(esuBound$geometry)
esuBound <- st_as_sf(esuBound)
st_crs(esuBound) <- 4326 # CRS for playing nice with Leaflet





#========================================
# Checks to see if the above code worked 
# commented out now that we know it does

# test <- esuBound %>% filter(DPS == "Southern DPS Eulachon")
# 
# ggplot(test) +
#   geom_sf()
# 
# leaflet(data = test) %>%
#   addPolygons()


