# Tarea de regresión lineal múltiple

# Predicción de beneficios de reventa de software
# Tayko Software es una empresa de catálogos de software que vende juegos y software
# educativo. Comenzó como un fabricante de software y luego agregó títulos de terceros a sus
# ofertas. Recientemente revisó su colección de artículos en un nuevo catálogo, que envió por
# correo a sus clientes. Este envío arrojó 2000 compras.
# Con base en estos datos, Tayko quiere crear un modelo para predecir la cantidad de gasto que
# producirá un cliente comprador. El archivo Tayko.csv contiene información sobre 2000
# compras. La siguiente tabla describe las variables que se utilizarán en el problema (el archivo
# de excel contiene variables adicionales).

# Descripción de variables para el ejemplo de software Tayko
# FREQ
# LAST_UPDATE
# WEB
# GENDER
# ADDRESS_RES
# ADDRESS_US
# SPENDING (response)

# Número de transacciones en el año anterior
# Número de días desde la última actualización del
# registro del cliente
# Si el cliente compró por pedido web al menos una vez
# Masculino o femenino
# Si es una dirección residencial
# Si es una dirección de EE. UU.
# Importe gastado por el cliente en envíos de prueba (edólares)





# a. Explora el monto del gasto creando una tabla dinámica para las variables categóricas
# y calcular el promedio y la desviación estándar del gasto en cada categoría.
# b. Explora la relación entre el gasto y cada uno de los dos continuos predictores
# mediante la creación de dos diagramas de dispersión (Spending vs Freq y Spending vs last_update_days_ago. ¿Parece haber una relación lineal?
#  c. Para ajustar un modelo predictivo de gastos:
#      i. Particiona los 2000 registros en conjuntos de entrenamiento y validación.
#      ii. Ejecuta un modelo de regresión lineal múltiple para Spending vs. los seis predictores. Dar la ecuación predictiva estimada.
#      iii. Con base en este modelo, ¿Qué tipo de comprador es más probable que gaste
#           una gran cantidad de dinero?
#      iv. Si usamos la eliminación hacia atrás para reducir el número de predictores,
#         que predictor se eliminaría primero del modelo?
#      v. Muestra cómo se calculan la predicción y el error de predicción para la primera compra en el conjunto de validación.




# Cargar y explorar los datos
# Primero, debemos cargar los datos y explorar las variables.
# Cargar las librerías necesarias
library(dplyr)
library(ggplot2)
library(caret)

# Cargar los datos
tayko_data <- read.csv("Tayko.csv")

# Visualizar los primeros registros del dataset
head(tayko_data)



# a. Crear una tabla dinámica para las variables categóricas
# Calcularemos el promedio y la desviación estándar del gasto (SPENDING) para cada categoría de las variables categóricas 
# (WEB, GENDER, ADDRESS_RES, ADDRESS_US).


# Mostrar los nombres de las columnas
colnames(tayko_data)

# Crear una función para calcular promedio y desviación estándar
summary_stats <- function(data, var) {
  data %>%
    group_by(!!sym(var)) %>%
    summarise(
      mean_spending = mean(Spending, na.rm = TRUE),
      sd_spending = sd(Spending, na.rm = TRUE)
    )
}

# Aplicar la función a las variables categóricas
categorical_vars <- c("Web.order", "Gender.male", "Address_is_res", "US")
lapply(categorical_vars, summary_stats, data = tayko_data)



# b. Explorar la relación entre el gasto y cada uno de los predictores continuos
# Creamos diagramas de dispersión para Spending vs Freq y Spending vs LAST_UPDATE.
# Diagrama de dispersión para Spending vs Freq
ggplot(tayko_data, aes(x = Freq, y = Spending)) +
  geom_point() +
  geom_smooth(method = "lm", col = "red") +
  labs(title = "Spending vs Freq", x = "Freq", y = "Spending")

# Diagrama de dispersión para Spending vs last_update_days_ago
ggplot(tayko_data, aes(x = last_update_days_ago, y = Spending)) +
  geom_point() +
  geom_smooth(method = "lm", col = "red") +
  labs(title = "Spending vs last_update_days_ago", x = "last_update_days_ago", y = "Spending")

# c. Ajustar un modelo predictivo de gastos
# i. Particionar los datos en conjuntos de entrenamiento y validación
# Particionar los datos en conjuntos de entrenamiento y validación
library(caret)
library(lattice)
set.seed(123)
training_index <- createDataPartition(tayko_data$Spending, p = 0.7, list = FALSE)
training_data <- tayko_data[training_index, ]
validation_data <- tayko_data[-training_index, ]


# ii. Ejecutar un modelo de regresión lineal múltiple
# Ajustar el modelo de regresión lineal múltiple
model <- lm(Spending ~ Freq + last_update_days_ago + Web.order + Gender.male + Address_is_res + US, data = training_data)
summary(model)

# iii. Analizar el tipo de comprador que gasta más
# Mostrar los coeficientes del modelo
coefficients(model)

# iv. Eliminar predictores usando eliminación hacia atrás
# Eliminar predictores no significativos usando eliminación hacia atrás
step_model <- step(model, direction = "backward")
summary(step_model)

# v. Calcular predicción y error de predicción para la primera compra en el conjunto de validación
# Predicción para la primera compra en el conjunto de validación
first_pred <- predict(step_model, newdata = validation_data[1, ])
first_actual <- validation_data$Spending[1]
prediction_error <- first_actual - first_pred

# Mostrar predicción y error
list(prediction = first_pred, actual = first_actual, error = prediction_error)

# vi. Evaluar la precisión predictiva del modelo
# Evaluar el modelo en el conjunto de validación
predictions <- predict(step_model, newdata = validation_data)
validation_results <- data.frame(
  actual = validation_data$Spending,
  predicted = predictions,
  residuals = validation_data$Spending - predictions
)

# Calcular el RMSE
rmse <- sqrt(mean(validation_results$residuals^2))
rmse


# vii. Crear un histograma de los residuos del modelo
# Crear histograma de los residuos
ggplot(validation_results, aes(x = residuals)) +
  geom_histogram(binwidth = 5, fill = "blue", color = "black") +
  labs(title = "Histograma de los Residuos", x = "Residuos", y = "Frecuencia")

# Evaluar si los residuos siguen una distribución normal
qqnorm(validation_results$residuals)
qqline(validation_results$residuals, col = "red")

shapiro.test(model$residuals)


plot(model,5)

# Distancia de cook
# ningun valor es influyente
# Esto es generalmente una situación favorable, ya que significa que el modelo 
# es robusto a la presencia de valores atípicos o influyentes.
cooks.distance(model)
which(cooks.distance(model) > 1)




# ----------------------- alternativa -------------------
# Transformación logarítmica de la variable de respuesta Spending
tayko_data$log_Spending <- log(tayko_data$Spending + 1) # Agregar 1 para evitar log(0)

# Particionar los datos en conjuntos de entrenamiento y validación nuevamente
set.seed(123)
training_index <- createDataPartition(tayko_data$log_Spending, p = 0.7, list = FALSE)
training_data <- tayko_data[training_index, ]
validation_data <- tayko_data[-training_index, ]

# Ajustar el modelo de regresión lineal múltiple con la variable transformada
model_log <- lm(log_Spending ~ Freq + last_update_days_ago + Web.order + Gender.male + Address_is_res + US, data = training_data)
summary(model_log)

# Evaluar el modelo en el conjunto de validación
log_predictions <- predict(model_log, newdata = validation_data)
validation_results_log <- data.frame(
  actual = validation_data$log_Spending,
  predicted = log_predictions,
  residuals = validation_data$log_Spending - log_predictions
)

# Calcular el RMSE para el modelo transformado
rmse_log <- sqrt(mean(validation_results_log$residuals^2))
rmse_log

# Crear QQ-plot para los residuos del modelo transformado
qqnorm(validation_results_log$residuals)
qqline(validation_results_log$residuals, col = "red")

# Crear histograma de los residuos del modelo transformado
ggplot(validation_results_log, aes(x = residuals)) +
  geom_histogram(binwidth = 0.1, fill = "blue", color = "black") +
  labs(title = "Histograma de los Residuos (Modelo Transformado)", x = "Residuos", y = "Frecuencia")

# Calcular el RMSE para el modelo transformado
rmse_log <- sqrt(mean(validation_results_log$residuals^2))
rmse_log

hist(model$residuals, color = "grey")s
