# Making the ESU Leafelet
# Rory Spurr

source("code/PreAppCode-1.R")

ui <- fluidPage(
  selectInput(inputId = "DPS", label = "Choose an ESU to View",
              choices = levels(ESU.spatial$ESU), 
              multiple = F),
  radioButtons(inputId = "lifestage", label = "Choose a lifestage",
               choices = c("Adult", "Juvenile")),
  # actionButton(inputId = "goButton", label = "Go!"),
  leafletOutput("map")
)


server <- function(input, output){
  filteredData <- reactive({
    ESU.spatial %>% 
      filter(ESU == input$DPS) %>%
      filter(Lifestage == input$lifestage)
  })
  output$map <- renderLeaflet({
    leaflet(ESU.spatial) %>% 
      addProviderTiles(providers$Stamen.TerrainBackground) %>%
      setView(lng = -124.072971, lat = 40.887325,
              zoom = 4)
  })
  observe({
    pal <- colorNumeric(palette = "viridis",
                    domain = filteredData()$ExpTake)

    leafletProxy("map", data = filteredData()) %>%
        clearShapes() %>%
        addPolygons(
          fillColor = ~pal(filteredData()$ExpTake),
          color = "transparent",
          fillOpacity = 0.7,
          popup = ~labels,
          highlight = highlightOptions(color = "white",
                                       bringToFront = T)
          ) %>%
      clearControls() %>%
      addLegend(
        pal = pal,
        values = filteredData()$ExpTake,
        title = "Authorized Take (# of fish)",
        position = "bottomleft"
      )
  })
}

shinyApp(ui = ui, server = server)
