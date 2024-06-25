# AGUA SANTA
library(dplyr)
library(readr)

# Definir la ruta a la carpeta que contiene los archivos CSV
folder_path <- "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/AGUA SANTA/limpios"

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

# Definir la ruta a la carpeta que contiene los archivos CSV
folder_path <- "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/BINE/limpios"

# Listar todos los archivos CSV en la carpeta
file_list <- list.files(path = folder_path, pattern = "*.csv", full.names = TRUE)

# Leer y concatenar todos los archivos CSV en un solo DataFrame
all_data <- lapply(file_list, read_csv) %>% bind_rows()



# Exportar el DataFrame combinado a un nuevo archivo CSV
write_csv(all_data, paste0(folder_path, "BINE_2020-2024_combinado.csv"))

# Mostrar las primeras filas del DataFrame combinado
head(all_data)
