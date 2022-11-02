#' @title reportFilter
#'
#' @description Filters the take/mortality reported data.
#' @param data Data frame from NOAA, with one line describing each permit, species, report \cr
#' year and the amount of take/mortality reported for that year
#' @return A data frame that contains only information pertinent to the App. Filters can be \cr
#' changed in the code if different filtering criteria need to be met, or priorities change.
#' @export
reportFilter <- function(data){
  data <- data %>%
    dplyr::filter(ResultCode %in% c("NMFS 10a1A Salmon","4d", "NMFS BiOp DTA", "Tribal 4d")) %>% 
    dplyr::mutate(LifeStage = dplyr::recode(LifeStage,
                              "Smolt" = "Juvenile",
                              "Kelt" = "Juvenile",
                              "Yearling" = "Juvenile",
                              "Sub-Yearling" = "Juvenile",
                              "Egg" = "Juvenile",
                              "Fry" = "Juvenile",
                              "Larvae" = "Juvenile",
                              "Subadult" = "Adult",
                              "Spawned Adult/ Carcass" = "Adult")) %>%
    dplyr::mutate(CommonName = dplyr::recode(CommonName,
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
    dplyr::mutate(Species = paste(Population, CommonName, sep = " ")) %>% 
    dplyr::mutate(Prod = dplyr::recode(Production, 
                         "Natural" = "Natural", 
                         "Listed Hatchery" = "Listed Hatchery", 
                         "Listed Hatchery, Clipped and Intact" = "Listed Hatchery",  
                         "Listed Hatchery Intact Adipose" = "Listed Hatchery", 
                         "Listed Hatchery Adipose Clip" = "Listed Hatchery",
                         "Unlisted Hatchery" = "Unlisted Hatchery")) %>%
    dplyr::filter(Prod != "Unlisted Hatchery") %>% 
    dplyr::filter(TakeAction != "Observe/Harass") %>%
    dplyr::filter(TakeAction != "Observe/Sample Tissue Dead Animal")
  return(data)
}