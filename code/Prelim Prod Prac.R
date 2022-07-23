# Alana Santana
# Leaflet integration into R shiny

library(shiny)
library(shinydashboard)
source("code/Reading and Filtering.R")
source("code/Species_ExpTakeJuveniles_Leaflet.R")
source("code/Species_ExpTakeAdults_Leaflet.R")



ui <- fluidPage(
  dashboardPage(
    skin = "blue",
    dashboardHeader(title = "NOAA Permit Applications"),
    dashboardSidebar( width = 250,
                      menuItem("Home", tabName = "home", icon = icon("home")),
                      menuItem("Species Take Map", tabName = "Take map", icon = icon("map marked alt")),
                      menuItem("Active Permits by HUC Map", tabName = "Permit map", icon = icon("map marked alt")), 
                      HTML(paste0(
                        "<br><br><br><br><br><br><br><br><br>",
                        "<table style='margin-left:auto; margin-right:auto;'>",
                        "<tr>",
                        "<td style='padding: 5px;'><a href='https://www.facebook.com/nationalparkservice' target='_blank'><i class='fab fa-facebook-square fa-lg'></i></a></td>",
                        "<td style='padding: 5px;'><a href='https://www.youtube.com/nationalparkservice' target='_blank'><i class='fab fa-youtube fa-lg'></i></a></td>",
                        "<td style='padding: 5px;'><a href='https://www.twitter.com/natlparkservice' target='_blank'><i class='fab fa-twitter fa-lg'></i></a></td>",
                        "<td style='padding: 5px;'><a href='https://www.instagram.com/nationalparkservice' target='_blank'><i class='fab fa-instagram fa-lg'></i></a></td>",
                        "<td style='padding: 5px;'><a href='https://www.flickr.com/nationalparkservice' target='_blank'><i class='fab fa-flickr fa-lg'></i></a></td>",
                        "</tr>",
                        "</table>",
                        "<br>"),
                        HTML(paste0(
                          "<script>",
                          "var today = new Date();",
                          "var yyyy = today.getFullYear();",
                          "</script>",
                          "<p style = 'text-align: center;'><small>&copy; - <a href='https://alessiobenedetti.com' target='_blank'>alessiobenedetti.com</a> - <script>document.write(yyyy);</script></small></p>")
                        ))
    )
    
  ),
  dashboardBody(
    tabItems()
  )