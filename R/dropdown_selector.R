dropdownUI <- function(id){
  ns <- NS(id)
  uiOutput(ns('dropdown'))
}

dropdownServer <- function(id, choices){
  moduleServer(
    id,
    function(input, output, session){
      output$dropdown <- renderUI({
        ns <- session$ns
        default_value <- choices()[1]
        dropdown_input(ns(id), choices = choices(), value = default_value)
      })
    }
  )
}

