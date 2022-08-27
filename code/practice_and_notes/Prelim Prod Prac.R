# Alana Santana
# Additional Information Shiny Dashboard Practice

#=============================================================
#Reading in packages
library(shiny)
library(shinydashboard)
library(ggplot2)
library(sf)
library(dplyr)
library(tidyverse)
library(leaflet)
sf_use_s2(FALSE)
#==============================================================
#Sourcing Script
setwd("~/GitHub/ESA_Permits_Capstone")
source(paste(getwd(), "/code/dependencies/Reading and Filtering.R", sep = ""))
source("code/dependencies/PreAppCode-1.R")
st_transform(wcr_spatial, st_crs(wcr_spatial))
#==============================================================
#Setting up leaflet 1 - Gear type 
wcr_GT <- wcr_spatial %>% 
  group_by(huc8, name, states, Species, CaptureMethod, Organization) %>% 
  count(permit = ResultCode)
wcr_GT <- subset(wcr_GT, permit != FALSE) 
#==============================================================
#Setting up palette for leaflet 1
#pal <- colorBin("viridis", domain = wcr_GT$states) #in progress: finding better way to bin data
#==============================================================
# Creating Map 1
labels <- paste0(
  "<strong> State: </strong> ",
  wcr_GT$states, "<br/> ",
  "<strong> HUC: </strong> ",
  wcr_GT$name, "<br/> ",
  "<strong> Organization: </strong> ",
  wcr_GT$Organization, "<br/> ",
  "<strong> Gear Type: </strong> ",
  wcr_GT$CaptureMethod, "<br/> ",
  "<strong> Species: </strong> ",
  wcr_GT$Species, "<br/> ") %>%
  lapply(htmltools::HTML)

leaflet(wcr_GT) %>% 
  addProviderTiles(providers$Stamen.TonerLite) %>% 
  addEasyButton(easyButton(
    icon="fa-crosshairs", title="Locate Me",
    onClick=JS("function(btn, map){ map.locate({setView: true}); }"))) %>%
  addPolygons(
    fillColor = "red", 
    color = "white",
    fillOpacity = 0.9, 
    label = ~labels,
    highlight = highlightOptions(color = "white", bringToFront = T)) %>% 
  setView(lng = -124.072971, lat = 43.458,
          zoom = 5)
#==============================================================
#Setting up leaflet 2 - Take Action
wcr_TA <- wcr_spatial %>% 
  group_by(huc8, name, states, Species, TakeAction, Organization) %>% 
  count(permit = ResultCode)
wcr_TA <- subset(wcr_TA, permit != FALSE) 
#==============================================================
# Creating Map 2
labels <- paste0(
  "<strong> State: </strong> ",
  wcr_TA$states, "<br/> ",
  "<strong> HUC: </strong> ",
  wcr_TA$name, "<br/> ",
  "<strong> Organization: </strong> ",
  wcr_TA$Organization, "<br/> ",
  "<strong> Gear Type: </strong> ",
  wcr_TA$TakeAction, "<br/> ",
  "<strong> Species: </strong> ",
  wcr_GT$Species, "<br/> ") %>%
  lapply(htmltools::HTML)

leaflet(wcr_TA) %>% 
  addProviderTiles(providers$Stamen.TonerLite) %>% 
  addEasyButton(easyButton(
    icon="fa-crosshairs", title="Locate Me",
    onClick=JS("function(btn, map){ map.locate({setView: true}); }"))) %>%
  addPolygons(
    fillColor = "blue", 
    color = "white",
    fillOpacity = 0.9, 
    label = ~labels,
    highlight = highlightOptions(color = "white", bringToFront = T)) %>% 
  setView(lng = -124.072971, lat = 43.458,
          zoom = 5)
#==============================================================
#Setting up tables to display data
#in progress
#==============================================================
#Integrating into Shiny Dashboard
#in progress