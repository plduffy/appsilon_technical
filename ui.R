library(shiny.semantic)
library(shinycssloaders)
library(DT)
library(leaflet)

ui <- semanticPage(
  div(
    leafletOutput('map') %>% withSpinner(),
    textOutput('distance_between_observations'),
    flow_layout(
      div(class = 'raised ui segment',
        p('Select a vessel type:'),
        dropdownUI('select_vessel_type')
      ),
      div(class = 'raised ui segment',
          p('Select vessel name:'),
          dropdownUI('select_vessel_name')),
      cell_width = '49%'
    ),
    dataTableOutput('about_vessel')
  )
)