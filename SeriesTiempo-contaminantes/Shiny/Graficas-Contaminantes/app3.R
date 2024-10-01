library(shiny)
library(dplyr)
library(plotly)
library(reshape2)
library(ggplot2)
library(tidyr) # Para usar replace_na

ui <- fluidPage(
  titlePanel("Visualización de Contaminantes en Área de Ninfas"),
  sidebarLayout(
    sidebarPanel(
      radioButtons("plotType", "Selecciona el tipo de gráfico:",
                   choices = c("Diagrama de dispersión", "Mapa de calor", "Gráfico de líneas"),
                   selected = "Diagrama de dispersión")
    ),
    mainPanel(
      plotlyOutput("contaminantesPlot")
    )
  )
)

server <- function(input, output) {
  
  # Cargar los datos desde la ruta especificada
  datos_ninfas <- read.csv("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/datos-limpios/NINFAS/NINFAS_2020-2024_combinado.csv")
  
  # Convertir la columna de FECHA al formato Date ("dd/mm/yyyy")
  if ("FECHA" %in% colnames(datos_ninfas)) {
    datos_ninfas$FECHA <- as.Date(datos_ninfas$FECHA, format = "%d/%m/%Y")
  } else {
    stop("La columna 'FECHA' no existe en el conjunto de datos.")
  }
  
  # Reemplazar valores no finitos (NA, NaN, Inf) por ceros
  datos_ninfas <- datos_ninfas %>% mutate(across(where(is.numeric), ~ tidyr::replace_na(., 0)))
  
  # Calcular los promedios de contaminantes
  promedios_contaminantes <- datos_ninfas %>% 
    summarise(
      O3 = mean(O3, na.rm = TRUE),
      NO2 = mean(NO2, na.rm = TRUE),
      CO = mean(CO, na.rm = TRUE),
      SO2 = mean(SO2, na.rm = TRUE),
      PM10 = mean(PM.10, na.rm = TRUE),
      PM25 = mean(PM.2.5, na.rm = TRUE)
    )
  
  # Preparar los datos para diferentes gráficos
  promedios_melted <- melt(promedios_contaminantes, variable.name = "Contaminante", value.name = "Concentración")
  
  # Renderizar el gráfico según la selección
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
      datos_ninfas_filtrado <- datos_ninfas %>% filter(across(where(is.numeric), is.finite))
      
      # Gráfico de líneas
      p <- ggplot(datos_ninfas_filtrado, aes(x = FECHA)) +
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
}

shinyApp(ui, server)
