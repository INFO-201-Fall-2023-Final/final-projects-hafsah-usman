library(shiny)


ui <- fluidPage(
  navbarPage(
    "Mental Health and COVID-19",
    tabPanel("Intro", source("intro.R")),
    tabPanel("Depression", source("interactivepage1.R")),
    tabPanel("Anxiety", source("interactivepage2.R")),
    tabPanel("Mental Health", source("interactivepage3.R")),
    tabPanel("Summary", source("summary.R"))
  )
)
server <- function(input, output, session) {}

shinyApp(ui, server)
