
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
           p('Learn about the correlation between depression and COVID cases.')
  ),
  
  tabsetPanel(
    tabPanel("Definitions", textOutput("definition")),
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
  
  
  
  output$definition <- renderText({
    "Depression is a mental disorder that involves a persistent feeling of loss of pleasure or interest in activities for long periods of time."
    # You can modify this text to include more detailed information if needed.
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
