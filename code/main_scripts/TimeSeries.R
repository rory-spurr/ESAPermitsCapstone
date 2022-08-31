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
source(paste(getwd(), "/code/dependencies/Reading and Filtering.R", sep = ""))
#==============================================================
#Setting up data - Changing time factor
a<-as.factor(wcr_act$AnnualTimeStart)
b<-strptime(a,format="%Y-%m-%d") 
Year <- format(as.Date(b, format ="%Y-%m-%d" ), "%Y")
Year <- as.data.frame(Year)
wcr.v <- cbind(wcr_act, Year)
#==============================================================
#Setting up data - Filtering and recoding 
wcr.v <- wcr.v %>% 
  filter(ResultCode == c("NMFS 10a1A Salmon","4d", "NMFS BiOp DTA", "Tribal 4d")) %>% 
  mutate(CommonName = recode(CommonName,
                             "Salmon, coho" = "coho salmon",
                             "Steelhead" = "steelhead", #steelhead respawn
                             "Eulachon" = "eulachon",
                             "Salmon, Chinook" = "Chinook salmon",
                             "Salmon, chum" = "chum salmon",
                             "Salmon, sockeye" = "sockeye salmon",
                             "Sturgeon, green" = "green sturgeon",
                             "Rockfish, Canary" = "canary rockfish",
                             "Rockfish, Bocaccio" = "bocaccio",
                             "Rockfish, Yelloweye" = "yelloweye rockfish")) %>%
  mutate(LifeStage = recode(LifeStage,
                            "Smolt" = "Juvenile",
                            "Fry" = "Juvenile",
                            "Larvae" = "Juvenile",
                            "Subadult" = "Adult")) %>%
  filter(LifeStage != "Spawned Adult/ Carcass") %>% 
  mutate(Species = paste(Population, CommonName, sep = " ")) %>% 
  mutate(Species = recode(Species, 
                          "NA sockeye salmon" = "Columbia River sockeye salmon")) %>% 
  mutate(Prod = recode(Production, 
                       "Natural" = "Natural", 
                       "Listed Hatchery" = "Listed Hatchery", 
                       "Listed Hatchery, Clipped and Intact" = "Listed Hatchery",  
                       "Listed Hatchery Intact Adipose" = "Listed Hatchery", 
                       "Listed Hatchery Adipose Clip" = "Listed Hatchery", 
                       "Unlisted Hatchery" = "Unlisted Hatchery")) %>%
  filter(Prod != "Unlisted Hatchery") %>%
  filter(Prod != "All") %>% 
  filter(Species != "NA")
#==============================================================
#Setting up data - Creating authtake and totalmorts 
wcr.v <-wcr.v %>% 
  create_totalmorts() %>%
  order_table() %>% 
  replace_na(list(ExpTake = 0, ActTake = 0, TotalMorts = 0, ActMort = 0))
wcr.v <- wcr.v %>% 
  mutate(AuthTake = ExpTake + IndMort)
#==============================================================
#Setting up data
ESU <- wcr.v %>% 
  filter(Species == "Puget Sound Chinook salmon") %>% 
  select(Year, Species, Prod, AuthTake, TotalMorts) %>% 
  group_by(Year) %>% 
  count(Sp.cnt = Species == "Puget Sound Chinook salmon")
ESU <- subset(ESU, Sp.cnt != FALSE) 
ESU1 <- wcr.v %>% 
  select(Year, Species, Prod, AuthTake, TotalMorts) %>% 
  group_by(Year, AuthTake, TotalMorts) %>% 
  count(Sp.cnt = Species == "Puget Sound Chinook salmon")
ESU1 <- subset(ESU1, Sp.cnt != FALSE)
#==============================================================
#Aggregating Authorized Take 
df <- aggregate(wcr.v$AuthTake, 
                by = list(wcr.v$CommonName, wcr.v$Species, wcr.v$LifeStage, wcr.v$Prod, 
                          wcr.v$Year, wcr.v$TotalMorts), FUN = sum)

names(df) <- c("CommonName", "ESU", "LifeStage", "Production", "Year", "TotalMorts", "AuthTake")             
#==============================================================
#Creating prelim plot
ggplot(data = ESU1, aes(x=Year, y= n))+
  geom_col(fill=I("blue"),
           col=I("red"),
           alpha=I(.2)) +
  geom_label(aes(label = scales::comma(AuthTake)),
             size = 2)+
  theme_minimal() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) +
  labs(x = "Year", y = "Permits per Year",
       title = "# of AuthTake of Puget Sound Chinook salmon over time")
#==============================================================
#Shiny Integration
ui <- fluidPage(
  titlePanel("Authorized Take static graphs"),
  sidebarLayout(

    sidebarPanel(
      radioButtons(inputId = "lifestage", label = "Choose a lifestage",
                   choices = c("Adult", "Juvenile")),
      radioButtons(inputId = "Prod", label = "Choose an Origin",
                   choices = c("Natural", "Listed Hatchery")),
      selectInput(inputId = "ESU", label = "Choose an ESU to View",
                  choices = levels(df$Species),
                  multiple = F),
      width = 4
    ),

    mainPanel(
      leafletOutput("ggplot"),
      width = 8
    ),

    position = c("left", "right"),
    fluid = T
  )
)

server <- function(input, output) {
  output$ggplot <-renderPlot({
    title <- "Authorized Take static graphs"
    ggplot(rnorm(input$df), main = title)
  })
}