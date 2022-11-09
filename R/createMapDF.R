#' @title createMapDF
#'
#' @description Creates data frames for input into Leaflet map.
#' @param data Filtered permit data frame with TotalMorts column already created.
#' @param spatialData Polygon spatial data for HUC 8's in Washington, Idaho, Oregon and California.
#' Recommended to use the data that comes with this package from the Watershed Boundary Dataset (Made 
#' and maintained by the USGS).
#' @param createTakeVar Logical indicating whether total take (sum of lethal and non-lethal take) data 
#' should be summarized instead of only lethal take data. Defaults to TRUE indicating that total take 
#' data should be summarized
#' @return A spatial data frame with the total amount of take or mortalities for each unique ESU, huc8, 
#' LifeStage, and Production combination.
#' @export
createMapDF <- function(data, spatialData, createTakeVar = T){
  ESUs <- unique(data$Species)
  
  ESUdf <- stats::aggregate(if (createTakeVar == T) {data$ExpTake} else {data$TotalMorts}, 
                            by = list(data$HUCNumber, data$Species, data$LifeStage, data$Prod),
                            FUN = sum) # aggregate total expected take by HUC
  names(ESUdf) <- c("huc8", "ESU", "LifeStage", "Production", "theData") # rename columns
  # need generic "theData" name so that we can have Leaflet toggle between data
  # types
  
  ESU_spatial <- dplyr::right_join(spatialData, ESUdf, by = "huc8") 
  
  ESU_spatial <- ESU_spatial %>% 
    sf::st_transform(crs = 4326) %>% # need to for Leaflet (WGS 1984)
    dplyr::filter(huc8 != 99999999) %>% 
    dplyr::filter(!is.na(huc8))
  
  # Creates labels for Leaflet popup, but has to create correct labels
  # based on which variable we are creating them for.
  if (createTakeVar == T){
    ESU_spatial$labels <- paste0(
      "<strong> Name: </strong>",
      ESU_spatial$name, "<br/> ",
      "<strong> HUC 8: </strong>",
      ESU_spatial$huc8, "<br/> ",
      "<strong> Authorized Take (# of fish): </strong> ",
      ESU_spatial$theData, "<br/> "
    ) %>%
      lapply(htmltools::HTML) 
  } else {
    ESU_spatial$labels <- paste0(
      "<strong> Name: </strong>",
      ESU_spatial$name, "<br/> ",
      "<strong> HUC 8: </strong>",
      ESU_spatial$huc8, "<br/> ",
      "<strong> Lethal Take (# of fish): </strong> ",
      ESU_spatial$theData, "<br/> "
    ) %>%
      lapply(htmltools::HTML) 
  }
  return(ESU_spatial)
}
