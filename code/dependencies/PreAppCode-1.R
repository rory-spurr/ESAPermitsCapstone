# Rory Spurr
# Script to be run before the Shiny app


source("code/dependencies/Reading and Filtering.R")
source("code/dependencies/NOAA Permitting Team Code.R")
library(shiny)
library(leaflet)
library(leaflet.extras)
library(leaflet.providers)
library(htmlwidgets)
# library(devtools)
# devtools::install_github("DianaDishman-NOAA/NMFSResPermits")
library(NMFSResPermits)

wcr <- wcr %>%
  rename_population() %>%
  rename_takeaction() %>%
  create_totalmorts() %>%
  order_table()

ESUs <- unique(wcr$Species)
ESUs

ESUdf <- aggregate(wcr$ExpTake, 
                   by = list(wcr$HUCNumber, wcr$Species, wcr$LifeStage, wcr$Prod),
                   FUN = sum) # aggregate total expected take by HUC
names(ESUdf) <- c("huc8", "ESU", "LifeStage", "Production", "theData") # rename columns
ESU_spatialTotal <- right_join(wbd.hucs, ESUdf, by = "huc8") 
ESU_spatialTotal <- st_transform(ESU_spatialTotal, crs = 4326)

ESU_spatialTotal$labels <- paste0(
  "<strong> Name: </strong>",
  ESU_spatialTotal$name, "<br/> ",
  "<strong> HUC 8: </strong>",
  ESU_spatialTotal$huc8, "<br/> ",
  "<strong> Authorized Take (# of fish): </strong> ",
  ESU_spatialTotal$theData, "<br/> "
) %>%
  lapply(htmltools::HTML)


ESUdfMort <- aggregate(wcr$TotalMorts,
                       by = list(wcr$HUCNumber, wcr$Species, wcr$LifeStage, wcr$Prod),
                       FUN = sum)
names(ESUdfMort) <- c("huc8", "ESU", "LifeStage", "Production", "theData") # rename columns
ESU_spatialMort <- right_join(wbd.hucs, ESUdfMort, by = "huc8") 
ESU_spatialMort <- st_transform(ESU_spatialMort, crs = 4326)

ESU_spatialMort$labels <- paste0(
  "<strong> Name: </strong>",
  ESU_spatialMort$name, "<br/> ",
  "<strong> HUC 8: </strong>",
  ESU_spatialMort$huc8, "<br/> ",
  "<strong> Lethal Take (# of fish): </strong> ",
  ESU_spatialMort$theData, "<br/> "
) %>%
  lapply(htmltools::HTML)


# # ESUdf <- cbind(ESUdf, ESUdfMort$TotalMorts) # Add Total morts to dataframe
# # names(ESUdf)[6] <- c("TotalMorts")# rename column
# 
# # join with spatial data
# ESU.spatial <- right_join(wbd.hucs, ESUdf, by = "huc8") 
# ESU.spatial <- st_transform(ESU.spatial, crs = 4326)
# 
# # Make labels for Leaflet map popup



