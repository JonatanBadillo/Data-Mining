# Visualización de datos multidimensionales

# Ejemplo 1: Datos de vivienda de Boston

# Consideramos tres posibles tareas:
  # 1. Una tarea predictiva supervisada, donde la variable de resultado de interés es el valor
  # mediano de una vivienda en el tramo (MEDV).
  # 2. Una tarea de clasificación supervisada, donde la variable de resultado de interés es la
  # variable binaria CAT.MEDV que indica si el valor de la vivienda está por encima o
  # por debajo de $30,000.
  # 3. Una tarea no supervisada, cuyo objetivo es agrupar secciones censales.


library(readr)
housing.df <- read_csv("Datasets/BostonHousing.csv")
head(housing.df, 9)

# ------------------------------------------------------------------------------
# Ejemplo 2: Número de pasajeros en trenes Amtrak

# Aquí nos centramos en pronosticar el número de usuarios futuros
# utilizando la serie de usuarios mensuales entre enero de 1991 y marzo de 2004. Los datos y
# se describen brevemente a continuación. Por lo tanto, nuestra tarea aquí es pronosticar series
# de tiempo (numéricas).

Amtrak.df<-read.csv("Datasets/Amtrak.csv")
View(Amtrak.df)



# ------------------------------------------------------------------------------
# Gráficos básicos: gráficos de barras, gráficos de líneas, y diagramas de dispersión

# Los tres gráficos básicos más eficaces son los gráficos de barras, los gráficos de líneas y los
# gráficos de dispersión.


# Uso del analisis de series de tiempo
install.packages("forecast")
library(forecast)

# un gráfico de líneas de la serie temporal de pasajeros mensuales en Amtrak.
ridership.ts <- ts(Amtrak.df$Ridership, start = c(1991, 1), end = c(2004, 3), freq = 12)
plot(ridership.ts, xlab = "Year", ylab = "Ridership (in 000s)", ylim = c(1300, 2300))

# diagrama de dispersion con nombres de ejes
plot(housing.df$MEDV ~ housing.df$LSTAT, xlab = "MDEV", ylab = "LSTAT")


## barchart de CHAS vs. mean MEDV
# calcula media MEDV por CHAS = (0, 1)
data.for.plot <- aggregate(housing.df$MEDV, by = list(housing.df$CHAS), FUN = mean)
names(data.for.plot) <- c("CHAS", "MeanMEDV")
barplot(data.for.plot$MeanMEDV, names.arg = data.for.plot$CHAS, + xlab = "CHAS", ylab = "Avg. MEDV")


## barchart de CHAS vs. % CAT.MEDV
data.for.plot <- aggregate(housing.df$CAT..MEDV, by = list(housing.df$CHAS), FUN = mean)
names(data.for.plot) <- c("CHAS", "MeanCATMEDV")
barplot(data.for.plot$MeanCATMEDV * 100, names.arg = data.for.plot$CHAS,
          + xlab = "CHAS", ylab = "% of CAT.MEDV")



