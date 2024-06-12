# Importacion de Datos
library(readr)
data <- read_csv("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/NINFAS/NINFAS-2023.csv")
View(data)

library(dplyr)
library(tidyr)

# Ver las primeras filas del dataframe
head(data)

summary(data)

# Convertir valores específicos a NA
data[data == "F.O." | data == "D.I." | data == "Mtto." | data == "Mtto"] <- NA

# Ver las primeras filas del dataframe
head(data)


# Convertir las columnas numéricas que tienen valores como texto a tipo numérico
cols_to_convert <- c("O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")
data[cols_to_convert] <- lapply(data[cols_to_convert], as.numeric)

# Reemplazar los NA por el promedio de cada columna
data <- data %>%
  mutate(across(all_of(cols_to_convert), ~ replace_na(., mean(., na.rm = TRUE))))

# Verificar los cambios
head(data)





