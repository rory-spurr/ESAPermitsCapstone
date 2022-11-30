library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Visualizing ESA-Listed Fish Research",
                  titleWidth = 350),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("home")), #info-sign can be another option
      menuItem("Authorized Take Map", tabName = "takeMap", icon = icon("globe", lib = "glyphicon")), #globe can be another option
      menuItem("Time Series", tabName = "time series", icon = icon("time", lib = "glyphicon"))
    )
  ), 
  dashboardBody(
    tabItems(
      tabItem(tabName = "home",
        tabBox(title = "Getting Started",
        id = "tabset1", height = "1000px", width = "auto",
        tabPanel("Background", "Here we will put backghround on WCR/Permits/ESA"),
        tabPanel("How it works", "Here we will display a video on how it works"),
        tabPanel("Disclaimer", "Here we will discuss limitations/caveats of app")),   
      ),
      tabItem(tabName = "takeMap",
        fluidRow(
          box(
            title = "Controls",
            radioButtons(inputId = "lifestage", label = "Choose a lifestage",
              choices = c("Adult", "Juvenile")),
            radioButtons(inputId = "Prod", label = "Choose an Origin",
              choices = c("Natural", "Listed Hatchery")),
            radioButtons(inputId = "displayData", label = "Choose data to display",
              choices = c("Total Take", "Lethal Take")),
            selectInput(inputId = "DPS", label = "Choose an ESU to View",
              choices = levels(wcr$Species), multiple = F)
          ),
          box(
            leafletOutput("map")
          ),
          box(
            dataTableOutput("wcr_table")
          ),
        )
      )
    )
  )
)
server <- function(input, output) { 
  output$tabset1Selected <- renderText({
  input$tabset1
})}


shinyApp(ui, server)