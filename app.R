library(shiny)

# Define UI
ui <- fluidPage(
  navbarPage(
    "Your Shiny App",
    tabPanel("Intro", source("intro.R")),
    tabPanel("Story 1", source("story1.R")),
    tabPanel("Story 2", source("story2.R")),
    tabPanel("Story 3", source("story3.R")),
    tabPanel("Summary", source("summary.R"))
  )
)

# Define server
server <- function(input, output, session) {}

# Run the app
shinyApp(ui, server)
