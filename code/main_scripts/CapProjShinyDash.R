library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Visualizing ESA-Listed Fish Research",
                  titleWidth = 350),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("home")), #info-sign can be another option
      menuItem("Map", tabName = "map", icon = icon("map-marker", lib = "glyphicon")), #globe can be another option
      menuItem("Time Series", tabName = "time series", icon = icon("time", lib = "glyphicon"))
    )
), 
  dashboardBody(
    tabBox(title = "Getting Started",
           id = "tabset1", height = "1000px", width = "auto",
           tabPanel("Background", "Here we will put backghround on WCR/Permits/ESA"),
           tabPanel("How it works", "Here we will display a video on how it works"),
           tabPanel("Disclaimer", "Here we will discuss limitations/caveats of app")),
    tabItems(
      tabItem(tabName = "home"),
      tabItem(tabName = "map"),
      tabItem(tabName = "time series")
    )
  )
)
server <- function(input, output) { 
  output$tabset1Selected <- renderText({
  input$tabset1
})}


shinyApp(ui, server)