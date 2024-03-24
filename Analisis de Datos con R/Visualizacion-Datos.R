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
