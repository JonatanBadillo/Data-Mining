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
