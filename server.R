library(shiny)
# source("simula.R")

shinyServer(function(input, output) {
  output$table <- renderTable( dataset[dataset$MUNICÍPIOS==input$cidade,], rownames=TRUE)
  }
)
