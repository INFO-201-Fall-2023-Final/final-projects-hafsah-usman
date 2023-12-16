library(dplyr)
library(stringr)
library(ggplot2)
library(shiny)
library(plotly)
library(shinythemes)

data <- read.csv("unified_and_cleaned_data.csv")

# ----------------------- MORE DATA MANIPULATION ----------------------------- #

data <- filter(data, !str_detect(Indicator, "Symptoms of Anxiety Disorder or Depressive Disorder"))

data <- mutate(data, row_number = row_number() %% 2)
data <- group_by(data, MonthYear, row_number)

processed_data <- summarise(data,
                            Depression = ifelse(row_number == 0, sum(Average_Percentage_per_Condition), NA),
                            Anxiety = ifelse(row_number == 1, sum(Average_Percentage_per_Condition), NA))

processed_data <- ungroup(processed_data)

final_data <- left_join(data, processed_data, by = c("MonthYear", "row_number"))
for (i in seq(1, nrow(data), by = 2)) {
  final_data$Depression[i] <- final_data$Depression[i + 1]
}

final_data <- final_data[!is.na(final_data$Anxiety), ]
final_data <- select(final_data, -Average_Percentage_per_Condition)
final_data <- final_data[, !names(final_data) %in% c("row_number")]
final_data <- select(final_data, -Indicator)
final_data <- select(final_data, -Cumulative_Cases_EndOfMonth)
final_data <- select(final_data, -Anxiety)

numeric_columns <- sapply(final_data, is.numeric)

column_to_exclude <- "MonthYear"
numeric_columns[column_to_exclude] <- FALSE

final_data[, numeric_columns] <- round(final_data[, numeric_columns], 2)

final_data$Average_New_Cases_per_100 <- final_data$Average_New_Cases / 1000
final_data <- final_data[, !names(final_data) %in% c("Average_New_Cases")]
names(final_data)[names(final_data) == "Average New_Cases (per_1000)"] <- "Average New_Cases (per_1000)"
names(final_data)[names(final_data) == "Average New_Cases (per_1000)"] <- "Average New_Cases (per_1000)"
final_data$Average_New_Cases_per_100 <- as.numeric(final_data$Average_New_Cases_per_100)

# --------------------------- UI / FUID PAGE --------------------------------- #

ui <- fluidPage(
  theme = shinytheme("darkly"),
  tags$div(class = "jumbotron text-center", style = "margin-bottom:0px;margin-top:0px",
           tags$h2(class = 'jumbotron-heading', stye = 'margin-bottom:0px;margin-top:0px', 'COVID-19 and Depression Analysis'),
  ),
  
  tabsetPanel(
    tabPanel("Depression", 
                      div(
                        style = "text-align: center;",
                        h1("Understanding Depression", style = "color: #3E92CC;"),
  
                        p("Depression is a mood disorder characterized by persistent feelings of sadness, hopelessness, and a lack of interest in daily activities. It can affect how you feel, think, and handle daily activities. Seeking help and support is important for managing depression.", style = "font-size: 18px;"),
                        hr(),
                        hr(),
                        h1("How to Measure Depression", style = "color: #3E92CC;"),
                        p("The Beck Depression Inventory (BDI) is widely used to screen for depression and to measure behavioral manifestations and severity of depression. The BDI can be used for ages 13 to 80. The inventory contains 21 self-report items which individuals complete using multiple choice response formats.", style = "font-size: 18px;")
                      )),
    tabPanel("Depression Levels Over Time",
             sliderInput("date_range_depression", "Select Date Range:",
                         min = min(as.Date(paste0(data$MonthYear, "-01")), na.rm = TRUE),
                         max = max(as.Date(paste0(data$MonthYear, "-01")), na.rm = TRUE),
                         value = c(min(as.Date(paste0(data$MonthYear, "-01")), na.rm = TRUE),
                                   max(as.Date(paste0(data$MonthYear, "-01")), na.rm = TRUE)),
                         step = 1),
             plotOutput("plot_depression")),
    tabPanel("Average COVID-19 Cases Over Time",
             sliderInput("date_range_cases", "Select Date Range:",
                         min = min(as.Date(paste0(data$MonthYear, "-01")), na.rm = TRUE),
                         max = max(as.Date(paste0(data$MonthYear, "-01")), na.rm = TRUE),
                         value = c(min(as.Date(paste0(data$MonthYear, "-01")), na.rm = TRUE),
                                   max(as.Date(paste0(data$MonthYear, "-01")), na.rm = TRUE)),
                         step = 1),
             plotOutput("plot_cases")),
  )
)


# -------------------------------- SERVER ------------------------------------ #
server <- function(input, output) {
  
  filtered_data <- reactive({
    date_range <- input$date_range_depression
    filtered <- subset(final_data, as.Date(paste0(MonthYear, "-01")) >= date_range[1] &
                         as.Date(paste0(MonthYear, "-01")) <= date_range[2])
    return(filtered)
  })
  
  filtered_data_cases <- reactive({
    date_range <- input$date_range_cases
    filtered <- subset(final_data, as.Date(paste0(MonthYear, "-01")) >= date_range[1] &
                         as.Date(paste0(MonthYear, "-01")) <= date_range[2])
    return(filtered)
  })
  
  output$plot_cases <- renderPlot({
    selected_data <- filtered_data_cases()
    ggplot(selected_data, aes(x = MonthYear, y = Average_New_Cases_per_100, group = 1)) +
      geom_line() +
      labs(title = "Average New Cases per 100 Over Time", x = "MonthYear", y = "Average New Cases per 100") +
      theme_minimal()
  })
  
  output$plot_depression <- renderPlot({
    selected_data <- filtered_data()
    ggplot(selected_data, aes(x = MonthYear, y = Depression, group = 1)) +
      geom_line() +
      labs(title = "Depression vs. Time", x = "MonthYear", y = "Depression") +
      theme_minimal()
  })
}

shinyApp(ui = ui, server = server)
