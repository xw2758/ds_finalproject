library(shiny)
library(readxl)
library(tidyverse)
library(plotly)
library(rgdal)
library(maps)
library(devtools)
library(leaflet)
library(maptools)
library(BAMMtools)
library(patchwork)

load(file = "tidy_data.Rdata")

licence_count <- tidy_data %>% 
    mutate(zipcode = as.character(owner_zip)) %>% 
    group_by(valid_year,zipcode) %>%
    summarize(n_licence = n()) %>% 
    filter(valid_year != "NA")

dat = readOGR(dsn = "zipcode_data/cb_2013_us_zcta510_500k/cb_2013_us_zcta510_500k.shp") 
dat = dat[dat$ZCTA5CE10 %in% unique(licence_count$zipcode),]

ui <- fluidPage(

    # Application title
    titlePanel("Map of licenses by zipcode"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("years", "Year of Observation",
                        min = 2003, max = 2020, step=1, value = 2003
            )
        ),

        # Show a plot of the generated distribution
        mainPanel(
            leafletOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderLeaflet({
        
        licence_count = 
            licence_count  %>%
            filter(valid_year==input[["years"]])
        
        dat@data <- left_join(dat@data,licence_count, by = c('ZCTA5CE10' = 'zipcode'))
        dat$n_licence[is.na(dat$n_licence)] <- 0
        
        # spatial transform
        zip_map_crs <- spTransform(dat, CRS("+init=epsg:4326"))
        
        getJenksBreaks(licence_count$n_licence, 6)
        
        # set bins
        licence_bins <- c(1, 14, 35, 64, 106, 184)
        
        # set pals
        licence_pal <- colorBin('Greens', bins = licence_bins, na.color = '#aaff56')
        
        label_popup <- paste0(
            "<strong>Zip code: </strong>",
            dat$ZCTA5CE10,
            "<br><strong>Number of licence: </strong>",
            dat$n_licence
        )
        
        leaflet::leaflet(data = zip_map_crs) %>% 
            addProviderTiles('CartoDB.Positron') %>% 
            addPolygons(fillColor = ~licence_pal(n_licence),
                        fillOpacity = 0.8,
                        color = "#BDBDC3",
                        weight = 1,
                        popup = label_popup,
                        highlightOptions = highlightOptions(color = "black", weight = 2,
                                                            bringToFront = TRUE)) %>% 
            addLegend('bottomleft',
                      pal = licence_pal,
                      values = ~n_licence,
                      title = 'Number of licence by zip code',
                      opacity = 1)
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
