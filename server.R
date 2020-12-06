library(magrittr)
library(shiny.semantic)
library(dplyr)
library(geosphere)
library(leaflet)
library(sp)

## Only using DT for a single line table, so get rid of everything minus the table
options(DT.options = list(dom = 't'))

server <- function(input, output, session) {
  
  ns <- session$ns
  
  store <- reactiveValues()
  
  # store$ships <- fread('ships.csv') %>%
  #   as.data.frame()
  store$ships <- readRDS('ships_data.rds')
  
  store$vessel_types <- reactive({
    unique(store$ships$ship_type)
  })
  
  dropdownServer('select_vessel_type', reactive(store$vessel_types()))
  
  store$ship_names <- reactive({
    unique(store$ships$SHIPNAME)
  })
  
  dropdownServer('select_vessel_name', reactive(store$ship_names()))
  
  observeEvent(input[['select_vessel_type-select_vessel_type']], {
    ship_names <- store$ships %>% 
      filter(ship_type == input[['select_vessel_type-select_vessel_type']]) %$%
      SHIPNAME %>% 
      unique()
    update_dropdown_input(session, 'select_vessel_name-select_vessel_name', choices = ship_names)
  })
  
  observeEvent(input[['select_vessel_name-select_vessel_name']], {
    store$longest_trip <- longest_between_observations(store$ships, input[['select_vessel_name-select_vessel_name']])  
  })
  
  output$map <- renderLeaflet({
    
    req(input[['select_vessel_name-select_vessel_name']])
    
    long <- store$longest_trip$long
    
    leaflet() %>% 
      addTiles() %>% 
      addCircleMarkers(data = long, lng = ~LON, lat = ~LAT,
                       label = ~DATETIME)
  })
  
  output$distance_between_observations <- renderText({
    req(input[['select_vessel_name-select_vessel_name']])
    
    distance <- longest_between_observations(store$ships, input[['select_vessel_name-select_vessel_name']])$full$distance
    distance <- round(distance, 0) %>% 
      scales::comma()
    
    text <- paste0('Longest distance sailed between two observations for the vessel ',
                   input[['select_vessel_name-select_vessel_name']],
                   ' was ',
                   distance,
                   ' km.')
  })
  
  output$about_vessel <- renderDataTable({
    req(input[['select_vessel_name-select_vessel_name']])
    vessel <- store$longest_trip$full
    
    vessel %>% 
      select(Date = DATETIME,
             Destination = DESTINATION,
             Heading = HEADING,
             Parked = is_parked) %>% 
      mutate(Parked = if_else(Parked == 0, 'No', 'Yes')) %>% 
      semantic_DT()
    
  })
  
}