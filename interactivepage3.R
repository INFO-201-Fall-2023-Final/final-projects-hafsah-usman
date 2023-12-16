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
library(shinythemes)

data <- read.csv("unified_and_cleaned_data.csv")

# ----------------------- MORE DATA MANIPULATION ----------------------------- #
data <- filter(data, !str_detect(Indicator, "Symptoms of Anxiety Disorder or Depressive Disorder"))

data <- mutate(data, row_number = row_number() %% 2)
data <- group_by(data, MonthYear, row_number)

processed_data <- data %>%
  group_by(MonthYear, row_number) %>%
  summarise(Depression = ifelse(row_number == 0, sum(Average_Percentage_per_Condition), NA),
            Anxiety = ifelse(row_number == 1, sum(Average_Percentage_per_Condition), NA),
            .groups = "drop") %>%
  ungroup()

final_data <- left_join(data, processed_data, by = c("MonthYear", "row_number"))
for (i in seq(1, nrow(data), by = 2)) {
  final_data$Depression[i] <- final_data$Depression[i + 1]
  
}

final_data <- final_data[!is.na(final_data$Anxiety), ]
final_data <- select(final_data, -Average_Percentage_per_Condition)
final_data <- final_data[, !names(final_data) %in% c("row_number")]
final_data <- select(final_data, -Indicator)
final_data <- select(final_data, -Cumulative_Cases_EndOfMonth)

numeric_columns <- sapply(final_data, is.numeric)

column_to_exclude <- "MonthYear"

numeric_columns[column_to_exclude] <- FALSE

final_data[, numeric_columns] <- round(final_data[, numeric_columns], 2)

final_data$Average_New_Cases_per_100 <- final_data$Average_New_Cases / 1000
final_data <- final_data[, !names(final_data) %in% c("Average_New_Cases")]
names(final_data)[names(final_data) == "Average New_Cases (per_1000)"] <- "Average New_Cases (per_1000)"

# --------------------------- UI / FUID PAGE --------------------------------- #
ui <- fluidPage(
  theme = shinytheme("darkly"),
  tags$div(class = "jumbotron text-center", style = "margin-bottom:0px;margin-top:0px",
           tags$h2(class = 'jumbotron-heading', stye = 'margin-bottom:0px;margin-top:0px', 'COVID-19 and Mental Health Analysis'),
           p('Visualize the correlation between COVID-19 cases and mental health.')
  ),
  
  p(""),
  p(""),
  p(""),
  p("This graph shows the change in percentage of adults in the United States showing signs of Anxiety and Depression, as well as the average new cases"),
  p("for each month. Levels of anxiety and depression can be seeing overtime, as the number of cases change. "),
  sliderInput("date_range", "Select Date Range:",
              min = min(as.Date(paste0(data$MonthYear, "-01")), na.rm = TRUE),
              max = max(as.Date(paste0(data$MonthYear, "-01")), na.rm = TRUE),
              value = c(min(as.Date(paste0(data$MonthYear, "-01")), na.rm = TRUE),
                        max(as.Date(paste0(data$MonthYear, "-01")), na.rm = TRUE)),
              step = 1),
  p(""),
  p(""),
  p(""),
  p(""),
  plotOutput("plot"),
)

# -------------------------------- SERVER ------------------------------------ #
server <- function(input, output) {
  final_data$MonthYear <- as.Date(paste0(final_data$MonthYear, "-01"))
  
  observe({
    filtered_data <- subset(final_data, MonthYear >= input$date_range[1] & MonthYear <= input$date_range[2])
    
    long_data <- gather(filtered_data, key = "Legend", value = "Value", -MonthYear)
    
    output$plot <- renderPlot({
      ggplot(long_data, aes(x = MonthYear, y = Value, fill = Legend)) +
        geom_bar(stat = "identity", position = "dodge", width = 0.7) +
        ylab("Values") +
        xlab("Date") +
        ggtitle("Depression, Anxiety, and New COVID-19 Cases Over Time") +
        theme_minimal()
    })
  })
}

shinyApp(ui = ui, server = server)
