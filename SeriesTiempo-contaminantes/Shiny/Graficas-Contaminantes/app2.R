library(shiny)
library(leaflet)
library(dplyr)

ui <- fluidPage(
  titlePanel("Mapa de la Ciudad de Puebla"),
  leafletOutput("map"),
  tags$div(style="margin-top: 20px;",
           h4("Leyenda:"),
                    tags$p(tags$span(style="color: lightblue;", "●"), "Centro Histórico de Puebla"),
                    tags$p(tags$span(style="color: pink;", "●"), "Área de Bine"),
           tags$p(tags$span(style="color: green;", "●"), "O3"),
           tags$p(tags$span(style="color: yellow;", "●"), "NO2"),
           tags$p(tags$span(style="color: blue;", "●"), "CO"),
           tags$p(tags$span(style="color: purple;", "●"), "SO2"),
           tags$p(tags$span(style="color: orange;", "●"), "PM-10"),
           tags$p(tags$span(style="color: red;", "●"), "PM-2.5")
  )
)

server <- function(input, output, session) {
  
  # Cargar los datos desde la ruta especificada
  datos_bine <- read.csv("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/datos-limpios/BINE/BINE_2021-2024_combinado.csv")
  
  # Calcular los promedios de contaminantes
  promedios_contaminantes <- datos_bine %>% 
    summarise(
      O3 = mean(O3, na.rm = TRUE),
      NO2 = mean(NO2, na.rm = TRUE),
      CO = mean(CO, na.rm = TRUE),
      SO2 = mean(SO2, na.rm = TRUE),
      PM10 = mean(PM.10, na.rm = TRUE),
      PM25 = mean(PM.2.5, na.rm = TRUE)
    )
  
  # Coordenadas del centro del área de Bine
  bine_center <- c(lng = -98.2070, lat = 19.0400)
  
  # Función para generar puntos aleatorios dentro de la zona del Bine
  generate_random_points <- function(center, n, radius = 0.001) {
    tibble(
      lng = rnorm(n, mean = center['lng'], sd = radius),
      lat = rnorm(n, mean = center['lat'], sd = radius)
    )
  }
  
  # Generar puntos proporcionales al valor de cada contaminante
  puntos_O3 <- generate_random_points(bine_center, round(promedios_contaminantes$O3 * 100))
  puntos_NO2 <- generate_random_points(bine_center, round(promedios_contaminantes$NO2 * 100))
  puntos_CO <- generate_random_points(bine_center, round(promedios_contaminantes$CO * 100))
  puntos_SO2 <- generate_random_points(bine_center, round(promedios_contaminantes$SO2 * 100))
  puntos_PM10 <- generate_random_points(bine_center, round(promedios_contaminantes$PM10 * 2))  # Se ajusta para visibilidad
  puntos_PM25 <- generate_random_points(bine_center, round(promedios_contaminantes$PM25 * 2))  # Se ajusta para visibilidad
  
  # Renderizar el mapa
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
        fillOpacity = 0.9,
        popup = "Centro Histórico de Puebla"
      ) %>%
      addCircles(
        lng = -98.2070, lat = 19.0400,  # Área de Bine
        radius = 300,                    # Radio en metros
        color = "red",
        weight = 2,
        fillColor = "pink",
        fillOpacity = 0.95,
        popup = paste("Área de Bine<br>",
                      "O3:", round(8.47, 2), "ppm<br>",
                      "NO2:", round(4.75, 2), "ppm<br>",
                      "CO:", round(5.71, 2), "ppm<br>",
                      "SO2:", round(1.20, 2), "ppm<br>",
                      "PM-10:", round(45.15, 2), "µg/m³<br>",
                      "PM-2.5:", round(45.86, 2), "µg/m³")
      )  %>%
      addCircleMarkers(
        lng = puntos_O3$lng, lat = puntos_O3$lat,
        color = "green",
        radius = 3,
        fillOpacity = 0.5,
        popup = "O3"
      ) %>%
      addCircleMarkers(
        lng = puntos_NO2$lng, lat = puntos_NO2$lat,
        color = "yellow",
        radius = 3,
        fillOpacity = 0.05,
        popup = "NO2"
      ) %>%
      addCircleMarkers(
        lng = puntos_CO$lng, lat = puntos_CO$lat,
        color = "blue",
        radius = 3,
        fillOpacity = 0.05,
        popup = "CO"
      ) %>%
      addCircleMarkers(
        lng = puntos_SO2$lng, lat = puntos_SO2$lat,
        color = "purple",
        radius = 3,
        fillOpacity = 0.05,
        popup = "SO2"
      ) %>%
      addCircleMarkers(
        lng = puntos_PM10$lng, lat = puntos_PM10$lat,
        color = "orange",
        radius = 3,
        fillOpacity = 0.5,
        popup = "PM-10"
      ) %>%
      addCircleMarkers(
        lng = puntos_PM25$lng, lat = puntos_PM25$lat,
        color = "red",
        radius = 3,
        fillOpacity = 0.05,
        popup = "PM-2.5"
      )
  })
}

shinyApp(ui, server)
