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

# Guardar el gráfico en la carpeta 'imagenes'
ggsave("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/NINFAS2023/Todos-Contaminantes/NINFAS2023_hora_contaminantes.jpg", NINFAS2023_hora_contaminantes, width = 10, height = 6, dpi = 300)


# Iterar sobre cada contaminante para generar y guardar un gráfico
contaminantes_unicos <- unique(promedio_hora$Contaminante)

# Ruta base para guardar los gráficos
ruta_base <- "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/NINFAS2023/Cada-Contaminantes"

# Crear la carpeta si no existe
if (!dir.exists(ruta_base)) {
  dir.create(ruta_base, recursive = TRUE)
}

for(contaminante in contaminantes_unicos) {
  # Filtrar los datos para el contaminante actual
  datos_contaminante <- filter(promedio_hora, Contaminante == contaminante)
  
  # Crear el gráfico
  grafico <- ggplot(datos_contaminante, aes(x = Hora, y = Promedio_Concentracion)) +
    geom_line(size = 1) +
    scale_x_continuous(breaks = 0:23, limits = c(0, 23)) + # Asegura que se muestren todas las horas
    labs(title = paste("Promedio de concentración de", contaminante, "por hora en Puebla NINFAS 2023"),
         x = "Hora del día",
         y = "Promedio de concentración") +
    theme_minimal()
  
  # Definir el nombre del archivo basado en el contaminante
  nombre_archivo <- paste(ruta_base, "/NINFAS2023_hora_", tolower(gsub(" ", "_", contaminante)), ".jpg", sep = "")
  
  # Guardar el gráfico en la ruta especificada
  ggsave(nombre_archivo, grafico, width = 10, height = 6, dpi = 300)
}


# Cargamos Datos de ----------------UTP-2024-------------------------------------------------------------
data <- read_csv("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/UTP/UTP-2024-limpiado.csv")
View(data)


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
  labs(title = "Promedio de concentración de contaminantes por hora en Puebla UTP 2024",
       x = "Hora del día",
       y = "Promedio de concentración") +
  theme_minimal()

# Guardar el gráfico en la carpeta 'imagenes'
ggsave("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/UTP2024/Todos-Contaminantes/UTP2024_hora_contaminantes.jpg", NINFAS2023_hora_contaminantes, width = 10, height = 6, dpi = 300)


# Iterar sobre cada contaminante para generar y guardar un gráfico
contaminantes_unicos <- unique(promedio_hora$Contaminante)

# Ruta base para guardar los gráficos
ruta_base <- "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/UTP2024/Cada-Contaminantes"

# Crear la carpeta si no existe
if (!dir.exists(ruta_base)) {
  dir.create(ruta_base, recursive = TRUE)
}

for(contaminante in contaminantes_unicos) {
  # Filtrar los datos para el contaminante actual
  datos_contaminante <- filter(promedio_hora, Contaminante == contaminante)
  
  # Crear el gráfico
  grafico <- ggplot(datos_contaminante, aes(x = Hora, y = Promedio_Concentracion)) +
    geom_line(size = 1) +
    scale_x_continuous(breaks = 0:23, limits = c(0, 23)) + # Asegura que se muestren todas las horas
    labs(title = paste("Promedio de concentración de", contaminante, "por hora en Puebla UTP 2024"),
         x = "Hora del día",
         y = "Promedio de concentración") +
    theme_minimal()
  
  # Definir el nombre del archivo basado en el contaminante
  nombre_archivo <- paste(ruta_base, "/UTP2024_hora_", tolower(gsub(" ", "_", contaminante)), ".jpg", sep = "")
  
  # Guardar el gráfico en la ruta especificada
  ggsave(nombre_archivo, grafico, width = 10, height = 6, dpi = 300)
}



# Cargamos Datos de ----------------AGUASANTA -2024-------------------------------------------------------------
data <- read_csv("Datos/AGUA SANTA/AGUA-SANTA-2024-limpiado.csv")
View(data)


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
  labs(title = "Promedio de concentración de contaminantes por hora en Puebla AGUA SANTA 2024",
       x = "Hora del día",
       y = "Promedio de concentración") +
  theme_minimal()

# Guardar el gráfico en la carpeta 'imagenes'
ggsave("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/AGUA-SANTA2024/Todos-Contaminantes/UTP2024_hora_contaminantes.jpg", NINFAS2023_hora_contaminantes, width = 10, height = 6, dpi = 300)


# Iterar sobre cada contaminante para generar y guardar un gráfico
contaminantes_unicos <- unique(promedio_hora$Contaminante)

# Ruta base para guardar los gráficos
ruta_base <- "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/AGUA-SANTA2024/Cada-Contaminantes"

# Crear la carpeta si no existe
if (!dir.exists(ruta_base)) {
  dir.create(ruta_base, recursive = TRUE)
}

for(contaminante in contaminantes_unicos) {
  # Filtrar los datos para el contaminante actual
  datos_contaminante <- filter(promedio_hora, Contaminante == contaminante)
  
  # Crear el gráfico
  grafico <- ggplot(datos_contaminante, aes(x = Hora, y = Promedio_Concentracion)) +
    geom_line(size = 1) +
    scale_x_continuous(breaks = 0:23, limits = c(0, 23)) + # Asegura que se muestren todas las horas
    labs(title = paste("Promedio de concentración de", contaminante, "por hora en Puebla AGUA SANTA 2024"),
         x = "Hora del día",
         y = "Promedio de concentración") +
    theme_minimal()
  
  # Definir el nombre del archivo basado en el contaminante
  nombre_archivo <- paste(ruta_base, "/AGUA-SANTA2024_hora_", tolower(gsub(" ", "_", contaminante)), ".jpg", sep = "")
  
  # Guardar el gráfico en la ruta especificada
  ggsave(nombre_archivo, grafico, width = 10, height = 6, dpi = 300)
}



# Cargamos Datos de ----------------AGUASANTA -2023-------------------------------------------------------------
data <- read_csv("Datos/AGUA SANTA/AGUA-SANTA-2023-limpiado.csv")
View(data)


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
  labs(title = "Promedio de concentración de contaminantes por hora en Puebla AGUA SANTA 2023",
       x = "Hora del día",
       y = "Promedio de concentración") +
  theme_minimal()

# Guardar el gráfico en la carpeta 'imagenes'
ggsave("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/AGUA-SANTA2023/Todos-Contaminantes/AGUA-SANTA2023_hora_contaminantes.jpg", NINFAS2023_hora_contaminantes, width = 10, height = 6, dpi = 300)


# Iterar sobre cada contaminante para generar y guardar un gráfico
contaminantes_unicos <- unique(promedio_hora$Contaminante)

# Ruta base para guardar los gráficos
ruta_base <- "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/AGUA-SANTA2023/Cada-Contaminantes"

# Crear la carpeta si no existe
if (!dir.exists(ruta_base)) {
  dir.create(ruta_base, recursive = TRUE)
}

for(contaminante in contaminantes_unicos) {
  # Filtrar los datos para el contaminante actual
  datos_contaminante <- filter(promedio_hora, Contaminante == contaminante)
  
  # Crear el gráfico
  grafico <- ggplot(datos_contaminante, aes(x = Hora, y = Promedio_Concentracion)) +
    geom_line(size = 1) +
    scale_x_continuous(breaks = 0:23, limits = c(0, 23)) + # Asegura que se muestren todas las horas
    labs(title = paste("Promedio de concentración de", contaminante, "por hora en Puebla AGUA SANTA 2024"),
         x = "Hora del día",
         y = "Promedio de concentración") +
    theme_minimal()
  
  # Definir el nombre del archivo basado en el contaminante
  nombre_archivo <- paste(ruta_base, "/AGUA-SANTA2023_hora_", tolower(gsub(" ", "_", contaminante)), ".jpg", sep = "")
  
  # Guardar el gráfico en la ruta especificada
  ggsave(nombre_archivo, grafico, width = 10, height = 6, dpi = 300)
}




# Cargamos Datos de ----------------BINE -2023-------------------------------------------------------------
data <- read_csv("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/BINE/BINE-2023-limpiado.csv")
View(data)


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
  labs(title = "Promedio de concentración de contaminantes por hora en Puebla BINE 2023",
       x = "Hora del día",
       y = "Promedio de concentración") +
  theme_minimal()

# Guardar el gráfico en la carpeta 'imagenes'
ggsave("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/BINE2023/Todos-Contaminantes/BINE2023_hora_contaminantes.jpg", NINFAS2023_hora_contaminantes, width = 10, height = 6, dpi = 300)


# Iterar sobre cada contaminante para generar y guardar un gráfico
contaminantes_unicos <- unique(promedio_hora$Contaminante)

# Ruta base para guardar los gráficos
ruta_base <- "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/BINE2023/Cada-Contaminantes"

# Crear la carpeta si no existe
if (!dir.exists(ruta_base)) {
  dir.create(ruta_base, recursive = TRUE)
}

for(contaminante in contaminantes_unicos) {
  # Filtrar los datos para el contaminante actual
  datos_contaminante <- filter(promedio_hora, Contaminante == contaminante)
  
  # Crear el gráfico
  grafico <- ggplot(datos_contaminante, aes(x = Hora, y = Promedio_Concentracion)) +
    geom_line(size = 1) +
    scale_x_continuous(breaks = 0:23, limits = c(0, 23)) + # Asegura que se muestren todas las horas
    labs(title = paste("Promedio de concentración de", contaminante, "por hora en Puebla BINE 2023"),
         x = "Hora del día",
         y = "Promedio de concentración") +
    theme_minimal()
  
  # Definir el nombre del archivo basado en el contaminante
  nombre_archivo <- paste(ruta_base, "/BINE2023_hora_", tolower(gsub(" ", "_", contaminante)), ".jpg", sep = "")
  
  # Guardar el gráfico en la ruta especificada
  ggsave(nombre_archivo, grafico, width = 10, height = 6, dpi = 300)

}



# Cargamos Datos de ----------------VELODROMO-2023-------------------------------------------------------------
data <- read_csv("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/VELODROMO/VELO-2023-limpiado.csv")
View(data)


# Convertir las columnas FECHA y Horas a un solo datetime
data <- data %>%
  mutate(Datetime = dmy_hms(paste(FECHA, Horas))) %>%
  select(-FECHA, -Horas) %>%
  arrange(Datetime)


# hacerlos long format (formato largo)
data_long <- data %>%
  pivot_longer(cols = c(O3, NO2, CO, SO2, `PM.10`, `PM.2.5`), 
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
  labs(title = "Promedio de concentración de contaminantes por hora en Puebla VELODROMO 2023",
       x = "Hora del día",
       y = "Promedio de concentración") +
  theme_minimal()

# Guardar el gráfico en la carpeta 'imagenes'
ggsave("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/VELO2023/Todos-Contaminantes/VELO2023_hora_contaminantes.jpg", NINFAS2023_hora_contaminantes, width = 10, height = 6, dpi = 300)


# Iterar sobre cada contaminante para generar y guardar un gráfico
contaminantes_unicos <- unique(promedio_hora$Contaminante)

# Ruta base para guardar los gráficos
ruta_base <- "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/VELO2023/Cada-Contaminantes"

# Crear la carpeta si no existe
if (!dir.exists(ruta_base)) {
  dir.create(ruta_base, recursive = TRUE)
}

for(contaminante in contaminantes_unicos) {
  # Filtrar los datos para el contaminante actual
  datos_contaminante <- filter(promedio_hora, Contaminante == contaminante)
  
  # Crear el gráfico
  grafico <- ggplot(datos_contaminante, aes(x = Hora, y = Promedio_Concentracion)) +
    geom_line(size = 1) +
    scale_x_continuous(breaks = 0:23, limits = c(0, 23)) + # Asegura que se muestren todas las horas
    labs(title = paste("Promedio de concentración de", contaminante, "por hora en Puebla VELODROMO 2023"),
         x = "Hora del día",
         y = "Promedio de concentración") +
    theme_minimal()
  
  # Definir el nombre del archivo basado en el contaminante
  nombre_archivo <- paste(ruta_base, "/VELO2023_hora_", tolower(gsub(" ", "_", contaminante)), ".jpg", sep = "")
  
  # Guardar el gráfico en la ruta especificada
  ggsave(nombre_archivo, grafico, width = 10, height = 6, dpi = 300)
  
}



# Cargamos Datos de ----------------VELODROMO-2024-------------------------------------------------------------
data <- read_csv("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/VELODROMO/VELO-2024-limpiado.csv")
View(data)


# Convertir las columnas FECHA y Horas a un solo datetime
data <- data %>%
  mutate(Datetime = dmy_hms(paste(FECHA, Horas))) %>%
  select(-FECHA, -Horas) %>%
  arrange(Datetime)


# hacerlos long format (formato largo)
data_long <- data %>%
  pivot_longer(cols = c(O3, NO2, CO, SO2, `PM.10`, `PM.2.5`), 
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
  labs(title = "Promedio de concentración de contaminantes por hora en Puebla VELODROMO 2024",
       x = "Hora del día",
       y = "Promedio de concentración") +
  theme_minimal()

# Guardar el gráfico en la carpeta 'imagenes'
ggsave("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/VELO2024/Todos-Contaminantes/VELO2024_hora_contaminantes.jpg", NINFAS2023_hora_contaminantes, width = 10, height = 6, dpi = 300)


# Iterar sobre cada contaminante para generar y guardar un gráfico
contaminantes_unicos <- unique(promedio_hora$Contaminante)

# Ruta base para guardar los gráficos
ruta_base <- "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/VELO2024/Cada-Contaminantes"

# Crear la carpeta si no existe
if (!dir.exists(ruta_base)) {
  dir.create(ruta_base, recursive = TRUE)
}

for(contaminante in contaminantes_unicos) {
  # Filtrar los datos para el contaminante actual
  datos_contaminante <- filter(promedio_hora, Contaminante == contaminante)
  
  # Crear el gráfico
  grafico <- ggplot(datos_contaminante, aes(x = Hora, y = Promedio_Concentracion)) +
    geom_line(size = 1) +
    scale_x_continuous(breaks = 0:23, limits = c(0, 23)) + # Asegura que se muestren todas las horas
    labs(title = paste("Promedio de concentración de", contaminante, "por hora en Puebla VELODROMO 2024"),
         x = "Hora del día",
         y = "Promedio de concentración") +
    theme_minimal()
  
  # Definir el nombre del archivo basado en el contaminante
  nombre_archivo <- paste(ruta_base, "/VELO2024_hora_", tolower(gsub(" ", "_", contaminante)), ".jpg", sep = "")
  
  # Guardar el gráfico en la ruta especificada
  ggsave(nombre_archivo, grafico, width = 10, height = 6, dpi = 300)
  
}


# Cargamos Datos de ----------------BINE-2024-------------------------------------------------------------
data <- read_csv("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/BINE/BINE-2024-limpiado.csv")
View(data)


# Convertir las columnas FECHA y Horas a un solo datetime
data <- data %>%
  mutate(Datetime = dmy_hms(paste(Fecha, Horas))) %>%
  select(-Fecha, -Horas) %>%
  arrange(Datetime)


# hacerlos long format (formato largo)
data_long <- data %>%
  pivot_longer(cols = c(O3, NO2, CO, SO2, `PM.10`, `PM.2.5`), 
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
  labs(title = "Promedio de concentración de contaminantes por hora en Puebla BINE 2024",
       x = "Hora del día",
       y = "Promedio de concentración") +
  theme_minimal()

# Guardar el gráfico en la carpeta 'imagenes'
ggsave("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/BINE2024/Todos-Contaminantes/BINE2024_hora_contaminantes.jpg", NINFAS2023_hora_contaminantes, width = 10, height = 6, dpi = 300)


# Iterar sobre cada contaminante para generar y guardar un gráfico
contaminantes_unicos <- unique(promedio_hora$Contaminante)

# Ruta base para guardar los gráficos
ruta_base <- "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/BINE2024/Cada-Contaminantes"

# Crear la carpeta si no existe
if (!dir.exists(ruta_base)) {
  dir.create(ruta_base, recursive = TRUE)
}

for(contaminante in contaminantes_unicos) {
  # Filtrar los datos para el contaminante actual
  datos_contaminante <- filter(promedio_hora, Contaminante == contaminante)
  
  # Crear el gráfico
  grafico <- ggplot(datos_contaminante, aes(x = Hora, y = Promedio_Concentracion)) +
    geom_line(size = 1) +
    scale_x_continuous(breaks = 0:23, limits = c(0, 23)) + # Asegura que se muestren todas las horas
    labs(title = paste("Promedio de concentración de", contaminante, "por hora en Puebla BINE 2024"),
         x = "Hora del día",
         y = "Promedio de concentración") +
    theme_minimal()
  
  # Definir el nombre del archivo basado en el contaminante
  nombre_archivo <- paste(ruta_base, "/BINE2024_hora_", tolower(gsub(" ", "_", contaminante)), ".jpg", sep = "")
  
  # Guardar el gráfico en la ruta especificada
  ggsave(nombre_archivo, grafico, width = 10, height = 6, dpi = 300)
  
}






