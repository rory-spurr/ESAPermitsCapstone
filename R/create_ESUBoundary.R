#' @title create_ESUBoundary
#'
#' @description Filters to only include species relevant to the app.
#' @param data Data frame describing the different HUC 8 where ESUs can be found. One row per unique
#' DPS/huc8 combination. Therefore species that are found in multiple DPSs wil be lsted in multiple 
#' rows, one for each DPS where they can be found.
#' @param spatialData Polygon spatial data for HUC 8's in Washington, Idaho, Oregon and California.
#' Recommended to use the data that comes with this package from the Watershed Boundary Dataset (Made 
#' and maintained by the USGS).
#' @return A large multipolygon data frame, where each ESU/DPS has a collection of spatial polygons that 
#' show the full extent of where the ESU may be found.
#' @export
create_ESUBoundary <- function(data, spatialData){
  data <- data %>%
    dplyr::filter(Species %in% c("Eulachon", "Salmon, Chinook", "Salmon, chum",
                                 "Salmon, coho", "Salmon, sockeye", "Steelhead",
                                 "Sturgeon, green")) %>%
    dplyr::mutate(HUC8 = as.double(HUC8)) %>% # Did not read in as correct data type - fixed here
    dplyr::mutate(Species = dplyr::recode(Species,
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
  spatialData <- sf::st_as_sf(spatialData)
  ESUBasinsSpatial <- dplyr::full_join(data, spatialData, by = c("HUC8" = "huc8")) %>%
    sf::st_as_sf() %>%
    dplyr::mutate(DPS = paste(Population.Stock, Species, sep = " ")) # create ESU/DPS column (same unique values
  # as permit data)

  DPSs <- unique(ESUBasinsSpatial$DPS)
  nDPS <- length(DPSs)
  sf::sf_use_s2(use_s2 = F) # have to shut this off so loop works (due to some vertices being used in multiple shapes)

  temp <- ESUBasinsSpatial %>% dplyr::filter(DPS == DPSs[1])
  temp <- sf::st_union(temp)
  esuBound <- temp
  for (i in 2:nDPS){
    temp <- ESUBasinsSpatial %>% dplyr::filter(DPS == DPSs[i])
    temp <- sf::st_union(temp)
    esuBound <- rbind(esuBound, temp)
    rm(temp)
  } # loop to combine all polygons for each DPS -> creates ESU boundary polygons


  # This chunk re-formats, provides informative column names
  # and sets up spatial data
  esuBound <- cbind(DPSs, esuBound)
  esuBound <- as.data.frame(esuBound)
  names(esuBound) <- c("DPS", "geometry")
  esuBound$geometry <- sf::st_as_sfc(esuBound$geometry)
  esuBound <- sf::st_as_sf(esuBound)
  sf::st_crs(esuBound) <- 4326
  
  return(esuBound)
}
