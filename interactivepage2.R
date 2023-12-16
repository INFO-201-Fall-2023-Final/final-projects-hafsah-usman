library(shiny)
library(dplyr)
library(ggplot2)
library(fmsb)
library(zoo)
library(reshape2)


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
final_data <- select(final_data, -Depression)

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
           tags$h2(class = 'jumbotron-heading', stye = 'margin-bottom:0px;margin-top:0px', 'COVID-19 and Anxiety Analysis'),
           p('Learn about the correlation between Anxiety and COVID-19 cases.')
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
    tabPanel("Anxiety Levels Over Time", plotOutput("plot_anxiety")),
    tabPanel("Average COVID-19 Cases Over Time", plotOutput("plot_cases")),
  )
)

# -------------------------------- SERVER ------------------------------------ #
server <- function(input, output) {
  
  output$plot_cases <- renderPlot({
    ggplot(final_data, aes(x = MonthYear, y = Average_New_Cases_per_100, group = 1)) +
      geom_line() +
      labs(title = "Average New Cases per 100 Over Time", x = "MonthYear", y = "Average New Cases per 100") +
      theme_minimal()
  })
  
  output$plot_anxiety <- renderPlot({
    ggplot(final_data, aes(x = MonthYear, y = Anxiety, group = 1)) +
      geom_line() +
      labs(title = "Anxiety vs. Time", x = "MonthYear", y = "Anxiety") +
      theme_minimal()
  })
  
}

shinyApp(ui = ui, server = server)

