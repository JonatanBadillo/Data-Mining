library(shiny)
library(ggplot2)
library(dplyr)
library(lubridate)
library(tidyr)
library(readr)

# Define la función para cargar y procesar datos
load_and_process_data <- function(station, year, type) {
  # Reemplaza "AGUA SANTA" por "AGUASANTA" antes de construir la ruta del archivo
  station <- gsub("AGUA SANTA", "AGUASANTA", station)
  
  if (type == "year") {
    # Para el gráfico anual, leer todos los años
    years <- c("2020", "2021", "2022", "2023", "2024")
    data_list <- lapply(years, function(y) {
      file_path <- paste0("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/datos-limpios/", station, "/", station, "-", y, "-limpiado.csv")
      data <- tryCatch({
        read_csv(file_path, col_types = cols())
      }, error = function(e) {
        return(NULL)
      })
      if (!is.null(data)) {
        data <- data %>%
          mutate(Datetime = dmy_hms(paste(FECHA, Horas))) %>%
          select(-FECHA, -Horas) %>%
          arrange(Datetime) %>%
          pivot_longer(cols = c(O3, NO2, CO, SO2, `PM-10`, `PM-2.5`), names_to = "Contaminante", values_to = "Concentracion") %>%
          mutate(Year = year(Datetime)) %>%
          select(-Datetime)
        return(data)
      } else {
        return(NULL)
      }
    })
    data <- bind_rows(data_list) %>%
      group_by(Year, Contaminante) %>%
      summarise(Promedio_Concentracion = mean(Concentracion, na.rm = TRUE), .groups = 'drop')
  } else {
    # Para los gráficos por hora y por mes, leer un solo año
    file_path <- paste0("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/datos-limpios/", station, "/", station, "-", year, "-limpiado.csv")
    data <- tryCatch({
      read_csv(file_path, col_types = cols())
    }, error = function(e) {
      return(NULL)
    })
    
    if (is.null(data)) {
      return(NULL)
    }
    
    data <- data %>%
      mutate(Datetime = dmy_hms(paste(FECHA, Horas))) %>%
      select(-FECHA, -Horas) %>%
      arrange(Datetime) %>%
      pivot_longer(cols = c(O3, NO2, CO, SO2, `PM-10`, `PM-2.5`), names_to = "Contaminante", values_to = "Concentracion")
    
    if (type == "hour") {
      data <- data %>%
        mutate(Hora = hour(Datetime)) %>%
        group_by(Hora, Contaminante) %>%
        summarise(Promedio_Concentracion = mean(Concentracion, na.rm = TRUE), .groups = 'drop')
    } else if (type == "month") {
      data <- data %>%
        mutate(Mes = month(Datetime, label = TRUE, abbr = TRUE)) %>%
        group_by(Mes, Contaminante) %>%
        summarise(Promedio_Concentracion = mean(Concentracion, na.rm = TRUE), .groups = 'drop')
    }
  }
  
  return(data)
}

# Define la interfaz de usuario
ui <- fluidPage(
  titlePanel("Promedio de Concentración de Contaminantes en Puebla"),
  sidebarLayout(
    sidebarPanel(
      selectInput("graphType", "Seleccionar Tipo de Gráfico:",
                  choices = c("Por Hora" = "hour", "Por Año" = "year", "Por Mes" = "month")),
      
      uiOutput("station_ui"),
      uiOutput("time_ui"),
      uiOutput("contaminants_ui")
    ),
    mainPanel(
      plotOutput("contaminantPlot")
    )
  )
)

# Define la función del servidor
server <- function(input, output, session) {
  
  # Reacciona a los cambios en el tipo de gráfico
  observe({
    if (input$graphType == "year") {
      output$station_ui <- renderUI({
        selectInput("station", "Seleccionar Estación:",
                    choices = c("NINFAS", "UTP", "AGUA SANTA", "BINE"))
      })
      output$time_ui <- renderUI({
        NULL  # Elimina la selección de año para gráficos por año
      })
      output$contaminants_ui <- renderUI({
        selectInput("contaminants", "Seleccionar Contaminantes:",
                    choices = c("Todos" = "ALL", "O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5"))
      })
    } else {
      output$station_ui <- renderUI({
        selectInput("station", "Seleccionar Estación:",
                    choices = c("NINFAS", "UTP", "AGUA SANTA", "BINE"))
      })
      output$time_ui <- renderUI({
        selectInput("year", "Seleccionar Año:",
                    choices = c("2020", "2021", "2022", "2023", "2024"))
      })
      output$contaminants_ui <- renderUI({
        selectInput("contaminants", "Seleccionar Contaminantes:",
                    choices = c("Todos" = "ALL", "O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5"))
      })
    }
  })
  
  # Reacciona a los cambios en el tipo de gráfico y en los filtros para cargar datos
  output$contaminantPlot <- renderPlot({
    data <- load_and_process_data(input$station, input$year, input$graphType)
    
    # Depuración: Imprimir los primeros registros del dataset
    print(head(data))
    
    if (input$graphType == "hour") {
      if (is.null(data)) {
        ggplot() + 
          labs(title = paste("Error: No se encontraron suficientes datos para", input$station, input$year), x = NULL, y = NULL) +
          theme_void()
      } else {
        if ("ALL" %in% input$contaminants) {
          filtered_data <- data
        } else {
          filtered_data <- data %>%
            filter(Contaminante %in% input$contaminants)
        }
        
        ggplot(filtered_data, aes(x = Hora, y = Promedio_Concentracion, color = Contaminante, group = Contaminante)) +
          geom_line(size = 1) +
          facet_wrap(~ Contaminante, scales = "free_y") +
          labs(title = paste("Promedio de concentración de contaminantes por hora en Puebla -", input$station, input$year),
               x = "Hora del día",
               y = "Promedio de concentración") +
          theme_minimal()
      }
    } else if (input$graphType == "month") {
      if (is.null(data)) {
        ggplot() + 
          labs(title = paste("Error: No se encontraron suficientes datos para", input$station, input$year), x = NULL, y = NULL) +
          theme_void()
      } else {
        if ("ALL" %in% input$contaminants) {
          filtered_data <- data
        } else {
          filtered_data <- data %>%
            filter(Contaminante %in% input$contaminants)
        }
        
        ggplot(filtered_data, aes(x = Mes, y = Promedio_Concentracion, color = Contaminante, group = Contaminante)) +
          geom_line(size = 1) +
          facet_wrap(~ Contaminante, scales = "free_y") +
          labs(title = paste("Promedio de concentración de contaminantes por mes en Puebla -", input$station, input$year),
               x = "Mes del año",
               y = "Promedio de concentración") +
          theme_minimal()
      }
    } else if (input$graphType == "year") {
      if (is.null(data)) {
        ggplot() + 
          labs(title = paste("Error: No se encontraron suficientes datos para", input$station), x = NULL, y = NULL) +
          theme_void()
      } else {
        if ("ALL" %in% input$contaminants) {
          filtered_data <- data
        } else {
          filtered_data <- data %>%
            filter(Contaminante %in% input$contaminants)
        }
        
        ggplot(filtered_data, aes(x = Year, y = Promedio_Concentracion, color = Contaminante, group = Contaminante)) +
          geom_line(size = 1) +
          facet_wrap(~ Contaminante, scales = "free_y") +
          labs(title = paste("Promedio de concentración de contaminantes por año en Puebla -", input$station),
               x = "Año",
               y = "Promedio de concentración") +
          theme_minimal()
      }
    }
  })
}

# Ejecutar la aplicación Shiny
shinyApp(ui = ui, server = server)
