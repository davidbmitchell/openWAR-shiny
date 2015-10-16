
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

position_labels <- c("P", "C", "1B", "2B", "3B", "SS", "LF", "CF", "RF", "DH")
library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("openWAR Data"),
  
  fluidRow(checkboxGroupInput('position', "Positions", 
                         choices = position_labels,
                         selected = NULL,
                         inline = TRUE
                         )
           ),
  mainPanel(
    tabsetPanel(id = "year",
      # Show a plot of the generated distribution
      tabPanel("2015", dataTableOutput("oWAR15")),
      tabPanel("2014", dataTableOutput("oWAR14")),
      tabPanel("2013", dataTableOutput("oWAR13"))
    )
  )
))
