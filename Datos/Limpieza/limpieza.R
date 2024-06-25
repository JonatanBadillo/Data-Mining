# Importacion de Datos
library(readr)
data <- read_csv("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/BINE/BINE-2023.csv")
View(data)

library(dplyr)
library(tidyr)

# Ver las primeras filas del dataframe
head(data)

summary(data)

# Hasta la fila 8760, que abarca has 31/12/23
data <- data[1:8760, ]


# Convertir valores específicos a NA
data[data == "F.O." | data == "D.I." | data == "Mtto." | data == "Mtto"] <- NA


na_count <- colSums(is.na(data))
na_count

# Ver las primeras filas del dataframe
head(data)


# Convertir las columnas numéricas que tienen valores como texto a tipo numérico
cols_to_convert <- c("O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")


# aplica la función as.numeric a cada una de las columnas seleccionadas. 
# lapply devuelve una lista donde cada elemento es el resultado de  aplicar as.numeric a las columnas, 
# convirtiéndolas a numérico.

data[cols_to_convert] <- lapply(data[cols_to_convert], as.numeric)

# Reemplazar los NA por el promedio de cada columna
# Dentro de mutate, across se utiliza para aplicar una función a las columnas especificadas en cols_to_convert.
# all_of(cols_to_convert) asegura que se utilicen las columnas especificadas en cols_to_convert.
# ~ replace_na(., mean(., na.rm = TRUE)) es una fórmula que define la operación a realizar en cada columna seleccionada. 
# replace_na(., mean(., na.rm = TRUE)) reemplaza los NA en cada columna (.) con el promedio de la columna, 
# calculado con mean(., na.rm = TRUE), donde na.rm = TRUE indica que se deben omitir los NA al calcular el promedio.
data <- data %>%
  mutate(across(all_of(cols_to_convert), ~ replace_na(., mean(., na.rm = TRUE))))


# Formatear los números (sin decimales para enteros, tres decimales para otros)
data <- data %>%
  mutate(across(all_of(cols_to_convert), ~ ifelse(round(.) == ., format(round(.)), format(round(., 3)))))


# Verificar los cambios
head(data)


na_count <- colSums(is.na(data))
na_count

# Guardar el dataframe limpio en un nuevo archivo CSV
write.csv(data, "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/BINE/BINE-2023-limpiado.csv", row.names = FALSE)

# -------------------------------------------------------------
# DATOS 2020 - 2022
# AGUA SANTA 2020
library(dplyr)
library(lubridate)
library(readr)

# Leer el archivo CSV
data <- read_csv("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/AGUA SANTA/Datos_Santa_2020.csv")

# Convertir valores específicos a NA en las columnas adecuadas
data <- data %>%
  mutate(across(where(is.character), ~na_if(., "F.O."))) %>%
  mutate(across(where(is.character), ~na_if(., "D.I."))) %>%
  mutate(across(where(is.character), ~na_if(., "Mtto."))) %>%
  mutate(across(where(is.character), ~na_if(., "Mtto")))

# Eliminar la columna 'O3 8 hrs (ppm)'
data <- data %>% select(-`O3 8 hrs (ppm)`)

# Renombrar las columnas para que coincidan con el archivo 'agua_santa_2023.csv'
colnames(data) <- c("FECHA", "Horas", "O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")

# Convertir la columna 'FECHA' al formato adecuado (día/mes/año)
data$FECHA <- format(as.Date(data$FECHA, format="%Y-%m-%d"), "%d/%m/%Y")


# Convertir las columnas numéricas que tienen valores como texto a tipo numérico
cols_to_convert <- c("O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")


# aplica la función as.numeric a cada una de las columnas seleccionadas. 
# lapply devuelve una lista donde cada elemento es el resultado de  aplicar as.numeric a las columnas, 
# convirtiéndolas a numérico.

data[cols_to_convert] <- lapply(data[cols_to_convert], as.numeric)

# Reemplazar los NA por el promedio de cada columna
# Dentro de mutate, across se utiliza para aplicar una función a las columnas especificadas en cols_to_convert.
# all_of(cols_to_convert) asegura que se utilicen las columnas especificadas en cols_to_convert.
# ~ replace_na(., mean(., na.rm = TRUE)) es una fórmula que define la operación a realizar en cada columna seleccionada. 
# replace_na(., mean(., na.rm = TRUE)) reemplaza los NA en cada columna (.) con el promedio de la columna, 
# calculado con mean(., na.rm = TRUE), donde na.rm = TRUE indica que se deben omitir los NA al calcular el promedio.
data <- data %>%
  mutate(across(all_of(cols_to_convert), ~ replace_na(., mean(., na.rm = TRUE))))


# Formatear los números (sin decimales para enteros, tres decimales para otros)
data <- data %>%
  mutate(across(all_of(cols_to_convert), ~ ifelse(round(.) == ., format(round(.)), format(round(., 3)))))


# Verificar los cambios
head(data)


na_count <- colSums(is.na(data))
na_count

# Guardar el dataframe limpio en un nuevo archivo CSV
write.csv(data, "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/AGUA SANTA/AGUA-SANTA-2020-limpiado.csv", row.names = FALSE)


# -------------------------------------------------------------
# DATOS 2020 - 2022
# AGUA SANTA 2021
library(dplyr)
library(lubridate)
library(readr)

# Leer el archivo CSV
data <- read_csv("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/AGUA SANTA/Datos_Santa_2021.csv")

# Convertir valores específicos a NA en las columnas adecuadas
data <- data %>%
  mutate(across(where(is.character), ~na_if(., "F.O."))) %>%
  mutate(across(where(is.character), ~na_if(., "D.I."))) %>%
  mutate(across(where(is.character), ~na_if(., "Mtto."))) %>%
  mutate(across(where(is.character), ~na_if(., "Mtto")))

# Eliminar la columna 'O3 8 hrs (ppm)'
data <- data %>% select(-`O3 8 hrs (ppm)`)

# Renombrar las columnas para que coincidan con el archivo 'agua_santa_2023.csv'
colnames(data) <- c("FECHA", "Horas", "O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")

# Convertir la columna 'FECHA' al formato adecuado (día/mes/año)
data$FECHA <- format(as.Date(data$FECHA, format="%Y-%m-%d"), "%d/%m/%Y")


# Convertir las columnas numéricas que tienen valores como texto a tipo numérico
cols_to_convert <- c("O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")


# aplica la función as.numeric a cada una de las columnas seleccionadas. 
# lapply devuelve una lista donde cada elemento es el resultado de  aplicar as.numeric a las columnas, 
# convirtiéndolas a numérico.

data[cols_to_convert] <- lapply(data[cols_to_convert], as.numeric)

# Reemplazar los NA por el promedio de cada columna
# Dentro de mutate, across se utiliza para aplicar una función a las columnas especificadas en cols_to_convert.
# all_of(cols_to_convert) asegura que se utilicen las columnas especificadas en cols_to_convert.
# ~ replace_na(., mean(., na.rm = TRUE)) es una fórmula que define la operación a realizar en cada columna seleccionada. 
# replace_na(., mean(., na.rm = TRUE)) reemplaza los NA en cada columna (.) con el promedio de la columna, 
# calculado con mean(., na.rm = TRUE), donde na.rm = TRUE indica que se deben omitir los NA al calcular el promedio.
data <- data %>%
  mutate(across(all_of(cols_to_convert), ~ replace_na(., mean(., na.rm = TRUE))))


# Formatear los números (sin decimales para enteros, tres decimales para otros)
data <- data %>%
  mutate(across(all_of(cols_to_convert), ~ ifelse(round(.) == ., format(round(.)), format(round(., 3)))))


# Verificar los cambios
head(data)


na_count <- colSums(is.na(data))
na_count

# Guardar el dataframe limpio en un nuevo archivo CSV
write.csv(data, "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/AGUA SANTA/AGUA-SANTA-2021-limpiado.csv", row.names = FALSE)


# -------------------------------------------------------------
# DATOS 2020 - 2022
# AGUA SANTA 2022
library(dplyr)
library(lubridate)
library(readr)

# Leer el archivo CSV
data <- read_csv("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/AGUA SANTA/Datos_Santa_2022.csv")

# Convertir valores específicos a NA en las columnas adecuadas
data <- data %>%
  mutate(across(where(is.character), ~na_if(., "F.O."))) %>%
  mutate(across(where(is.character), ~na_if(., "D.I."))) %>%
  mutate(across(where(is.character), ~na_if(., "Mtto."))) %>%
  mutate(across(where(is.character), ~na_if(., "Mtto")))

# Eliminar la columna 'O3 8 hrs (ppm)'
data <- data %>% select(-`O3 8 hrs (ppm)`)

# Renombrar las columnas para que coincidan con el archivo 'agua_santa_2023.csv'
colnames(data) <- c("FECHA", "Horas", "O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")

# Convertir la columna 'FECHA' al formato adecuado (día/mes/año)
data$FECHA <- format(as.Date(data$FECHA, format="%Y-%m-%d"), "%d/%m/%Y")


# Convertir las columnas numéricas que tienen valores como texto a tipo numérico
cols_to_convert <- c("O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")


# aplica la función as.numeric a cada una de las columnas seleccionadas. 
# lapply devuelve una lista donde cada elemento es el resultado de  aplicar as.numeric a las columnas, 
# convirtiéndolas a numérico.

data[cols_to_convert] <- lapply(data[cols_to_convert], as.numeric)

# Reemplazar los NA por el promedio de cada columna
# Dentro de mutate, across se utiliza para aplicar una función a las columnas especificadas en cols_to_convert.
# all_of(cols_to_convert) asegura que se utilicen las columnas especificadas en cols_to_convert.
# ~ replace_na(., mean(., na.rm = TRUE)) es una fórmula que define la operación a realizar en cada columna seleccionada. 
# replace_na(., mean(., na.rm = TRUE)) reemplaza los NA en cada columna (.) con el promedio de la columna, 
# calculado con mean(., na.rm = TRUE), donde na.rm = TRUE indica que se deben omitir los NA al calcular el promedio.
data <- data %>%
  mutate(across(all_of(cols_to_convert), ~ replace_na(., mean(., na.rm = TRUE))))


# Formatear los números (sin decimales para enteros, tres decimales para otros)
data <- data %>%
  mutate(across(all_of(cols_to_convert), ~ ifelse(round(.) == ., format(round(.)), format(round(., 3)))))


# Verificar los cambios
head(data)


na_count <- colSums(is.na(data))
na_count

# Guardar el dataframe limpio en un nuevo archivo CSV
write.csv(data, "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/AGUA SANTA/AGUA-SANTA-2022-limpiado.csv", row.names = FALSE)



# -------------------------------------------------------------
# DATOS 2020 - 2022
# BINE 2021
library(dplyr)
library(lubridate)
library(readr)

# Leer el archivo CSV
data <- read_csv("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/BINE/Datos_Bine_2021.csv")

# Convertir valores específicos a NA en las columnas adecuadas
data <- data %>%
  mutate(across(where(is.character), ~na_if(., "F.O."))) %>%
  mutate(across(where(is.character), ~na_if(., "D.I."))) %>%
  mutate(across(where(is.character), ~na_if(., "Mtto."))) %>%
  mutate(across(where(is.character), ~na_if(., "Mtto")))

# Eliminar la columna 'O3 8 hrs (ppm)'
data <- data %>% select(-`O3 8 hrs (ppm)`)

# Renombrar las columnas para que coincidan con el archivo 'agua_santa_2023.csv'
colnames(data) <- c("FECHA", "Horas", "O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")

# Convertir la columna 'FECHA' al formato adecuado (día/mes/año)
data$FECHA <- format(as.Date(data$FECHA, format="%Y-%m-%d"), "%d/%m/%Y")


# Convertir las columnas numéricas que tienen valores como texto a tipo numérico
cols_to_convert <- c("O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")


# aplica la función as.numeric a cada una de las columnas seleccionadas. 
# lapply devuelve una lista donde cada elemento es el resultado de  aplicar as.numeric a las columnas, 
# convirtiéndolas a numérico.

data[cols_to_convert] <- lapply(data[cols_to_convert], as.numeric)

# Reemplazar los NA por el promedio de cada columna
# Dentro de mutate, across se utiliza para aplicar una función a las columnas especificadas en cols_to_convert.
# all_of(cols_to_convert) asegura que se utilicen las columnas especificadas en cols_to_convert.
# ~ replace_na(., mean(., na.rm = TRUE)) es una fórmula que define la operación a realizar en cada columna seleccionada. 
# replace_na(., mean(., na.rm = TRUE)) reemplaza los NA en cada columna (.) con el promedio de la columna, 
# calculado con mean(., na.rm = TRUE), donde na.rm = TRUE indica que se deben omitir los NA al calcular el promedio.
data <- data %>%
  mutate(across(all_of(cols_to_convert), ~ replace_na(., mean(., na.rm = TRUE))))


# Formatear los números (sin decimales para enteros, tres decimales para otros)
data <- data %>%
  mutate(across(all_of(cols_to_convert), ~ ifelse(round(.) == ., format(round(.)), format(round(., 3)))))

na_count <- colSums(is.na(data))
na_count

# Guardar el dataframe limpio en un nuevo archivo CSV
write.csv(data, "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/BINE/BINE-2021-limpiado.csv", row.names = FALSE)

# -------------------------------------------------------------
# DATOS 2020 - 2022
# BINE 2021
library(dplyr)
library(lubridate)
library(readr)

# Leer el archivo CSV
data <- read_csv("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/BINE/Datos_Bine_2022.csv")

# Convertir valores específicos a NA en las columnas adecuadas
data <- data %>%
  mutate(across(where(is.character), ~na_if(., "F.O."))) %>%
  mutate(across(where(is.character), ~na_if(., "D.I."))) %>%
  mutate(across(where(is.character), ~na_if(., "Mtto."))) %>%
  mutate(across(where(is.character), ~na_if(., "Mtto")))

# Eliminar la columna 'O3 8 hrs (ppm)'
data <- data %>% select(-`O3 8 hrs (ppm)`)

# Renombrar las columnas para que coincidan con el archivo 'agua_santa_2023.csv'
colnames(data) <- c("FECHA", "Horas", "O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")

# Convertir la columna 'FECHA' al formato adecuado (día/mes/año)
data$FECHA <- format(as.Date(data$FECHA, format="%Y-%m-%d"), "%d/%m/%Y")


# Convertir las columnas numéricas que tienen valores como texto a tipo numérico
cols_to_convert <- c("O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")


# aplica la función as.numeric a cada una de las columnas seleccionadas. 
# lapply devuelve una lista donde cada elemento es el resultado de  aplicar as.numeric a las columnas, 
# convirtiéndolas a numérico.

data[cols_to_convert] <- lapply(data[cols_to_convert], as.numeric)

# Reemplazar los NA por el promedio de cada columna
# Dentro de mutate, across se utiliza para aplicar una función a las columnas especificadas en cols_to_convert.
# all_of(cols_to_convert) asegura que se utilicen las columnas especificadas en cols_to_convert.
# ~ replace_na(., mean(., na.rm = TRUE)) es una fórmula que define la operación a realizar en cada columna seleccionada. 
# replace_na(., mean(., na.rm = TRUE)) reemplaza los NA en cada columna (.) con el promedio de la columna, 
# calculado con mean(., na.rm = TRUE), donde na.rm = TRUE indica que se deben omitir los NA al calcular el promedio.
data <- data %>%
  mutate(across(all_of(cols_to_convert), ~ replace_na(., mean(., na.rm = TRUE))))


# Formatear los números (sin decimales para enteros, tres decimales para otros)
data <- data %>%
  mutate(across(all_of(cols_to_convert), ~ ifelse(round(.) == ., format(round(.)), format(round(., 3)))))

na_count <- colSums(is.na(data))
na_count

# Guardar el dataframe limpio en un nuevo archivo CSV
write.csv(data, "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/BINE/BINE-2022-limpiado.csv", row.names = FALSE)

# -------------------------------------------------------------
# DATOS 2020 - 2022
# NINFAS 2020
library(dplyr)
library(lubridate)
library(readr)

# Leer el archivo CSV
data <- read_csv("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/NINFAS/Datos_Ninfas_2020.csv")

# Convertir valores específicos a NA en las columnas adecuadas
data <- data %>%
  mutate(across(where(is.character), ~na_if(., "F.O."))) %>%
  mutate(across(where(is.character), ~na_if(., "D.I."))) %>%
  mutate(across(where(is.character), ~na_if(., "Mtto."))) %>%
  mutate(across(where(is.character), ~na_if(., "Mtto")))

# Eliminar la columna 'O3 8 hrs (ppm)'
data <- data %>% select(-`O3 8 hrs (ppm)`)

# Renombrar las columnas para que coincidan con el archivo 'agua_santa_2023.csv'
colnames(data) <- c("FECHA", "Horas", "O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")

# Convertir la columna 'FECHA' al formato adecuado (día/mes/año)
data$FECHA <- format(as.Date(data$FECHA, format="%Y-%m-%d"), "%d/%m/%Y")


# Convertir las columnas numéricas que tienen valores como texto a tipo numérico
cols_to_convert <- c("O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")


# aplica la función as.numeric a cada una de las columnas seleccionadas. 
# lapply devuelve una lista donde cada elemento es el resultado de  aplicar as.numeric a las columnas, 
# convirtiéndolas a numérico.

data[cols_to_convert] <- lapply(data[cols_to_convert], as.numeric)

# Reemplazar los NA por el promedio de cada columna
# Dentro de mutate, across se utiliza para aplicar una función a las columnas especificadas en cols_to_convert.
# all_of(cols_to_convert) asegura que se utilicen las columnas especificadas en cols_to_convert.
# ~ replace_na(., mean(., na.rm = TRUE)) es una fórmula que define la operación a realizar en cada columna seleccionada. 
# replace_na(., mean(., na.rm = TRUE)) reemplaza los NA en cada columna (.) con el promedio de la columna, 
# calculado con mean(., na.rm = TRUE), donde na.rm = TRUE indica que se deben omitir los NA al calcular el promedio.
data <- data %>%
  mutate(across(all_of(cols_to_convert), ~ replace_na(., mean(., na.rm = TRUE))))


# Formatear los números (sin decimales para enteros, tres decimales para otros)
data <- data %>%
  mutate(across(all_of(cols_to_convert), ~ ifelse(round(.) == ., format(round(.)), format(round(., 3)))))

na_count <- colSums(is.na(data))
na_count

# Guardar el dataframe limpio en un nuevo archivo CSV
write.csv(data, "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/NINFAS/NINFAS-2020-limpiado.csv", row.names = FALSE)



# -------------------------------------------------------------
# DATOS 2020 - 2022
# NINFAS 2021
library(dplyr)
library(lubridate)
library(readr)

# Leer el archivo CSV
data <- read_csv("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/NINFAS/Datos_Ninfas_2021.csv")

# Convertir valores específicos a NA en las columnas adecuadas
data <- data %>%
  mutate(across(where(is.character), ~na_if(., "F.O."))) %>%
  mutate(across(where(is.character), ~na_if(., "D.I."))) %>%
  mutate(across(where(is.character), ~na_if(., "Mtto."))) %>%
  mutate(across(where(is.character), ~na_if(., "Mtto")))

# Eliminar la columna 'O3 8 hrs (ppm)'
data <- data %>% select(-`O3 8 hrs (ppm)`)

# Renombrar las columnas para que coincidan con el archivo 'agua_santa_2023.csv'
colnames(data) <- c("FECHA", "Horas", "O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")

# Convertir la columna 'FECHA' al formato adecuado (día/mes/año)
data$FECHA <- format(as.Date(data$FECHA, format="%Y-%m-%d"), "%d/%m/%Y")


# Convertir las columnas numéricas que tienen valores como texto a tipo numérico
cols_to_convert <- c("O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")


# aplica la función as.numeric a cada una de las columnas seleccionadas. 
# lapply devuelve una lista donde cada elemento es el resultado de  aplicar as.numeric a las columnas, 
# convirtiéndolas a numérico.

data[cols_to_convert] <- lapply(data[cols_to_convert], as.numeric)

# Reemplazar los NA por el promedio de cada columna
# Dentro de mutate, across se utiliza para aplicar una función a las columnas especificadas en cols_to_convert.
# all_of(cols_to_convert) asegura que se utilicen las columnas especificadas en cols_to_convert.
# ~ replace_na(., mean(., na.rm = TRUE)) es una fórmula que define la operación a realizar en cada columna seleccionada. 
# replace_na(., mean(., na.rm = TRUE)) reemplaza los NA en cada columna (.) con el promedio de la columna, 
# calculado con mean(., na.rm = TRUE), donde na.rm = TRUE indica que se deben omitir los NA al calcular el promedio.
data <- data %>%
  mutate(across(all_of(cols_to_convert), ~ replace_na(., mean(., na.rm = TRUE))))


# Formatear los números (sin decimales para enteros, tres decimales para otros)
data <- data %>%
  mutate(across(all_of(cols_to_convert), ~ ifelse(round(.) == ., format(round(.)), format(round(., 3)))))

na_count <- colSums(is.na(data))
na_count

# Guardar el dataframe limpio en un nuevo archivo CSV
write.csv(data, "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/NINFAS/NINFAS-2021-limpiado.csv", row.names = FALSE)


# -------------------------------------------------------------
# DATOS 2020 - 2022
# NINFAS 2022
library(dplyr)
library(lubridate)
library(readr)

# Leer el archivo CSV
data <- read_csv("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/NINFAS/Datos_Ninfas_2022.csv")

# Convertir valores específicos a NA en las columnas adecuadas
data <- data %>%
  mutate(across(where(is.character), ~na_if(., "F.O."))) %>%
  mutate(across(where(is.character), ~na_if(., "D.I."))) %>%
  mutate(across(where(is.character), ~na_if(., "Mtto."))) %>%
  mutate(across(where(is.character), ~na_if(., "Mtto")))

# Eliminar la columna 'O3 8 hrs (ppm)'
data <- data %>% select(-`O3 8 hrs (ppm)`)

# Renombrar las columnas para que coincidan con el archivo 'agua_santa_2023.csv'
colnames(data) <- c("FECHA", "Horas", "O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")

# Convertir la columna 'FECHA' al formato adecuado (día/mes/año)
data$FECHA <- format(as.Date(data$FECHA, format="%Y-%m-%d"), "%d/%m/%Y")


# Convertir las columnas numéricas que tienen valores como texto a tipo numérico
cols_to_convert <- c("O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")


# aplica la función as.numeric a cada una de las columnas seleccionadas. 
# lapply devuelve una lista donde cada elemento es el resultado de  aplicar as.numeric a las columnas, 
# convirtiéndolas a numérico.

data[cols_to_convert] <- lapply(data[cols_to_convert], as.numeric)

# Reemplazar los NA por el promedio de cada columna
# Dentro de mutate, across se utiliza para aplicar una función a las columnas especificadas en cols_to_convert.
# all_of(cols_to_convert) asegura que se utilicen las columnas especificadas en cols_to_convert.
# ~ replace_na(., mean(., na.rm = TRUE)) es una fórmula que define la operación a realizar en cada columna seleccionada. 
# replace_na(., mean(., na.rm = TRUE)) reemplaza los NA en cada columna (.) con el promedio de la columna, 
# calculado con mean(., na.rm = TRUE), donde na.rm = TRUE indica que se deben omitir los NA al calcular el promedio.
data <- data %>%
  mutate(across(all_of(cols_to_convert), ~ replace_na(., mean(., na.rm = TRUE))))


# Formatear los números (sin decimales para enteros, tres decimales para otros)
data <- data %>%
  mutate(across(all_of(cols_to_convert), ~ ifelse(round(.) == ., format(round(.)), format(round(., 3)))))

na_count <- colSums(is.na(data))
na_count

# Guardar el dataframe limpio en un nuevo archivo CSV
write.csv(data, "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/NINFAS/NINFAS-2022-limpiado.csv", row.names = FALSE)



# -------------------------------------------------------------
# DATOS 2020 - 2022
# UTP 2020
library(dplyr)
library(lubridate)
library(readr)

# Leer el archivo CSV
data <- read_csv("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/UTP/Datos_UTP_2020.csv")

# Convertir valores específicos a NA en las columnas adecuadas
data <- data %>%
  mutate(across(where(is.character), ~na_if(., "F.O."))) %>%
  mutate(across(where(is.character), ~na_if(., "D.I."))) %>%
  mutate(across(where(is.character), ~na_if(., "Mtto."))) %>%
  mutate(across(where(is.character), ~na_if(., "Mtto")))

# Eliminar la columna 'O3 8 hrs (ppm)'
data <- data %>% select(-`O3 8 hrs (ppm)`)

# Renombrar las columnas para que coincidan con el archivo 'agua_santa_2023.csv'
colnames(data) <- c("FECHA", "Horas", "O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")

# Convertir la columna 'FECHA' al formato adecuado (día/mes/año)
data$FECHA <- format(as.Date(data$FECHA, format="%Y-%m-%d"), "%d/%m/%Y")


# Convertir las columnas numéricas que tienen valores como texto a tipo numérico
cols_to_convert <- c("O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")


# aplica la función as.numeric a cada una de las columnas seleccionadas. 
# lapply devuelve una lista donde cada elemento es el resultado de  aplicar as.numeric a las columnas, 
# convirtiéndolas a numérico.

data[cols_to_convert] <- lapply(data[cols_to_convert], as.numeric)

# Reemplazar los NA por el promedio de cada columna
# Dentro de mutate, across se utiliza para aplicar una función a las columnas especificadas en cols_to_convert.
# all_of(cols_to_convert) asegura que se utilicen las columnas especificadas en cols_to_convert.
# ~ replace_na(., mean(., na.rm = TRUE)) es una fórmula que define la operación a realizar en cada columna seleccionada. 
# replace_na(., mean(., na.rm = TRUE)) reemplaza los NA en cada columna (.) con el promedio de la columna, 
# calculado con mean(., na.rm = TRUE), donde na.rm = TRUE indica que se deben omitir los NA al calcular el promedio.
data <- data %>%
  mutate(across(all_of(cols_to_convert), ~ replace_na(., mean(., na.rm = TRUE))))


# Formatear los números (sin decimales para enteros, tres decimales para otros)
data <- data %>%
  mutate(across(all_of(cols_to_convert), ~ ifelse(round(.) == ., format(round(.)), format(round(., 3)))))

na_count <- colSums(is.na(data))
na_count

# Guardar el dataframe limpio en un nuevo archivo CSV
write.csv(data, "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/UTP/UTP-2020-limpiado.csv", row.names = FALSE)




# -------------------------------------------------------------
# DATOS 2020 - 2022
# UTP 2021
library(dplyr)
library(lubridate)
library(readr)

# Leer el archivo CSV
data <- read_csv("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/UTP/Datos_UTP_2021.csv")

# Convertir valores específicos a NA en las columnas adecuadas
data <- data %>%
  mutate(across(where(is.character), ~na_if(., "F.O."))) %>%
  mutate(across(where(is.character), ~na_if(., "D.I."))) %>%
  mutate(across(where(is.character), ~na_if(., "Mtto."))) %>%
  mutate(across(where(is.character), ~na_if(., "Mtto")))

# Eliminar la columna 'O3 8 hrs (ppm)'
data <- data %>% select(-`O3 8 hrs (ppm)`)

# Renombrar las columnas para que coincidan con el archivo 'agua_santa_2023.csv'
colnames(data) <- c("FECHA", "Horas", "O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")

# Convertir la columna 'FECHA' al formato adecuado (día/mes/año)
data$FECHA <- format(as.Date(data$FECHA, format="%Y-%m-%d"), "%d/%m/%Y")


# Convertir las columnas numéricas que tienen valores como texto a tipo numérico
cols_to_convert <- c("O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")


# aplica la función as.numeric a cada una de las columnas seleccionadas. 
# lapply devuelve una lista donde cada elemento es el resultado de  aplicar as.numeric a las columnas, 
# convirtiéndolas a numérico.

data[cols_to_convert] <- lapply(data[cols_to_convert], as.numeric)

# Reemplazar los NA por el promedio de cada columna
# Dentro de mutate, across se utiliza para aplicar una función a las columnas especificadas en cols_to_convert.
# all_of(cols_to_convert) asegura que se utilicen las columnas especificadas en cols_to_convert.
# ~ replace_na(., mean(., na.rm = TRUE)) es una fórmula que define la operación a realizar en cada columna seleccionada. 
# replace_na(., mean(., na.rm = TRUE)) reemplaza los NA en cada columna (.) con el promedio de la columna, 
# calculado con mean(., na.rm = TRUE), donde na.rm = TRUE indica que se deben omitir los NA al calcular el promedio.
data <- data %>%
  mutate(across(all_of(cols_to_convert), ~ replace_na(., mean(., na.rm = TRUE))))


# Formatear los números (sin decimales para enteros, tres decimales para otros)
data <- data %>%
  mutate(across(all_of(cols_to_convert), ~ ifelse(round(.) == ., format(round(.)), format(round(., 3)))))

na_count <- colSums(is.na(data))
na_count

# Guardar el dataframe limpio en un nuevo archivo CSV
write.csv(data, "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/UTP/UTP-2021-limpiado.csv", row.names = FALSE)



# -------------------------------------------------------------
# DATOS 2020 - 2022
# UTP 2022
library(dplyr)
library(lubridate)
library(readr)

# Leer el archivo CSV
data <- read_csv("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/UTP/Datos_UTP_2022.csv")

# Convertir valores específicos a NA en las columnas adecuadas
data <- data %>%
  mutate(across(where(is.character), ~na_if(., "F.O."))) %>%
  mutate(across(where(is.character), ~na_if(., "D.I."))) %>%
  mutate(across(where(is.character), ~na_if(., "Mtto."))) %>%
  mutate(across(where(is.character), ~na_if(., "Mtto")))

# Eliminar la columna 'O3 8 hrs (ppm)'
data <- data %>% select(-`O3 8 hrs (ppm)`)

# Renombrar las columnas para que coincidan con el archivo 'agua_santa_2023.csv'
colnames(data) <- c("FECHA", "Horas", "O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")

# Convertir la columna 'FECHA' al formato adecuado (día/mes/año)
data$FECHA <- format(as.Date(data$FECHA, format="%Y-%m-%d"), "%d/%m/%Y")


# Convertir las columnas numéricas que tienen valores como texto a tipo numérico
cols_to_convert <- c("O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")


# aplica la función as.numeric a cada una de las columnas seleccionadas. 
# lapply devuelve una lista donde cada elemento es el resultado de  aplicar as.numeric a las columnas, 
# convirtiéndolas a numérico.

data[cols_to_convert] <- lapply(data[cols_to_convert], as.numeric)

# Reemplazar los NA por el promedio de cada columna
# Dentro de mutate, across se utiliza para aplicar una función a las columnas especificadas en cols_to_convert.
# all_of(cols_to_convert) asegura que se utilicen las columnas especificadas en cols_to_convert.
# ~ replace_na(., mean(., na.rm = TRUE)) es una fórmula que define la operación a realizar en cada columna seleccionada. 
# replace_na(., mean(., na.rm = TRUE)) reemplaza los NA en cada columna (.) con el promedio de la columna, 
# calculado con mean(., na.rm = TRUE), donde na.rm = TRUE indica que se deben omitir los NA al calcular el promedio.
data <- data %>%
  mutate(across(all_of(cols_to_convert), ~ replace_na(., mean(., na.rm = TRUE))))


# Formatear los números (sin decimales para enteros, tres decimales para otros)
data <- data %>%
  mutate(across(all_of(cols_to_convert), ~ ifelse(round(.) == ., format(round(.)), format(round(., 3)))))

na_count <- colSums(is.na(data))
na_count

# Guardar el dataframe limpio en un nuevo archivo CSV
write.csv(data, "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/UTP/UTP-2022-limpiado.csv", row.names = FALSE)




# -------------------------------------------------------------
# DATOS 2020 - 2022
# VELODROMO 2020
library(dplyr)
library(lubridate)
library(readr)

# Leer el archivo CSV
data <- read_csv("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/VELODROMO/Datos_VEL_2022.csv")

# Convertir valores específicos a NA en las columnas adecuadas
data <- data %>%
  mutate(across(where(is.character), ~na_if(., "F.O."))) %>%
  mutate(across(where(is.character), ~na_if(., "D.I."))) %>%
  mutate(across(where(is.character), ~na_if(., "Mtto."))) %>%
  mutate(across(where(is.character), ~na_if(., "Mtto")))

# Eliminar la columna 'O3 8 hrs (ppm)'
data <- data %>% select(-`O3 8 hrs (ppm)`)

# Renombrar las columnas para que coincidan con el archivo 'agua_santa_2023.csv'
colnames(data) <- c("FECHA", "Horas", "O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")

# Convertir la columna 'FECHA' al formato adecuado (día/mes/año)
data$FECHA <- format(as.Date(data$FECHA, format="%Y-%m-%d"), "%d/%m/%Y")


# Convertir las columnas numéricas que tienen valores como texto a tipo numérico
cols_to_convert <- c("O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")


# aplica la función as.numeric a cada una de las columnas seleccionadas. 
# lapply devuelve una lista donde cada elemento es el resultado de  aplicar as.numeric a las columnas, 
# convirtiéndolas a numérico.

data[cols_to_convert] <- lapply(data[cols_to_convert], as.numeric)

# Reemplazar los NA por el promedio de cada columna
# Dentro de mutate, across se utiliza para aplicar una función a las columnas especificadas en cols_to_convert.
# all_of(cols_to_convert) asegura que se utilicen las columnas especificadas en cols_to_convert.
# ~ replace_na(., mean(., na.rm = TRUE)) es una fórmula que define la operación a realizar en cada columna seleccionada. 
# replace_na(., mean(., na.rm = TRUE)) reemplaza los NA en cada columna (.) con el promedio de la columna, 
# calculado con mean(., na.rm = TRUE), donde na.rm = TRUE indica que se deben omitir los NA al calcular el promedio.
data <- data %>%
  mutate(across(all_of(cols_to_convert), ~ replace_na(., mean(., na.rm = TRUE))))


# Formatear los números (sin decimales para enteros, tres decimales para otros)
data <- data %>%
  mutate(across(all_of(cols_to_convert), ~ ifelse(round(.) == ., format(round(.)), format(round(., 3)))))

na_count <- colSums(is.na(data))
na_count

# Guardar el dataframe limpio en un nuevo archivo CSV
write.csv(data, "~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/VELODROMO/VELO-2022-limpiado.csv", row.names = FALSE)
