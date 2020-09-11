library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Capstone App"),
  h5("by NIDHI on Sept, 2020"),
  h5("Please wait a few seconds for the data to load"),
  
  mainPanel(
    textInput("textIn", 
              label = h3("Text input: "), 
              value = ""),
    h3("Text output: "),
    textOutput("textOut"),
    h3("Source code: "),
    h5("https://github.com/Papazian/Capstone")
  )
)
)