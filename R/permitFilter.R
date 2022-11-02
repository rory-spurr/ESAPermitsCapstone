#' @title permitFilter
#'
#' @description Filters the West Coast region permit data
#' @param data Data frame from NOAA, with one line describing each separate permit number, \cr
#' type, species, location, amount of authorized take, etc.
#' @return A data frame that contains only information pertinent to the App. Filters can be \cr
#' changed in the code if different filtering criteria need to be met, or priorities change.
#' @export
permitFilter <- function(data){
  data <- data %>% 
    dplyr::filter(PermitStatus == "Issued") %>%
    dplyr::filter(DateIssued >"2012-01-01") %>%
    dplyr::filter(DateExpired >= Sys.Date()) %>% #DateField >= Sys.Date() puts it to the date of the system
    dplyr::filter(ResultCode %in% c("NMFS 10a1A Salmon","4d", "NMFS BiOp DTA", "Tribal 4d")) %>%
    dplyr::mutate(LifeStage = dplyr::recode(LifeStage,
                              "Smolt" = "Juvenile",
                              "Fry" = "Juvenile",
                              "Larvae" = "Juvenile",
                              "Subadult" = "Adult")) %>%
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
    dplyr::mutate(HUCNumber = dplyr::recode(HUCNumber,
                              `18020103` = 18020156,
                              `18020109` = 18020163,
                              `18020112` = 18020154,
                              `18020118` = 18020154,
                              `18040005` = 18040012,
                              `18060001` = 18060015,
                              `18060012` = 18060006)) %>% 
    dplyr::mutate(Species = paste(Population, CommonName, sep = " ")) %>% 
    dplyr::mutate(Prod = dplyr::recode(Production, 
                         "Natural" = "Natural", 
                         "Listed Hatchery" = "Listed Hatchery", 
                         "Listed Hatchery, Clipped and Intact" = "Listed Hatchery",  
                         "Listed Hatchery Intact Adipose" = "Listed Hatchery", 
                         "Listed Hatchery Adipose Clip" = "Listed Hatchery", 
                         # "Listed Hatchery and Natural Origin" = "All", # Only applies to abundance data
                         "Unlisted Hatchery" = "Unlisted Hatchery")) %>%
    dplyr::filter(Prod != "Unlisted Hatchery") %>%
    dplyr::filter(Prod != "All") %>% 
    dplyr::filter(TakeAction != "Observe/Harass") %>%
    dplyr::filter(TakeAction != "Observe/Sample Tissue Dead Animal") %>%
    dplyr::filter(TakeAction != "Unknown")
  return(data)
}


