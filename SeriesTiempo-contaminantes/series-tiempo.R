library(shiny)
library(dplyr)
library(ggplot2)
library(lubridate)
library(tidyr)
library(readr)

# UI (Interfaz de Usuario)
ui <- fluidPage(
  titlePanel("Análisis de la Calidad del Aire en Puebla"),
  sidebarLayout(
    sidebarPanel(
      selectInput("station", "Selecciona la estación de monitoreo:",
                  choices = c("NINFAS-2023", "UTP-2024", "AGUA-SANTA-2024", "AGUA-SANTA-2023", "BINE-2023", "VELODROMO-2023")),
      selectInput("contaminante", "Selecciona el contaminante:",
                  choices = c("O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")),
      actionButton("update", "Actualizar Gráfica")
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

# Server (Lógica del Servidor)
server <- function(input, output, session) {
  
  # Función para cargar y procesar los datos en función de la estación seleccionada
  load_data <- function(station) {
    data_path <- switch(station,
                        "NINFAS-2023" = "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/NINFAS/NINFAS-2023-limpiado.csv",
                        "UTP-2024" = "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/UTP/UTP-2024-limpiado.csv",
                        "AGUA-SANTA-2024" = "Datos/AGUA SANTA/AGUA-SANTA-2024-limpiado.csv",
                        "AGUA-SANTA-2023" = "Datos/AGUA SANTA/AGUA-SANTA-2023-limpiado.csv",
                        "BINE-2023" = "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/BINE/BINE-2023-limpiado.csv",
                        "VELODROMO-2023" = "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/VELODROMO/VELO-2023-limpiado.csv"
    )
    
    data <- read_csv(data_path) %>%
      mutate(Datetime = dmy_hms(paste(FECHA, Horas))) %>%
      select(-FECHA, -Horas) %>%
      arrange(Datetime) %>%
      pivot_longer(cols = c(O3, NO2, CO, SO2, `PM-10`, `PM-2.5`), 
                   names_to = "Contaminante", 
                   values_to = "Concentracion") %>%
      mutate(Hora = hour(Datetime))
    
    return(data)
  }
  
  # Reactivo para cargar los datos cuando se cambia la estación
  datos <- eventReactive(input$update, {
    load_data(input$station)
  })
  
  # Generación de la gráfica
  output$plot <- renderPlot({
    data <- datos()
    promedio_hora <- data %>%
      filter(Contaminante == input$contaminante) %>%
      group_by(Hora, Contaminante) %>%
      summarise(Promedio_Concentracion = mean(Concentracion, na.rm = TRUE))
    
    ggplot(promedio_hora, aes(x = Hora, y = Promedio_Concentracion)) +
      geom_line(size = 1) +
      scale_x_continuous(breaks = 0:23, limits = c(0, 23)) +
      labs(title = paste("Promedio de concentración de", input$contaminante, "por hora en Puebla", input$station),
           x = "Hora del día",
           y = "Promedio de concentración") +
      theme_minimal()
  })
}

# Lanzar la aplicación Shiny
shinyApp(ui = ui, server = server)
