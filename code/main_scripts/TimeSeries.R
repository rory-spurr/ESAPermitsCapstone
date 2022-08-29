# Making Time Series Infographics
# Alana Santana and Rory Spurr
#=============================================================
#Reading in packages
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
#==============================================================
#Setting up data
