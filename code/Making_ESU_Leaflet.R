# Making the ESU Leafelet
# Rory Spurr

source("code/PreAppCode-1.R")

ui <- fluidPage(
  selectInput(inputId = "DPS", label = "Choose an ESU to View",
              choices = unique(ESU.spatial$ESU), multiple = F),
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
              zoom = 4.5)
  })
  observe({
    pal <- colorBin(palette = "viridis",
                    domain = filteredData()$ExpTake,
                    bins = quantile(filteredData()$ExpTake))

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
