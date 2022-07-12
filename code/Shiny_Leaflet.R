# Rory Spurr
# Leaflet integration into R shiny

library(shiny)
source("code/Reading and Filtering.R")
source("code/Species_ExpTakeJuveniles_Leaflet.R")
source("code/Species_ExpTakeAdults_Leaflet.R")



ui <- fluidPage(
  radioButtons(
    inputId = "AorJ",
    label = "Choose Life Stage",
    choices = c("Adults", "Juveniles")
  ),
  leafletOutput("map")
)


server <- function(input, output){
  output$map <- renderLeaflet({
    leaf_map <- switch(input$AorJ,
                      "Adults" = leaf_ExpTake_adults,
                      "Juveniles" = leaf_ExpTake_juveniles)
    return(leaf_map)
    }
  )
}


shinyApp(ui = ui, server = server)
