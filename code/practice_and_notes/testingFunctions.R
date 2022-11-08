


x <- createLocations(permitFilter(WestCoastPermitData))
# x <- x %>%
#   NMFSResPermits::create_totalmorts() # need to ask Diana about these functions,
# don't think they work when I added them, and think that they mostly worked
# because of the 'NOAA permitting team code' script.

SW_FW <- sapply(x$Location, assignWaterType)
x <- cbind(x, SW_FW)

# wcr4App <- x %>%
#   select(FileNumber, # File Number
#          ResultCode, # Permit Type
#          Organization, # Organization
#          HUCNumber, # HUC 8
#          Location, # Location
#          SW_FW, # water type
#          TakeAction:ExpTake, 
#          TotalMorts,
#          LifeStage,
#          Species,
#          Prod) %>%
#   mutate(HUCNumber = as.character(HUCNumber)) %>%
#   replace_na(list(HUCNumber = "No Data")) # This doesn't really need to be a function
# can just have this as a chunk within the function that calls the app, also does not work
# quite yet as the 

LocGroup1 <- c("Admiralty Inlet", "North Puget Sound", "South Puget Sound",
               "Whidbey Basin", "Puget Sound")
LocGroup2 <- "Hood Canal"
LocGroup3 <- "Strait of Juan de Fuca"

x <- assignMarineAreas(x, LocGroup1, LocGroup2, LocGroup3)
