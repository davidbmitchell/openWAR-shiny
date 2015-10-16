
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

oWAR15 <- readRDS("data/oWAR_15.rds")
oWAR14 <- readRDS("data/oWAR_14.rds")
oWAR13 <- readRDS("data/oWAR_13.rds")

position_labels <- c("P", "C", "1B", "2B", "3B", "SS", "LF", "CF", "RF", "DH")

library(shiny)

shinyServer(function(input, output) {
  
  data <- reactive({
    oWAR15 <- subset(oWAR15, Position %in% c(input$position))[,2:12]
    oWAR14 <- subset(oWAR14, Position %in% c(input$position))[,2:12]
    oWAR13 <- subset(oWAR13, Position %in% c(input$position))[,2:12]
    
  })
  
  output$oWAR15 <- renderDataTable({
    if(is.null(input$position)) {
      oWAR15[,2:12]
    }
    else {
      data()
    }
  })
  
  output$oWAR14 <- renderDataTable({
    if(is.null(input$position)) {
      oWAR14[,2:12]
    }
    else {
      data()
    }
  })
  
  output$oWAR13 <- renderDataTable({
    if(is.null(input$position)) {
      oWAR13[,2:12]
    }
    else {
      data()
    }
  })

})
