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
barplot(data.for.plot$MeanMEDV, names.arg = data.for.plot$CHAS, xlab = "CHAS", ylab = "Avg. MEDV")


## barchart de CHAS vs. % CAT.MEDV
data.for.plot <- aggregate(housing.df$CAT..MEDV, by = list(housing.df$CHAS), FUN = mean)
names(data.for.plot) <- c("CHAS", "MeanCATMEDV")
barplot(data.for.plot$MeanCATMEDV * 100, names.arg = data.for.plot$CHAS,
          xlab = "CHAS", ylab = "% of CAT.MEDV")

# ------------------------------------------------------------------------------

## histograma de MEDV
hist(housing.df$MEDV, xlab = "MEDV")

## boxplot de MEDV para diferentes valores de CHAS
boxplot(housing.df$MEDV ~ housing.df$CHAS, xlab = "CHAS", ylab = "MEDV")

# ------------------------------------------------------------------------------
## side-by-side boxplots
# use par() to split the plots into panels.
par(mfcol = c(1, 4))
boxplot(housing.df$NOX ~ housing.df$CAT..MEDV, xlab = "CAT.MEDV", ylab = "NOX")
boxplot(housing.df$LSTAT ~ housing.df$CAT..MEDV, xlab = "CAT.MEDV", ylab = "LSTAT")
boxplot(housing.df$PTRATIO ~ housing.df$CAT..MEDV, xlab = "CAT.MEDV", ylab ="PTRATIO")
boxplot(housing.df$INDUS ~ housing.df$CAT..MEDV, xlab = "CAT.MEDV", ylab = "INDUS")

# ------------------------------------------------------------------------------
# Mapas de calor (heatmaps): Visualización de correlaciones y valores perdidos
# los mapas de calor son especialmente útiles para dos propósitos: visualizar tablas de correlación y visualizar valores
# faltantes en los datos.

install.packages("ggplot2")
## mapa de calor simple de correlaciones (sin valores)
heatmap(cor(housing.df), Rowv = NA, Colv = NA)
## heatmap con valores
install.packages("gplots")
library(gplots)
heatmap.2(cor(housing.df), Rowv = FALSE, Colv = FALSE, dendrogram = "none",
            cellnote = round(cor(housing.df),2),
            notecol = "black", key = FALSE, trace = 'none', margins = c(10,10))



# plot alternativo con ggplot
install.packages("reshape")
library(ggplot2)
library(reshape)
cor.mat <- round(cor(housing.df),2) # rounded correlation matrix
melted.cor.mat <- melt(cor.mat)
ggplot(melted.cor.mat, aes(x = X1, y = X2, fill = value)) +geom_tile() +geom_text(aes(x = X1, y = X2, label = value))

