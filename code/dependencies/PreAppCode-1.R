# Rory Spurr
# Script #1 to be run before the Shiny app
# =================================================
# Summary:
# This script creates the tables that summarize both lethal and non-lethal take data. 
# Also creates the labels that are used in Leaflet popups, and joins the tables to spatial 
# data for HUC 8's

# =================================================
# Source dependent scripts as well as read in important packages

source("code/dependencies/Reading and Filtering.R")
source("code/dependencies/NOAA Permitting Team Code.R")
library(shiny)
library(leaflet)
library(leaflet.extras)
library(leaflet.providers)
library(htmlwidgets)

# Package made by Diana Dishman at NOAA, new users will have to download the package from Github
# by un-commenting and running lines 23:24.
#
# library(devtools)
# devtools::install_github("DianaDishman-NOAA/NMFSResPermits")
library(NMFSResPermits)

# =================================================
# Use functions from NMFSResPermits package to organize data and create columns
wcr <- wcr %>%
  rename_population() %>%
  rename_takeaction() %>%
  create_totalmorts() %>%
  order_table()

# =================================================
# Aggreagation and joining
# End result is two seperate tables, one summarizing total take and one summarizing lethal take, with
# spatial data attached.

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
  lapply(htmltools::HTML) # create labels for Leaflet map popups


ESUdfMort <- aggregate(wcr$TotalMorts,
                       by = list(wcr$HUCNumber, wcr$Species, wcr$LifeStage, wcr$Prod),
                       FUN = sum) # aggregate total lethal take by HUC, species, life stage and production
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
  lapply(htmltools::HTML) # Create labels for Leaflet map popups





