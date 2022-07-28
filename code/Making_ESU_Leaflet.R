# Making the ESU Leafelet
# Rory Spurr

source("code/PreAppCode-1.R")

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
      addProviderTiles(providers$Stamen.TerrainBackground)
  })
  observe({
    pal <- colorBin(palette = "viridis",
                    domain = filteredData()$ExpTake,
                    bins = 3, pretty = F)

    leafletProxy("map", data = filteredData()) %>%
        clearShapes() %>%
        addPolygons(
          fillColor = ~pal(filteredData()$ExpTake),
          popup = ~labels,
          highlight = highlightOptions(color = "white",
                                       bringToFront = T)
          )
  })
}

shinyApp(ui = ui, server = server)
