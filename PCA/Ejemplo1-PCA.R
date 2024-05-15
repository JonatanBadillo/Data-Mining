# Ejemplo 1: Precios de la vivienda en Boston

# Retomamos el ejemplo que se propone en la tarea de regresión lineal múltiple, Boston
# Housing data set. Para cada vecindario, se dan varias variables, como la tasa de criminalidad,
# la proporción de estudiantes por maestro y el valor medio de una unidad de vivienda en el
# vecindario. En la tabla 1 se da una descripción de las 14 variables. Los primeros nueve
# registros de los datos se muestran en la tabla 2. La primera fila representa el primer
# vecindario, que tenía una tasa de criminalidad per cápita promedio de 0.006, 18% de la tierra
# residencial dividida en zonas para lotes de más de 25,000 pies2, 2.31% de la tierra dedicada
# a negocios no minoristas, sin frontera con el río Charles, y pronto.

boston.housing.df <- read.csv("BostonHousing.csv", header = TRUE)
head(boston.housing.df, 9)
summary(boston.housing.df)

mean(boston.housing.df$CRIM)
# find the number of missing values of variable CRIM
sum(is.na(boston.housing.df$CRIM))

# data frame que contiene las estadísticas descriptivas mencionadas 
data.frame(mean=sapply(boston.housing.df, mean),
           sd=sapply(boston.housing.df, sd),
           min=sapply(boston.housing.df, min),
           max=sapply(boston.housing.df, max),
           median=sapply(boston.housing.df, median),
           length=sapply(boston.housing.df, length),
           miss.val=sapply(boston.housing.df, function(x)
           sum(length(which(is.na(x))))))


# tabla de correlacion para los datos de boston housing
round(cor(boston.housing.df),2)




# Tablas de agregación y pivote

# Otro enfoque muy útil para explorar los datos es la agregación por una o más variables. Para
# la agregación por una sola variable, podemos usar table(). 
# rango de estadísticas de resumen (recuento, promedio, porcentaje, etc.).

# Para las variables categóricas, obtenemos un desglose de los registros por combinación de
# categorías. Por ejemplo, calculamos el MEDV promedio por CHAS y RM. Ten
# en cuenta que la variable numérica RM (el número promedio de habitaciones por vivienda
# en el vecindario) debe agruparse primero en contenedores de tamaño 1 (0–1, 1–2, etc.). Ten
# en cuenta los valores vacíos, lo que indica que no hay vecindarios en el conjunto de datos
# con esas combinaciones (por ejemplo, delimitando el río y con un promedio de 3 habitaciones).

table(boston.housing.df$CHAS) # Número de vecindarios que limitan con el río Charles frente a los que no.


# create bins of size 1
boston.housing.df$RM.bin <- .bincode(boston.housing.df$RM, c(1:9))
# compute the average of MEDV by (binned) RM and CHAS
# in aggregate() use the argument by= to define the list of aggregating variables,
# and FUN= as an aggregating function.

# MEDV promedio para CHAS y RM.
aggregate(boston.housing.df$MEDV, by=list(RM=boston.housing.df$RM.bin,CHAS=boston.housing.df$CHAS), FUN=mean) 


# Otro conjunto útil de funciones son melt() y cast() en el paquete reshape, que permiten la
# creación de tablas dinámicas. melt() toma un conjunto de columnas y las apila en una sola
# columna. cast() luego cambia la forma de la columna única en múltiples columnas mediante
# las variables agregadas de nuestra elección.
# En las tareas de clasificación, donde el objetivo es encontrar variables predictoras que
# distingan entre dos clases, un buen paso exploratorio es producir resúmenes para cada clase.
# Esto puede ayudar a detectar predictores útiles que muestren alguna separación entre las dos
# clases. Los resúmenes de datos son útiles para casi cualquier tarea de minería de datos y, por
# lo tanto, son un paso preliminar importante para limpiar y comprender los datos antes de
# realizar análisis adicionales.

# use install.packages("reshape") the first time the package is used
library(reshape)
boston.housing.df <- read.csv("BostonHousing.csv")
# create bins of size 1
boston.housing.df$RM.bin <- .bincode(boston.housing.df$RM, c(1:9))
# use melt() to stack a set of columns into a single column of data.
# stack MEDV values for each combination of (binned) RM and CHAS
mlt <- melt(boston.housing.df, id=c("RM.bin", "CHAS"), measure=c("MEDV"))
head(mlt, 5)

# use cast() to reshape data and generate pivot table
cast(mlt, RM.bin ~ CHAS, subset=variable=="MEDV",margins=c("grand_row", "grand_col"), mean)




# se muestra un ejemplo, donde la distribución de la variable de resultado
# CAT.MEDV se desglosa por ZN (tratada aquí como una variable categórica). Podemos ver
# que la distribución de CAT.MEDV es idéntica para ZN = 17.5, 90, 95 y 100 (donde todos los
#                                                                           vecindarios tienen CAT.MEDV = 1).
# Estas cuatro categorías se pueden combinar en una sola categoría. De manera similar, las
# categorías ZN = 12.5, 25, 28, 30 y 70 se pueden combinar. También es posible una
# combinación adicional basada en barras similares.
install.packages("ggmap")
library(ggmap)
tbl <- table(boston.housing.df$CAT..MEDV, boston.housing.df$ZN)
prop.tbl <- prop.table(tbl, margin=2)
barplot(prop.tbl, xlab="ZN", ylab="", yaxt="n",main="Distribution of CAT.MEDV by ZN")
axis(2, at=(seq(0,1, 0.2)), paste(seq(0,100,20), "%"))
# Distribución de CAT.MEDV (El negro denota CAT.MEDV = 0) POR ZN. Las
# barras similares indican una baja separación entre clases y se pueden combinar.
