library(shiny)
library(stringr)

prefix <- "ARRANJOS_DOMICILIARES_BR_.*"
dir_files <- drop_dir("/")$name
db_files <- str_extract(dir_files, prefix)[!is.na(str_extract(dir_files,prefix))]
db_years <- gsub(".*([0-9]{4}).csv$","\\1", db_files)

shinyServer(

function(input, output) {
  output$ano_selector <- renderUI({ selectInput("ano","Ano:", choices=db_years, selected="1970") })
  output$estado_selector <- renderUI({
#   print(input$ano);
    # This is a workaround since "ano" might hit here being NULL when ano_selector
    # is finishing render, so avoid it, otherwise filename to download is crap and
    # a HTTP 409 error happens.
    if (!is.null(input$ano)) {
      db_name <- paste("ARRANJOS_DOMICILIARES_BR_", input$ano, ".csv", sep="")
      drop_download(db_name, overwrite=TRUE)
      db <<- read.csv(db_name, sep=";", fileEncoding="latin1")
#     db <<- read.csv(paste("./arranjo_BR_",input$ano,".csv",sep=""))
#     db <<- drop_read_csv(paste("ARRANJOS_DOMICILIARES_BR_",input$ano,".csv",sep=""), fileEncoding="latin1")
      estados <- levels(db[which(db$CENSO==input$ano),]$ESTADO)
      selectInput("estado","Estado:", choices=estados)
    }
  })
  output$cidade_selector <- renderUI({
    cidades <- db[which(db$CENSO==input$ano & db$ESTADO==input$estado),]$MUNICIPIO
    selectInput("cidade","Cidade:", choices=sort(as.vector(cidades)))
  })
  output$table <- renderTable( db[which(db$CENSO==input$ano & db$ESTADO==input$estado & db$MUNICIPIO==input$cidade),], rownames=TRUE )
})
