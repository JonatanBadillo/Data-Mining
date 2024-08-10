library(shiny)
library(dplyr)
library(ggplot2)
library(lubridate)
library(tidyr)
library(readr)

# Define UI
ui <- fluidPage(
  titlePanel("Promedio de Concentración de Contaminantes por Hora"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("estacion", "Selecciona la Estación:",
                  choices = c("NINFAS", "Otra_Estacion")),
      selectInput("anio", "Selecciona el Año:",
                  choices = c("2023", "2024")),
      uiOutput("contaminante_ui")
    ),
    
    mainPanel(
      plotOutput("grafico")
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  
  # Cargar datos dependiendo de la selección del usuario
  datos <- reactive({
    archivo <- paste0("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/", input$estacion, "/", input$estacion, "-", input$anio, "-limpiado.csv")
    data <- read_csv(archivo)
    
    data <- data %>%
      mutate(Datetime = dmy_hms(paste(FECHA, Horas))) %>%
      select(-FECHA, -Horas) %>%
      arrange(Datetime) %>%
      pivot_longer(cols = c(O3, NO2, CO, SO2, `PM-10`, `PM-2.5`), 
                   names_to = "Contaminante", 
                   values_to = "Concentracion") %>%
      mutate(Hora = hour(Datetime))
    
    promedio_hora <- data %>%
      group_by(Hora, Contaminante) %>%
      summarise(Promedio_Concentracion = mean(Concentracion, na.rm = TRUE))
    
    return(promedio_hora)
  })
  
  # Actualizar los contaminantes disponibles
  output$contaminante_ui <- renderUI({
    contaminantes <- unique(datos()$Contaminante)
    selectInput("contaminante", "Selecciona el Contaminante:",
                choices = c("Todos", contaminantes))
  })
  
  # Renderizar el gráfico
  output$grafico <- renderPlot({
    promedio_hora <- datos()
    
    if (input$contaminante != "Todos") {
      promedio_hora <- filter(promedio_hora, Contaminante == input$contaminante)
    }
    
    ggplot(promedio_hora, aes(x = Hora, y = Promedio_Concentracion, color = Contaminante, group = Contaminante)) +
      geom_line(size = 1) +
      facet_wrap(~ Contaminante, scales = "free_y") +
      labs(title = paste("Promedio de concentración de contaminantes por hora en", input$estacion, input$anio),
           x = "Hora del día",
           y = "Promedio de concentración") +
      theme_minimal()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
