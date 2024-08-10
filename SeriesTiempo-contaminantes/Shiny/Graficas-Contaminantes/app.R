library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)
library(readr)

# Definimos la interfaz de usuario (UI)
ui <- fluidPage(
  titlePanel("Visualización de Calidad del Aire en Puebla"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("estacion", "Seleccione la estación de monitoreo:",
                  choices = c("NINFAS-2023", "UTP-2024", "AGUA-SANTA-2024", "AGUA-SANTA-2023", "BINE-2023", "VELODROMO-2023")),
      selectInput("contaminante", "Seleccione el contaminante:",
                  choices = c("O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")),
      selectInput("tipo_grafico", "Seleccione el tipo de gráfico:",
                  choices = c("Todos los Contaminantes", "Por Contaminante"))
    ),
    
    mainPanel(
      plotOutput("grafico")
    )
  )
)

# Definimos la lógica del servidor (Server)
server <- function(input, output) {
  
  # Cargar los datos según la estación seleccionada
  datos_estacion <- reactive({
    archivo <- switch(input$estacion,
                      "NINFAS-2023" = "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/NINFAS/NINFAS-2023-limpiado.csv",
                      "UTP-2024" = "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/UTP/UTP-2024-limpiado.csv",
                      "AGUA-SANTA-2024" = "Datos/AGUA SANTA/AGUA-SANTA-2024-limpiado.csv",
                      "AGUA-SANTA-2023" = "Datos/AGUA SANTA/AGUA-SANTA-2023-limpiado.csv",
                      "BINE-2023" = "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/BINE/BINE-2023-limpiado.csv",
                      "VELODROMO-2023" = "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/VELODROMO/VELO-2023-limpiado.csv")
    data <- read_csv(archivo)
    data <- data %>%
      mutate(Datetime = dmy_hms(paste(FECHA, Horas))) %>%
      select(-FECHA, -Horas) %>%
      arrange(Datetime) %>%
      pivot_longer(cols = c(O3, NO2, CO, SO2, `PM-10`, `PM-2.5`), 
                   names_to = "Contaminante", 
                   values_to = "Concentracion") %>%
      mutate(Hora = hour(Datetime))
    
    data
  })
  
  # Generar el gráfico según la selección del usuario
  output$grafico <- renderPlot({
    data_long <- datos_estacion()
    
    if (input$tipo_grafico == "Todos los Contaminantes") {
      promedio_hora <- data_long %>%
        group_by(Hora, Contaminante) %>%
        summarise(Promedio_Concentracion = mean(Concentracion, na.rm = TRUE))
      
      ggplot(promedio_hora, aes(x = Hora, y = Promedio_Concentracion, color = Contaminante, group = Contaminante)) +
        geom_line(size = 1) +
        facet_wrap(~ Contaminante, scales = "free_y") +
        labs(title = paste("Promedio de concentración de contaminantes por hora en", input$estacion),
             x = "Hora del día",
             y = "Promedio de concentración") +
        theme_minimal()
      
    } else {
      datos_contaminante <- data_long %>%
        filter(Contaminante == input$contaminante) %>%
        group_by(Hora, Contaminante) %>%
        summarise(Promedio_Concentracion = mean(Concentracion, na.rm = TRUE))
      
      ggplot(datos_contaminante, aes(x = Hora, y = Promedio_Concentracion)) +
        geom_line(size = 1) +
        scale_x_continuous(breaks = 0:23, limits = c(0, 23)) +
        labs(title = paste("Promedio de concentración de", input$contaminante, "por hora en", input$estacion),
             x = "Hora del día",
             y = "Promedio de concentración") +
        theme_minimal()
    }
  })
}

# Ejecutamos la aplicación Shiny
shinyApp(ui = ui, server = server)
