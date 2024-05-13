# Ejemplo de regresión con máquinas de soporte vectorial

# Primero haremos una regresión lineal simple, luego pasaremos a la regresión con SVM para
# que puedas ver cómo se comportan los dos con los mismos datos.


# Un conjunto de datos simple
# Para empezar, usaremos este conjunto de datos simple:


# Paso 1: regresión lineal simple en R
# Aquí están los mismos datos en formato CSV, los guardamos en el archivo regression.csv:

data <- read.csv('regression.csv')
View(data)

# Plot the data
plot(data, pch=16)

# Create a linear regression model
model <- lm(Y ~ X, data)
summary(model)
# Add the fitted line
abline(model)



# Paso 2: ¿Qué tan buena es nuestra regresión?
#   Para poder comparar la regresión lineal con la regresión con SVM, primero necesitamos una
# forma de medir qué tan buena es.
# Para ello cambiaremos un poco nuestro código para visualizar cada predicción realizada por
# nuestro modelo.

plot(data, pch=16)
# make a prediction for each X
predictedY <- predict(model, data)
# display the predictions
points(data$X, predictedY, col = "blue", pch=4)



# Para cada punto de datos Xi, el modelo hace una predicción Ŷi que se muestra como una cruz
# azul en el gráfico. La única diferencia con el gráfico anterior es que los puntos no están
# conectados entre sí.
# Para medir qué tan bueno es nuestro modelo, calcularemos cuántos errores comete.

# Podemos comparar cada valor de Yi con el valor predicho asociado Ŷi y ver qué tan lejos están
# con una simple diferencia.
# Ten en cuenta que la expresión Ŷi− Yi es el error, si hacemos una predicción perfecta Ŷi
# seráigual a Yi y el error será cero.
# Si hacemos esto para cada punto de datos y sumamos el error tendremos la suma de los
# errores, y si tomamos la media obtendremos el error cuadrático medio (MSE, Mean Squared Error)

# Usando R podemos usar el siguiente código para calcular el RMSE:
rmse<-function(error){
      sqrt(mean(error^2))
      }
error<-model$residuals # Same as data$Y - predictedY
predictionRMSE<-rmse(error)
predictionRMSE
# Ahora sabemos que el RMSE de nuestro modelo de regresión lineal es 5.70. ¡Intentemos mejorarlo con SVM!


# Paso 3: Regresión con SVM
# Para crear un modelo SVM con R necesitarás el paquete e1071. 
# A continuación, se muestra el código para hacer predicciones de regresión con SVM:
library(e1071)
# La función elegirá automáticamente SVM si detecta que los datos son categóricos (si la variable es un factor en R).
model1<-svm(Y ~ X, data)
predictedY<-predict(model1, data)
plot(data, pch=16)
points(data$X, predictedY, col = "red", pch=4)

# ¡Esta vez las predicciones están más cerca de los valores reales! Calculemos el RMSE de
# nuestro modelo de regresión con SVM.
error<-data$Y - predictedY
svmPredictionRMSE<-rmse(error)
svmPredictionRMSE

# Como era de esperar, el RMSE es mejor: ahora es 3.15 en comparación con el 5.70 anterior.
# ¿Pero podemos hacerlo mejor?





# Paso 4: Ajustar tu modelo de regresión con SVM

# Para mejorar el rendimiento de la regresión con SVM necesitaremos seleccionar los mejores
# parámetros para el modelo.
# En nuestro ejemplo anterior, realizamos una regresión épsilon, no establecimos ningún valor
# para épsilon (ε), pero se tomó un valor predeterminado de 0.1. También hay un parámetro de
# costo que podemos cambiar para evitar el sobreajuste.
# El proceso de elección de estos parámetros se denomina optimización de hiperparámetros o
# selección del modelo.

# perform a grid search
# Usamos el método tune para entrenar modelos con ε = 0, 0.1, 0.2,...,1 y costo = 22, 23, 24, ...,29
# lo que significa que entrenará 88 modelos (puede llevar mucho tiempo).
tuneResult <- tune(svm, Y ~ X, data = data,ranges = list(epsilon = seq(0,1,0.1), cost = 2^(2:9)))
# tuneResult devuelve el MSE, no olvides convertirlo a RMSE antes de comparar el
# valor con nuestro modelo anterior.
print(tuneResult)

# Draw the tuning graph
plot(tuneResult)
# En este gráfico podemos ver que cuanto más oscura es la región, mejor es nuestro modelo
# (porque el RMSE está más cerca de cero en las regiones más oscuras).



# Esto significa que podemos intentar otra búsqueda en la rejilla en un rango más estrecho,
# intentaremos con valores de ε entre 0 y 0.2. No parece que el valor del costo esté teniendo
# efecto por el momento así que lo mantendremos como está para ver si cambia.
# perform a grid search

# Entrenamos diferentes 168 modelos con este pequeño fragmento de código.
# A medida que nos acercamos dentro de la región oscura, podemos ver que hay varios parches
# más oscuros.
# En el gráfico puedes ver que los modelos con C entre 200 y 300 y ε entre 0.08 y 0.09 tienen
# menos error.


