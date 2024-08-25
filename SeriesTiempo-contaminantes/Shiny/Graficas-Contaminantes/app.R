library(shiny)
library(ggplot2)
library(dplyr)
library(lubridate)
library(tidyr)
library(readr)
library(forecast)

# Define la función para cargar y procesar datos
load_and_process_data <- function(station, year, type) {
  station <- gsub("AGUA SANTA", "AGUASANTA", station)
  
  if (type == "year") {
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
          filter(!is.na(FECHA) & !is.na(Horas)) %>%  # Eliminar filas con fechas u horas faltantes
          mutate(Datetime = parse_date_time(paste(FECHA, Horas), orders = c("dmy HMS", "dmy HM", "dmy H"))) %>%  # Crear columna Datetime combinando FECHA y Horas
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
      filter(!is.na(FECHA) & !is.na(Horas)) %>%  # Eliminar filas con fechas u horas faltantes
      mutate(Datetime = parse_date_time(paste(FECHA, Horas), orders = c("dmy HMS", "dmy HM", "dmy H"))) %>%
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
      uiOutput("contaminants_ui"),
      conditionalPanel(
        condition = "input.graphType == 'hour'",
        checkboxInput("showPrediction", "Mostrar Predicción ARIMA", value = FALSE)
      )
    ),
    mainPanel(
      plotOutput("contaminantPlot")
    )
  )
)

# Define la función del servidor
server <- function(input, output, session) {
  
  observe({
    if (input$graphType == "year") {
      output$station_ui <- renderUI({
        selectInput("station", "Seleccionar Estación:",
                    choices = c("NINFAS", "UTP", "AGUA SANTA", "BINE"))
      })
      output$time_ui <- renderUI({
        NULL
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
  
  output$contaminantPlot <- renderPlot({
    data <- load_and_process_data(input$station, input$year, input$graphType)
    
    if (input$graphType == "hour") {
      if (is.null(data)) {
        ggplot() + 
          labs(title = paste("Error: No se encontraron suficientes datos para", input$station, input$year), x = NULL, y = NULL) +
          theme_void()
      } else {
        filtered_data <- if ("ALL" %in% input$contaminants) data else data %>% filter(Contaminante %in% input$contaminants)
        
        p <- ggplot(filtered_data, aes(x = Hora, y = Promedio_Concentracion, color = Contaminante, group = Contaminante)) +
          geom_line(size = 1) +
          facet_wrap(~ Contaminante, scales = "free_y") +
          labs(title = paste("Promedio de concentración de contaminantes por hora en Puebla -", input$station, input$year),
               x = "Hora del día",
               y = "Promedio de concentración") +
          theme_minimal()
        
        if (input$showPrediction) {
          predicciones <- lapply(unique(filtered_data$Contaminante), function(contaminante) {
            datos_contaminante <- filtered_data %>% filter(Contaminante == contaminante)
            ts_data <- ts(datos_contaminante$Promedio_Concentracion, frequency = 24)
            
            # Verifica si hay valores NA
            if (any(is.na(ts_data))) {
              warning(paste("No se puede aplicar ARIMA a", contaminante, "debido a valores NA"))
              return(NULL)
            }
            
            fit <- auto.arima(ts_data)
            pred <- forecast(fit, h = 24)
            pred_df <- data.frame(Hora = (max(datos_contaminante$Hora) + 1):(max(datos_contaminante$Hora) + 24),
                                  Prediccion = pred$mean,
                                  Contaminante = contaminante)
            return(pred_df)
          })
          
          predicciones <- bind_rows(predicciones)
          predicciones <- predicciones[complete.cases(predicciones), ]  # Eliminar filas con valores NA
          
          p <- p + geom_line(data = predicciones, aes(x = Hora, y = Prediccion, color = Contaminante, linetype = "Predicción"), size = 1, inherit.aes = FALSE)
        }
        
        p
      }
    } else if (input$graphType == "month") {
      if (is.null(data)) {
        ggplot() + 
          labs(title = paste("Error: No se encontraron suficientes datos para", input$station, input$year), x = NULL, y = NULL) +
          theme_void()
      } else {
        filtered_data <- if ("ALL" %in% input$contaminants) data else data %>% filter(Contaminante %in% input$contaminants)
        
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
        filtered_data <- if ("ALL" %in% input$contaminants) data else data %>% filter(Contaminante %in% input$contaminants)
        
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
