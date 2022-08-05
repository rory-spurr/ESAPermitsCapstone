source("Reading and Filtering.R")
source("NOAA Permitting Team Code.R")

library(shiny)
library(leaflet)
library(leaflet.extras)
library(leaflet.providers)
library(htmlwidgets)

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
names(ESUdf) <- c("huc8", "ESU", "Lifestage", "Production", "ExpTake") # rename columns
ESU.spatial <- right_join(wbd.hucs, ESUdf, by = "huc8") # join with spatial data
ESU.spatial <- st_transform(ESU.spatial, crs = 4326)

# Make labels for Leaflet map popup
ESU.spatial$labels <- paste0(
    "<strong> Name: </strong>",
    ESU.spatial$name, "<br/> ",
    "<strong> HUC 8: </strong>",
    ESU.spatial$huc8, "<br/> ",
    "<strong> Authorized Take (# of fish): </strong> ",
    ESU.spatial$ExpTake, "<br/> "
  ) %>%
    lapply(htmltools::HTML)
