library(shiny)
library(shinythemes)

ui <- fluidPage(
  theme = shinytheme("darkly"),
  tabsetPanel(
    tabPanel(
      "About Project",
      div(
        style = "text-align: left;",
        h1("About Our Project", style = "color: #3E92CC;"),
        
        h3("Project Overview"),
        p(
          "Welcome to our data-driven exploration of the complex relationship between COVID-19 and mental health. This project aims to uncover the nuanced ways in which the pandemic has influenced mental well-being, combining comprehensive analysis with real-world stories."
        ),
        
        h3("Dataset Sources"),
        p("1. **COVID-19 Data (World Health Organization):**",
          "   - Source: [World Health Organization](https://www.who.int/)",
          "   - Observations: 329,905 | Features: 8",
          "   - Collection Period: December 2019 to March 2020 (pre-22 March 2020) and region-specific dashboards thereafter."
        ),
        p("2. **Indicators of Anxiety or Depression (USDHHS):**",
          "   - Source: [U.S. Department of Health & Human Services](https://www.hhs.gov/)",
          "   - Observations: 14,374 | Features: 14",
          "   - Collection Method: Internet questionnaires sent via email and text messages."
        ),
        
        h3("Project Team"),
        p(
          "This project was conducted by Faiza Imran, Anuujin Chadraa, and Hafsah Usman."
        ),
        
      )
    ),
    
    tabPanel(
      "Summary Takeaways",
      div(
        style = "text-align: left;",
        h1("Summary Takeaways", style = "color: #3E92CC;"),
        
        h3("Key Findings"),
        p(
          "Our analysis reveals crucial insights into the intersection of COVID-19 and mental health. Here are the key takeaways:"
        ),
        
        h4("1. Increased Rates of Anxiety and Depression"),
        p(
          "Throughout the pandemic, there has been a notable surge in anxiety and depression, impacting diverse demographic groups."
        ),
        
        h4("2. Disparities in Mental Health Challenges"),
        p(
          "Disparities have emerged, with young, less-educated, single-parent, female, Black, and Hispanic respondents experiencing higher rates of mental health disorders."
        ),
        
        h4("3. Opportunities for Resilience and Growth"),
        p(
          "Despite challenges, the pandemic has also provided opportunities for self-reflection, resilience, and community building."
        ),
        
        h4("4. Urgent Need for Increased Mental Health Services"),
        p(
          "Our findings underscore the urgent need for increased access to mental health services, particularly for vulnerable populations."
        ),
        
        h3("Why It Matters"),
        p(
          "Understanding the mental health impact of the COVID-19 pandemic is crucial for shaping future public health policies, interventions, and support systems. By addressing mental health challenges, we can collectively work towards a more resilient and supportive society."
        ),
        
        h3("Next Steps"),
        p(
          "Our project lays the foundation for ongoing research and interventions aimed at mitigating the long-term mental health consequences of the pandemic. Continued efforts are essential to ensuring the well-being of individuals and communities worldwide."
        )
      )
    )
  )
)

server <- function(input, output) {

}

shinyApp(ui = ui, server = server)

