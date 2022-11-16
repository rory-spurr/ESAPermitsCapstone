
library(ESAPermitsCapstone)

x <- createLocations(permitFilter(WestCoastPermitData))
sp.order <- NMFSResPermits::sp.order # Need data from this package for functions to work
ls.order <- NMFSResPermits::ls.order
pr.order <- NMFSResPermits::pr.order
x <- x %>%
  NMFSResPermits::rename_population() %>%
  NMFSResPermits::create_totalmorts() %>%
  NMFSResPermits::order_table()

SW_FW <- sapply(x$Location, assignWaterType)
x <- cbind(x, SW_FW)

wcr4App <- x %>%
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
  tidyr::replace_na(list(HUCNumber = "No Data")) # This doesn't really need to be a function
# can just have this as a chunk within the function that calls the app

LocGroup1 <- c("Admiralty Inlet", "North Puget Sound", "South Puget Sound",
               "Whidbey Basin", "Puget Sound")
LocGroup2 <- "Hood Canal"
LocGroup3 <- "Strait of Juan de Fuca"

x <- assignMarineAreas(x, LocGroup1, LocGroup2, LocGroup3)

takeframe <- createMapDF(x, WestCoastHUC8, T)
mortframe <- createMapDF(x, WestCoastHUC8, F)
esuBound <- create_ESUBoundary(data = ESUwithHUC, spatialData = WestCoastHUC8)
 

library(ESAPermitsCapstone)
MakeLeafletApp(DF = WestCoastPermitData, spatialData = WestCoastHUC8, ESUhucData = ESUwithHUC)


# remotes::install_github("Appsilon/shiny.react")
# remotes::install_github("Appsilon/shiny.fluent")

  
  