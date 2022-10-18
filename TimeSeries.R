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
  ggplot(data = dat(), aes (y = ProportionT, x = Year, fill = Take) ) +
    geom_bar(stat = "identity", position = "stack")+
    scale_fill_viridis(discrete = T) +
    labs(x = "Year", y = "Take", title = "Total Authorized Take vs Reported Take over Time")
  ggplotly(tooltip = c("y", "x"))
})
output$plot2 <-renderPlotly({
  ggplot(data = dat(), aes (y = ProportionM, x = Year, fill = Mortality )) +
    geom_bar(stat = "identity", position = "stack")+
    scale_fill_viridis(discrete = T) +
    labs(x = "Year", y = "Mortality", title = "Total Authorized Mortality vs Reported Mortality over Time")
})
} #sets up server object

shinyApp (ui = ui, server = server) 
