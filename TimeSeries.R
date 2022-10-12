# Making Time Series Infographics
# Alana Santana and Rory Spurr
#=============================================================
#Reading in packages
library(shiny)
library(ggplot2)
library(sf)
library(dplyr)
library(tidyverse)
library(leaflet)
library(NMFSResPermits)
library(plotly)
library(viridis)
sf_use_s2(FALSE)
#==============================================================
#Sourcing Script
#setwd("~/GitHub/ESA_Permits_Capstone")
source(paste(getwd(), "/code/dependencies/Reading and Filtering.R", sep = ""))
source(paste(getwd(), "/code/dependencies/TS PreAppCode.R", sep = ""))
#==============================================================
#Shiny Integration
ui <-  fluidPage(
  titlePanel("Authorized versus Reported Take Plot"),
  sidebarLayout(
    
    sidebarPanel(
      radioButtons(inputId = "LifeStage", label = "Choose a lifestage",
                   choices = c("Adult", "Juvenile")),
      radioButtons(inputId = "Production", label = "Choose an Origin",
                   choices = c("Natural", "Listed Hatchery")),
      selectInput(inputId = "ESU", label = "Choose an ESU to View",
                  choices = levels(df$ESU), 
                  multiple = F)),
    mainPanel(
      plotlyOutput("plot1"), fluid = T,
      plotlyOutput("plot2"), fluid = T
    )))

server <- function(input, output, session){
  dat <- reactive({
    req(c(input$LifeStage, input$Production, input$ESU))
    df1 <- df %>% 
    filter(LifeStage %in% input$LifeStage) %>% 
    filter(Production %in% input$Production) %>%  
    filter(ESU %in% input$ESU) %>% 
    group_by(Year)
  })
output$plot1 <-renderPlotly({
  ggplot( data = dat(), aes (y = PropT, x = Year, text = paste("Take Action:", TakeAction) )) +
    geom_bar(stat = "identity", position = "stack")+
    scale_fill_viridis(discrete = F) +
    labs(x = "Year", y = "Authorized Take", title = "Total Authorized Take vs Reported Take over Time", legend = "Reported Take (Lethal/Non-Lethal")
  ggplotly(tooltip = c("y", "x", "text"))
})
output$plot2 <-renderPlotly({
  ggplot(data = dat(), aes (y = PropM, x = Year, text = paste("Take Action:", TakeAction) )) +
    geom_bar(stat = "identity", position = "stack")+
    scale_fill_viridis(discrete = F) +
    labs(x = "Year", y = "Authorized Mortality", title = "Total Authorized Mortality vs Reported Mortality over Time", legend = "Reported Take (Lethal/Non-Lethal")
  ggplotly(tooltip = c("y", "x", "text"))
})
} #sets up server object

shinyApp (ui = ui, server = server) 
