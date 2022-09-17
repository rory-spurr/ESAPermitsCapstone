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
sf_use_s2(FALSE)
#==============================================================
#Sourcing Script
#setwd("~/GitHub/ESA_Permits_Capstone")
source(paste(getwd(), "/code/dependencies/Reading and Filtering 2.R", sep = ""))
#==============================================================
#Shiny Integration
ui <-  fluidPage(
  titlePanel("Authorized versus Actual Take Plots"),
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
      plotOutput("plot1"), fluid = T,
      plotOutput("plot2"), fluid = T
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
output$plot1 <-renderPlot({
  ggplot( data = dat(), aes (y = ExpTake, x = Year, fill = Year)) +
    geom_bar(stat = "identity")+
    labs(x = "Year", y = "Total Authorized Take", title = "Total Authorized Take over Time")
})
output$plot2 <-renderPlot({
  ggplot(data = dat(), aes (y = TotalMorts, x = Year, fill = Year)) +
    geom_bar(stat = "identity")+
    labs(x = "Year", y = "Total Actual Take", title = "Total Actual Take over Time")
})
} #sets up server object

shinyApp (ui = ui, server = server) 
