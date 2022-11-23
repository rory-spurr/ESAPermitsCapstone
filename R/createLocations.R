#' @title createLocations
#'
#' @description Creates a Location field that describes the location of the research, based on 
#' hierarchical sort of the 4 location-based columns in the raw data. The default hierarchy is 
#' WaterbodyName > BasinName > StreamName > LocationDescription, where the highest-level data that 
#' is not NA was used. For example, if a permit had an NA value for WaterbodyName, and a non-NA value 
#' for BasinName, the BasinName value would be used to describe that permits location in the new “Location” column.
#' @param data Filtered permit data frame, usually the result of `permitFilter` function
#' @return A data frame of research permits, but now with the added Location column.
#' @export
createLocations <- function(data){
  data <- naniar::replace_with_na(data, replace = list(WaterbodyName = "N/A", 
                                                       BasinName = "N/A", 
                                                       StreamName = "N/A",
                                                       LocationDescription = "N/A")) # replace character NA values

  Location <- data$WaterbodyName
  for (i in 1:nrow(data)){
    if(is.na(Location[i] == T)){
      Location[i] <- data$BasinName[i]
    }
  }
  for (i in 1:nrow(data)){
    if(is.na(Location[i] == T)){
      Location[i] <- data$StreamName[i]
    }
  }
  data <- cbind(data, Location)
  data <- data %>%
    naniar::replace_with_na(replace = list(Location = ".")) # some inputted periods, may have to adjust if
  # there are other values to QC
  for (i in 1:nrow(data)){
    if(is.na(data$Location[i] == T)){
      data$Location[i] <- data$LocationDescription[i]
    }
  }
  return(data)
}

