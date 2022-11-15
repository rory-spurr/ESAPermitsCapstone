#' @title MakeLeafletApp
#'
#' @description Creates the Leaflet app displaying take data for ESA-listed species.
#' @param data Data frame describing the different HUC 8 where ESUs can be found. One row per unique
#' DPS/huc8 combination. Therefore species that are found in multiple DPSs wil be lsted in multiple 
#' rows, one for each DPS where they can be found.
#' @param spatialData Polygon spatial data for HUC 8's in Washington, Idaho, Oregon and California.
#' Recommended to use the data that comes with this package from the Watershed Boundary Dataset (Made 
#' and maintained by the USGS).
#' @return A large multipolygon data frame, where each ESU/DPS has a collection of spatial polygons that 
#' show the full extent of where the ESU may be found.
#' @export
MakeLeafletApp <- function(data, spatialData, ESUhucData){
  
  permitDF <- createLocations(permitFilter(data))
  
  sp.order <- NMFSResPermits::sp.order # Need data from this package for functions to work
  ls.order <- NMFSResPermits::ls.order
  pr.order <- NMFSResPermits::pr.order
  
  permitDF <- permitDF %>%
    NMFSResPermits::rename_population() %>%
    NMFSResPermits::create_totalmorts() %>%
    NMFSResPermits::order_table()
  
  SW_FW <- sapply(permitDF$Location, assignWaterType)
  permitDF <- cbind(permitDF, SW_FW)
  
  wcr4App <- permitDF %>%
    dplyr::select(FileNumber, # File Number
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
    dplyr::mutate(HUCNumber = as.character(HUCNumber)) %>%
    tidyr::replace_na(list(HUCNumber = "No Data"))
  
  LocGroup1 <- c("Admiralty Inlet", "North Puget Sound", "South Puget Sound",
                 "Whidbey Basin", "Puget Sound")
  LocGroup2 <- "Hood Canal"
  LocGroup3 <- "Strait of Juan de Fuca"
  
  x <- assignMarineAreas(x, LocGroup1, LocGroup2, LocGroup3)
  
  takeframe <- createMapDF(x, WestCoastHUC8, T)
  mortframe <- createMapDF(x, WestCoastHUC8, F)
  esuBound <- create_ESUBoundary(data = ESUwithHUC, spatialData = WestCoastHUC8)
}