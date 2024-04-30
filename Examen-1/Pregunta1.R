# 1. Utiliza el archivo weather1.csv. Totalmente ficticio, supuestamente se refiere a las condiciones climáticas 
# que son adecuadas para jugar un juego no especificado. Hay cuatro variables predictoras: 
#   outlook, 
#   temperature, 
#   humidity  
#   wind. 
# El resultado es si jugar ("yes", "no", "maybe"). 
# Utiliza alguno de los métodos de clasificación vistos hasta ahora, para construir un clasificador 
# que aprenda cómo varias variables predictoras podrían relacionarse con el resultado. 
# Informa de la precisión de tu modelo.


library(tidyverse)
# Cargar el archivo CSV
weather_data <- read.csv("weather1.csv")

glimpse(weather_data)
head(weather_data)  # Ver los primeros registros
summary(weather_data)  # Resumen 

# Dividir los datos en conjuntos de entrenamiento y prueba. 
# El conjunto de entrenamiento se usara para construir el modelo
# mientras que el conjunto de prueba se utilizara para evaluar su rendimiento.

set.seed(123) 
# sample se utiliza para seleccionar una muestra aleatoria de índices de fila del conjunto de datos. 
# La muestra se toma del conjunto de índices que va desde 1 hasta el número total de filas (1:nrow(weather_data)),
# y el tamaño de la muestra es el 80% del número total de filas (0.8 * nrow(weather_data)).
train_index <- sample(1:nrow(weather_data), 0.8 * nrow(weather_data))  # Índices de entrenamiento

# Conjunto de entrenamiento
train_data <- weather_data[train_index, ] # selecciona las filas especificadas en train_index.
# Conjunto de prueba
test_data <- weather_data[-train_index, ] 



