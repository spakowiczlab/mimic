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
                choices = c("mimic1 x Anti-PD-1 x HONC-60-55.v3", "mimic1 x Anti-PD-1 x HONC-60-55.v4",
                            "mimic1 x IgG x HONC-60-55.v3", "mimic1 x IgG x HONC-60-55.v4",
                            "mimic2 x Anti-PD1 x Fitness (DL081)", "mimic2 x Anti-PD1 x Saline",
                            "mimic2 x IgG x Fitness (DL081)", "mimic2 x IgG x Saline",
                            "mimic3 x IgG x Fitness:DL017", "mimic3 x PD1 x Fitness:DL017", 
                            "mimic4 x IgG x 84v4", "mimic4 x PD1 x 84v3", "mimic5 x IgG x 10v3",
                            "mimic5 x IgG x 10v4", "mimic5 x PD1 x 10v3", "mimic5 x PD1 x 10v4", 
                            "mimic6 x Anti-PD1 x HONC60-55 v3", "mimic6 x Anti-PD1 x HONC60-55 v4",
                            "mimic6 x IgG x HONC60-55 v3", "mimic6 x IgG x HONC60-55 v4",
                            "mimic7 x Anti-PD1 x HONC60-55 v3", "mimic7 x Anti-PD1 x HONC60-55 v4",
                            "mimic7 x IgG x HONC60-55 v3", "mimic7 x IgG x HONC60-55 v4", 
                            "mimic8 x Anti-PD1 x DL017", "mimic8 x IgG x DL017", 
                            "mimic9 x Anti-PD1 x HONC-60 62v2", "mimic9 x IgG x HONC-60 62v4")
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
