# AGUA SANTA
library(dplyr)
library(readr)

data1 <- read_csv("Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/AGUA SANTA/limpios/AGUA-SANTA-2020-limpiado.csv")
data2 <- read_csv("Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/AGUA SANTA/limpios/AGUA-SANTA-2021-limpiado.csv")
data3 <- read_csv("Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/AGUA SANTA/limpios/AGUA-SANTA-2022-limpiado.csv")
data4 <- read_csv("Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/AGUA SANTA/limpios/AGUA-SANTA-2023-limpiado.csv")
data5 <- read_csv("Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/AGUA SANTA/limpios/AGUA-SANTA-2024-limpiado.csv")


colnames(data1) <- c("FECHA", "Horas", "O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")
colnames(data2) <- c("FECHA", "Horas", "O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")
colnames(data3) <- c("FECHA", "Horas", "O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")
colnames(data4) <- c("FECHA", "Horas", "O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")
colnames(data5) <- c("FECHA", "Horas", "O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")

# Definir la ruta a la carpeta que contiene los archivos CSV
folder_path <- "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/AGUA SANTA/limpios/"

# Exportar el DataFrame combinado a un nuevo archivo CSV
write_csv(data1, paste0(folder_path, "AGUA-SANTA-2020-limpiado.csv"))
write_csv(data2, paste0(folder_path, "AGUA-SANTA-2021-limpiado.csv"))
write_csv(data3, paste0(folder_path, "AGUA-SANTA-2022-limpiado.csv"))
write_csv(data4, paste0(folder_path, "AGUA-SANTA-2023-limpiado.csv"))
write_csv(data5, paste0(folder_path, "AGUA-SANTA-2024-limpiado.csv"))




# Listar todos los archivos CSV en la carpeta
file_list <- list.files(path = folder_path, pattern = "*.csv", full.names = TRUE)

# Leer y concatenar todos los archivos CSV en un solo DataFrame
all_data <- lapply(file_list, read_csv) %>% bind_rows()



# Exportar el DataFrame combinado a un nuevo archivo CSV
write_csv(all_data, paste0(folder_path, "AGUA_SANTA_2020-2024_combinado.csv"))

# Mostrar las primeras filas del DataFrame combinado
head(all_data)

na_count <- colSums(is.na(all_data))
na_count



# -----------------------------------------
# BINE
library(dplyr)
library(readr)

data1 <- read_csv("Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/BINE/limpios/BINE-2020-limpiado.csv")
data2 <- read_csv("Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/BINE/limpios/BINE-2021-limpiado.csv")
data3 <- read_csv("Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/BINE/limpios/BINE-2022-limpiado.csv")
data4 <- read_csv("Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/BINE/limpios/BINE-2023-limpiado.csv")
data5 <- read_csv("Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/BINE/limpios/BINE-2024-limpiado.csv")


colnames(data1) <- c("FECHA", "Horas", "O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")
colnames(data2) <- c("FECHA", "Horas", "O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")
colnames(data3) <- c("FECHA", "Horas", "O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")
colnames(data4) <- c("FECHA", "Horas", "O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")
colnames(data5) <- c("FECHA", "Horas", "O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")

# Definir la ruta a la carpeta que contiene los archivos CSV
folder_path <- "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/BINE/limpios/"

# Exportar el DataFrame combinado a un nuevo archivo CSV
write_csv(data1, paste0(folder_path, "BINE-2020-limpiado.csv"))
write_csv(data2, paste0(folder_path, "BINE-2021-limpiado.csv"))
write_csv(data3, paste0(folder_path, "BINE-2022-limpiado.csv"))
write_csv(data4, paste0(folder_path, "BINE-2023-limpiado.csv"))
write_csv(data5, paste0(folder_path, "BINE-2024-limpiado.csv"))

# Listar todos los archivos CSV en la carpeta
file_list <- list.files(path = folder_path, pattern = "*.csv", full.names = TRUE)

# Leer y concatenar todos los archivos CSV, tomando solo las primeras 8 columnas
all_data <- lapply(file_list, function(file) {
  read_csv(file, col_names = TRUE) %>% select(1:8)
}) %>% bind_rows()



# Exportar el DataFrame combinado a un nuevo archivo CSV
write_csv(all_data, paste0(folder_path, "BINE_2021-2024_combinado.csv"))

# Mostrar las primeras filas del DataFrame combinado
head(all_data)

na_count <- colSums(is.na(all_data))
na_count


# -----------------------------------------
# NINFAS
library(dplyr)
library(readr)
library(tidyr)

data1 <- read_csv("Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/NINFAS/limpios/NINFAS-2020-limpiado.csv")
data2 <- read_csv("Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/NINFAS/limpios/NINFAS-2021-limpiado.csv")
data3 <- read_csv("Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/NINFAS/limpios/NINFAS-2022-limpiado.csv")
data4 <- read_csv("Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/NINFAS/limpios/NINFAS-2023-limpiado.csv")
data5 <- read_csv("Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/NINFAS/limpios/NINFAS-2024-limpiado.csv")


colnames(data1) <- c("FECHA", "Horas", "O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")
colnames(data2) <- c("FECHA", "Horas", "O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")
colnames(data3) <- c("FECHA", "Horas", "O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")
colnames(data4) <- c("FECHA", "Horas", "O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")
colnames(data5) <- c("FECHA", "Horas", "O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")

# Definir la ruta a la carpeta que contiene los archivos CSV
folder_path <- "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/NINFAS/limpios/"

# Exportar el DataFrame combinado a un nuevo archivo CSV
write_csv(data1, paste0(folder_path, "NINFAS-2020-limpiado.csv"))
write_csv(data2, paste0(folder_path, "NINFAS-2021-limpiado.csv"))
write_csv(data3, paste0(folder_path, "NINFAS-2022-limpiado.csv"))
write_csv(data4, paste0(folder_path, "NINFAS-2023-limpiado.csv"))
write_csv(data5, paste0(folder_path, "NINFAS-2024-limpiado.csv"))

# Listar todos los archivos CSV en la carpeta
file_list <- list.files(path = folder_path, pattern = "*.csv", full.names = TRUE)

# Leer y concatenar todos los archivos CSV, tomando solo las primeras 8 columnas
all_data <- lapply(file_list, function(file) {
  read_csv(file, col_names = TRUE) %>% select(1:8)
}) %>% bind_rows()



# Exportar el DataFrame combinado a un nuevo archivo CSV
write_csv(all_data, paste0(folder_path, "NINFAS_2020-2024_combinado.csv"))

# Mostrar las primeras filas del DataFrame combinado
head(all_data)

na_count <- colSums(is.na(all_data))
na_count

# Borrar las filas que tienen valores NA
all_data <- all_data %>% drop_na()
na_count <- colSums(is.na(all_data))
na_count

# Exportar el DataFrame combinado a un nuevo archivo CSV
write_csv(all_data, paste0(folder_path, "NINFAS_2020-2024_combinado.csv"))

na_count

# -----------------------------------------
# UTP
library(dplyr)
library(readr)
library(tidyr)

data1 <- read_csv("Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/UTP/limpios/UTP-2020-limpiado.csv")
data2 <- read_csv("Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/UTP/limpios/UTP-2021-limpiado.csv")
data3 <- read_csv("Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/UTP/limpios/UTP-2022-limpiado.csv")
data4 <- read_csv("Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/UTP/limpios/UTP-2023-limpiado.csv")
data5 <- read_csv("Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/UTP/limpios/UTP-2024-limpiado.csv")


colnames(data1) <- c("FECHA", "Horas", "O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")
colnames(data2) <- c("FECHA", "Horas", "O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")
colnames(data3) <- c("FECHA", "Horas", "O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")
colnames(data4) <- c("FECHA", "Horas", "O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")
colnames(data5) <- c("FECHA", "Horas", "O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")

# Definir la ruta a la carpeta que contiene los archivos CSV
folder_path <- "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/UTP/limpios/"

# Exportar el DataFrame combinado a un nuevo archivo CSV
write_csv(data1, paste0(folder_path, "UTP-2020-limpiado.csv"))
write_csv(data2, paste0(folder_path, "UTP-2021-limpiado.csv"))
write_csv(data3, paste0(folder_path, "UTP-2022-limpiado.csv"))
write_csv(data4, paste0(folder_path, "UTP-2023-limpiado.csv"))
write_csv(data5, paste0(folder_path, "UTP-2024-limpiado.csv"))

# Listar todos los archivos CSV en la carpeta
file_list <- list.files(path = folder_path, pattern = "*.csv", full.names = TRUE)

# Leer y concatenar todos los archivos CSV, tomando solo las primeras 8 columnas
all_data <- lapply(file_list, function(file) {
  read_csv(file, col_names = TRUE) %>% select(1:8)
}) %>% bind_rows()



# Exportar el DataFrame combinado a un nuevo archivo CSV
write_csv(all_data, paste0(folder_path, "UTP_2020-2024_combinado.csv"))

# Mostrar las primeras filas del DataFrame combinado
head(all_data)

na_count <- colSums(is.na(all_data))
na_count

# Borrar las filas que tienen valores NA
all_data <- all_data %>% drop_na()

na_count






# -------------------------------------------------------------------------------------------------
# AGUA SANTA
library(tidyverse)
library(readr)
data <- read_csv("Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/AGUA SANTA/limpios/AGUA_SANTA_2020-2024_combinado.csv")

# Convierte la columna de fechas a un formato de fecha:
data$FECHA <- as.Date(data$FECHA, format = "%d/%m/%Y")

# Agrega una columna de año:
data$Year <- format(data$FECHA, "%Y")

# Calcula los promedios anuales para cada contaminante:
annual_means <- data %>%
  group_by(Year) %>%
  summarize(across(O3:`PM-2.5`, mean, na.rm = TRUE))


annual_means_long <- pivot_longer(annual_means, cols = O3:`PM-2.5`, names_to = "Contaminante", values_to = "Promedio")


# Gráfico de Líneas y Puntos Combinados
plot1<-ggplot(annual_means_long, aes(x = Year, y = Promedio, color = Contaminante, group = Contaminante)) +
  geom_line() +
  geom_point(size = 3) +
  labs(title = "Promedio Anual de Concentración de Contaminantes en Puebla AGUA SANTA",
       x = "Año",
       y = "Concentración Promedio",
       color = "Contaminante") +
  theme_minimal()

# Guardar el gráfico en la carpeta 'imagenes'
ggsave("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/años/AGUASANTA/AGUASANTA_anios_contaminantes.jpg", plot1, width = 10, height = 6, dpi = 300)


# -------------------------------------------------------------------------------------------------
# BINE
library(tidyverse)
library(readr)
data <- read_csv("Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/BINE/limpios/BINE_2021-2024_combinado.csv")

# Convierte la columna de fechas a un formato de fecha:
data$FECHA <- as.Date(data$FECHA, format = "%d/%m/%Y")

# Agrega una columna de año:
data$Year <- format(data$FECHA, "%Y")

# Calcula los promedios anuales para cada contaminante:
annual_means <- data %>%
  group_by(Year) %>%
  summarize(across(O3:`PM-2.5`, mean, na.rm = TRUE))


annual_means_long <- pivot_longer(annual_means, cols = O3:`PM-2.5`, names_to = "Contaminante", values_to = "Promedio")


# Gráfico de Líneas y Puntos Combinados
plot1<-ggplot(annual_means_long, aes(x = Year, y = Promedio, color = Contaminante, group = Contaminante)) +
  geom_line() +
  geom_point(size = 3) +
  labs(title = "Promedio Anual de Concentración de Contaminantes en Puebla BINE",
       x = "Año",
       y = "Concentración Promedio",
       color = "Contaminante") +
  theme_minimal()

# Guardar el gráfico en la carpeta 'imagenes'
ggsave("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/años/BINE/BINE_anios_contaminantes.jpg", plot1, width = 10, height = 6, dpi = 300)


# -------------------------------------------------------------------------------------------------
# NINFAS
library(tidyverse)
library(readr)
data <- read_csv("Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/NINFAS/limpios/NINFAS_2020-2024_combinado.csv")

# Convierte la columna de fechas a un formato de fecha:
data$FECHA <- as.Date(data$FECHA, format = "%d/%m/%Y")

# Agrega una columna de año:
data$Year <- format(data$FECHA, "%Y")

# Calcula los promedios anuales para cada contaminante:
annual_means <- data %>%
  group_by(Year) %>%
  summarize(across(O3:`PM-2.5`, mean, na.rm = TRUE))


annual_means_long <- pivot_longer(annual_means, cols = O3:`PM-2.5`, names_to = "Contaminante", values_to = "Promedio")


# Gráfico de Líneas y Puntos Combinados
plot1<-ggplot(annual_means_long, aes(x = Year, y = Promedio, color = Contaminante, group = Contaminante)) +
  geom_line() +
  geom_point(size = 3) +
  labs(title = "Promedio Anual de Concentración de Contaminantes en Puebla NINFAS",
       x = "Año",
       y = "Concentración Promedio",
       color = "Contaminante") +
  theme_minimal()

# Guardar el gráfico en la carpeta 'imagenes'
ggsave("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/años/NINFAS/NINFAS_anios_contaminantes.jpg", plot1, width = 10, height = 6, dpi = 300)

# -------------------------------------------------------------------------------------------------
# UTP
library(tidyverse)
library(readr)
data <- read_csv("Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/UTP/limpios/UTP_2020-2024_combinado.csv")

# Convierte la columna de fechas a un formato de fecha:
data$FECHA <- as.Date(data$FECHA, format = "%d/%m/%Y")

# Agrega una columna de año:
data$Year <- format(data$FECHA, "%Y")

# Calcula los promedios anuales para cada contaminante:
annual_means <- data %>%
  group_by(Year) %>%
  summarize(across(O3:`PM-2.5`, mean, na.rm = TRUE))


annual_means_long <- pivot_longer(annual_means, cols = O3:`PM-2.5`, names_to = "Contaminante", values_to = "Promedio")


# Gráfico de Líneas y Puntos Combinados
plot1<-ggplot(annual_means_long, aes(x = Year, y = Promedio, color = Contaminante, group = Contaminante)) +
  geom_line() +
  geom_point(size = 3) +
  labs(title = "Promedio Anual de Concentración de Contaminantes en Puebla UTP",
       x = "Año",
       y = "Concentración Promedio",
       color = "Contaminante") +
  theme_minimal()

# Guardar el gráfico en la carpeta 'imagenes'
ggsave("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/SeriesTiempo-contaminantes/imagenes/años/UTP/UTP_anios_contaminantes.jpg", plot1, width = 10, height = 6, dpi = 300)







