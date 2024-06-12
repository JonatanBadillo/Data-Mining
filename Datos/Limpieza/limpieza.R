# Importacion de Datos
library(readr)
data <- read_csv("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/NINFAS/NINFAS-2023.csv")
View(data)

library(dplyr)


# Ver las primeras filas del dataframe
head(data)

summary(data)

# Convertir valores específicos a NA
data[data == "F.O." | data == "D.I." | data == "Mtto." | data == "Mtto"] <- NA

# Ver las primeras filas del dataframe
head(data)