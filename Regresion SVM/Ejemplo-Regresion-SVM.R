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