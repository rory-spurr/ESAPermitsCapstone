#############################################################
# Alana Santana and Rory Spurr                              #
# Preliminary Product and Shiny Dashboard Integration        #
#############################################################

#=============================================================
#Reading in packages
library(shiny)
library(shinydashboard)
library(ggplot2)
library(sf)
library(dplyr)
library(tidyverse)
library(leaflet)

#==============================================================
#Sourcing Script
#source("code/Reading and Filtering.R") # commented out for Shiny integration

#==============================================================
#Leaflet setup

#==============================================================
#R Shiny Dashboard
ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(),
  dashboardBody()
)

server <- function(input, output) { }

shinyApp(ui, server)

server <- function(input, output) {
  set.seed(122)
  histdata <- rnorm(500)
  
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
}

shinyApp(ui, server)