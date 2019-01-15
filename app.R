# Packages
library(shiny)
library(shinydashboard)
library(shinyjs)
library(tidyverse)
library(plotly)
library(leaflet)

# Source
source("R/load_data.R")

# api options
mapbox <- "https://api.mapbox.com/styles/v1/robertmitchellv/cipr7teic001aekm72dnempan/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoicm9iZXJ0bWl0Y2hlbGx2IiwiYSI6ImNpcHI2cXFnbTA3MHRmbG5jNWJzMzJtaDQifQ.vtvgLokcc_EJgnWVPL4vXw"

# functions
`%<>%` <- magrittr::`%<>%`

# JS function -----------   ------------------------------------------------------- 
scroll <- "
shinyjs.scroll = function() { 
$('body').animate({ scrollTop: 0 }, 'slow'); } "

# colors - to ease the pain, I'd recommend creating an R package for this
pal <- RColorBrewer::brewer.pal(11, "Spectral")
qual5 <- c(pal[1], pal[3], pal[4], pal[9], pal[10])
qual6 <- c(pal[1], pal[3], pal[4], pal[8], pal[9], pal[10])
qual7 <- c(pal[1], pal[3], pal[4], pal[7], pal[8], pal[9], pal[10])
cool <- c(pal[7], pal[8], pal[9], pal[10], pal[11])
warm <- c(pal[5], pal[4], pal[3], pal[2], pal[1])
cool_gradient <- data_frame(
  range = c(0.000, 0.115, 0.290, 0.750, 1.000),
  hex = cool
)
warm_gradient <- data_frame(
  range = c(0.000, 0.115, 0.290, 0.750, 1.000),
  hex = warm
)

# Read data
housing_read <- load_data()

header <- dashboardHeader(
    title = tags$a(href = "",
                   tags$img(src = "r_logo.png", heigh = "45", width = "40",
                            style = "display: block; padding-top: 5px;"))
)

sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem("Home", tabName = "home", icon = icon("home")),
        menuItem("Maps", tabName = "maps", icon = icon("map-o"))
    )
)

body <- dashboardBody(
  useShinyjs(),
  extendShinyjs(text = scroll),
  tags$body(id = "body"),
  includeCSS("www/custom.css"),
  tabItems(
      # home
      
      # maps
      tabItem(
          tabName = "home",
          tags$style(type = "text/css", "#map {height: calc(100vh - 80px)!important;}"),
          leafletOutput("affordable_map"),
          absolutePanel(
              top = 80, right = 30,
              selectInput(
                "map_property_category", label = NULL,
                selected = "Supportive", choices = c(
                  "Artist", "Disabled", "Family", "Senior", "Supportive", "Chicago ARO"
                )
              )
          )
      )
  ) # end tabItems
) # body

ui <- dashboardPage(header, sidebar, body)

# server
server <- function(input, output) {
  # reactive data
  housing <- reactive({ 
    housing_read %>% 
      filter(property_category == input$map_property_category) %>%
      group_by(property_category) %>%
      mutate(total = n())
  })
  
  # home
  
  # maps
  output$affordable_map <- renderLeaflet({
    
    pal <- colorBin(
      warm,
      domain = housing()$total,
      bins = 15
    )
    
    icons <- awesomeIcons(
      icon = "fa-building",
      library = "fa",
      markerColor = "lightgray",
      iconColor = "white"
    )
    
    leaflet(housing()) %>%
      addTiles(mapbox) %>%
      addPolygons(
        fillColor = ~pal(total),
        weigh = 1.5,
        fillOpacity = 0.7,
        smoothFactor = 0.5,
        color = "white",
        highlight = highlightOptions(
          weight = 3,
          color = "#54565b",
          bringToFront = TRUE),
        label = ~community) %>%
      addAwesomeMarkers(
        icon = icons,
        lng = ~housing()$longitude,
        lat = ~housing()$latitude,
        label = ~str_glue("{property_name} {units} units")) %>%
      addLegend(
        pal = pal, values = ~total, opacity = 0.7,
        title = NULL, position = "bottomright")
  }) 
  
} # end server

# run app
shinyApp(ui, server)
