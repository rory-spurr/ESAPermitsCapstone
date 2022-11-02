#' @title reportFilter
#'
#' @description Filters the take/mortality reported data.
#'
#' @export
reportFilter <- function(data){
  data <- data %>%
    filter(ResultCode %in% c("NMFS 10a1A Salmon","4d", "NMFS BiOp DTA", "Tribal 4d")) %>% 
    mutate(LifeStage = recode(LifeStage,
                              "Smolt" = "Juvenile",
                              "Kelt" = "Juvenile",
                              "Yearling" = "Juvenile",
                              "Sub-Yearling" = "Juvenile",
                              "Egg" = "Juvenile",
                              "Fry" = "Juvenile",
                              "Larvae" = "Juvenile",
                              "Subadult" = "Adult",
                              "Spawned Adult/ Carcass" = "Adult")) %>%
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
    mutate(Species = paste(Population, CommonName, sep = " ")) %>% 
    mutate(Prod = recode(Production, 
                         "Natural" = "Natural", 
                         "Listed Hatchery" = "Listed Hatchery", 
                         "Listed Hatchery, Clipped and Intact" = "Listed Hatchery",  
                         "Listed Hatchery Intact Adipose" = "Listed Hatchery", 
                         "Listed Hatchery Adipose Clip" = "Listed Hatchery",
                         "Unlisted Hatchery" = "Unlisted Hatchery")) %>%
    filter(Prod != "Unlisted Hatchery") %>% 
    filter(TakeAction != "Observe/Harass") %>%
    filter(TakeAction != "Observe/Sample Tissue Dead Animal")
  return(data)
}