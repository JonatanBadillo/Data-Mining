library(shiny)
library(ggplot2)
library(dplyr)
library(readr)
library(lubridate)
library(tidyr)

# Interfaz de usuario
ui <- fluidPage(
  titlePanel("Análisis de Contaminantes por Estación"),
  sidebarLayout(
    sidebarPanel(
      selectInput("estacion", "Seleccione la Estación:", choices = c("NINFAS", "UTP", "AGUA SANTA")),
      numericInput("anio", "Seleccione el Año:", value = 2023, min = 2020, max = 2024),
      selectInput("contaminante", "Seleccione el Contaminante:", choices = c("Todos", "O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")),
      actionButton("btn", "Actualizar")
    ),
    mainPanel(
      plotOutput("plotContaminantes")
    )
  )
)

server <- function(input, output) {
  datos_filtrados <- eventReactive(input$btn, {
    # Aquí deberías cargar tus datos en función de la estación y el año seleccionados por el usuario
    # Por simplicidad, se asume que todos los datos están en un solo archivo y se filtran en consecuencia
    ruta <- paste0("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/", input$estacion, "/", input$estacion, "-", input$anio, "-limpiado.csv")
    data <- read_csv(ruta)
    data <- data %>%
      mutate(Datetime = dmy_hms(paste(FECHA, Horas))) %>%
      select(-FECHA, -Horas) %>%
      arrange(Datetime) %>%
      pivot_longer(cols = c(O3, NO2, CO, SO2, `PM-10`, `PM-2.5`), 
                   names_to = "Contaminante", 
                   values_to = "Concentracion") %>%
      mutate(Hora = hour(Datetime))
    
    if (input$contaminante != "Todos") {
      data <- data %>% filter(Contaminante == input$contaminante)
    }
    
    data
  })
  
  output$plotContaminantes <- renderPlot({
    data <- datos_filtrados()
    promedio_hora <- data %>%
      group_by(Hora, Contaminante) %>%
      summarise(Promedio_Concentracion = mean(Concentracion, na.rm = TRUE))
    
    ggplot(promedio_hora, aes(x = Hora, y = Promedio_Concentracion, color = Contaminante, group = Contaminante)) +
      geom_line(size = 1) +
      facet_wrap(~ Contaminante, scales = "free_y") +
      labs(title = paste("Promedio de concentración de contaminantes por hora en", input$estacion, input$anio),
           x = "Hora del día",
           y = "Promedio de concentración") +
      theme_minimal()
  })
}

# Ejecutar la aplicación
shinyApp(ui = ui, server = server)