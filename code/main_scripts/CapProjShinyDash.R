library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Visualizing ESA-Listed Fish Research",
                  titleWidth = 350),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("home")), #info-sign can be another option
      menuItem("Authorized Take Map", tabName = "takeMap", icon = icon("globe", lib = "glyphicon")), #globe can be another option
      menuItem("Time Series", tabName = "timeSeries", icon = icon("time", lib = "glyphicon"))
    )
  ), 
  dashboardBody(
    tabItems(
      tabItem(tabName = "home",
        tabBox(title = "Getting Started",
        id = "tabset1", height = "1000px", width = "auto",
        tabPanel("Background", backgroundText),
        tabPanel("How it works", "Here we will display a video on how it works"),
        tabPanel("Disclaimer", "Here we will discuss limitations/caveats of app")),   
      ),
      tabItem(tabName = "takeMap",
        fluidRow(
          box(
            title = "Controls",
            width = 4,
            radioButtons(inputId = "lifestage", label = "Choose a lifestage",
              choices = c("Adult", "Juvenile")),
            radioButtons(inputId = "Prod", label = "Choose an origin",
              choices = c("Natural", "Listed Hatchery")),
            radioButtons(inputId = "displayData", label = "Choose data to display",
              choices = c("Total Take", "Lethal Take")),
            selectInput(inputId = "DPS", label = "Choose an ESU to view",
              choices = levels(wcr$Species), multiple = F),
            background = "light-blue"
          ),
          box(
            title = "Authorized Take Map",
            width = 8,
            leafletOutput("map")
          ),
          box(
            title = "Raw Data Table",
            width = 12,
            dataTableOutput("wcr_table")
          ),
        )
      ),
      tabItem(tabName = "timeSeries")
    )
  )
)

server <- function(input, output) { 
  output$tabset1Selected <- renderText({
  input$tabset1
  })
  # Filter for take data within HUC 8's
  filteredData <- reactive({
    ifelse(input$displayData == "Total Take",
           ESU.spatial <- ESU_spatialTotal,
           ESU.spatial <- ESU_spatialMort)
    ESU.spatial %>% 
      filter(ESU == input$DPS) %>%
      filter(LifeStage == input$lifestage) %>% 
      filter(Production == input$Prod)
  })
  # Filter for data table data
  filteredWCR <- reactive({
    wcr4App %>%
      filter(Species == input$DPS) %>%
      filter(LifeStage == input$lifestage) %>% 
      filter(Prod == input$Prod) %>%
      filter(ResultCode != "Tribal 4d") %>%
      select(FileNumber:TotalMorts)
  })
  # Filter for boundary data
  filteredBound <- reactive({
    esuBound %>%
      filter(DPS == input$DPS)
  })
  # Base map output (does not change)
  output$map <- renderLeaflet({
    leaflet(filteredData()) %>% 
      addProviderTiles(providers$Stamen.TerrainBackground) %>%
      setView(map, lng = -124.072971, lat = 40.887325, zoom = 4)
  })
  # Observer to render parts of map that change based on user inputs
  observe({
    pal <- colorNumeric(palette = "viridis",
                        domain = filteredData()$theData,
                        reverse = T)
    
    proxy <- leafletProxy("map", data = filteredData()) %>%
      clearShapes() %>%
      addPolygons(
        data = filteredBound(),
        fillColor = "transparent",
        color = "black"
      ) %>%
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
        title = ifelse(input$displayData == "Total Take", 
                       "Total Take (# of fish)",
                       "Lethal Take (# of fish)"),
        position = "bottomleft"
      )
    ifelse(!is.na(st_bbox(filteredData())[1]) == T,
           proxy %>% setView(lng = st_coordinates(st_centroid(st_as_sfc(st_bbox(filteredData()))))[1],
                             lat = st_coordinates(st_centroid(st_as_sfc(st_bbox(filteredData()))))[2],
                             zoom = 6), 
           proxy %>% setView(map, lng = -124.072971, lat = 40.887325, zoom = 4))
  })
  # Data table processing and rendering
  output$wcr_table <- DT::renderDataTable({
    filteredWCR()},
    caption = "Table displaying raw data that makes up take values in map above. 
    Note that `Tribal 4d` permits are not included in the table for privacy concerns, 
    but are included in the take totals displayed in the map above.",
    colnames = c("File Number", "Permit Type", "Organization", "HUC 8", "Location",
                 "Water Type", "Take Action","Capture Method", "Total Take", "Lethal Take"),
    options = list(pageLength = 10, autoWidth = T,
      dom = "ft",
      columnDefs = list(list(
      targets = "_all",
      render = JS(
        "function(data, type, row, meta) {",
        "return type === 'display' && data.length > 25 ?",
        "'<span title=\"' + data + '\">' + data.substr(0, 25) + '...</span>' : data;",
        "}")
      ), 
      list(width = '500px', targets = c(5,7,8)))),
    callback = JS('table.page(3).draw(false);')
  )
}

shinyApp(ui, server)