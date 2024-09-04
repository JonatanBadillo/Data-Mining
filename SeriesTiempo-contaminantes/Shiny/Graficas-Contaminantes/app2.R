library(shiny)
library(leaflet)

# Definir las coordenadas del centro histórico de Puebla
centro_historico <- list(
  c(19.0438, -98.1970),  # Coordenada 1
  c(19.0438, -98.2167),  # Coordenada 2
  c(19.0329, -98.2167),  # Coordenada 3
  c(19.0329, -98.1970),  # Coordenada 4
  c(19.0438, -98.1970)   # Volver a la primera coordenada para cerrar el polígono
)

# Coordenadas de Bine
bine <- list(
  c(19.0425, -98.2030),  # Coordenada 1
  c(19.0425, -98.2100),  # Coordenada 2
  c(19.0385, -98.2100),  # Coordenada 3
  c(19.0385, -98.2030),  # Coordenada 4
  c(19.0425, -98.2030)   # Volver a la primera coordenada para cerrar el polígono
)

# Coordenadas de Ninfas
ninfas <- list(
  c(19.0460, -98.2100),  # Coordenada 1
  c(19.0460, -98.2200),  # Coordenada 2
  c(19.0400, -98.2200),  # Coordenada 3
  c(19.0400, -98.2100),  # Coordenada 4
  c(19.0460, -98.2100)   # Volver a la primera coordenada para cerrar el polígono
)

ui <- fluidPage(
  titlePanel("Mapa de la Ciudad de Puebla"),
  leafletOutput("map")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>% 
      setView(lng = -98.2063, lat = 19.0413, zoom = 12) %>%  # Coordenadas de Puebla
      addPolygons(
        lng = sapply(centro_historico, function(x) x[2]),
        lat = sapply(centro_historico, function(x) x[1]),
        color = "blue",
        weight = 2,
        fillColor = "lightblue",
        fillOpacity = 0.5,
        popup = "Centro Histórico de Puebla"
      ) %>%
      addPolygons(
        lng = sapply(bine, function(x) x[2]),
        lat = sapply(bine, function(x) x[1]),
        color = "red",
        weight = 2,
        fillColor = "pink",
        fillOpacity = 0.5,
        popup = "Área de Bine"
      ) %>%
      addPolygons(
        lng = sapply(ninfas, function(x) x[2]),
        lat = sapply(ninfas, function(x) x[1]),
        color = "green",
        weight = 2,
        fillColor = "lightgreen",
        fillOpacity = 0.5,
        popup = "Área de Ninfas"
      )
  })
}

shinyApp(ui, server)
