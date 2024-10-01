library(shiny)
library(dplyr)
library(plotly)
library(reshape2)
library(ggplot2)

ui <- fluidPage(
  titlePanel("Visualización de Contaminantes en Área de Ninfas"),
  sidebarLayout(
    sidebarPanel(
      radioButtons("plotType", "Selecciona el tipo de gráfico:",
                   choices = c("Diagrama de dispersión", "Mapa de calor"),
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
      promedios_melted$Contaminante <- factor(promedios_melted$Contaminante, levels = promedios_melted$Contaminante)
      p <- ggplot(promedios_melted, aes(x = Contaminante, y = "Concentración", fill = Concentración)) +
        geom_tile(color = "white") +
        scale_fill_gradient(low = "yellow", high = "red") +
        theme_minimal() +
        labs(title = "Mapa de Calor de Contaminantes", x = "Contaminante", y = "")
      
      ggplotly(p)
    }
  })
}

shinyApp(ui, server)
