# Series de Tiempo

# Cargamos Datos de ----------------NINFAS-2023-------------------------------------------------------------
library(readr)
data <- read_csv("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/NINFAS/NINFAS-2023-limpiado.csv")

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
  summarise(Promedio_Concentracion = mean(Concentracion, na.rm = TRUE)) %>%
  ungroup()

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

# Iterar sobre cada contaminante para generar y guardar un gráfico
contaminantes_unicos <- unique(promedio_mes$Contaminante)

# Ruta base para guardar los gráficos
ruta_base <- "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/mes/NINFAS2023/Cada-Contaminantes"

# Crear la carpeta si no existe
if (!dir.exists(ruta_base)) {
  dir.create(ruta_base, recursive = TRUE)
}

for(contaminante in contaminantes_unicos) {
  # Filtrar los datos para el contaminante actual
  datos_contaminante <- filter(promedio_mes, Contaminante == contaminante)
  
  # Verificar si hay al menos dos puntos de datos para el contaminante
  if (nrow(datos_contaminante) > 1) {
    # Crear el gráfico
    grafico <- ggplot(datos_contaminante, aes(x = Mes, y = Promedio_Concentracion, group = 1)) +
      geom_line(size = 1) +
      scale_x_discrete(limits = month.abb) + # Asegura que se muestren todos los meses
      labs(title = paste("Promedio de concentración de", contaminante, "por mes en Puebla NINFAS 2023"),
           x = "Mes del año",
           y = "Promedio de concentración") +
      theme_minimal()
    
    # Definir el nombre del archivo basado en el contaminante
    nombre_archivo <- paste(ruta_base, "/NINFAS2023_mes_", tolower(gsub(" ", "_", contaminante)), ".jpg", sep = "")
    
    # Guardar el gráfico en la ruta especificada
    ggsave(nombre_archivo, grafico, width = 10, height = 6, dpi = 300)
  } else {
    message(paste("No hay suficientes datos para el contaminante:", contaminante))
  }
}



# Cargamos Datos de ----------------UTP-2024-------------------------------------------------------------
data <- read_csv("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/UTP/UTP-2024-limpiado.csv")


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
  summarise(Promedio_Concentracion = mean(Concentracion, na.rm = TRUE)) %>%
  ungroup()

# Asignar el gráfico a una variable
NINFAS2023_mes_contaminantes <- ggplot(promedio_mes, aes(x = Mes, y = Promedio_Concentracion, color = Contaminante, group = Contaminante)) +
  geom_line(size = 1) +
  facet_wrap(~ Contaminante, scales = "free_y") +
  labs(title = "Promedio de concentración de contaminantes por mes en Puebla UTP 2024",
       x = "Mes del año",
       y = "Promedio de concentración") +
  theme_minimal()

# Guardar el gráfico en la carpeta 'imagenes'
ggsave("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/mes/UTP2024/Todos-Contaminantes/UTP2024_mes_contaminantes.jpg", NINFAS2023_mes_contaminantes, width = 10, height = 6, dpi = 300)



# Iterar sobre cada contaminante para generar y guardar un gráfico
contaminantes_unicos <- unique(promedio_mes$Contaminante)

# Ruta base para guardar los gráficos
ruta_base <- "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/mes/UTP2024/Cada-Contaminantes"

# Crear la carpeta si no existe
if (!dir.exists(ruta_base)) {
  dir.create(ruta_base, recursive = TRUE)
}

for(contaminante in contaminantes_unicos) {
  # Filtrar los datos para el contaminante actual
  datos_contaminante <- filter(promedio_mes, Contaminante == contaminante)
  
  # Verificar si hay al menos dos puntos de datos para el contaminante
  if (nrow(datos_contaminante) > 1) {
    # Crear el gráfico
    grafico <- ggplot(datos_contaminante, aes(x = Mes, y = Promedio_Concentracion, group = 1)) +
      geom_line(size = 1) +
      scale_x_discrete(limits = month.abb) + # Asegura que se muestren todos los meses
      labs(title = paste("Promedio de concentración de", contaminante, "por mes en Puebla UTP 2024"),
           x = "Mes del año",
           y = "Promedio de concentración") +
      theme_minimal()
    
    # Definir el nombre del archivo basado en el contaminante
    nombre_archivo <- paste(ruta_base, "/UTP2024_mes_", tolower(gsub(" ", "_", contaminante)), ".jpg", sep = "")
    
    # Guardar el gráfico en la ruta especificada
    ggsave(nombre_archivo, grafico, width = 10, height = 6, dpi = 300)
  } else {
    message(paste("No hay suficientes datos para el contaminante:", contaminante))
  }
}



# Cargamos Datos de ----------------AGUASANTA-2024-------------------------------------------------------------
data <- read_csv("Datos/AGUA SANTA/AGUA-SANTA-2024-limpiado.csv")


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
  summarise(Promedio_Concentracion = mean(Concentracion, na.rm = TRUE)) %>%
  ungroup()

# Asignar el gráfico a una variable
NINFAS2023_mes_contaminantes <- ggplot(promedio_mes, aes(x = Mes, y = Promedio_Concentracion, color = Contaminante, group = Contaminante)) +
  geom_line(size = 1) +
  facet_wrap(~ Contaminante, scales = "free_y") +
  labs(title = "Promedio de concentración de contaminantes por mes en Puebla AGUA SANTA 2024",
       x = "Mes del año",
       y = "Promedio de concentración") +
  theme_minimal()

# Guardar el gráfico en la carpeta 'imagenes'
ggsave("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/mes/AGUA-SANTA2024/Todos-Contaminantes/AGUA-SANTA2024_mes_contaminantes.jpg", NINFAS2023_mes_contaminantes, width = 10, height = 6, dpi = 300)



# Iterar sobre cada contaminante para generar y guardar un gráfico
contaminantes_unicos <- unique(promedio_mes$Contaminante)

# Ruta base para guardar los gráficos
ruta_base <- "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/mes/AGUA-SANTA2024/Cada-Contaminantes"

# Crear la carpeta si no existe
if (!dir.exists(ruta_base)) {
  dir.create(ruta_base, recursive = TRUE)
}

for(contaminante in contaminantes_unicos) {
  # Filtrar los datos para el contaminante actual
  datos_contaminante <- filter(promedio_mes, Contaminante == contaminante)
  
  # Verificar si hay al menos dos puntos de datos para el contaminante
  if (nrow(datos_contaminante) > 1) {
    # Crear el gráfico
    grafico <- ggplot(datos_contaminante, aes(x = Mes, y = Promedio_Concentracion, group = 1)) +
      geom_line(size = 1) +
      scale_x_discrete(limits = month.abb) + # Asegura que se muestren todos los meses
      labs(title = paste("Promedio de concentración de", contaminante, "por mes en Puebla AGUA SANTA 2024"),
           x = "Mes del año",
           y = "Promedio de concentración") +
      theme_minimal()
    
    # Definir el nombre del archivo basado en el contaminante
    nombre_archivo <- paste(ruta_base, "/AGUA-SANTA2024_mes_", tolower(gsub(" ", "_", contaminante)), ".jpg", sep = "")
    
    # Guardar el gráfico en la ruta especificada
    ggsave(nombre_archivo, grafico, width = 10, height = 6, dpi = 300)
  } else {
    message(paste("No hay suficientes datos para el contaminante:", contaminante))
  }
}




# Cargamos Datos de ----------------AGUASANTA-2023-------------------------------------------------------------
data <- read_csv("Datos/AGUA SANTA/AGUA-SANTA-2023-limpiado.csv")


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
  summarise(Promedio_Concentracion = mean(Concentracion, na.rm = TRUE)) %>%
  ungroup()

# Asignar el gráfico a una variable
NINFAS2023_mes_contaminantes <- ggplot(promedio_mes, aes(x = Mes, y = Promedio_Concentracion, color = Contaminante, group = Contaminante)) +
  geom_line(size = 1) +
  facet_wrap(~ Contaminante, scales = "free_y") +
  labs(title = "Promedio de concentración de contaminantes por mes en Puebla AGUA SANTA 2023",
       x = "Mes del año",
       y = "Promedio de concentración") +
  theme_minimal()

# Guardar el gráfico en la carpeta 'imagenes'
ggsave("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/mes/AGUA-SANTA2023/Todos-Contaminantes/AGUA-SANTA2023_mes_contaminantes.jpg", NINFAS2023_mes_contaminantes, width = 10, height = 6, dpi = 300)



# Iterar sobre cada contaminante para generar y guardar un gráfico
contaminantes_unicos <- unique(promedio_mes$Contaminante)

# Ruta base para guardar los gráficos
ruta_base <- "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/mes/AGUA-SANTA2023/Cada-Contaminantes"

# Crear la carpeta si no existe
if (!dir.exists(ruta_base)) {
  dir.create(ruta_base, recursive = TRUE)
}

for(contaminante in contaminantes_unicos) {
  # Filtrar los datos para el contaminante actual
  datos_contaminante <- filter(promedio_mes, Contaminante == contaminante)
  
  # Verificar si hay al menos dos puntos de datos para el contaminante
  if (nrow(datos_contaminante) > 1) {
    # Crear el gráfico
    grafico <- ggplot(datos_contaminante, aes(x = Mes, y = Promedio_Concentracion, group = 1)) +
      geom_line(size = 1) +
      scale_x_discrete(limits = month.abb) + # Asegura que se muestren todos los meses
      labs(title = paste("Promedio de concentración de", contaminante, "por mes en Puebla AGUA SANTA 2023"),
           x = "Mes del año",
           y = "Promedio de concentración") +
      theme_minimal()
    
    # Definir el nombre del archivo basado en el contaminante
    nombre_archivo <- paste(ruta_base, "/AGUA-SANTA2023_mes_", tolower(gsub(" ", "_", contaminante)), ".jpg", sep = "")
    
    # Guardar el gráfico en la ruta especificada
    ggsave(nombre_archivo, grafico, width = 10, height = 6, dpi = 300)
  } else {
    message(paste("No hay suficientes datos para el contaminante:", contaminante))
  }
}




# Cargamos Datos de ----------------BINE-2023-------------------------------------------------------------
data <- read_csv("Datos/BINE/BINE-2023-limpiado.csv")


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
  summarise(Promedio_Concentracion = mean(Concentracion, na.rm = TRUE)) %>%
  ungroup()

# Asignar el gráfico a una variable
NINFAS2023_mes_contaminantes <- ggplot(promedio_mes, aes(x = Mes, y = Promedio_Concentracion, color = Contaminante, group = Contaminante)) +
  geom_line(size = 1) +
  facet_wrap(~ Contaminante, scales = "free_y") +
  labs(title = "Promedio de concentración de contaminantes por mes en Puebla BINE 2023",
       x = "Mes del año",
       y = "Promedio de concentración") +
  theme_minimal()

# Guardar el gráfico en la carpeta 'imagenes'
ggsave("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/mes/BINE2023/Todos-Contaminantes/BINE2023_mes_contaminantes.jpg", NINFAS2023_mes_contaminantes, width = 10, height = 6, dpi = 300)



# Iterar sobre cada contaminante para generar y guardar un gráfico
contaminantes_unicos <- unique(promedio_mes$Contaminante)

# Ruta base para guardar los gráficos
ruta_base <- "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/mes/BINE2023/Cada-Contaminantes"

# Crear la carpeta si no existe
if (!dir.exists(ruta_base)) {
  dir.create(ruta_base, recursive = TRUE)
}

for(contaminante in contaminantes_unicos) {
  # Filtrar los datos para el contaminante actual
  datos_contaminante <- filter(promedio_mes, Contaminante == contaminante)
  
  # Verificar si hay al menos dos puntos de datos para el contaminante
  if (nrow(datos_contaminante) > 1) {
    # Crear el gráfico
    grafico <- ggplot(datos_contaminante, aes(x = Mes, y = Promedio_Concentracion, group = 1)) +
      geom_line(size = 1) +
      scale_x_discrete(limits = month.abb) + # Asegura que se muestren todos los meses
      labs(title = paste("Promedio de concentración de", contaminante, "por mes en Puebla BINE 2023"),
           x = "Mes del año",
           y = "Promedio de concentración") +
      theme_minimal()
    
    # Definir el nombre del archivo basado en el contaminante
    nombre_archivo <- paste(ruta_base, "/BINE2023_mes_", tolower(gsub(" ", "_", contaminante)), ".jpg", sep = "")
    
    # Guardar el gráfico en la ruta especificada
    ggsave(nombre_archivo, grafico, width = 10, height = 6, dpi = 300)
  } else {
    message(paste("No hay suficientes datos para el contaminante:", contaminante))
  }
}

# Cargamos Datos de ----------------VELODROMO-2023-------------------------------------------------------------
data <- read_csv("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/VELODROMO/VELO-2023-limpiado.csv")


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

# Extraer el mes del datetime
data_long <- data_long %>%
  mutate(Mes = month(Datetime, label = TRUE, abbr = TRUE))

# Calcular el promedio por mes
promedio_mes <- data_long %>%
  group_by(Mes, Contaminante) %>%
  summarise(Promedio_Concentracion = mean(Concentracion, na.rm = TRUE)) %>%
  ungroup()

# Asignar el gráfico a una variable
NINFAS2023_mes_contaminantes <- ggplot(promedio_mes, aes(x = Mes, y = Promedio_Concentracion, color = Contaminante, group = Contaminante)) +
  geom_line(size = 1) +
  facet_wrap(~ Contaminante, scales = "free_y") +
  labs(title = "Promedio de concentración de contaminantes por mes en Puebla VELODROMO 2023",
       x = "Mes del año",
       y = "Promedio de concentración") +
  theme_minimal()

# Guardar el gráfico en la carpeta 'imagenes'
ggsave("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/mes/VELO2023/Todos-Contaminantes/VELO2023_mes_contaminantes.jpg", NINFAS2023_mes_contaminantes, width = 10, height = 6, dpi = 300)



# Iterar sobre cada contaminante para generar y guardar un gráfico
contaminantes_unicos <- unique(promedio_mes$Contaminante)

# Ruta base para guardar los gráficos
ruta_base <- "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/mes/VELO2023/Cada-Contaminantes"

# Crear la carpeta si no existe
if (!dir.exists(ruta_base)) {
  dir.create(ruta_base, recursive = TRUE)
}

for(contaminante in contaminantes_unicos) {
  # Filtrar los datos para el contaminante actual
  datos_contaminante <- filter(promedio_mes, Contaminante == contaminante)
  
  # Verificar si hay al menos dos puntos de datos para el contaminante
  if (nrow(datos_contaminante) > 1) {
    # Crear el gráfico
    grafico <- ggplot(datos_contaminante, aes(x = Mes, y = Promedio_Concentracion, group = 1)) +
      geom_line(size = 1) +
      scale_x_discrete(limits = month.abb) + # Asegura que se muestren todos los meses
      labs(title = paste("Promedio de concentración de", contaminante, "por mes en Puebla VELODROMO 2023"),
           x = "Mes del año",
           y = "Promedio de concentración") +
      theme_minimal()
    
    # Definir el nombre del archivo basado en el contaminante
    nombre_archivo <- paste(ruta_base, "/VELO2023_mes_", tolower(gsub(" ", "_", contaminante)), ".jpg", sep = "")
    
    # Guardar el gráfico en la ruta especificada
    ggsave(nombre_archivo, grafico, width = 10, height = 6, dpi = 300)
  } else {
    message(paste("No hay suficientes datos para el contaminante:", contaminante))
  }
}



# Cargamos Datos de ----------------VELODROMO-2024-------------------------------------------------------------
data <- read_csv("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/VELODROMO/VELO-2024-limpiado.csv")


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

# Extraer el mes del datetime
data_long <- data_long %>%
  mutate(Mes = month(Datetime, label = TRUE, abbr = TRUE))

# Calcular el promedio por mes
promedio_mes <- data_long %>%
  group_by(Mes, Contaminante) %>%
  summarise(Promedio_Concentracion = mean(Concentracion, na.rm = TRUE)) %>%
  ungroup()

# Asignar el gráfico a una variable
NINFAS2023_mes_contaminantes <- ggplot(promedio_mes, aes(x = Mes, y = Promedio_Concentracion, color = Contaminante, group = Contaminante)) +
  geom_line(size = 1) +
  facet_wrap(~ Contaminante, scales = "free_y") +
  labs(title = "Promedio de concentración de contaminantes por mes en Puebla VELODROMO 2024",
       x = "Mes del año",
       y = "Promedio de concentración") +
  theme_minimal()

# Guardar el gráfico en la carpeta 'imagenes'
ggsave("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/mes/VELO2024/Todos-Contaminantes/VELO2024_mes_contaminantes.jpg", NINFAS2023_mes_contaminantes, width = 10, height = 6, dpi = 300)



# Iterar sobre cada contaminante para generar y guardar un gráfico
contaminantes_unicos <- unique(promedio_mes$Contaminante)

# Ruta base para guardar los gráficos
ruta_base <- "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/mes/VELO2024/Cada-Contaminantes"

# Crear la carpeta si no existe
if (!dir.exists(ruta_base)) {
  dir.create(ruta_base, recursive = TRUE)
}

for(contaminante in contaminantes_unicos) {
  # Filtrar los datos para el contaminante actual
  datos_contaminante <- filter(promedio_mes, Contaminante == contaminante)
  
  # Verificar si hay al menos dos puntos de datos para el contaminante
  if (nrow(datos_contaminante) > 1) {
    # Crear el gráfico
    grafico <- ggplot(datos_contaminante, aes(x = Mes, y = Promedio_Concentracion, group = 1)) +
      geom_line(size = 1) +
      scale_x_discrete(limits = month.abb) + # Asegura que se muestren todos los meses
      labs(title = paste("Promedio de concentración de", contaminante, "por mes en Puebla VELODROMO 2024"),
           x = "Mes del año",
           y = "Promedio de concentración") +
      theme_minimal()
    
    # Definir el nombre del archivo basado en el contaminante
    nombre_archivo <- paste(ruta_base, "/VELO2024_mes_", tolower(gsub(" ", "_", contaminante)), ".jpg", sep = "")
    
    # Guardar el gráfico en la ruta especificada
    ggsave(nombre_archivo, grafico, width = 10, height = 6, dpi = 300)
  } else {
    message(paste("No hay suficientes datos para el contaminante:", contaminante))
  }
}


# Cargamos Datos de ----------------BINE-2024-------------------------------------------------------------
data <- read_csv("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/BINE/BINE-2024-limpiado.csv")


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

# Extraer el mes del datetime
data_long <- data_long %>%
  mutate(Mes = month(Datetime, label = TRUE, abbr = TRUE))

# Calcular el promedio por mes
promedio_mes <- data_long %>%
  group_by(Mes, Contaminante) %>%
  summarise(Promedio_Concentracion = mean(Concentracion, na.rm = TRUE)) %>%
  ungroup()

# Asignar el gráfico a una variable
NINFAS2023_mes_contaminantes <- ggplot(promedio_mes, aes(x = Mes, y = Promedio_Concentracion, color = Contaminante, group = Contaminante)) +
  geom_line(size = 1) +
  facet_wrap(~ Contaminante, scales = "free_y") +
  labs(title = "Promedio de concentración de contaminantes por mes en Puebla BINE 2024",
       x = "Mes del año",
       y = "Promedio de concentración") +
  theme_minimal()

# Guardar el gráfico en la carpeta 'imagenes'
ggsave("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/mes/BINE2024/Todos-Contaminantes/BINE2024_mes_contaminantes.jpg", NINFAS2023_mes_contaminantes, width = 10, height = 6, dpi = 300)



# Iterar sobre cada contaminante para generar y guardar un gráfico
contaminantes_unicos <- unique(promedio_mes$Contaminante)

# Ruta base para guardar los gráficos
ruta_base <- "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/mes/BINE2024/Cada-Contaminantes"

# Crear la carpeta si no existe
if (!dir.exists(ruta_base)) {
  dir.create(ruta_base, recursive = TRUE)
}

for(contaminante in contaminantes_unicos) {
  # Filtrar los datos para el contaminante actual
  datos_contaminante <- filter(promedio_mes, Contaminante == contaminante)
  
  # Verificar si hay al menos dos puntos de datos para el contaminante
  if (nrow(datos_contaminante) > 1) {
    # Crear el gráfico
    grafico <- ggplot(datos_contaminante, aes(x = Mes, y = Promedio_Concentracion, group = 1)) +
      geom_line(size = 1) +
      scale_x_discrete(limits = month.abb) + # Asegura que se muestren todos los meses
      labs(title = paste("Promedio de concentración de", contaminante, "por mes en Puebla BINE 2024"),
           x = "Mes del año",
           y = "Promedio de concentración") +
      theme_minimal()
    
    # Definir el nombre del archivo basado en el contaminante
    nombre_archivo <- paste(ruta_base, "/BINE2024_mes_", tolower(gsub(" ", "_", contaminante)), ".jpg", sep = "")
    
    # Guardar el gráfico en la ruta especificada
    ggsave(nombre_archivo, grafico, width = 10, height = 6, dpi = 300)
  } else {
    message(paste("No hay suficientes datos para el contaminante:", contaminante))
  }
}


# Cargamos Datos de ----------------NINFAS-2024-------------------------------------------------------------
data <- read_csv("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/NINFAS/NINFAS-2024-limpiado.csv")


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

# Extraer el mes del datetime
data_long <- data_long %>%
  mutate(Mes = month(Datetime, label = TRUE, abbr = TRUE))

# Calcular el promedio por mes
promedio_mes <- data_long %>%
  group_by(Mes, Contaminante) %>%
  summarise(Promedio_Concentracion = mean(Concentracion, na.rm = TRUE)) %>%
  ungroup()

# Asignar el gráfico a una variable
NINFAS2023_mes_contaminantes <- ggplot(promedio_mes, aes(x = Mes, y = Promedio_Concentracion, color = Contaminante, group = Contaminante)) +
  geom_line(size = 1) +
  facet_wrap(~ Contaminante, scales = "free_y") +
  labs(title = "Promedio de concentración de contaminantes por mes en Puebla NINFAS 2024",
       x = "Mes del año",
       y = "Promedio de concentración") +
  theme_minimal()

# Guardar el gráfico en la carpeta 'imagenes'
ggsave("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/mes/NINFAS2024/Todos-Contaminantes/NINFAS2024_mes_contaminantes.jpg", NINFAS2023_mes_contaminantes, width = 10, height = 6, dpi = 300)



# Iterar sobre cada contaminante para generar y guardar un gráfico
contaminantes_unicos <- unique(promedio_mes$Contaminante)

# Ruta base para guardar los gráficos
ruta_base <- "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/mes/NINFAS2024/Cada-Contaminantes"

# Crear la carpeta si no existe
if (!dir.exists(ruta_base)) {
  dir.create(ruta_base, recursive = TRUE)
}

for(contaminante in contaminantes_unicos) {
  # Filtrar los datos para el contaminante actual
  datos_contaminante <- filter(promedio_mes, Contaminante == contaminante)
  
  # Verificar si hay al menos dos puntos de datos para el contaminante
  if (nrow(datos_contaminante) > 1) {
    # Crear el gráfico
    grafico <- ggplot(datos_contaminante, aes(x = Mes, y = Promedio_Concentracion, group = 1)) +
      geom_line(size = 1) +
      scale_x_discrete(limits = month.abb) + # Asegura que se muestren todos los meses
      labs(title = paste("Promedio de concentración de", contaminante, "por mes en Puebla NINFAS 2024"),
           x = "Mes del año",
           y = "Promedio de concentración") +
      theme_minimal()
    
    # Definir el nombre del archivo basado en el contaminante
    nombre_archivo <- paste(ruta_base, "/NINFAS2024_mes_", tolower(gsub(" ", "_", contaminante)), ".jpg", sep = "")
    
    # Guardar el gráfico en la ruta especificada
    ggsave(nombre_archivo, grafico, width = 10, height = 6, dpi = 300)
  } else {
    message(paste("No hay suficientes datos para el contaminante:", contaminante))
  }
}






