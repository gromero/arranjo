library(shiny)
library(rdrop2)

datafile <- drop_dir()$path_display[2] # dataset_SP_1970.csv
dataset <- drop_read_csv(datafile)
cidades <- list("SP" = "São Paulo", "MG" = "Minas Gerais")

mun <- levels(dataset$MUNICÍPIOS)[]
lista_mun <- as.list(mun)
names(lista_mun) <- mun

shinyUI(fluidPage(
  titlePanel("Arranjo Domiciliar"),
  sidebarLayout(
    sidebarPanel(
      selectInput("cidade", "Cidade", choices=lista_mun),
      hr()),
     mainPanel(tableOutput("table"))
  )
 )
)
#  server = function (input, output) {
#   output$data <- renderTable( {
#     dataset[dataset$MUNICÍPIOS==c("ADAMANTINA"),]}, rownames=TRUE)
#   }
