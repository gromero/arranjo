library(shiny)
library(stringr)

prefix <- "arranjo_.*"
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
#     drop_download(paste("arranjo_BR_",input$ano,".csv",sep=""),overwrite=TRUE)
#     db <<- read.csv(paste("./arranjo_BR_",input$ano,".csv",sep=""))
      db <<- drop_read_csv(paste("/arranjo_BR_",input$ano,".csv",sep=""))
      estados <- levels(db[which(db$CENSO==input$ano),]$ESTADO)
      selectInput("estado","Estado:", choices=estados)
    }
  })
  output$cidade_selector <- renderUI({
    cidades <- db[which(db$CENSO==input$ano & db$ESTADO==input$estado),]$MUNICIPIO
    selectInput("cidade","Cidade:", choices=as.vector(cidades))
  })
  output$table <- renderTable( db[which(db$CENSO==input$ano & db$ESTADO==input$estado & db$MUNICIPIO==input$cidade),], rownames=TRUE )
})
