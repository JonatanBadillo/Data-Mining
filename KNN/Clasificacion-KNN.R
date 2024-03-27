# Clasificación con k-NN

# Matriz de confusión

# Una matriz de confusión muestra el número de predicciones correctas e incorrectas realizadas
# por el modelo de clasificación en comparación con los resultados reales (valor objetivo) en
# los datos.

# El algoritmo k-NN
  # • El algoritmo k-NN recibe su nombre del hecho de que utiliza información sobre los
  # k vecinos más cercanos para clasificar ejemplos no etiquetados.
  # • k es un término variable que implica que se podría usar cualquier número de vecinos
  # más cercanos.
  # • Para cada registro no etiquetado en el conjunto de datos de prueba, k-NN identifica k
  # registros en el conjunto de datos de entrenamiento que son “más cercanos” en
  # similitud.
  # • A la instancia de prueba sin etiqueta se le asigna la clase de la mayoría de los k vecinos
  # más cercanos.


# Un ejemplo de clasificación k-NN

# Leer el archivo y mostrar el resumen (se utilizó R versión 4.0.4)
library(class)
file <-"german_credit.csv"
h<-read.csv(file)
head(h,4)