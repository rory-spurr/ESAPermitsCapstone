library(shiny)
library(shinydashboard)
source(paste(getwd(), "/code/dependencies/Reading and Filtering.R", sep = ""))
source(paste(getwd(), "/code/dependencies/TSPreAppCode.R", sep = ""))
source(paste(getwd(),"/code/dependencies/PreAppCode-1.R", sep = ""))
source(paste(getwd(),"/code/dependencies/PreAppCode-2.R", sep = ""))
source(paste(getwd(),"/code/dependencies/PreAppCode-3.R", sep = ""))
source(paste(getwd(),"/code/dependencies/homePageWriting.R", sep = ""))

ui <- dashboardPage(
  dashboardHeader(title = "Visualizing ESA-Listed Fish Research",
                  titleWidth = 350),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("home"), #info-sign can be another option
        menuSubItem("Welcome", tabName = "welcome"),
        menuSubItem("Background and Purpose", tabName = "background"),
        menuSubItem("Disclaimer", tabName = "disclaimer")), 
      menuItem("Authorized Take Map", tabName = "takeMap", icon = icon("globe", lib = "glyphicon")), #globe can be another option
      menuItem("Time Series Plots", tabName = "timeSeries", icon = icon("time", lib = "glyphicon"))
    )
  ), 
  dashboardBody(
    tabItems(
      tabItem(tabName = "welcome",
        box(title = "Welcome to the ESA-Listed Fish Research App for West Coast Permits!",
            uiOutput("welcomeUI"))
      ),
      # use uiOutput for HTML (can also use htmlOutput)
      tabItem(tabName = "background", 
        box(uiOutput("backText"))
      ),
      tabItem(tabName = "disclaimer",
        box(uiOutput("discText"))
      ),
      tabItem(tabName = "takeMap",
        fluidRow(
          box(
            title = "Controls",
            width = 4,
            radioButtons(inputId = "lifestage", label = "Choose a Life Stage",
              choices = c("Adult", "Juvenile")),
            radioButtons(inputId = "Prod", label = "Choose an Origin",
              choices = c("Natural", "Listed Hatchery")),
            radioButtons(inputId = "displayData", label = "Choose Data to Display",
              choices = c("Total Take", "Lethal Take")),
            selectInput(inputId = "DPS", label = "Choose an ESU to View",
              choices = levels(wcr$Species), multiple = F),
            actionButton(inputId = "update", label = "Update Map and Table"), # action button to control when map updates
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
      tabItem(tabName = "timeSeries", 
              fluidRow(
                box(
                  title = "Getting Started",
                  width = 12, height = 180, solidHeader = T, status = "primary", 
                  background = "light-blue", 
                  "Here we are showing how the number of authorized take 
                  (how many fish we think we might interact with and/or lethally remove) 
                  and reported take (how many fish we actually interacted with and/or 
                  lethally removed) has changed over time. Total Take (number of fish) 
                  is broken down into reported take or what was actually used (yellow) 
                  and authorized take that was unused (blue). Used and Unused take 
                  culminates to what was authorized for that specific year. Note that 
                  the data is only showing what was reported through APPs and is not complete."
                ),
                box(
                  title = "Controls",
                  width = 4, height = 900,
                  radioButtons(inputId = "LifeStage", label = "Choose a Life Stage",
                               choices = c("Adult", "Juvenile")),
                  radioButtons(inputId = "Production", label = "Choose an Origin",
                               choices = c("Natural", "Listed Hatchery")),
                  selectInput(inputId = "ESU", label = "Choose an ESU to View",
                              choices = levels(df$ESU),  
                              multiple = F), 
                  background = "light-blue", solidHeader = T
                ),
                box(
                  title = "Time Series",
                  solidHeader = T,
                  width = 8, height = 900, 
                  plotlyOutput("plot1"),
                  plotlyOutput("plot2")
                ),
                
                box(
                  title = "Raw Data Table",
                  solidHeader = T, 
                  width = 12,
                  dataTableOutput("table")),
              )
      )
    )
  )
)

server <- function(input, output) { 
  # have to use renderUI to render HTML correctly
  output$backText <- renderUI({
    backgroundText
  })
  
  output$discText <- renderUI({
    disclaimerText
  })
  
  # Filter for take data within HUC 8's
  # for the following three "filteredXXX" chunks, the 'input$update' 
  # ensures the data only changes after the action button is hit
  filteredData <- reactive({
    ifelse(input$displayData == "Total Take",
           ESU.spatial <- ESU_spatialTotal,
           ESU.spatial <- ESU_spatialMort)
    ESU.spatial %>% 
      filter(ESU == input$DPS) %>%
      filter(LifeStage == input$lifestage) %>% 
      filter(Production == input$Prod)
  }) %>%
  bindEvent(input$update)
  
  # Filter for data table data (below take map)
  filteredWCR <- reactive({
    wcr4App %>%
      filter(Species == input$DPS) %>%
      filter(LifeStage == input$lifestage) %>% 
      filter(Prod == input$Prod) %>%
      filter(ResultCode != "Tribal 4d") %>%
      select(FileNumber:TotalMorts)
  }) %>%
  bindEvent(input$update)
  
  # Filter for boundary data
  filteredBound <- reactive({
    esuBound %>%
      filter(DPS == input$DPS)
  }) %>%
  bindEvent(input$update)
  
  #Timeseries plot total take
  dat <- reactive({
    req(c(input$LifeStage, input$Production, input$ESU))
    df1 <- df_plot %>% 
      filter(LifeStage %in% input$LifeStage) %>% 
      filter(Production %in% input$Production) %>%  
      filter(ESU %in% input$ESU)
  })
  
  #Timeseries plot total mort
  dat2 <- reactive({
    req(c(input$LifeStage, input$Production, input$ESU))
    df1 <- df_plot2 %>% 
      filter(LifeStage %in% input$LifeStage) %>%
      filter(Production %in% input$Production) %>%
      filter(ESU %in% input$ESU)
  })
  
  #Timeseries table 
  dat3 <- reactive({
    dt %>%
      filter(ESU == input$ESU) %>%
      filter(LifeStage == input$LifeStage) %>% 
      filter(Production == input$Production) %>%
      filter(ResultCode != "Tribal 4d") %>%
      select(c(Year, FileNumber, ReportID, ResultCode, CaptureMethod, 
               Authorized_Take, Reported_Take, Authorized_Take_Unused, 
               Authorized_Mortality, Reported_Mortality, Authorized_Mortality_Unused))
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
  }) %>%
  bindEvent(input$update)
  
  # Data table processing and rendering
  output$wcr_table <- DT::renderDataTable({
    filteredWCR()},
    caption = "Table displaying raw data that makes up take values in map above. 
    Note that `Tribal 4d` permits are not included in the table for privacy concerns, 
    but are included in the take totals displayed in the map above.",
    colnames = c("File Number", "Permit Type", "Organization", "HUC 8", "Location",
                 "Water Type", "Take Action","Capture Method", "Total Take", "Lethal Take"),
    options = list(pageLength = 10, autoWidth = F, scrollX = T, 
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
  
  output$plot1 <-renderPlotly({
    ggplot(data = dat(), aes (y = N, x = Year, fill = Take_Type))+ 
      geom_bar(stat = "identity", position = "stack", color = "black")+
      scale_fill_manual(values = mycols, name = "Take Type") +
      labs(x = "Year", y = "Total Take (Number of fish)", title = "Total Fish Authorized To Be Touched")+ 
      theme(axis.text.x = element_text(angle = 30, hjust = 0.5, vjust = 0.5), 
            panel.background = element_rect(fill = "#D0D3D4" ))
    ggplotly(tooltip = c("y", "x", "fill"))
  })
  
  output$plot2 <-renderPlotly({
    ggplot(data = dat2(), aes (y = N, x = Year, fill = Take_Type))+ 
      geom_bar(stat = "identity", position = "stack", color = "black")+
      scale_fill_manual(values = mycols, name = "Take Type") +
      labs(x = "Year", y = "Total Take (Number of fish)", title = "Fish Authorized To Be Killed")+ 
      theme(axis.text.x = element_text(angle = 30, hjust = 0.5, vjust = 0.5), 
            panel.background = element_rect(fill = "#D0D3D4" ))
    ggplotly(tooltip = c("y", "x", "fill"))
    
  })
  
  output$table <- DT::renderDataTable({dat3()},
                                    caption = "Note: Table excludes 'Tribal 4d' permits for privacy concerns, 
                but are included in the take totals", 
                                    colnames = c("Year", "Permit Code","Report ID","Permit Type","Gear Type",
                                                 "Authorized Take", "Reported Take", "Unused Take",
                                                  "Authorized Mortality", "Reported Mortality", "Unused Mortality"),
                                    options = list(pageLength = 10, autoWidth = F, scrollX = T)
)
jqui_sortable("#table thead tr")}

shinyApp(ui = ui, server = server)
