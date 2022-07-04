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
                            `18060012` = 18060006)) # check notes below:
# recoding HUCs to account for HUCs that were altered or moved
# broken hucs are 18020103, 18020109, 18020112, 18020118,
# 18040005, 18060001, 18060012

# What to change them to:
# 18020103 = 18020156 # very certain
# 18020109 = 18020163 # very certain
# 18020112 = 18020154 # very certain based on location descriptions
# 18020118 = 18020154 # very certain based on location descriptions
# 18040005 = 18040012 # very certain based on location descriptions
# 18060001 = 18060015 # split between 18050006 as well, arbitrarily picked
# 18060012 = 18060006 # chose this over Monterrey Bay as population is South-Central Cal Coast

# Seperate DF by life stage
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

# =================================================================================
# Helpful functions and data organization
# =================================================================================
# Aggregating the number of apps per Species
species.num.apps <- function(dat){ # I put this in a function to reduce global variables
  # get species names
  species <- unique(dat$CommonName)
  # total number of species
  nspecies <- length(species)
  
  #create tibble os species and the number of apps
  nApps <- table(dat$CommonName)
  SpeciesDist <- as_tibble(cbind(species, nApps))
  
  # # the following chunk sorts and organizes data (in the barplot) 
  # but breaks in R Shiny therefore its commented out for now
  # sorted <- sort(SpeciesDist$nApps)
  # positions <- vector(length = nspecies)
  # for (i in 1:nspecies){
  #   positions[i] <- which(SpeciesDist$nApps == sorted[i])
  # }
  # speciesLevels <- species[positions]
  # SpeciesDist$species <- factor(SpeciesDist$species,
  #                               levels = speciesLevels)
  SpeciesDist$nApps <- as.numeric(SpeciesDist$nApps)
  return(SpeciesDist)
}



# ============================================================================
# Creating spatial data frames for each species
species <- unique(wcr_spatial$CommonName)

nspecies <- length(species)
species.dats <- list(NULL)

for (i in 1:(nspecies-2)){
  temp <- wcr_rev5 %>%
    filter(CommonName == species[i])
  species.dats[[i]] <- temp
  # print(paste("yay", i, "done")) # tracking progress as it was running slowly
  rm(temp)
}

for (i in 1:(nspecies-2)){
  temp <- right_join(x = wbd.hucs, y = species.dats[[i]], by = c("huc8" = "HUCNumber")) 
  temp <- filter(temp, huc8 != c(99999999, NA))
  species.dats[[i]] <- temp
  rm(temp)
}

sf::sf_use_s2(FALSE)

mort.sum <- function(x){
  x <- x %>%
    group_by(huc8) %>%
    summarize(sum = sum(IndMort, na.rm = T))
}

species.dats <- lapply(species.dats, mort.sum)
names(species.dats) <- species[1:7]


# x <- subset(species.dats, names(species.dats) == "Salmon, Chinook")
# x
# x <- x %>% as.data.frame() %>% st_as_sf()
# class(x)
# names(x)[1:2] <- c("huc8", "sum")
# ploty.plot <- ggplot() +
#   geom_sf(data = wcr.bound, fill = "ivory") +
#   geom_sf(data = x, aes(fill = sum)) +
#   scale_fill_continuous(type = "viridis", name = "Incidental Mortality") +
#   theme_bw()
# ggsave(here("output", "plotyplot.pdf"))

