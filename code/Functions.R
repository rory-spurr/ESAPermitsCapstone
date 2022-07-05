# =================================================================================
# Helpful functions and data organization
# Rory Spurr
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