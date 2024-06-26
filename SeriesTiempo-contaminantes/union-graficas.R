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

# Definir la ruta a la carpeta que contiene los archivos CSV
folder_path <- "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/NINFAS/limpios"

# Listar todos los archivos CSV en la carpeta
file_list <- list.files(path = folder_path, pattern = "*.csv", full.names = TRUE)

# Leer y concatenar todos los archivos CSV en un solo DataFrame
all_data <- lapply(file_list, read_csv) %>% bind_rows()



# Exportar el DataFrame combinado a un nuevo archivo CSV
write_csv(all_data, paste0(folder_path, "NINFAS_2020-2024_combinado.csv"))

# Mostrar las primeras filas del DataFrame combinado
head(all_data)
