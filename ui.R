library(shiny)
library(rdrop2)

shinyUI(fluidPage(
  titlePanel("Arranjo Domiciliar"),
  sidebarLayout(
    sidebarPanel(
      uiOutput("ano_selector"),
      uiOutput("estado_selector"),
      uiOutput("cidade_selector"),
      hr()),
    mainPanel(tableOutput("table"))
  )
 )
)
