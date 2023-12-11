library(shiny)

# Define UI
ui <- fluidPage(
  navbarPage(
    "Mental Health and COVID-19",
    tabPanel("Intro", source("intro.R")),
    tabPanel("Story 1", source("interactivepage1.R")),
    tabPanel("Story 2", source("interactivepage2.R")),
    tabPanel("Story 3", source("interactivepage3.R")),
    tabPanel("Summary", source("summary.R"))
  )
)

# Define server
server <- function(input, output, session) {}

# Run the app
shinyApp(ui, server)
