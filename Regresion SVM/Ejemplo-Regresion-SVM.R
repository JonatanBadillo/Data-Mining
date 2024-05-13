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
# Podemos comparar cada valor de Yi con el valor predicho asociado Ŷ
# 
# i y ver qué tan lejos están
# 
# con una simple diferencia.
# Ten en cuenta que la expresión Ŷ
# 
# i− Yi es el error, si hacemos una predicción perfecta Ŷ
# i
# será
# 
# igual a Yi y el error será cero.
# Si hacemos esto para cada punto de datos y sumamos el error tendremos la suma de los
# errores, y si tomamos la media obtendremos el error cuadrático medio (MSE, Mean Squared
#                                                                       Error)
