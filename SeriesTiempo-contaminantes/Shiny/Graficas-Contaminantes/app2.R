library(shiny)
library(dplyr)
library(plotly)
library(reshape2)
library(ggplot2)
library(tidyr) # Para usar replace_na
library(leaflet) # Para el mapa
library(leaflet.extras) # Para usar addHeatmap

ui <- fluidPage(
  titlePanel("Visualización de Contaminantes en Área de Bine"),
  sidebarLayout(
    sidebarPanel(
      radioButtons("plotType", "Selecciona el tipo de visualización:",
                   choices = c("Diagrama de dispersión", "Mapa de calor", "Gráfico de líneas", "Mapa"),
                   selected = "Diagrama de dispersión")
    ),
    mainPanel(
      conditionalPanel(
        condition = "input.plotType != 'Mapa'",
        plotlyOutput("contaminantesPlot")
      ),
      conditionalPanel(
        condition = "input.plotType == 'Mapa'",
        leafletOutput("map"),
        tags$div(
          style = "margin-top: 20px;",
          h4("Leyenda:"),
          tags$div(
            style = "display: flex; justify-content: space-between;",
            tags$div(
              style = "flex: 1;",
              tags$p(tags$span(style = "color: lightblue;", "■"), "Centro Histórico de Puebla"),
              tags$p(tags$span(style = "color: lightgreen;", "■"), "Área de Bine")
            ),
            tags$div(
              style = "flex: 1;",
              tags$p(tags$span(style = "color: green;", "●"), "O3"),
              tags$p(tags$span(style = "color: yellow;", "●"), "NO2"),
              tags$p(tags$span(style = "color: blue;", "●"), "CO")
            ),
            tags$div(
              style = "flex: 1;",
              tags$p(tags$span(style = "color: purple;", "●"), "SO2"),
              tags$p(tags$span(style = "color: orange;", "●"), "PM-10"),
              tags$p(tags$span(style = "color: red;", "●"), "PM-2.5")
            )
          )
        )
      )
    )
  )
)

server <- function(input, output, session) {
  
  # Cargar los datos desde la ruta especificada
  datos_bine <- read.csv("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/datos-limpios/BINE/BINE_2021-2024_combinado.csv")
  
  # Convertir la columna de FECHA al formato Date ("dd/mm/yyyy")
  if ("FECHA" %in% colnames(datos_bine)) {
    datos_bine$FECHA <- as.Date(datos_bine$FECHA, format = "%d/%m/%Y")
  } else {
    stop("La columna 'FECHA' no existe en el conjunto de datos.")
  }
  
  # Reemplazar valores no finitos (NA, NaN, Inf) por ceros
  datos_bine <- datos_bine %>% mutate(across(where(is.numeric), ~ tidyr::replace_na(., 0)))
  
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
  
  # Preparar los datos para diferentes gráficos
  promedios_melted <- melt(promedios_contaminantes, id.vars = NULL, measure.vars = c("O3", "NO2", "CO", "SO2", "PM10", "PM25"),
                           variable.name = "Contaminante", value.name = "Concentración")
  
  # Renderizar los gráficos según la selección
  output$contaminantesPlot <- renderPlotly({
    if (input$plotType == "Diagrama de dispersión") {
      # Diagrama de dispersión
      p <- ggplot(promedios_melted, aes(x = Contaminante, y = Concentración, color = Contaminante)) +
        geom_point(size = 5) +
        theme_minimal() +
        labs(title = "Promedio de Contaminantes (Diagrama de Dispersión)", y = "Concentración", x = "Contaminante")
      
      ggplotly(p)
      
    } else if (input$plotType == "Mapa de calor") {
      # Mapa de calor
      p <- ggplot(promedios_melted, aes(x = Contaminante, y = "Concentración", fill = Concentración)) +
        geom_tile(color = "white") +
        scale_fill_gradient(low = "yellow", high = "red") +
        theme_minimal() +
        labs(title = "Mapa de Calor de Contaminantes", x = "Contaminante", y = "")
      
      ggplotly(p)
      
    } else if (input$plotType == "Gráfico de líneas") {
      # Filtrar datos no finitos
      datos_bine_filtrado <- datos_bine %>% filter(across(where(is.numeric), is.finite))
      
      # Gráfico de líneas
      p <- ggplot(datos_bine_filtrado, aes(x = FECHA)) +
        geom_line(aes(y = O3, color = "O3")) +
        geom_line(aes(y = NO2, color = "NO2")) +
        geom_line(aes(y = CO, color = "CO")) +
        geom_line(aes(y = SO2, color = "SO2")) +
        geom_line(aes(y = PM.10, color = "PM10")) +
        geom_line(aes(y = PM.2.5, color = "PM25")) +
        theme_minimal() +
        labs(title = "Evolución de Contaminantes a lo Largo del Tiempo", y = "Concentración", x = "FECHA")
      
      ggplotly(p)
    }
  })
  
  # Renderizar el mapa
  output$map <- renderLeaflet({
    # Coordenadas del área de Bine y del Centro Histórico
    bine_center <- c(lng = -98.2070, lat = 19.0400)
    centro_historico <- c(lng = -98.2063, lat = 19.0413)
    
    # Función para generar puntos aleatorios dentro de la zona de Bine
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
    puntos_PM10 <- generate_random_points(bine_center, round(promedios_contaminantes$PM10 * 2))  # Ajuste para visibilidad
    puntos_PM25 <- generate_random_points(bine_center, round(promedios_contaminantes$PM25 * 2))  # Ajuste para visibilidad
    
    # Combinar todos los puntos en un solo conjunto de datos para el mapa de calor
    puntos_todos <- bind_rows(puntos_O3, puntos_NO2, puntos_CO, puntos_SO2, puntos_PM10, puntos_PM25)
    
    # Crear el mapa
    leaflet() %>%
      addTiles() %>%
      setView(lng = bine_center['lng'], lat = bine_center['lat'], zoom = 17) %>%
      # Añadir el mapa de calor primero
      addHeatmap(lng = ~lng, lat = ~lat, intensity = 0.5, blur = 20, max = 0.05, radius = 15, data = puntos_todos) %>%
      # Añadir el círculo del Centro Histórico
      addCircles(
        lng = centro_historico['lng'], lat = centro_historico['lat'],
        radius = 500,  # Radio en metros
        color = "blue",
        weight = 2,
        fillColor = "lightblue",
        fillOpacity = 0.4,  # Ajustar la opacidad
        popup = "Centro Histórico de Puebla"
      ) %>%
      # Añadir el círculo del área de Bine
      addCircles(
        lng = bine_center['lng'], lat = bine_center['lat'],  # Área de Bine
        radius = 300,                    # Radio en metros
        color = "green",
        weight = 2,
        fillColor = "lightgreen",
        fillOpacity = 0.4,  # Ajustar la opacidad
        popup = paste("Área de Bine<br>",
                      "O3:", round(promedios_contaminantes$O3, 2), "ppm<br>",
                      "NO2:", round(promedios_contaminantes$NO2, 2), "ppm<br>",
                      "CO:", round(promedios_contaminantes$CO, 2), "ppm<br>",
                      "SO2:", round(promedios_contaminantes$SO2, 2), "ppm<br>",
                      "PM-10:", round(promedios_contaminantes$PM10, 2), "µg/m³<br>",
                      "PM-2.5:", round(promedios_contaminantes$PM25, 2), "µg/m³")
      )
  })
}

shinyApp(ui, server)
