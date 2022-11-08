#' @title assignMarineAreas
#'
#' @description Assigns HUC 8 codes to marine areas based on Location column
#' @param data Filtered permit data frame, with the added `Location` column already
#' created.
#' @param LocGroup1 Character vector describing Location names to assign to HUC 8 number
#' 17110019 - "Puget Sound". 
#' @param LocGroup2 Character vector describing Location names to assign to HUC 8 number
#' 17110018 - "Hood Canal". 
#' @param LocGroup3 Character vector describing Location names to assign to HUC 8 number
#' 17110021 - "Crescent-Hoko".Note that it is possible that a different HUC could have been 
#' chosen (17110020 - "Dungeness-Elwha") as either of these HUCs can describe Strait of Juan 
#' de Fuca research.
#' @return A very similar data frame, know with more HUC's assigned to marine areas
#' @export
assignMarineAreas <- function(data, LocGroup1, LocGroup2, LocGroup3){
  N <- length(data$Location)
  for (i in 1:N){
    if (data$Location[i] %in% LocGroup1) {data$HUCNumber[i] <- 17110019} 
    if (data$Location[i] %in% LocGroup2) {data$HUCNumber[i] <- 17110018} 
    if (data$Location[i] %in% LocGroup3) {data$HUCNumber[i] <- 17110021} 
  }
  return(data)
}

