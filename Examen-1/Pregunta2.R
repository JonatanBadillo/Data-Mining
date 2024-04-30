# 2. Predecir vuelos retrasados. 
# El archivo FlightDelays.csv contiene información sobre todos los vuelos comerciales que salen del área de Washington, DC y llegan a Nueva York 
# durante enero de 2004. 
# Para cada vuelo, hay información sobre los aeropuertos de salida y llegada, la distancia de la ruta, la hora programada y fecha del vuelo, etc.
# La variable que intentamos predecir es si un vuelo se retrasa o no. 
# Un retraso se define como una llegada que se retrasa al menos 15 minutos de lo programado.

# Preprocesamiento de datos. Transforma la información del día de la semana (DAY_WEEK) en una variable categórica. 
# Agrupa la hora de salida programada en ocho compartimentos (en R usa la función cut()). 
# Utiliza estas y todas las demás columnas como predictores (excepto DAY_OF_MONTH). 
# Divide los datos en conjuntos de entrenamiento y validación.
# Ajusta un árbol de clasificación a la variable de retraso de vuelo utilizando todos los predictores relevantes. 
# No incluyas DEP_TIME (hora de salida real) en el modelo porque se desconoce en el momento de la predicción 
# (a menos que estemos generando nuestras predicciones de retrasos después del despegue del avión, lo cual es poco probable).

# Cargar el archivo CSV
flight_data <- read.csv("FlightDelays.csv")
head(flight_data)  # Ver los primeros registros
summary(flight_data)  # Resumen 