# This is a bare bones shiny app so that I can figure out how to work the inputs and outputs.

# load code
library(shiny)
library(dplyr)
library(ggplot2)
library(tidyr)
library(RColorBrewer)
source("shiny-functions.R")


# Define UI 
ui <- fluidPage(
  
  # App title ----
  titlePanel("Display tumor means for selected groups"),
  
  # Sidebar layout with input and output definitions
  sidebarLayout(
    
    # Sidebar panel for inputs 
    sidebarPanel(
      
      # Input: Upload file of redcap output, choose nutrients to display pie
      checkboxGroupInput(inputId = "mgroups", 
                label = "Mimic groups", 
                choices = c("Anti-PD-1 x HONC-60-55.v3", "Anti-PD-1 x HONC-60-55.v4", 
                            "Anti-PD1 x Fitness (DL081)", "Anti-PD1 x HONC60-55 v3",
                            "Anti-PD1 x HONC60-55 v4", "Anti-PD1 x Saline", "IgG x 10v3",
                            "IgG x 10v4", "IgG x 84v4", "IgG x Fitness (DL081)", "IgG x Fitness:DL017",
                            "IgG x HONC-60-55.v3", "IgG x HONC-60-55.v4", "IgG x HONC60-55 v3",
                            "IgG x HONC60-55 v4", "IgG x Saline", "PD1 x 10v3", "PD1 x 10v4", 
                            "PD1 x 84v3", "PD1 x Fitness:DL017")
      )),
      # actionButton("go", "Update")),
    
    mainPanel(
      
      plotOutput("lineplot")
    )
    
    
  )
  
  # Main panel for displaying outputs ----
  
)


# Define server 
server <- function(input, output) {
  
  # redouttab <- reactive({
  #   req(input$redcapoutput)
  #   read.csv(input$redcapoutput$datapath)
  # })

  
  # observeEvent(input$go, {
    output$lineplot <- renderPlot(plotDesiredGroups(input$mgroups))
    # })

}

# Run the app
shinyApp(ui = ui, server = server)
