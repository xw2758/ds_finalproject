library(shiny)
library(tidyverse)
library(plotly)

load("tidy_data.Rdata")

breed = tidy_data %>% distinct(breed) %>% pull()

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("License counts Over Time"),

    sidebarLayout(
        sidebarPanel(
            checkboxGroupInput("breed_choice", label = h3("Select breed"),
                               choices = breed, selected = "MIXED")
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotlyOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlotly({ 
        
        plot_data = 
            tidy_data %>%
            filter(
                breed == input[["breed_choice"]]
            ) 
        
        plot_data %>% 
            group_by(breed) %>% 
            count(valid_year) %>% 
            plot_ly(x = ~valid_year, y = ~n, color = ~breed, type = "scatter", mode = "lines+markers") %>% 
            layout(title = "License counts Over Time")
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
