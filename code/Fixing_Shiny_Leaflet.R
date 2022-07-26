# Leaflet integration into R shiny

library(shiny)
source("code/Reading and Filtering.R")
source("code/Species_ExpTakeJuveniles_Leaflet.R")
source("code/Species_ExpTakeAdults_Leaflet.R")



ui <- fluidPage(
  radioButtons(
    inputId = "AorJ",
    label = "Choose a species",
    choices = c("Adults", "Juveniles")
  ),
  leafletOutput("map")
)


server <- function(input, output){
  output$map <- renderLeaflet({
  map %>% 
      clearPopups()
  }
  leafletProxy("map", data = final.spatial) %>%
    clearShapes() %>%
    addPolygons(
      fillColor = ~pal()
    )
  )
}


shinyApp(ui = ui, server = server)
