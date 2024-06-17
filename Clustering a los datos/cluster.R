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

# Revisar los primeros datos para confirmar que están bien cargados
head(data)

# Normalizar las columnas numéricas
data_scaled <- scale(data[, c("O3", "NO2", "CO", "SO2", "PM-10", "PM-2.5")])


# Paso 3: Aplicar k-means clustering
# aplicaremos k-means clustering a los datos normalizados. 
# decidir el número de clusters (k), utilizando el método del codo (elbow method).

# Método del codo para determinar el número óptimo de clusters
set.seed(123) 
wss <- (nrow(data_scaled)-1)*sum(apply(data_scaled, 2, var))
for (i in 2:15) wss[i] <- sum(kmeans(data_scaled, centers=i)$withinss)

# Graficar el método del codo
# El "codo" en la gráfica te dará una idea del número óptimo de clusters. Supongamos que decidimos usar 3 clusters.
plot(1:15, wss, type="b", xlab="Número de Clusters", ylab="Suma de Cuadrados Dentro de los Clusters (WSS)")

# sugiere que lo ideal sean hasta 4 o 5 clusters

