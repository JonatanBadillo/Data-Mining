library(readr)
data <- read_csv("~/Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Datos/NINFAS/NINFAS-2023-limpiado.csv")
View(data)

# las columnas que representan variables numéricas sean de tipo numérico
data$O3 <- as.numeric(data$O3)
data$NO2 <- as.numeric(data$NO2)
data$CO <- as.numeric(data$CO)
data$SO2 <- as.numeric(data$SO2)
data$`PM-10` <- as.numeric(data$`PM-10`)
data$`PM-2.5` <- as.numeric(data$`PM-2.5`)

# revisar los primeros datos para confirmar que están bien cargados
head(data)

# Normalizar las columnas numéricas
data_scaled <- scale(data[, c("O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")])


# Aplicar k-means clustering

# aplicaremos k-means clustering a los datos normalizados. 
# decidir el número de clusters (k), utilizando el método del codo (elbow method).
# calcular la suma de los cuadrados dentro de los clusters (WSS) para diferentes valores de k (número de clusters). 
# Método del codo para determinar el número óptimo de clusters
set.seed(123) 
# suma de los cuadrados por cada grupo : wss

# Suma todas las varianzas calculadas de las características.
# Multiplica la suma de las varianzas por el número de observaciones menos uno. 
# inicializa el vector wss con el valor de la suma total de las varianzas de las características,por el número de observaciones.
wss <- (nrow(data_scaled)-1)*sum(apply(data_scaled, 2, var)) 

# Este bucle for itera sobre los valores de i desde 2 hasta 15
# Ejecuta el algoritmo k-means en el conjunto de datos data_scaled con i centros. 
# Calcula la suma de los valores de withinss para obtener el WSS total para i centros.
# Asigna el WSS calculado para i centros a la i-ésima posición del vector wss.
for (i in 2:15) wss[i] <- sum(kmeans(data_scaled, centers=i)$withinss)





# Graficar el método del codo
# El "codo" en la gráfica dará una idea del número óptimo de clusters. 
plot(1:15, wss, type="b", xlab="Número de Clusters", ylab="Suma de Cuadrados Dentro de los Clusters (WSS)")

# sugiere que lo ideal sean hasta 4 o 5 clusters


# Aplicar k-means con 4 clusters
set.seed(123) 
kmeans_result <- kmeans(data_scaled, centers=4)

# Agregar la asignación de clusters a los datos originales
data$cluster <- kmeans_result$cluster

# Ver los resultados
head(data)



# visualización
library(ggplot2)

# Crear un gráfico de pares coloreado por clusters
pairs(data[, c("O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")], col=data$cluster, pch=19)


# Calcular la media de cada variable para cada cluster
aggregate(data[, c("O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")], by=list(cluster=data$cluster), FUN=mean)


library(ggplot2)
ggplot(data, aes(x=factor(cluster), y=O3, fill=factor(cluster))) + geom_boxplot()
ggplot(data, aes(x=factor(cluster), y=NO2, fill=factor(cluster))) + geom_boxplot()



