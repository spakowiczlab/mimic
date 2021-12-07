# This is a bare bones shiny app so that I can figure out how to work the inputs and outputs.

# load code
library(shiny)
library(dplyr)
library(ggplot2)
library(tidyr)
source("shiny-functions.R")


# Define UI 
ui <- fluidPage(
  
  # App title ----
  titlePanel("Dietary Carotenoid Assessment Tool (DCAT)"),
  
  # Sidebar layout with input and output definitions
  sidebarLayout(
    
    # Sidebar panel for inputs 
    sidebarPanel(
      
      # Input: Upload file of redcap output, choose nutrients to display pie
      fileInput(inputId = "redcapoutput", 
                label = "Upload REDCap output", 
                accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")
      ),
      downloadButton("carotab", "Download carotenoid table")),
    
    mainPanel(
      
      tableOutput("table"),
      plotOutput("piesource")
    )
    
    
  )
  
  # Main panel for displaying outputs ----
  
)


# Define server 
server <- function(input, output) {
  
  redouttab <- reactive({
    req(input$redcapoutput)
    read.csv(input$redcapoutput$datapath)
  })

  output$table <- renderTable({
    calcCaroteneSub(redouttab())
  })
  
  output$piesource <- renderPlot(displayCaroSource(redouttab()))
  output$carotab <- downloadHandler(
    filename = function(){
      "FFQ-results.csv"
    },
    content <- function(file){
      write.csv(calcCaroteneSub(redouttab()), file)
    }
  )
}

# Run the app
shinyApp(ui = ui, server = server)