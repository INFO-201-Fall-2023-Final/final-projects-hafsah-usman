library(shiny)
library(shinythemes)

ui <- fluidPage(
  theme = shinytheme("darkly"),
  tags$div(
    class = "jumbotron text-center",
    style = "margin-bottom:0px;margin-top:0px",
    tags$h2(
      class = 'jumbotron-heading',
      stye = 'margin-bottom:0px;margin-top:0px',
      'Interactive Page 1'
    ),
    p('Learn about the correlation between depression and COVID cases.')
  ),
  
  tabsetPanel(
    tabPanel(
      "Project Overview",
      div(
        style = "text-align: left;",
        h1("Project Overview", style = "color: #3E92CC;"),
        
        h3("Welcome to Our Project: A Data-Driven Exploration"),
        p(
          "In a world grappling with the aftermath of the COVID-19 pandemic, we invite you to embark on a journey into the often-overlooked realm of mental health."
        ),
        
        h3("Why This Matters?"),
        p(
          "The COVID-19 pandemic has been an unprecedented global phenomenon, affecting not only millions directly impacted by the virus but also leaving a lasting imprint on the mental well-being of millions more."
        ),
        
        h3("The Narrative Unfolded"),
        p(
          "Our project, driven by comprehensive data analysis, seeks to illuminate the intricate relationship between COVID-19 and mental health."
        ),
        
        h3("Paradoxes of the Pandemic"),
        p(
          "One intriguing aspect we explore is the paradoxical nature of the pandemic's impact. While anxiety, stress, and isolation increased for many, the crisis also became a catalyst for self-reflection, resilience, and community building. Our narrative embraces this paradox, adding depth and complexity to the story."
        ),
        
        h3("Data Sources"),
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
        
        h3("Inspiration and Background Research"),
        HTML("<ul>
              <li><a href='https://covid19.nih.gov/covid-19-topics/mental-health#:~:text=If%20you%20get%20COVID%2D19,Psychosis' target='_blank'>NIH - Mental Health and COVID-19</a>: The NIH's ongoing research highlights the significant impact of COVID-19 on mental health, reinforcing our project's focus.</li>
              <li><a href='https://www.kff.org/mental-health/issue-brief/the-implications-of-covid-19-for-mental-health-and-substance-use/' target='_blank'>KFF - Implications of COVID-19 for Mental Health</a>: This source underscores the widespread concerns about mental health implications, including increased rates of anxiety and depression.</li>
              <li><a href='https://www.cidrap.umn.edu/large-study-reveals-clearer-links-between-covid-19-mental-health-risks' target='_blank'>CIDRAP - Clearer Links Between COVID-19 and Mental Health Risks</a>: A large-scale study linking COVID-19 with higher risks of anxiety, depression, and sleep disorders emphasizes the need for mental health awareness.</li>
              <li><a href='https://www.bc.edu/bc-web/bcnews/campus-community/faculty/anxiety-and-stress-spike-during-pandemic.html' target='_blank'>Boston College - Anxiety and Stress Spike During Pandemic</a>: This research unveils disparities in mental health challenges during the pandemic, emphasizing the need for increased access to mental health services.</li>
              <li><a href='https://mhanational.org/mental-health-and-covid-19-april-2022-data' target='_blank'>Mental Health America - April 2022 Data</a>: MHA's report on the significant increase in mental health concerns aligns with our own findings, reinforcing the urgency of the issue.</li>
              <li><a href='https://www.theguardian.com/commentisfree/2023/mar/10/pandemic-mental-health-covid-lockdown' target='_blank'>The Guardian - Nuanced Perspectives on Pandemic Mental Health</a>: This article prompts us to consider the nuanced effects of the pandemic on different groups, aligning with our commitment to explore the varied impacts.</li>
            </ul>"
        ),
        

        
        )
      )
    )
  )

  server <- function(input, output) {
  }
  
  shinyApp(ui = ui, server = server)
  