## app.R ##
library(shinydashboard)
library(mapsapi)
library(leaflet)
library(xml2)
library(DT)

key_txt <- Sys.getenv("geocode_key")

source("R/functions.R")

ui <- dashboardPage(
  dashboardHeader(title = "Google Geocode"),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    # Boxes need to be put in a row (or column)
    fluidRow(
      box(textInput("input_text_box", "Address", "Aston Academy, Aughton Road, Swallownest, Sheffield, South Yorkshire, S26 4SF"), width = 10),
      box(actionButton("do", "Search"), width = 2)
    ),
    fluidRow(
      box(leafletOutput("mymap"), width = 12)
    ),
    fluidRow(
      box(dataTableOutput("mytable"), width = 12)
    )
  )
)

server <- function(input, output) {
  
  observeEvent(input$do, {
    
    doc = mp_geocode(addresses = input$input_text_box, region = "gb", key = key_txt)
    
    pnt = mp_get_points(doc)
    
    output$mymap <- renderLeaflet({
      
      leaflet() %>%
        addTiles(urlTemplate = "https://mt0.google.com/vt/lyrs=m&hl=en&x={x}&y={y}&z={z}&s=Ga", attribution = 'Google', options = providerTileOptions(noWrap = TRUE), group = "Map") %>%
        addTiles(urlTemplate = "https://mts1.google.com/vt/lyrs=s&hl=en&src=app&x={x}&y={y}&z={z}&s=G", attribution = 'Google', options = providerTileOptions(noWrap = TRUE), group = "Satellite") %>%
        addMarkers(data = pnt) %>%
        addLayersControl(
          baseGroups = c("Map", "Satellite"),
          options = layersControlOptions(collapsed = FALSE)
        )
    })
    
    output$mytable = DT::renderDataTable({
      
      pnt %>%
        data.frame() %>%
        mutate(
          lng_lat = paste0(pnt$`1`[1], ",", pnt$`1`[2]),
          east_north = lnglat_to_eastnorth(lng_lat)
        ) %>%
        select(-pnt)
      
    })
     
  }
  )

}

shinyApp(ui, server)
