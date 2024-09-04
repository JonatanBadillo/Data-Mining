library(shiny)
library(leaflet)

ui <- fluidPage(
  titlePanel("Mapa de la Ciudad de Puebla"),
  leafletOutput("map"),
  br(),
  div(style = "text-align: center;",
      tags$b("Leyenda:"),
      tags$ul(
        tags$li(tags$span(style = "color: blue;", "●"), " Centro Histórico de Puebla"),
        tags$li(tags$span(style = "color: red;", "●"), " Área de Bine"),
        tags$li(tags$span(style = "color: green;", "●"), " Área de Ninfas")
      )
  )
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>% 
      setView(lng = -98.2063, lat = 19.0413, zoom = 12) %>%  # Coordenadas de Puebla
      addCircles(
        lng = -98.2063, lat = 19.0413,  # Centro Histórico
        radius = 500,                    # Radio en metros
        color = "blue",
        weight = 2,
        fillColor = "lightblue",
        fillOpacity = 0.5,
        popup = "Centro Histórico de Puebla"
      ) %>%
      addCircles(
        lng = -98.2063, lat = 19.0385,  # Área de Bine
        radius = 300,                    # Radio en metros
        color = "red",
        weight = 2,
        fillColor = "pink",
        fillOpacity = 0.5,
        popup = "Área de Bine"
      ) %>%
      addCircles(
        lng = -98.2100, lat = 19.0450,  # Área de Ninfas
        radius = 300,                    # Radio en metros
        color = "green",
        weight = 2,
        fillColor = "lightgreen",
        fillOpacity = 0.5,
        popup = "Área de Ninfas"
      )
  })
}

shinyApp(ui, server)
