#' @title esuBoundaryFilter
#'
#' @description Takes only the species we want from the ESU boudary data file.
#'
#' @export
esuBoundaryFilter <- function(data){
  data <- data %>%
    filter(Species %in% c("Eulachon", "Salmon, Chinook", "Salmon, chum",
                          "Salmon, coho", "Salmon, sockeye", "Steelhead",
                          "Sturgeon, green"))
}