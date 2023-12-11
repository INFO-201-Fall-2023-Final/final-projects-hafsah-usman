library(shiny)
library(dplyr)
library(ggplot2)
library(fmsb)
library(zoo)
library(reshape2)


data <- read.csv("unified_and_cleaned_data.csv")


ui <- fluidPage(
  theme = shinytheme("darkly"),
  tags$div(class = "jumbotron text-center", style = "margin-bottom:0px;margin-top:0px",
           tags$h2(class = 'jumbotron-heading', stye = 'margin-bottom:0px;margin-top:0px', 'Interactive Page 1'),
           p('Learn about the correlation between Anxiety and COVID cases.')
  ),
  
  tabsetPanel(
    tabPanel("Anxiety", 
             div(
               style = "text-align: center;",
               h1("Understanding Anxiety", style = "color: #3E92CC;"),
               
               p("Anxiety is a common human experience characterized by feelings of worry, fear, or unease. 
    It is a natural response to stress and can manifest in various ways, both mentally and physically. 
    Understanding and managing anxiety is crucial for maintaining mental well-being. 
    This page provides information about anxiety and its impact on different characters over time.", style = "font-size: 18px;"),
               p("Health Concerns: The fear of contracting COVID-19 or seeing loved ones fall ill created significant anxiety. 
    Uncertainty about the severity of the illness and the potential long-term effects added to these concerns.", style = "font-size: 18px;"), 
               p("Social Isolation and Loneliness: Lockdowns, social distancing measures, and quarantine protocols led to increased social isolation. 
    Lack of physical contact with friends and family, and reduced social interactions, contributed to feelings of loneliness and isolation, which are associated with anxiety.", style = "font-size: 18px;"),
               p("Economic Uncertainty: Job losses, financial instability, and economic uncertainty due to the pandemic led to increased stress and anxiety for many individuals and families."),
               p("Changes in Daily Routine: Disruptions to regular routines, including work-from-home setups, remote learning, and changes in daily activities, can contribute to feelings of instability and anxiety.", style = "font-size: 18px;"),
               p("Information Overload and Misinformation: The constant flow of information about the pandemic, coupled with the spread of misinformation, contributed to anxiety. Individuals faced challenges in distinguishing between reliable and unreliable sources, leading to increased stress.", style = "font-size: 18px;"),
               
               hr(),
               hr(),
             )),
    tabPanel("Average Percentage of Anxiety Over Time", plotOutput("line_plot")),
    #tabPanel("Average_New_Cases", plotOutput("plot2")),
  )
)

ui <- fluidPage(
  titlePanel("Anxiety and Time"),
  tabsetPanel(
    tabPanel("About Anxiety ", 
             ui
    ),
    tabPanel("How is it Measured",
             #plotOutput("line_plot")
    )
  )
)

server <- function(input, output) {
  print(str(data))
  print(colnames(data))
  
  #### line_plot_data <- filter(data, Indicator == "Symptoms of Anxiety Disorder")
  # Reshape the data for plotting
  melted_df <- melt(data, id.vars = c("Date", "Indicator"), measure.vars = c("Symptoms_of_Anxiety_Disorder", "Average_New_Cases"))
  
  # Shiny plot
  output$plot <- renderPlot({
    ggplot(melted_df, aes(x = Date, y = value, color = variable)) +
      geom_line() +
      labs(title = "Change in Cases Over Time",
           x = "Date",
           y = "Value",
           color = "Variable") +
      theme_minimal()
  })
  # line_plot_data$Date <- as.Date(paste0(line_plot_data$MonthYear, "-01"))
  # 
  # print(colnames(line_plot_data))
  # str(line_plot_data)
  # 
  # output$line_plot <- renderPlot({
  #   ggplot(line_plot_data, aes(x = Date, y = Average_New_Cases, group = 1)) +
  #     geom_line() +
  #     labs(title = "Change in Cases of Anxiety and COVID-19 Over Time",
  #          x = "Date",
  #          y = "Average New Cases")
  # })
}

shinyApp(ui = ui, server = server)

