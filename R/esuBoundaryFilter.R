#' @title esuBoundaryFilter
#'
#' @description Filters to only include species relevant to the app.
#' @param data Data frame describing the different HUC 8 where ESUs can be found
#' @return A data frame that contains only the relevant species. 
#' @export
esuBoundaryFilter <- function(data){
  data <- data %>%
    dplyr::filter(Species %in% c("Eulachon", "Salmon, Chinook", "Salmon, chum",
                          "Salmon, coho", "Salmon, sockeye", "Steelhead",
                          "Sturgeon, green"))
}