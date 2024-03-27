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

summary(h)


# La división se puede encontrar de la siguiente manera:
table(h$Creditability)
# En esta tabla, 0 representa las instancias de mala acreditabilidad (instancias que han
# incumplido) y 1 representa las instancias de buena acreditabilidad (aquellas que no han incumplido).



# Dividir datos en conjuntos de entrenamiento y prueba en una proporción de 2:1
sg0 <- which(h$Creditability==0)
sg1 <- which(h$Creditability==1) # OR sg1 <- !sg0
# Selecciona aproximadamente el 66.67% de las muestras de la clase negativa (sg0) para el conjunto de entrenamiento 
sg0tr <- sample(sg0,length(sg0)*2/3) 
# Selecciona aproximadamente el 66.67% de las muestras de la clase positiva (sg1)
sg1tr <- sample(sg1,length(sg1)*2/3)
# Selecciona las muestras de la clase negativa que no están en el conjunto de entrenamiento (sg0tr)
sg0ts <- sg0[!sg0 %in% sg0tr]
# Selecciona las muestras de la clase positiva que no están en el conjunto de entrenamiento (sg1tr)
sg1ts <- sg1[!sg1 %in% sg1tr]

# se imprime la longitud de cada conjunto de entrenamiento y prueba para ambas clases (positiva y negativa).
cat("Training+",length(sg0tr),'\n',"Training",length(sg1tr),"\n",
      "Testing+",length(sg0ts),"\n","Testing-",length(sg1ts))


# Combinar los registros seleccionados para los conjuntos de datos de Entrenamiento y Prueba
htr <- rbind(h[sg0tr,],h[sg1tr,])
hts <- rbind(h[sg0ts,],h[sg1ts,])
table(htr$Creditability)


table(hts$Creditability)

