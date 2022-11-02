#' @title permitFilter
#'
#' @description Filters the West Coast region permit data
#'
#' @export
permitFilter <- function(data){
  data <- data %>% 
    filter(PermitStatus == "Issued") %>%
    filter(DateIssued >"2012-01-01") %>%
    filter(DateExpired >= Sys.Date()) %>% #DateField >= Sys.Date() puts it to the date of the system
    filter(ResultCode %in% c("NMFS 10a1A Salmon","4d", "NMFS BiOp DTA", "Tribal 4d")) %>%
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
                              `18060012` = 18060006)) %>% 
    mutate(Species = paste(Population, CommonName, sep = " ")) %>% 
    mutate(Prod = recode(Production, 
                         "Natural" = "Natural", 
                         "Listed Hatchery" = "Listed Hatchery", 
                         "Listed Hatchery, Clipped and Intact" = "Listed Hatchery",  
                         "Listed Hatchery Intact Adipose" = "Listed Hatchery", 
                         "Listed Hatchery Adipose Clip" = "Listed Hatchery", 
                         # "Listed Hatchery and Natural Origin" = "All", # Only applies to abundance data
                         "Unlisted Hatchery" = "Unlisted Hatchery")) %>%
    filter(Prod != "Unlisted Hatchery") %>%
    filter(Prod != "All") %>% 
    filter(TakeAction != "Observe/Harass") %>%
    filter(TakeAction != "Observe/Sample Tissue Dead Animal") %>%
    filter(TakeAction != "Unknown")
  return(data)
}


