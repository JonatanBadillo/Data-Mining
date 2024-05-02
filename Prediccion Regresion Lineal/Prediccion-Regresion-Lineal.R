# Predicción con regresión lineal

# Para iniciar, necesitamos instalar los siguientes paquetes (si ya está instalado, solo cárgalo!):
library(tidyverse)
library(mlr)
library(imputeTS)
library(prettydoc)


# Necesitamos cargar el conjunto de datos que utilizaremos para este ejemplo de predicción.
coffee=read.csv("coffee_data.csv")
names(coffee)


# Este es un conjunto de datos muy grande. Se pueden hacer muchas cosas, pero hoy
# predeciremos los puntos del total de tazas de café usando la regresión lineal.
install.packages("naniar")
library(naniar)

coffee=coffee %>% select_if(is.numeric)# Esta línea selecciona solo las columnas numéricas decoffee utilizando la función select_if()
                                       # La función is.numeric se utiliza como criterio para seleccionar solo aquellas columnas que son numéricas. 
                                       # El operador %>%, toma el resultado de la expresión a su izquierda y lo pasa como primer argumento a la función a su derecha.
vis_miss(coffee) # para visualizar los valores faltantes en el dataframe resultante.