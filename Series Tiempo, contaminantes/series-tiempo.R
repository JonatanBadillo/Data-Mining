library(readr)
data <- read_csv("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/NINFAS/NINFAS-2023-limpiado.csv")
View(data)


# Cargar los paquetes necesarios
library(dplyr)
library(ggplot2)
library(lubridate)
library(tidyr)


# Convertir las columnas FECHA y Horas a un solo datetime
data <- data %>%
  mutate(Datetime = dmy_hms(paste(FECHA, Horas))) %>%
  select(-FECHA, -Horas) %>%
  arrange(Datetime)


# Derretir los datos para hacerlos long format (formato largo)
data_long <- data %>%
  pivot_longer(cols = c(O3, NO2, CO, SO2, `PM-10`, `PM-2.5`), 
               names_to = "Contaminante", 
               values_to = "Concentracion")

# Crear el gráfico de líneas
ggplot(data_long, aes(x = Datetime, y = Concentracion, color = Contaminante)) +
  geom_line() +
  facet_wrap(~ Contaminante, scales = "free_y") +
  labs(title = "Concentración de contaminantes por hora en Puebla",
       x = "Fecha y Hora",
       y = "Concentración") +
  theme_minimal() +
  theme(legend.position = "none")
