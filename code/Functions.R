# =================================================================================
# Helpful functions and data organization
# Rory Spurr
# =================================================================================

# Aggregating the number of apps per Species
species.num.apps <- function(dat){ # I put this in a function to reduce global variables
  # get species names
  species <- unique(dat$CommonName)
  #create tibble as species and the number of apps
  nApps <- table(dat$CommonName)
  SpeciesDist <- as_tibble(cbind(species, nApps))
  SpeciesDist <- SpeciesDist %>% 
    mutate(nApps = as.numeric(nApps)) %>%
    arrange(nApps) # sort in ascending order
  return(SpeciesDist)
}
species.num.apps(wcr)


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