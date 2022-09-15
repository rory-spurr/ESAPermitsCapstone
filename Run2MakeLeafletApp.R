# Making the ESU Leafelet
# Rory Spurr
# setwd("~/GitHub/ESA_Permits_Capstone")
# source(paste(getwd(), "/code/dependencies/PreAppCode-1.R", sep = ""))
source("code/dependencies/PreAppCode-1.R")
source("code/dependencies/PreAppCode-2.R")

ui <- fluidPage(
  titlePanel("Authorized Lethal and Non-Lethal Take of Current, Non-expired Permits"),
  sidebarLayout(
    
    sidebarPanel(
      radioButtons(inputId = "lifestage", label = "Choose a lifestage",
                   choices = c("Adult", "Juvenile")),
      radioButtons(inputId = "Prod", label = "Choose an Origin",
                   choices = c("Natural", "Listed Hatchery")),
      radioButtons(inputId = "displayData", label = "Choose data to display",
                   choices = c("Total Take", "Lethal Take")),
      selectInput(inputId = "DPS", label = "Choose an ESU to View",
                  choices = levels(wcr$Species), 
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
  dataTableOutput("wcr_table", width = "100%", height = "auto")
)


server <- function(input, output){
  filteredData <- reactive({
    ifelse(input$displayData == "Total Take",
           ESU.spatial <- ESU_spatialTotal,
           ESU.spatial <- ESU_spatialMort)
    ESU.spatial %>% 
      filter(ESU == input$DPS) %>%
      filter(LifeStage == input$lifestage) %>% 
      filter(Production == input$Prod)
  })
  filteredWCR <- reactive({
    wcr4App %>%
      filter(Species == input$DPS) %>%
      filter(LifeStage == input$lifestage) %>% 
      filter(Prod == input$Prod) %>%
      select(FileNumber:TotalMorts)
  })
  output$map <- renderLeaflet({
    leaflet(filteredData()) %>% 
      addProviderTiles(providers$Stamen.TerrainBackground) %>%
      setView(map, lng = -124.072971, lat = 40.887325, zoom = 4)
  })
  observe({
    pal <- colorNumeric(palette = "viridis",
                    domain = filteredData()$theData,
                    reverse = T)

    proxy <- leafletProxy("map", data = filteredData()) %>%
        clearShapes() %>%
        addPolygons(
          fillColor = ~pal(filteredData()$theData),
          color = "transparent",
          fillOpacity = 0.6,
          popup = ~labels,
          highlight = highlightOptions(color = "white",
                                       bringToFront = T)
          ) %>%
      clearControls() %>%
      addLegend(
        pal = pal,
        values = filteredData()$theData,
        title = "Authorized Take (# of fish)",
        position = "bottomleft"
      )
      ifelse(!is.na(st_bbox(filteredData())[1]) == T,
        proxy %>% setView(lng = st_coordinates(st_centroid(st_as_sfc(st_bbox(filteredData()))))[1],
                          lat = st_coordinates(st_centroid(st_as_sfc(st_bbox(filteredData()))))[2],
                          zoom = 6), 
        proxy %>% setView(map, lng = -124.072971, lat = 40.887325, zoom = 4))
  })
  output$wcr_table <- DT::renderDataTable(
    filteredWCR(),
    colnames = c("File Number", "Permit Type", "Organization", "HUC 8", "Location",
                 "Take Action","Capture Method", "Total Take", "Lethal Take"),
    options = list(pageLength = 50, autoWidth = T)
    )
}

shinyApp(ui = ui, server = server)
