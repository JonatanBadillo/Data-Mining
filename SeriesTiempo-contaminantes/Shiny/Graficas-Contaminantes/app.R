library(shiny)
library(readr)
library(dplyr)
library(ggplot2)
library(lubridate)

# UI
ui <- fluidPage(
  titlePanel("Análisis de Contaminantes por Estación - Estático"),
  sidebarLayout(
    sidebarPanel(
      selectInput("estacion", "Seleccione la Estación:", choices = c("NINFAS", "UTP", "AGUA SANTA")),
      numericInput("anio", "Seleccione el Año:", value = 2023, min = 2020, max = 2024)
    ),
    mainPanel(
      plotOutput("graficoO3"),
      plotOutput("graficoNO2"),
      plotOutput("graficoCO"),
      plotOutput("graficoSO2"),
      plotOutput("graficoPM10"),
      plotOutput("graficoPM25")
    )
  )
)

# Server
server <- function(input, output) {
  estacionModificada <- reactive({
    if(input$estacion == "AGUA SANTA") {
      return("AGUASANTA")
    } else {
      return(input$estacion)
    }
  })
  
  datos <- reactive({
    ruta <- paste0("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/datos-limpios/", estacionModificada(), "/", estacionModificada(), "-", input$anio, "-limpiado.csv")
    data <- read_csv(ruta, col_types = cols(
      `PM-10` = col_double(),
      `PM-2.5` = col_double()
    ))
    data <- data %>%
      mutate(FechaHora = dmy_hms(paste(FECHA, Horas))) %>%
      select(-FECHA, -Horas) %>%
      arrange(FechaHora)
    data
  })
  
  generar_grafico <- function(contaminante) {
    data <- datos()
    data %>%
      ggplot(aes(x = FechaHora, y = !!sym(contaminante))) +
      geom_line() +
      labs(title = paste("Concentración de", contaminante, "en", estacionModificada(), input$anio),
           x = "Fecha y Hora",
           y = "Concentración") +
      theme_minimal()
  }
  
  output$graficoO3 <- renderPlot({ generar_grafico("O3") })
  output$graficoNO2 <- renderPlot({ generar_grafico("NO2") })
  output$graficoCO <- renderPlot({ generar_grafico("CO") })
  output$graficoSO2 <- renderPlot({ generar_grafico("SO2") })
  output$graficoPM10 <- renderPlot({ generar_grafico("PM-10") })
  output$graficoPM25 <- renderPlot({ generar_grafico("PM-2.5") })
}

# Run the application 
shinyApp(ui = ui, server = server)