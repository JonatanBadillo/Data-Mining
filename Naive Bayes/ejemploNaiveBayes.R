# Ejemplo con Naive Bayes

# Ejemplo 1: Predecir vuelos retrasados
# El objetivo es predecir con precisión si se retrasará o no un nuevo
# vuelo (no en este conjunto de datos). La variable de resultado es si el vuelo se retrasó y, por
# lo tanto, tiene dos clases (1 = retrasado y 0 = puntual).

# Los datos se dividieron primero en conjuntos de entrenamiento (60%) y validación (40%), y
# luego se aplicó un clasificador Naïve Bayes al conjunto de entrenamiento (usamos el paquete e1071).

library(e1071)
delays.df <- read.csv("FlightDelays.csv")

# se cambian primero las variables numericas a categoricas
delays.df$DAY_WEEK <- factor(delays.df$DAY_WEEK)
delays.df$DEP_TIME <- factor(delays.df$DEP_TIME)