# Ejemplo de regresión con máquinas de soporte vectorial

# Primero haremos una regresión lineal simple, luego pasaremos a la regresión con SVM para
# que puedas ver cómo se comportan los dos con los mismos datos.


# Un conjunto de datos simple
# Para empezar, usaremos este conjunto de datos simple:


# Paso 1: regresión lineal simple en R
# Aquí están los mismos datos en formato CSV, los guardamos en el archivo regression.csv:

data <- read.csv('regression.csv')
View(data)

# > # Plot the data
plot(data, pch=16)

# > # Create a linear regression model
#   > model <- lm(Y ~ X, data)
# > # Add the fitted line
#   > abline(model)