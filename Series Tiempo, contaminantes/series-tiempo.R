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





# Extraer la hora del datetime
data_long <- data_long %>%
  mutate(Hora = hour(Datetime))

# Calcular el promedio por hora
promedio_hora <- data_long %>%
  group_by(Hora, Contaminante) %>%
  summarise(Promedio_Concentracion = mean(Concentracion, na.rm = TRUE))

# Crear el gráfico de barras
ggplot(promedio_hora, aes(x = Hora, y = Promedio_Concentracion, fill = Contaminante)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Promedio de concentración de contaminantes por hora en Puebla",
       x = "Hora del día",
       y = "Promedio de concentración") +
  theme_minimal()



# Cambiar a gráfico de líneas para una visualización más clara
ggplot(promedio_hora, aes(x = Hora, y = Promedio_Concentracion, color = Contaminante, group = Contaminante)) +
  geom_line(size = 1) +
  facet_wrap(~ Contaminante, scales = "free_y") +
  labs(title = "Promedio de concentración de contaminantes por hora en Puebla",
       x = "Hora del día",
       y = "Promedio de concentración") +
  theme_minimal()


