# Series de Tiempo

# Cargamos Datos de ----------------NINFAS-2023-------------------------------------------------------------
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

# hacerlos long format (formato largo)
data_long <- data %>%
  pivot_longer(cols = c(O3, NO2, CO, SO2, `PM-10`, `PM-2.5`), 
               names_to = "Contaminante", 
               values_to = "Concentracion")

# Extraer el mes del datetime
data_long <- data_long %>%
  mutate(Mes = month(Datetime, label = TRUE, abbr = TRUE))

# Calcular el promedio por mes
promedio_mes <- data_long %>%
  group_by(Mes, Contaminante) %>%
  summarise(Promedio_Concentracion = mean(Concentracion, na.rm = TRUE))

# Asignar el gráfico a una variable
NINFAS2023_mes_contaminantes <- ggplot(promedio_mes, aes(x = Mes, y = Promedio_Concentracion, color = Contaminante, group = Contaminante)) +
  geom_line(size = 1) +
  facet_wrap(~ Contaminante, scales = "free_y") +
  labs(title = "Promedio de concentración de contaminantes por mes en Puebla NINFAS 2023",
       x = "Mes del año",
       y = "Promedio de concentración") +
  theme_minimal()

# Guardar el gráfico en la carpeta 'imagenes'
ggsave("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/mes/NINFAS2023/Todos-Contaminantes/NINFAS2023_mes_contaminantes.jpg", NINFAS2023_mes_contaminantes, width = 10, height = 6, dpi = 300)
