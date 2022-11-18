#' @title MakeLeafletApp
#'
#' @description Creates the Leaflet app displaying take data for ESA-listed species.
#' @param DF Data frame describing the different HUC 8 where ESUs can be found. One row per unique
#' DPS/huc8 combination. Therefore species that are found in multiple DPSs wil be lsted in multiple 
#' rows, one for each DPS where they can be found.
#' @param spatialData Polygon spatial data for HUC 8's in Washington, Idaho, Oregon and California.
#' Recommended to use the data that comes with this package from the Watershed Boundary Dataset (Made 
#' and maintained by the USGS).
#' @param esuBound spatial data showing the boundaries of where each ESU/DPs can be found. Data is 
#' made using the create_ESUBoundary function, and then supplied to this function to create the app.
#' @return A Shiny application that displays take data in a Leaflet map, as well as a data table showing
#' what makes up the take values.
#' @export
MakeLeafletApp <- function(DF, spatialData, esuBound){
  
  DF <- createLocations(permitFilter(DF))
  
  DF<- DF %>%
    NMFSResPermits::rename_population() %>%
    NMFSResPermits::create_totalmorts() %>%
    NMFSResPermits::order_table()
  
  SW_FW <- sapply(DF$Location, assignWaterType)
  DF <- cbind(DF, SW_FW)
  
  wcr4App <- DF %>%
    dplyr::select(FileNumber, # File Number
                  ResultCode, # Permit Type
                  Organization, # Organization
                  HUCNumber, # HUC 8
                  Location, # Location
                  SW_FW, # water type
                  TakeAction:ExpTake,
                  TotalMorts,
                  LifeStage,
                  Species,
                  Prod) %>%
    dplyr::mutate(HUCNumber = as.character(HUCNumber)) %>%
    tidyr::replace_na(list(HUCNumber = "No Data"))
  
  LocGroup1 <- c("Admiralty Inlet", "North Puget Sound", "South Puget Sound",
                 "Whidbey Basin", "Puget Sound")
  LocGroup2 <- "Hood Canal"
  LocGroup3 <- "Strait of Juan de Fuca"
  
  DF <- assignMarineAreas(DF, LocGroup1, LocGroup2, LocGroup3)
  
  totalTake <- createMapDF(DF, spatialData, T)
  totalMort <- createMapDF(DF, spatialData, F)
  
  ui <- shiny::fluidPage(
    shiny::titlePanel("Authorized Lethal and Non-Lethal Take of Current, Non-expired Permits"),
    shiny::sidebarLayout(
      
      shiny::sidebarPanel(
        shiny::radioButtons(inputId = "lifestage", label = "Choose a lifestage",
                     choices = c("Adult", "Juvenile")),
        shiny::radioButtons(inputId = "Prod", label = "Choose an Origin",
                     choices = c("Natural", "Listed Hatchery")),
        shiny::radioButtons(inputId = "displayData", label = "Choose data to display",
                     choices = c("Total Take", "Lethal Take")),
        shiny::selectInput(inputId = "DPS", label = "Choose an ESU to View",
                    choices = levels(DF$Species), 
                    multiple = F),
        width = 4
      ),
      
      shiny::mainPanel(
        leaflet::leafletOutput("map"),
        width = 8
      ),
      
      position = c("left", "right"),
      fluid = T
    ),
    DT::dataTableOutput("wcr_table", width = "100%", height = "auto")
  )
  
  server <- function(input, output){
    filteredData <- shiny::reactive({
      ifelse(input$displayData == "Total Take",
             ESU.spatial <- totalTake,
             ESU.spatial <- totalMort)
      ESU.spatial %>% 
        dplyr::filter(ESU == input$DPS) %>%
        dplyr::filter(LifeStage == input$lifestage) %>% 
        dplyr::filter(Production == input$Prod)
    })
    
    filteredWCR <- shiny::reactive({
      wcr4App %>%
        dplyr::filter(Species == input$DPS) %>%
        dplyr::filter(LifeStage == input$lifestage) %>% 
        dplyr::filter(Prod == input$Prod) %>%
        dplyr::filter(ResultCode != "Tribal 4d") %>%
        dplyr::select(FileNumber:TotalMorts)
    })
    
    filteredBound <- shiny::reactive({
      esuBound %>%
        dplyr::filter(DPS == input$DPS)
    })
    
    output$map <- leaflet::renderLeaflet({
      leaflet::leaflet(filteredData()) %>% 
        leaflet::addProviderTiles(leaflet::providers$Stamen.TerrainBackground) %>%
        leaflet::setView(lng = -124.072971, lat = 40.887325, zoom = 4)
    })
    
    shiny::observe({
      pal <- leaflet::colorNumeric(palette = "viridis",
                          domain = filteredData()$theData,
                          reverse = T)
      
      proxy <- leaflet::leafletProxy("map", data = filteredData()) %>%
        leaflet::clearShapes() %>%
        leaflet::addPolygons(
          data = filteredBound(),
          fillColor = "transparent",
          color = "black"
        ) %>%
        leaflet::addPolygons(
          fillColor = ~pal(filteredData()$theData),
          color = "transparent",
          fillOpacity = 0.6,
          popup = ~labels,
          highlight = leaflet::highlightOptions(color = "white",
                                       bringToFront = T)
        ) %>%
        leaflet::clearControls() %>%
        leaflet::addLegend(
          pal = pal,
          values = filteredData()$theData,
          title = "Authorized Take (# of fish)",
          position = "bottomleft"
        )
      ifelse(!is.na(sf::st_bbox(filteredData())[1]) == T,
             proxy %>% leaflet::setView(
               lng = sf::st_coordinates(
                 sf::st_centroid(
                   sf::st_as_sfc(
                     sf::st_bbox(
                       filteredData()))))[1],
               lat = sf::st_coordinates(
                 sf::st_centroid(
                   sf::st_as_sfc(
                     sf::st_bbox(
                       filteredData()))))[2],
               zoom = 6), 
             proxy %>% leaflet::setView(lng = -124.072971, lat = 40.887325, zoom = 4))
    })
    
    output$wcr_table <- DT::renderDataTable(
      filteredWCR(),
      caption = "Table displaying raw data that makes up take values in map above. 
    Note that `Tribal 4d` permits are not included in the table for privacy concerns, 
    but are included in the take totals displayed in the map above.",
      colnames = c("File Number", "Permit Type", "Organization", "HUC 8", "Location",
                   "Water Type", "Take Action","Capture Method", "Total Take", "Lethal Take"),
      options = list(pageLength = 10, autoWidth = T, columnDefs = list(list(
        targets = "_all",
        render = htmlwidgets::JS(
          "function(data, type, row, meta) {",
          "return type === 'display' && data.length > 25 ?",
          "'<span title=\"' + data + '\">' + data.substr(0, 25) + '...</span>' : data;",
          "}")
      ), 
      list(width = '500px', targets = c(5,7,8)))),
      callback = htmlwidgets::JS('table.page(3).draw(false);')
    )
  }
  
  shiny::shinyApp(ui = ui, server = server)
}
