# Rory Spurr
# Goal of this script is to create large polygons that describe all of the 
# different HUC8's where you could potentially find a given ESU

ESUBasins <- ESUBasins %>%
  filter(Species %in% c("Eulachon", "Salmon, Chinook", "Salmon, chum",
                     "Salmon, coho", "Salmon, sockeye", "Steelhead",
                     "Sturgeon, green"))

ESUBasinsSpatial <- full_join(ESUBasins, wbd.hucs, by = c("HUC8" = "huc8"))
