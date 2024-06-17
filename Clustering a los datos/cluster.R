library(readr)
data <- read_csv("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/NINFAS/NINFAS-2023-limpiado.csv")
View(data)

# las columnas que representan variables numéricas sean de tipo numérico
data$O3 <- as.numeric(data$O3)
data$NO2 <- as.numeric(data$NO2)
data$CO <- as.numeric(data$CO)
data$SO2 <- as.numeric(data$SO2)
data$`PM-10` <- as.numeric(data$`PM-10`)
data$`PM-2.5` <- as.numeric(data$`PM-2.5`)

# Revisar los primeros datos para confirmar que están bien cargados
head(data)


