# Series de Tiempo

# Cargamos Datos de -------NINFAS-2023---------------
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

# Extraer la hora del datetime
data_long <- data_long %>%
  mutate(Hora = hour(Datetime))

# Calcular el promedio por hora
promedio_hora <- data_long %>%
  group_by(Hora, Contaminante) %>%
  summarise(Promedio_Concentracion = mean(Concentracion, na.rm = TRUE))

# Asignar el gráfico a una variable
NINFAS2023_hora_contaminantes <- ggplot(promedio_hora, aes(x = Hora, y = Promedio_Concentracion, color = Contaminante, group = Contaminante)) +
  geom_line(size = 1) +
  facet_wrap(~ Contaminante, scales = "free_y") +
  labs(title = "Promedio de concentración de contaminantes por hora en Puebla NINFAS 2023",
       x = "Hora del día",
       y = "Promedio de concentración") +
  theme_minimal()

# Crear la carpeta 'imagenes' si no existe
if (!dir.exists("imagenes")) {
  dir.create("imagenes")
}

# Guardar el gráfico en la carpeta 'imagenes'
ggsave("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/NINFAS2023/Todos-Contaminantes/NINFAS2023_hora_contaminantes.jpg", NINFAS2023_hora_contaminantes, width = 10, height = 6, dpi = 300)














