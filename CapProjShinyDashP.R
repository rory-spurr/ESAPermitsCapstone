library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
source(paste(getwd(), "/code/dependencies/Reading and Filtering.R", sep = ""))
source(paste(getwd(), "/code/dependencies/TSPreAppCode.R", sep = ""))
source(paste(getwd(),"/code/dependencies/PreAppCode-1.R", sep = ""))
source(paste(getwd(),"/code/dependencies/PreAppCode-2.R", sep = ""))
source(paste(getwd(),"/code/dependencies/PreAppCode-3.R", sep = ""))
source(paste(getwd(),"/code/dependencies/homePageWriting.R", sep = ""))

ui <- dashboardPage(
  dashboardHeader(title = "Visualizing ESA-Listed Fish Research on the West Coast",
                  titleWidth = 500),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("home"), #info-sign can be another option
               menuSubItem("Welcome", tabName = "welcome"),
               menuSubItem("How it works", tabName = "how2"),
               menuSubItem("Background and Purpose", tabName = "background"),
               menuSubItem("Glossary", tabName = "gloss"),
               menuSubItem("Use Statement", tabName = "disclaimer")), 
      menuItem("Authorized Take Map", tabName = "takeMap", icon = icon("globe", lib = "glyphicon")), #globe can be another option
      menuItem("Time Series Plots", tabName = "timeSeries", icon = icon("time", lib = "glyphicon")),
      menuItem("About Us", tabName = "About", icon = icon("info-sign", lib = "glyphicon"))
    )
  ), 
  
  dashboardBody(
    # includeCSS("www/appTheme.css"),
    
    # =========================================
    # Home Tab
    tabItems(
      tabItem(tabName = "welcome",
              box(title = "Welcome to the ESA-Listed Fish Research App for West Coast Permits!",
                  uiOutput("welcomeUI"), width = 12)
      ),
      # use uiOutput for HTML (can also use htmlOutput)
      tabItem(tabName = "how2", 
              box(title = "How to work the app", uiOutput("vidUI"), width = 12)
      ),
      tabItem(tabName = "background", 
              box(title = "What is the ESA and how does it affect scientific research?", uiOutput("backUI"), width = 12)
      ),
      tabItem(tabName = "gloss", 
              box(title = "Acronyms and Definitions", uiOutput("glossUI"), width = 12)
      ),
      tabItem(tabName = "disclaimer",
              box(title= "Assumptions, Limitations, and Delimitations", uiOutput("discUI"), width = 12, height = 900)
      ),
      
      # =========================================
      # Take Map Tab
      tabItem(tabName = "takeMap",
              fluidRow(
                box(
                  title = "Build Your Map",
                  width = 4,
                  radioButtons(inputId = "lifestage", label = "Choose a Life Stage",
                               choices = c("Adult", "Juvenile")),
                  radioButtons(inputId = "Prod", label = "Choose an Origin",
                               choices = c("Natural", "Hatchery")),
                  radioButtons(inputId = "displayData", label = "Choose Data to Display",
                               choices = c("Total Take", "Lethal Take")),
                  selectInput(inputId = "DPS", label = "Choose an ESU/DPS* to View",
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
                  title = "Glossary",
                  width = 6,
                  uiOutput("mapGloss")
                ),
                box(
                  title = "Raw Data Table",
                  uiOutput("tblCapt"),
                  width = 6
                ),
                box(
                  width = 12,
                  dataTableOutput("wcr_table")
                ),
              )
      ),
      
      # =========================================
      # Time Series Tab
      tabItem(tabName = "timeSeries", 
              fluidRow(
                box(
                  title = "Build Your Plot",
                  width = 4, height = 900,
                  radioButtons(inputId = "LifeStage", label = "Choose a Life Stage",
                               choices = c("Adult", "Juvenile")),
                  radioButtons(inputId = "Production", label = "Choose an Origin",
                               choices = c("Natural", "Hatchery")),
                  selectInput(inputId = "ESU", label = "Choose an ESU/DPS* to View",
                              choices = levels(df$ESU),  
                              multiple = F), 
                  background = "light-blue", solidHeader = T,
                  actionButton(inputId = "updat", label = "Update Plots and Table"),
                  br(),
                  "*ESU = Evolutionarily Significant Unit, DPS = Distinct Population Segments.
                    ESUs and DPSs are the organizational units (i.e., groups of populations) of salmon 
                    and steelhead (respectively) recognized as species for listing under the Endangered 
                    Species Act. See ‘Glossary’ Tab for more information.",
                  imageOutput("blank")
                ),
                box(
                  title = "Time Series",
                  solidHeader = T,
                  width = 8, height = 900, 
                  plotlyOutput("plot1"),
                  plotlyOutput("plot2")
                ),
                box(title = "About the plots",
                  width = 12, height = 180, solidHeader = T, status = "primary", 
                  background = "light-blue", 
                  "These plots display the authorized take and reported take of 
                  fish per year. Take is considerdd any action that harasses, harms, 
                  pursues, hunts, shoots, wounds, kills, traps, captures, or collects, or 
                  attempts to engage in any such conduct. Total take (number of fish) is 
                  the sum of reported take or what was actually used (yellow) and the 
                  remaining authorized take that was unused (blue). Note that the data 
                  is only showing what was reported through APPs and is not complete 
                  due to unreported take by researchers. Additionally, the current year
                  is incomplete."
                ),
                box(
                  title = "Raw Data Table",
                  solidHeader = T, 
                  width = 12,
                  dataTableOutput("table")),
                
                box(title = "About the table",
                  width = 12, height = 180, solidHeader = T, status = "primary", 
                  background = "light-blue", 
                  uiOutput("TSgloss")
                )
          )
      ),
      
      # =========================================
      # About Tab
      tabItem(tabName = "About",
              userBox(
                title = userDescription(
                  title = "Alana Santana",
                  subtitle = "Lead Developer",
                  type = 2,
                  image = "https://avatars.githubusercontent.com/u/103059893?v=4",
              ),
              uiOutput("alanaUI")
              ),
              userBox(
                title = userDescription(
                  title = "Rory Spurr",
                  subtitle = "Lead Developer",
                  type = 2,
                  image = "https://avatars.githubusercontent.com/u/104161019?v=4",
                ),
              uiOutput("roryUI")
              )
      )
    )
  )
)

server <- function(input, output) { 
  # have to use renderUI to render HTML correctly
  output$roryUI <- renderUI({
    roryText
  })
  output$alanaUI <- renderUI({
    alanaText
  })
  output$welcomeUI <- renderUI({
    welcomeText
  })
  output$vidUI <- renderUI({how2Text
  })
  output$backUI <- renderUI({
    backgroundText
  })
  output$mapGloss <- renderUI({
    mapGlossText
  })
  output$tblCapt <- renderUI({
    tblCaptText
  })
  output$discUI <- renderUI({
    disclaimerText
  })
  output$glossUI <- renderUI({
    glossText
  })
  output$TSgloss <- renderUI({
    TSglossText
  })
  #output$take_type <- renderImage({
    
    #list(src = "www/image/take_type.png",
         #width = "100%",
         #height = 400)}, deleteFile = F) #code used from https://algoritmaonline.com/advancing-your-shinyapp/#:~:text=To%20add%20an%20image%20in,by%20using%20renderImage()%20function.
  
  # Filter for take data within HUC 8's
  # for the following three "filteredXXX" chunks, the bindEvent(input$update)
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
  }) %>% bindEvent(input$updat)
  
  #Timeseries plot total mortality
  dat2 <- reactive({
    req(c(input$LifeStage, input$Production, input$ESU))
    df1 <- df_plot2 %>% 
      filter(LifeStage %in% input$LifeStage) %>%
      filter(Production %in% input$Production) %>%
      filter(ESU %in% input$ESU)
  }) %>% bindEvent(input$updat)
  
  #Timeseries data table 
  dat3 <- reactive({
    dt %>%
      filter(ESU == input$ESU) %>%
      filter(LifeStage == input$LifeStage) %>% 
      filter(Production == input$Production) %>%
      filter(ResultCode != "Tribal 4d") %>%
      select(c(Year,ReportID, FileNumber,  ResultCode, CaptureMethod, 
               Authorized_Take, Reported_Take, Authorized_Take_Unused, 
               Authorized_Mortality, Reported_Mortality, Authorized_Mortality_Unused))
  }) %>% bindEvent(input$updat)
  
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
    colnames = c("Permit Code", "Permit Type", "Organization", "HUC 8", "Location",
                 "Water Type", "Take Action","Gear Type", "Total Take", "Lethal Take"),
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
      labs(x = "Year", y = "Total Take (Number of fish)", title = "Total Fish Authorized To Be Handled")+ 
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
                                      caption = "Note: Permits issued under the ESA 4(d) authority specific 
                                      to Tribal Resource Management are not individually listed in the table 
                                      because they are not considered public, but those data are included in 
                                      the totals displayed in the map above.", 
                                      colnames = c("Year","Report ID", "Permit Code","Permit Type","Gear Type",
                                                   "Authorized Take", "Reported Take", "Unused Take",
                                                   "Authorized Mortality", "Reported Mortality", "Unused Mortality"),
                                      options = list(pageLength = 10, autoWidth = F, scrollX = T)
  )
  jqui_sortable("#table thead tr")}

shinyApp(ui = ui, server = server)
