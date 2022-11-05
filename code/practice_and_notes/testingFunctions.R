


x <- createLocations(permitFilter(WestCoastPermitData))
SW_FW <- sapply(x$Location, assignWaterType)
x <- cbind(x, SW_FW)

