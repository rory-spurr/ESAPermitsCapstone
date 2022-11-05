#' @title assignWaterType
#'
#' @description Creates a vector describing whether the research permits are occuring
#' in freshwater or saltwater based on strings within the Location column.
#' @param x a character column of Location names.
#' @param strings1 A vector of common strings found in the name of saltwater areas. Strings
#' can be user created, or default sting names can be used that are stored within the package. 
#' The list of default saltwater stings can be accessed by calling `SW_strings`.
#' @param strings2 A vector of common strings found in the name of freshwater areas. Strings
#' can be user created, or default string names can be used that are stored within the package. 
#' The list of default freshwater strings can be accessed by calling `FW_strings`.
#' @return A character vector denoting freshwater, saltwater, or both.
#' @export
assignWaterType <- function(x, strings1 = SW_strings, strings2 = FW_strings){
  result <- "empty"
  ifelse(stringr::str_detect(x, paste(strings1, collapse = "|")) & 
          stringr::str_detect(x, paste(strings2, collapse = "|")), result <- "SW/FW",
         ifelse(stringr::str_detect(x, paste(strings1, collapse = "|")), result <- "SW",
                result <- "FW"))
  return(result)
}