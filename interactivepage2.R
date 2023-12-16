library(shiny)
library(dplyr)
library(ggplot2)

# Read your data (replace "unified_and_cleaned_data.csv" with the actual file path)
data <- read.csv("unified_and_cleaned_data.csv")

about_view <- fluidPage(
  h1("ABOUT PAGE"),
  p("Anxiety is a common human experience characterized by feelings of worry, fear, or unease. 
    It is a natural response to stress and can manifest in various ways, both mentally and physically. 
    Understanding and managing anxiety is crucial for maintaining mental well-being. 
    This page provides information about anxiety and its impact on different characters over time."),
  p("Health Concerns: The fear of contracting COVID-19 or seeing loved ones fall ill created significant anxiety. 
    Uncertainty about the severity of the illness and the potential long-term effects added to these concerns."), 
  p("Social Isolation and Loneliness: Lockdowns, social distancing measures, and quarantine protocols led to increased social isolation. 
    Lack of physical contact with friends and family, and reduced social interactions, contributed to feelings of loneliness and isolation, which are associated with anxiety."),
  p("Economic Uncertainty: Job losses, financial instability, and economic uncertainty due to the pandemic led to increased stress and anxiety for many individuals and families."),
  p("Changes in Daily Routine: Disruptions to regular routines, including work-from-home setups, remote learning, and changes in daily activities, can contribute to feelings of instability and anxiety."),
  p("Information Overload and Misinformation: The constant flow of information about the pandemic, coupled with the spread of misinformation, contributed to anxiety. Individuals faced challenges in distinguishing between reliable and unreliable sources, leading to increased stress.")
)

ui <- fluidPage(
  titlePanel("Anxiety and Time"),
  tabsetPanel(
    tabPanel("About Anxiety ", about_view),
    tabPanel("How is it Measured",
             sliderInput("date_range", "Select Date Range:",
                         min = min(as.Date(paste0(data$MonthYear, "-01")), na.rm = TRUE),
                         max = max(as.Date(paste0(data$MonthYear, "-01")), na.rm = TRUE),
                         value = c(min(as.Date(paste0(data$MonthYear, "-01")), na.rm = TRUE),
                                   max(as.Date(paste0(data$MonthYear, "-01")), na.rm = TRUE)),
                         step = 1),
             plotOutput("line_plot")
    )
  )
)

server <- function(input, output) {
  observe({
    print(str(data))
    print(colnames(data))
  })
  
  line_plot_data <- reactive({
    req(data)  # Ensure that data is available
    # Assuming "MonthYear" corresponds to date information
    filter(data, Indicator == "Symptoms of Anxiety Disorder" & 
             as.Date(paste0(MonthYear, "-01")) >= input$date_range[1] & 
             as.Date(paste0(MonthYear, "-01")) <= input$date_range[2])
  })
  
  observe({
    print(colnames(line_plot_data()))
    str(line_plot_data())
  })
  
  output$line_plot <- renderPlot({
    ggplot(line_plot_data(), aes(x = as.Date(paste0(MonthYear, "-01")), y = Average_New_Cases, group = 1)) +
      geom_line() +
      labs(title = "Symptoms of Anxiety Disorder vs. Average New Cases",
           x = "Date",
           y = "Average New Cases")
  })
}

shinyApp(ui = ui, server = server)
