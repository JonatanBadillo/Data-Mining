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

# Eliminar etiquetas
# Se han creado los conjuntos de datos htr y hts. Ahora almacenamos las etiquetas de datos de
# Entrenamiento y Prueba en dos vectores, trLabels y tsLabels y luego eliminamos la columna
# Creditability de los conjuntos de datos htr y hts.
trLabels <- htr$Creditability
tsLabels <- hts$Creditability
htr <- htr[,-1]
hts <- hts[,-1]

# Crea una función para normalizar Ahora creamos una función para normalizar cualquier
# columna
normalize <- function(x) return( (x-min(x))/(max(x)-min(x)))

# Vamos a crear un frame de datos
d <- data.frame("col1"=c(1,3,7), "col2"=c(2,6,4))
print(d,row.names=F)


# Para normalizar las dos columnas, necesitamos usar lapply (list apply), de la siguiente
# manera.
dn <- lapply(d,normalize)
dn <- as.data.frame(dn)
print(dn,row.names=F)

# También podemos usar lapply para redondear los valores de la columna a 2 decimales
dn <- as.data.frame(lapply(dn,round,2))
print(dn,row.names=F)

# Ahora normaliza las columnas de htr y hts
htr <- as.data.frame(lapply(htr,normalize))
hts <- as.data.frame(lapply(hts,normalize))

summary(htr[,c(2,5,13)])
summary(hts[,c(2,5,13)])

# Funciones para evaluar la eficiencia k-NN

# splitFile: para dividir datos en conjuntos de entrenamiento y prueba en una proporción dada

# Dividir el archivo de datos en conjuntos de datos de entrenamiento y prueba
splitFile <- function(dataSet, trProp,classCol) {
  v <- dataSet[,classCol]
  sg0 <- which(v==0)
  sg1 <- which(v==1)
  sg0tr <- sample(sg0,length(sg0)*trProp)
  sg1tr <- sample(sg1,length(sg1)*trProp)
  sg0ts <- sg0[!sg0 %in% sg0tr]
  sg1ts <- sg1[!sg1 %in% sg1tr]
  htr <- rbind(dataSet[sg0tr,],dataSet[sg1tr,])
  hts <- rbind(dataSet[sg0ts,],dataSet[sg1ts,])
  trLabels <- htr[,classCol]
  tsLabels <- hts[,classCol]
  htr <- htr[,-which(names(htr) == classCol)]
  hts <- hts[,-which(names(hts) == classCol)]
  return(list(tr=htr,ts=hts,trL=trLabels,tsL=tsLabels))
}


# Dividir el conjunto de datos usando splitFile
a <- splitFile(h,.6,'Creditability')
trData <- a[[1]]
tsData <- a[[2]]
trL <- a[[3]]
tsL <- a[[4]]
table(trL)

table(tsL)


# Realiza una clasificación k-NN
a <- splitFile(h,.6,'Creditability')
trData <- a[[1]]
tsData <- a[[2]]
trLabels <- a[[3]]
tsLabels <- a[[4]]
tsPred <- knn(trData, tsData, trLabels, k=3)

#CrossTable(tsLabels, tsPred)
table(tsLabels,tsPred)



accu0 <- length(which(tsLabels==tsPred)==TRUE)/length(tsLabels)
sens0 <- length(which((tsLabels==tsPred) & (tsLabels==0))) / length(which(tsLabels==0))
spec0 <- length(which((tsLabels==tsPred) & (tsLabels==1))) / length(which(tsLabels==1))

cat("Accuracy=",round(accu0,2),'\n',"Sensitivity=",round(sens0,2),'\n',"Specificity=",round(spec0,2))

# Elegir el mejor valor de k
# Función para generar tasas de error de entrenamiento y prueba para varios k
bestK <- function(trData, trLabels, tsData, tsLabels) {
  ctr <- c(); cts <- c()
  for (k in 1:20) {
    knnTr <- knn(trData, trData, trLabels, k)
    knnTs <- knn(trData, tsData, trLabels, k)
    trTable <- prop.table(table(knnTr, trLabels))
    tsTable <- prop.table(table(knnTs, tsLabels))
    erTr <- trTable[1,2] + trTable[2,1]
    erTs <- tsTable[1,2] + tsTable[2,1]
    ctr <- c(ctr,erTr)
    cts <- c(cts,erTs)
  }
  #acc <- data.frame(k=1/c(1:100), trER=ctr, tsER=cts)
  err <- data.frame(k=1:20, trER=ctr, tsER=cts)
  return(err)
}
# Invoca la función bestK para crear un conjunto de datos y graficar índices de error de prueba
# y entrenamiento para varios valores de k
err <- bestK(trData, trLabels, tsData, tsLabels)
plot(err$k,err$trER,type='o',ylim=c(0,.5),xlab="k",ylab="Error rate",col="blue")
lines(err$k,err$tsER,type='o',col="red")
