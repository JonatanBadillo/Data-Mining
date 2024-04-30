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
str(flight_data)

# Preprocesamiento de datos
# Convertir variables a los formatos adecuados

# Convertir la fecha al formato "DD-MM-YYYY"
flight_data$FL_DATE <- as.Date(flight_data$FL_DATE, format = "%m/%d/%Y")
# Luego, formatear la fecha al formato "DD-MM-YYYY"
flight_data$FL_DATE <- format(flight_data$FL_DATE, "%d-%m-%Y")


# convertir las variables CARRIER, DEST, ORIGIN, TAIL_NUM, y Flight.Status a factores utilizando la función as.factor(). 
# Esto para tratar estas variables como categorías en análisis posteriores, en lugar de como variables continuas.
flight_data$CARRIER <- as.factor(flight_data$CARRIER)
flight_data$DEST <- as.factor(flight_data$DEST)
flight_data$ORIGIN <- as.factor(flight_data$ORIGIN)
flight_data$TAIL_NUM <- as.factor(flight_data$TAIL_NUM)
flight_data$Flight.Status <- as.factor(flight_data$Flight.Status)

# Transformar DAY_WEEK en una variable categórica
flight_data$DAY_WEEK <- factor(flight_data$DAY_WEEK, levels = 1:7,
                               labels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))


