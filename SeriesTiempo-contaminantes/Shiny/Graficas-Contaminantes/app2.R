library(shiny)
library(leaflet)

ui <- fluidPage(
  titlePanel("Mapa de la Ciudad de Puebla"),
  leafletOutput("map"),
  tags$div(style="margin-top: 20px;",
           h4("Leyenda:"),
           tags$p(tags$span(style="color: lightblue;", "●"), "Centro Histórico de Puebla"),
           tags$p(tags$span(style="color: pink;", "●"), "Área de Bine"),
           tags$p(tags$span(style="color: lightgreen;", "●"), "Área de Ninfas")
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
        lng = -98.2070, lat = 19.0400,  # Área de Bine
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
