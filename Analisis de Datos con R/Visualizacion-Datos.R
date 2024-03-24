# Gráfico de barras e histograma
data <- c(4,6,8,10,12,8)
barplot(data,xlab = "X-axis",ylab = "Y-axis",main = "Bar Chart 1", col = "green")

# Exportar el grafico como imagen
png(filename = "barchart.png", width = 800, height = 600)
barplot(data, xlab="x-axis", ylab="y-axis", main="bar chart 1", col="green")
dev.off()

# Grafica de barras horizontal
data <- c(4, 6, 7, 9, 10, 20, 12, 8)
barplot(data, xlab="x-axis", ylab="y-axis", main="bar chart 1",col = "green",horiz = TRUE)

# Diagrama de barras apiladas
data("mtcars")
data<-table(mtcars$gear,mtcars$carb)
data

barplot(data, xlab="x-axis", ylab="y-axis", main="bar chart 1", col=c("grey", "blue", "yellow"))

# Un gráfico de barras agrupadas
barplot(data, xlab="x-axis", ylab="y-axis", main="bar chart 1", col=c("grey", "blue", "yellow"),beside=TRUE)



# Histogramas
set.seed(123)
data1 <- rnorm(100, mean=5, sd=3)
hist(data1, main="histogram", xlab="x-axis", col="green",border="blue", breaks=10)


# Graficar un histograma con una línea de densidad
hist(data1, main="histogram", xlab="x-axis", col="green", border="blue", breaks=10,freq=FALSE)
lines(density(data1), col="red")

# Gráfico de líneas y gráfico circular
x <- c(1, 2, 3, 4, 5, 6, 8, 9)
y <- c(3, 5, 4, 6, 9, 8, 2, 1)
plot(x, y, type="l", xlab="x-axis", ylab="y-axis", main="linegraph", col="blue")

# Grafico de lineas multiple
x.1 <- c(2, 3, 4, 6, 7, 8, 9, 10)
y.1 <- c(6, 3, 5, 1, 5, 3, 4, 8)
plot(x, y, type="l", xlab="x-axis", ylab="y-axis", main="linegraph", col="blue")
lines(x.1, y.1, type="o", col="green")# type = "o" te dará un gráfico de líneas con un punto

# Grafico circular
x <- c(10, 30, 60, 10, 50)
labels <- c("one", "two", "three", "four", "five")
pie(x, labels, main="Pie Chart")

# Para trazar un gráfico circular 3D, debes instalar la biblioteca plotrix
library(plotrix)
pie3D(x, labels=labels, explode=0.1, main="Pie Chart")

# Diagrama de dispersión
x <- c(1, 2, 3, 4, 5, 6, 8, 9)
y <- c(3, 5, 4, 6, 9, 8, 2, 1)
plot(x, y, xlab="x-axis", ylab="y-axis", main="scatterplot")








