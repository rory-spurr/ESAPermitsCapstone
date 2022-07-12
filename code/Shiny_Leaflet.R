# Rory Spurr
# Leaflet integration into R shiny

library(shiny)
source("code/Reading and Filtering.R")
source("code/Species_ExpTakeJuveniles_Leaflet.R")
source("code/Species_ExpTakeAdults_Leaflet.R")



ui <- fluidPage(
  leafletOutput("map")
)


server <- function(input, output){
  output$map <- renderLeaflet(
    leaf_map
  )
}


shinyApp(ui = ui, server = server)