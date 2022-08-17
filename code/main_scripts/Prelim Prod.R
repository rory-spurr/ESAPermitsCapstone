#############################################################
# Alana Santana and Rory Spurr                              #
# Preliminary Product and Shiny Dashboard Integration        #
#############################################################

#=============================================================
#Reading in packages
library(shiny)
library(shinydashboard)
library(ggplot2)
library(sf)
library(dplyr)
library(tidyverse)
library(leaflet)

#==============================================================
#Sourcing Script
#source("code/Reading and Filtering.R") # commented out for Shiny integration

#==============================================================
#Leaflet setup
########## data setup ##########
newDF <- aggregate(adults$ExpTake, 
                   by = list(adults$HUCNumber, adults$CommonName),
                   FUN = sum) # aggregate total expected take by HUC
names(newDF) <- c("huc8", "CommonName", "ExpTake") # rename columns
wideDF <- newDF %>%
  pivot_wider(names_from = CommonName, values_from = ExpTake) # pivot data frame to wide format
final.spatial <- right_join(wbd.hucs, wideDF, by = "huc8") # join with spatial data
final.spatial <- st_transform(final.spatial, crs = 4326)

######### creating palettes ##########
final.spatial$labels <- ifelse(!is.na(final.spatial$`Chinook salmon`), 
                               paste0(
                                 "<strong> Name: </strong>",
                                 final.spatial$name, "<br/> ",
                                 "<strong> HUC 8: </strong>",
                                 final.spatial$huc8, "<br/> ",
                                 "<strong> Expected Take (# of fish): </strong> ",
                                 final.spatial$`Chinook salmon`, "<br/> "
                               ) %>%
                                 lapply(htmltools::HTML), NA)
pal <- colorBin(palette = "viridis",
                domain = final.spatial$`Chinook salmon`,
                na.color = NA,
                bins = quantile(final.spatial$`Chinook salmon`, na.rm = T))

final.spatial$labels2 <- ifelse(!is.na(final.spatial$steelhead), 
                                paste0(
                                  "<strong> Name: </strong>",
                                  final.spatial$name, "<br/> ",
                                  "<strong> HUC 8: </strong>",
                                  final.spatial$huc8, "<br/> ",
                                  "<strong> Expected Take (# of fish): </strong> ",
                                  final.spatial$steelhead, "<br/> "
                                ) %>%
                                  lapply(htmltools::HTML), NA)

pal2 <- colorBin(palette = "viridis",
                 domain = final.spatial$steelhead,
                 na.color = "transparent",
                 bins = quantile(final.spatial$steelhead, na.rm = T))

final.spatial$labels3 <- ifelse(!is.na(final.spatial$`green sturgeon`),
                                paste0(
                                  "<strong> Name: </strong>",
                                  final.spatial$name, "<br/> ",
                                  "<strong> HUC 8: </strong>",
                                  final.spatial$huc8, "<br/> ",
                                  "<strong> Expected Take (# of fish): </strong> ",
                                  final.spatial$`green sturgeon`, "<br/> "
                                ) %>%
                                  lapply(htmltools::HTML), NA)

pal3 <- colorBin(palette = "viridis",
                 domain = final.spatial$`green sturgeon`,
                 na.color = "transparent",
                 bins = 2, pretty = F)

final.spatial$labels4 <- ifelse(!is.na(final.spatial$`coho salmon`), paste0(
  "<strong> Name: </strong>",
  final.spatial$name, "<br/> ",
  "<strong> HUC 8: </strong>",
  final.spatial$huc8, "<br/> ",
  "<strong> Expected Take (# of fish): </strong> ",
  final.spatial$`coho salmon`, "<br/> "
) %>%
  lapply(htmltools::HTML), NA)

pal4 <- colorBin(palette = "viridis",
                 domain = final.spatial$`coho salmon`,
                 na.color = NA,
                 bins = quantile(final.spatial$`coho salmon`, na.rm = T))

########### adult take ###########
leaf_ExpTake_adults <- leaflet(final.spatial) %>% 
  addProviderTiles(providers$Stamen.TonerLite) %>% 
  setView(lng = -124.072971, lat = 40.887325,
          zoom = 4) %>% 
  addPolygons(
    fillColor = ~pal(`Chinook salmon`),
    color = "transparent",
    fillOpacity = 0.7,
    popup = ~labels,
    highlight = highlightOptions(color = "white",
                                 bringToFront = T),
    group = "Chinook"
  ) %>% 
  addPolygons(
    fillColor = ~pal2(steelhead),
    color = "transparent",
    fillOpacity = 0.7,
    popup = ~labels2,
    highlight = highlightOptions(color = "white",
                                 bringToFront = T),
    group = "Steelhead"
  ) %>% 
  addPolygons(
    fillColor = ~pal3(`green sturgeon`),
    color = "transparent",
    fillOpacity = 0.7,
    popup = ~labels3,
    highlight = highlightOptions(color = "white",
                                 bringToFront = T),
    group = "Green Sturgeon"
  ) %>% 
  addPolygons(
    fillColor = ~pal4(`coho salmon`),
    color = "transparent",
    fillOpacity = 0.7,
    popup = ~labels4,
    highlight = highlightOptions(color = "white",
                                 bringToFront = T),
    group = "Coho"
  ) %>%
  addLegend(pal = pal, values = ~`Chinook salmon`,
            title = "Chinook Authorized Take (# of Fish)",
            group = "Chinook", position = "bottomleft",
            className = "info legend Chinook") %>% 
  addLegend(pal = pal2, values = ~steelhead,
            title = "Steelhead Authorized Take (# of Fish)",
            group = "Steelhead", position = "bottomleft",
            className = "info legend Steelhead") %>% 
  addLegend(pal = pal3, values = ~`green sturgeon`,
            title = "Green Sturgeon Authorized Take (# of Fish)",
            group = "Green Sturgeon", position = "bottomleft",
            className = "info legend GreenSturgeon") %>% 
  addLegend(pal = pal4, values = ~`coho salmon`,
            title = "Coho Authorized Take (# of Fish)",
            group = "Coho", position = "bottomleft",
            className = "info legend Coho") %>% 
  addLayersControl(
    overlayGroups = c("Chinook", "Steelhead",
                      "Green Sturgeon", "Coho"),
    options = layersControlOptions(collapsed = F)) %>% 
  htmlwidgets::onRender("
      function(el, x) {
         var updateLegend = function () {
            var selectedGroup = document.querySelectorAll('input:checked')[0].nextSibling.innerText.substr(1);
            var selectedClass = selectedGroup.replace(' ', '');
            document.querySelectorAll('.legend').forEach(a => a.hidden=true);
            document.querySelectorAll('.legend').forEach(l => {
               if (l.classList.contains(selectedClass)) l.hidden=false;
            });
         };
         updateLegend();
         this.on('baselayerchange', el => updateLegend());
    }")

# Note - Some popups do not work
# Note - Include geartype and ind mort

# =======================================================
########## data setup ##########
newDF1 <- aggregate(juveniles$ExpTake, 
                   by = list(juveniles$HUCNumber, juveniles$CommonName),
                   FUN = sum) # aggregate total expected take by HUC
names(newDF1) <- c("huc8", "CommonName", "ExpTake") # rename columns
wideDF <- newDF1 %>%
  pivot_wider(names_from = CommonName, values_from = ExpTake) # pivot data frame to wide format
final.spatial <- right_join(wbd.hucs, wideDF, by = "huc8") # join with spatial data
final.spatial <- st_transform(final.spatial, crs = 4326)

######### creating palettes ##########
final.spatial$labels <- ifelse(!is.na(final.spatial$`Chinook salmon`), 
                              paste0(
                                "<strong> Name: </strong>",
                                final.spatial$name, "<br/> ",
                                "<strong> HUC 8: </strong>",
                                final.spatial$huc8, "<br/> ",
                                "<strong> Expected Take (# of fish): </strong> ",
                                final.spatial$`Chinook salmon`, "<br/> "
                              ) %>%
                                lapply(htmltools::HTML), NA)
palJ <- colorBin(palette = "viridis",
                domain = final.spatial$`Chinook salmon`,
                na.color = NA,
                bins = quantile(final.spatial$`Chinook salmon`, na.rm = T))

final.spatial$labels2 <- ifelse(!is.na(final.spatial$steelhead), 
                                paste0(
                                  "<strong> Name: </strong>",
                                  final.spatial$name, "<br/> ",
                                  "<strong> HUC 8: </strong>",
                                  final.spatial$huc8, "<br/> ",
                                  "<strong> Expected Take (# of fish): </strong> ",
                                  final.spatial$steelhead, "<br/> "
                                ) %>%
                                  lapply(htmltools::HTML), NA)

palJ2 <- colorBin(palette = "viridis",
                 domain = final.spatial$steelhead,
                 na.color = "transparent",
                 bins = quantile(final.spatial$steelhead, na.rm = T))

final.spatial$labels3 <- ifelse(!is.na(final.spatial$`green sturgeon`),
                                paste0(
                                  "<strong> Name: </strong>",
                                  final.spatial$name, "<br/> ",
                                  "<strong> HUC 8: </strong>",
                                  final.spatial$huc8, "<br/> ",
                                  "<strong> Expected Take (# of fish): </strong> ",
                                  final.spatial$`green sturgeon`, "<br/> "
                                ) %>%
                                  lapply(htmltools::HTML), NA)

palJ3 <- colorBin(palette = "viridis",
                 domain = final.spatial$`green sturgeon`,
                 na.color = "transparent",
                 bins = quantile(final.spatial$`green sturgeon`, na.rm = T))

final.spatial$labels4 <- ifelse(!is.na(final.spatial$`coho salmon`), paste0(
  "<strong> Name: </strong>",
  final.spatial$name, "<br/> ",
  "<strong> HUC 8: </strong>",
  final.spatial$huc8, "<br/> ",
  "<strong> Expected Take (# of fish): </strong> ",
  final.spatial$`coho salmon`, "<br/> "
) %>%
  lapply(htmltools::HTML), NA)

palJ4 <- colorBin(palette = "viridis",
                 domain = final.spatial$`coho salmon`,
                 na.color = NA,
                 bins = quantile(final.spatial$`coho salmon`, na.rm = T))

########### juvenile take ###########
leaf_ExpTake_juveniles <- leaflet(final.spatial) %>% 
  addProviderTiles(providers$Stamen.TonerLite) %>% 
  setView(lng = -124.072971, lat = 40.887325,
          zoom = 4) %>% 
  addPolygons(
    fillColor = ~pal(`Chinook salmon`),
    color = "transparent",
    fillOpacity = 0.7,
    popup = ~labels,
    highlight = highlightOptions(color = "white",
                                 bringToFront = T),
    group = "Chinook"
  ) %>% 
  addPolygons(
    fillColor = ~pal2(steelhead),
    color = "transparent",
    fillOpacity = 0.7,
    popup = ~labels2,
    highlight = highlightOptions(color = "white",
                                 bringToFront = T),
    group = "Steelhead"
  ) %>% 
  addPolygons(
    fillColor = ~pal3(`green sturgeon`),
    color = "transparent",
    fillOpacity = 0.7,
    popup = ~labels3,
    highlight = highlightOptions(color = "white",
                                 bringToFront = T),
    group = "Green Sturgeon"
  ) %>% 
  addPolygons(
    fillColor = ~pal4(`coho salmon`),
    color = "transparent",
    fillOpacity = 0.7,
    popup = ~labels4,
    highlight = highlightOptions(color = "white",
                                 bringToFront = T),
    group = "Coho"
  ) %>%
  addLegend(pal = pal, values = ~`Chinook salmon`,
            title = "Chinook Authorized Take (# of Fish)",
            group = "Chinook", position = "bottomleft",
            className = "info legend Chinook") %>% 
  addLegend(pal = pal2, values = ~steelhead,
            title = "Steelhead Authorized Take (# of Fish)",
            group = "Steelhead", position = "bottomleft",
            className = "info legend Steelhead") %>% 
  addLegend(pal = pal3, values = ~`green sturgeon`,
            title = "Green Sturgeon Authorized Take (# of Fish)",
            group = "Green Sturgeon", position = "bottomleft",
            className = "info legend GreenSturgeon") %>% 
  addLegend(pal = pal4, values = ~`coho salmon`,
            title = "Coho Authorized Take (# of Fish)",
            group = "Coho", position = "bottomleft",
            className = "info legend Coho") %>% 
  addLayersControl(
    overlayGroups = c("Chinook", "Steelhead",
                      "Green Sturgeon", "Coho"),
    options = layersControlOptions(collapsed = F)) %>% 
  htmlwidgets::onRender("
      function(el, x) {
         var updateLegend = function () {
            var selectedGroup = document.querySelectorAll('input:checked')[0].nextSibling.innerText.substr(1);
            var selectedClass = selectedGroup.replace(' ', '');
            document.querySelectorAll('.legend').forEach(a => a.hidden=true);
            document.querySelectorAll('.legend').forEach(l => {
               if (l.classList.contains(selectedClass)) l.hidden=false;
            });
         };
         updateLegend();
         this.on('baselayerchange', el => updateLegend());
    }")

# Note - Chinook is default despite all labels being clicked. 
# Note - Consider making an amalgamation of take to have as default.
# Note - Include geartype and ind mort

#==============================================================
#R Shiny Dashboard
ui <- dashboardPage(
  dashboardHeader(title = "Maps"),
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
