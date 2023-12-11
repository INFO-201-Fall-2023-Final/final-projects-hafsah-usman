library(dplyr)
library(stringr)
library(ggplot2)
library(shiny)
library(plotly)
library(shinythemes)

data <- read.csv("unified_and_cleaned_data.csv")


ui <- fluidPage(
  theme = shinytheme("darkly"),
  tags$div(class = "jumbotron text-center", style = "margin-bottom:0px;margin-top:0px",
           tags$h2(class = 'jumbotron-heading', stye = 'margin-bottom:0px;margin-top:0px', 'Interactive Page 1'),
           p('Learn about the correlation between anxiety and COVID cases.')
  ),
  
  tabsetPanel(
    tabPanel("Anxiety", 
             div(
               style = "text-align: center;",
               h1("Understanding Depression", style = "color: #3E92CC;"),
               
               p("Depression is a mood disorder characterized by persistent feelings of sadness, hopelessness, and a lack of interest in daily activities. It can affect how you feel, think, and handle daily activities. Seeking help and support is important for managing depression.", style = "font-size: 18px;"),
               hr(),
               hr(),
               h1("How to Measure Depression", style = "color: #3E92CC;"),
               p("The Beck Depression Inventory (BDI) is widely used to screen for depression and to measure behavioral manifestations and severity of depression. The BDI can be used for ages 13 to 80. The inventory contains 21 self-report items which individuals complete using multiple choice response formats.", style = "font-size: 18px;")
             )),
    tabPanel("Average_Percentage_per_Condition", plotOutput("plot1")),
    tabPanel("Average_New_Cases", plotOutput("plot2")),
    tabPanel("Cumulative_Cases_EndOfMonth", plotOutput("plot3"))
  )
)

server <- function(input, output) {
  
  data$Average_New_Cases <- as.numeric(as.character(data$Average_New_Cases))
  data$Cumulative_Cases_EndOfMonth <- as.numeric(as.character(data$Cumulative_Cases_EndOfMonth))
  
  observe({
    print(str(data))
  })
  
  filteredColumns <- reactive({
    columns <- data[, grepl("depressive", names(data))]
    return(columns)
  })
  
  
  output$plot1 <- renderPlot({
    ggplot(data = data, aes_string(x = "MonthYear", y = "Average_Percentage_per_Condition")) +
      geom_line() +
      labs(title = "Time vs Average_Percentage_per_Condition for Depressive Indicators", x = "MonthYear", y = "Average_Percentage_per_Condition") +
      theme_light()
  })
  
  output$plot2 <- renderPlot({
    ggplot(data = data, aes_string(x = "MonthYear", y = "Average_New_Cases")) +
      geom_line() +
      labs(title = "Time vs Average_New_Cases for Depressive Indicators", x = "MonthYear", y = "Average_New_Cases") +
      theme_light()
  })
  
  output$plot3 <- renderPlot({
    ggplot(data = data, aes_string(x = "MonthYear", y = "Cumulative_Cases_EndOfMonth")) +
      geom_line() +
      labs(title = "Time vs Cumulative_Cases_EndOfMonth for Depressive Indicators", x = "MonthYear", y = "Cumulative_Cases_EndOfMonth") +
      theme_light()
  })
}

shinyApp(ui = ui, server = server)
