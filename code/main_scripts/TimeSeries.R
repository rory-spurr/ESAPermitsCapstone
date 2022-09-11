# Making Time Series Infographics
# Alana Santana and Rory Spurr
#=============================================================
#Reading in packages
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
#Setting up data - Changing time factor
a<-as.factor(wcr.ts$AnnualTimeStart)
b<-strptime(a,format="%Y-%m-%d") 
Year <- format(as.Date(b, format ="%Y-%m-%d" ), "%Y")
Year <- as.data.frame(Year)
wcr.v <- cbind(wcr.ts, Year)
#==============================================================
#Setting up data - Creating authtake and totalmorts 
wcr.v <-wcr.v %>% 
  create_totalmorts() %>%
  order_table() %>% 
  replace_na(list(ExpTake = 0, ActTake = 0, TotalMorts = 0, ActMort = 0))
wcr.v <- wcr.v %>% 
  mutate(AuthTake = ExpTake + IndMort)
#==============================================================
#Aggregating Authorized Take 
df <- aggregate(wcr.v$AuthTake, 
                by = list(wcr.v$CommonName, wcr.v$Species, wcr.v$LifeStage, wcr.v$Prod, 
                          wcr.v$Year, wcr.v$TotalMorts), FUN = sum) 

names(df) <- c("CommonName", "ESU", "LifeStage", "Production", "Year", "TotalMorts", "AuthTake")
  
#==============================================================
#Creating prelim plot - LifeStage across all species/production over time
ggplot(data = df, aes(x=Year, y= AuthTake, fill = LifeStage))+
  geom_bar(stat = "identity",
           position = "dodge") # How do I know if it is aggregating correctly?

ggplot(data = df, aes(x=Year, y= TotalMorts, fill = LifeStage))+
  geom_bar(stat = "identity",
           position = "dodge")
#==============================================================
#Creating prelim plot - ESU across all LifeStages/production over time
ggplot(data = df, aes(x=Year, y= AuthTake, fill = ESU))+
  geom_bar(stat = "identity",
           position = "dodge")
ggplot(data = df, aes(x=Year, y= TotalMorts, fill = ESU))+
  geom_bar(stat = "identity",
           position = "dodge")
#==============================================================
#Creating prelim plot - Production across all species/lifestages over time
ggplot(data = df, aes(x=Year, y= AuthTake, fill = Production))+
  geom_bar(stat = "identity",
           position = "dodge")
ggplot(data = df, aes(x=Year, y= TotalMorts, fill = Production))+
  geom_bar(stat = "identity",
           position = "dodge")
#==============================================================
#Shiny Integration
ui <-  fluidPage(
  titlePanel("Title"),
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
      plotOutput("plot"), fluid = T
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
output$plot <-renderPlot({
  ggplot( data = df, aes (y = AuthTake, x = Year)) +
    geom_bar(stat = "identity")
})
# output$plot <-renderPlot({
#   ggplot(data = df, aes (y = TotalMorts, x = Year)) +
#     geom_bar(stat = "identity")
# })
} #sets up server object

shinyApp (ui = ui, server = server) 