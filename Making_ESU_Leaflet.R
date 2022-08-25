# Making the ESU Leafelet
# Rory Spurr
# setwd("~/GitHub/ESA_Permits_Capstone")
# source(paste(getwd(), "/code/dependencies/PreAppCode-1.R", sep = ""))
source("code/dependencies/PreAppCode-1.R")


ui <- fluidPage(
  titlePanel("Authorized Take of Current, Non-expired Permits"),
  sidebarLayout(
    
    sidebarPanel(
      radioButtons(inputId = "lifestage", label = "Choose a lifestage",
                   choices = c("Adult", "Juvenile")),
      radioButtons(inputId = "Prod", label = "Choose an Origin",
                   choices = c("Natural", "Listed Hatchery")),
      selectInput(inputId = "DPS", label = "Choose an ESU to View",
                  choices = levels(ESU.spatial$ESU), 
                  multiple = F),
      width = 4
    ),
    
    mainPanel(
      leafletOutput("map"),
      width = 8
    ),
    
    position = c("left", "right"),
    fluid = T
  ),
  tableOutput("wcr_table")
)


server <- function(input, output){
  filteredData <- reactive({
    ESU.spatial %>% 
      filter(ESU == input$DPS) %>%
      filter(LifeStage == input$lifestage) %>% 
      filter(Production == input$Prod)
  })
  filteredWCR <- reactive({
    wcr %>%
      filter(Species == input$DPS) %>%
      filter(LifeStage == input$lifestage) %>% 
      filter(Prod == input$Prod)
  })
  output$map <- renderLeaflet({
    leaflet(ESU.spatial) %>% 
      addProviderTiles(providers$Stamen.TerrainBackground)
  })
  observe({
    pal <- colorNumeric(palette = "viridis",
                    domain = filteredData()$ExpTake,
                    reverse = T)

    proxy <- leafletProxy("map", data = filteredData()) %>%
        clearShapes() %>%
        addPolygons(
          fillColor = ~pal(filteredData()$ExpTake),
          color = "transparent",
          fillOpacity = 0.6,
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
      ifelse(!is.na(st_bbox(filteredData())[1]) == T,
        proxy %>% setView(lng = st_coordinates(st_centroid(st_as_sfc(st_bbox(filteredData()))))[1],
                          lat = st_coordinates(st_centroid(st_as_sfc(st_bbox(filteredData()))))[2],
                          zoom = 6), 
        proxy %>% setView(map, lng = -124.072971, lat = 40.887325, zoom = 4))
  })
  output$wcr_table <- renderTable(filteredWCR())
}

shinyApp(ui = ui, server = server)


