# Making Time Series Infographics - Line plots
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
source(paste(getwd(), "/code/dependencies/TSPreAppCode3.R", sep = ""))
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
      plotOutput("plot1"), fluid = T,
      plotOutput("plot2"), fluid = T
    )))

server <- function(input, output, session){
  dat <- reactive({
    req(c(input$LifeStage, input$Production, input$ESU))
    df1 <- plot %>% 
      filter(LifeStage %in% input$LifeStage) %>% 
      filter(Production %in% input$Production) %>%  
      filter(ESU %in% input$ESU)
  })
  dat2 <- reactive({
    req(c(input$LifeStage, input$Production, input$ESU))
    df1 <- plot2 %>% 
      filter(LifeStage %in% input$LifeStage) %>%
      filter(Production %in% input$Production) %>%
      filter(ESU %in% input$ESU)
  })
  output$plot1 <-renderPlot({
    ggplot(data = dat(), aes (y = N, x = Year, color = Take, group = Take))+ 
      geom_line()+
      scale_color_discrete(name = "Take Type", labels = c("Authorized Take", "Reported Take")) +
      labs(x = "Year", y = "Take")+ 
      theme(axis.text.x = element_text(angle = 30, hjust = 0.5, vjust = 0.5))
    #ggplotly(tooltip = c("y", "x", "fill"))
  })
  output$plot2 <-renderPlot({
    ggplot(data = dat2(), aes (y = N, x = Year, color = Take, group = Take))+ 
      geom_line()+
      scale_color_discrete(name = "Take Type", labels = c("Authorized Mortality", "Reported Mortality")) +
      labs(x = "Year", y = "Take")+ 
      theme(axis.text.x = element_text(angle = 30, hjust = 0.5, vjust = 0.5))
    #ggplotly(tooltip = c("y", "x", "fill"))
  })
} 

shinyApp (ui = ui, server = server) 
