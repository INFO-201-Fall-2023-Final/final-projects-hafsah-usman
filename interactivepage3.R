# INFO 201 AUT2023: B/BF
# GROUP: BF5
# HAFSAH USMAN
# Prof. Julia Deeb-Swihart

library(dplyr)
library(stringr)
library(testthat)
library(shiny)
library(lubridate)
library(ggplot2)
library(tidyr)

# testing
df <- read.csv("unified_and_cleaned_data.csv")
reshaped_data <- pivot_wider(
  data = df,
  id_cols = MonthYear,
  names_from = Indicator,
  values_from = c(Average_Percentage_per_Condition, Average_New_Cases, Cumulative_Cases_EndOfMonth)
)
colnames(reshaped_data) <- c("MonthYear", 
                             paste("avg_", unique(df$Indicator), sep = ""),
                             paste("new_cases_", unique(df$Indicator), sep = ""),
                             paste("cumulative_", unique(df$Indicator), sep = "")
)

# ui
ui <- fluidPage(
  titlePanel("Depression, Anxiety, and COVID-19 Statistics Over Time"),
  p("hey"),
  mainPanel(
    plotOutput("bar_plot")
  )
)

# Define server logic
server <- function(input, output) {
  #Generate bar plot
  output$bar_plot <- renderPlot({
    ggplot(reshaped_data, aes(x = MonthYear)) +
      geom_bar(aes(y = avg_depression / 100, fill = "Depression"), stat = "identity", position = "identity") +
      geom_bar(aes(y = avg_anxiety / 100, fill = "Anxiety"), stat = "identity", position = "identity") +
      geom_line(aes(y = avg_new_cases / max(avg_new_cases), group = 1, color = "COVID-19 Cases"), size = 1, linetype = "dashed") +
      scale_y_continuous(labels = scales::percent_format(scale = 1), sec.axis = sec_axis(~.*max(avg_new_cases), name = "Number of Cases")) +
      scale_fill_manual(values = list("Depression" = "blue", "Anxiety" = "red")) +
      scale_color_manual(values = list("Cases" = "green", "COVID-19 Cases" = "orange")) +
      labs(title = "Depression, Anxiety, and COVID-19 Statistics Over Time",
           x = "Time (Month)",
           y = "Percentage",
           fill = "",
           color = "") +
      theme_minimal()
  })
}


# Run the application
shinyApp(ui = ui, server = server)