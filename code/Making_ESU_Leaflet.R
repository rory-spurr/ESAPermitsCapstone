# Making the ESU Leafelet
# Rory Spurr

source("code/Reading and Filtering.R")
source("code/NOAA Permitting Team Code.R")

library(shiny)
library(leaflet)

wcr <- wcr %>%
  rename_population() %>%
  rename_takeaction() %>%
  create_totalmorts()

ESUs <- unique(wcr$Species)
ESUs

ESUdf <- aggregate(wcr$ExpTake, 
                   by = list(wcr$HUCNumber, wcr$Species, wcr$LifeStage),
                   FUN = sum) # aggregate total expected take by HUC
names(ESUdf) <- c("huc8", "ESU", "Lifestage", "ExpTake") # rename columns
ESU.spatial <- right_join(wbd.hucs, ESUdf, by = "huc8") # join with spatial data
ESU.spatial <- st_transform(ESU.spatial, crs = 4326)

ui <- fluidPage(
  selectInput(inputId = "DPS", label = "Choose an ESU to View",
              choices = unique(ESU.spatial$ESU), multiple = F),
  leafletOutput("map")
)


server <- function(input, output){
  filteredData <- reactive({
    ESU.spatial[ESU.spatial$ESU == input$DPS,]
  })
  output$map <- renderLeaflet({
    leaflet(ESU.spatial) %>% 
      addTiles()
  })
  observe({
    pal <- colorNumeric(palette = "viridis", domain = filteredData()$ExpTake)
    
    leafletProxy("map", data = filteredData()) %>%
        clearShapes() %>%
        addPolygons(
          fillColor = ~pal(filteredData()$ExpTake)
          )
  })
}

shinyApp(ui = ui, server = server)
