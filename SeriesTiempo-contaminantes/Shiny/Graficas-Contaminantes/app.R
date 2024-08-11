library(shiny)
library(ggplot2)
library(dplyr)
library(lubridate)
library(tidyr)
library(readr)

# Define la función para cargar y procesar datos
load_and_process_data <- function(station, year) {
  file_path <- paste0("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/datos-limpios/", station, "/", station, "-", year, "-limpiado.csv")
  
  # Intenta leer el archivo, maneja el error si el archivo no existe
  data <- tryCatch({
    read_csv(file_path, col_types = cols())
  }, error = function(e) {
    # Retorna NULL o un mensaje de error específico si el archivo no existe
    return(NULL)
  })
  
  # Verifica si data es NULL, lo que indica que el archivo no se pudo leer
  if (is.null(data)) {
    return(NULL)
  }
  
  data <- data %>%
    mutate(Datetime = dmy_hms(paste(FECHA, Horas))) %>%
    select(-FECHA, -Horas) %>%
    arrange(Datetime) %>%
    pivot_longer(cols = c(O3, NO2, CO, SO2, `PM-10`, `PM-2.5`), names_to = "Contaminante", values_to = "Concentracion") %>%
    mutate(Hora = hour(Datetime)) %>%
    group_by(Hora, Contaminante) %>%
    summarise(Promedio_Concentracion = mean(Concentracion, na.rm = TRUE), .groups = 'drop')
  
  return(data)
}

# Define la interfaz de usuario
ui <- fluidPage(
  titlePanel("Promedio de Concentración de Contaminantes por Hora en Puebla"),
  sidebarLayout(
    sidebarPanel(
      selectInput("station", "Seleccionar Estación:",
                  choices = c("NINFAS", "UTP", "AGUA SANTA", "BINE")),
      selectInput("year", "Seleccionar Año:",
                  choices = c("2020","2021","2022","2023", "2024")),
      checkboxGroupInput("contaminants", "Seleccionar Contaminantes:",
                         choices = c("O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5"), 
                         selected = c("O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5"))
    ),
    mainPanel(
      plotOutput("contaminantPlot")
    )
  )
)

# Define la función del servidor
server <- function(input, output) {
  
  station <- reactive({
    if(input$station == "AGUA SANTA"){
      return("AGUASANTA")
    }else{
      return(input$station)
    }
  })
  
  output$contaminantPlot <- renderPlot({
    data <- load_and_process_data(station(), input$year)
    
    # Verifica si data es NULL y muestra un mensaje de error en lugar de intentar graficar
    if (is.null(data)) {
      ggplot() + 
        labs(title = paste("Error: No se encontraron suficientes datos para", station(), input$year), x = NULL, y = NULL) +
        theme_void()
    } else if (length(input$contaminants) > 0) {
      filtered_data <- data %>%
        filter(Contaminante %in% input$contaminants)
      
      ggplot(filtered_data, aes(x = Hora, y = Promedio_Concentracion, color = Contaminante, group = Contaminante)) +
        geom_line(size = 1) +
        facet_wrap(~ Contaminante, scales = "free_y") +
        labs(title = paste("Promedio de concentración de contaminantes por hora en Puebla -", station(), input$year),
             x = "Hora del día",
             y = "Promedio de concentración") +
        theme_minimal()
    } else {
      ggplot() + 
        labs(title = "Selecciona al menos un contaminante", x = NULL, y = NULL) +
        theme_void()
    }
  })
}

# Ejecutar la aplicación Shiny
shinyApp(ui = ui, server = server)