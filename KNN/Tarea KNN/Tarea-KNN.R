# Tarea KNN
# Predecir los precios medios de la vivienda

# El archivo BostonHousing.csv contiene información sobre más de 500 secciones censales en
# Boston, donde para cada sección se registran múltiples variables. La última columna
# (CAT.MEDV) se derivó de MEDV, de modo que obtiene el valor 1 si MEDV > 30 y 0 en
# caso contrario. Considera el objetivo de predecir el valor mediano (MEDV) de un tramo,
# dada la información en las primeras 12 columnas. Divide los datos en conjuntos de
# entrenamiento (60%) y validación (40%).

# -------------------------------------------------------------------------------
# A)
# Realiza una predicción k-NN con los 12 predictores (ignora la columna CAT.MEDV),
# probando valores de k de 1 a 5. Asegúrate de normalizar los datos y
# elije la función knn() del paquete class en lugar del paquete FNN. Para asegurarte de
# que R está usando el paquete class (cuando ambos paquetes están cargados), usa
# ¿Cuál es la mejor k? Qué significa eso?

# Cargamos el Dataset
library(readr)
BostonHousing <- read_csv("BostonHousing.csv")

# Crear una función para normalizar 
normalize <- function(x) return( round((x-min(x))/(max(x)-min(x)), 2))

# Aplicar la función de normalización a todas las columnas del conjunto de datos
BostonHousing_normalized <- as.data.frame(lapply(BostonHousing, normalize))

set.seed (1234)
# Dividimos en conjunto de prueba y entrenamiento
# Entrenamiento 67%
# Prueba 33%
bth <- sample(2,nrow(BostonHousing_normalized),replace = T,prob = c(0.67,0.33))

# Seleccionamos las columnas necesarias
boston.training <- BostonHousing_normalized[bth==1,1:12]
boston.test <- BostonHousing_normalized[bth==2,1:12]

class(boston.training)# es un data frame que necesitamo convertirlo a matriz

# Convertir las variables a matrices de datos simples
boston.training <- as.matrix(boston.training)
boston.test <- as.matrix(boston.test)

# Seleccionamos nuestra clase:
boston.trainLabel <- BostonHousing_normalized[bth==1,13]
boston.testLabel <- BostonHousing_normalized[bth==2,13]


# Ahora construir el modelo KNN
# con K=3
library(class)


medv_pred <- knn(train = boston.training, test = boston.test, cl = boston.trainLabel, k=5)

print(medv_pred)
summary(medv_pred)


# Evaluar modelo con tabulacion cruzada
library(gmodels)
CrossTable(x=medv_pred, y=boston.testLabel, prop.chisq = FALSE)

# -------------------------------------------------------------------------------
# B)
# Predecir el MEDV para un tramo con la siguiente información, utilizando la mejor k:
# Crear un dataframe con las características proporcionadas
nuevo_dato <- data.frame(
  CRIM = 0.2,
  ZN = 0,
  INDUS = 7,
  CHAS = 0,
  NOX = 0.538,
  RM = 6,
  AGE = 62,
  DIS = 4.7,
  RAD = 4,
  TAX = 307,
  PTRATIO = 21,
  LSTAT = 10
)

# Normalizar el nuevo dato usando los mismos valores de normalización que usaste en los datos de entrenamiento
nuevo_dato_normalized <- (nuevo_dato - min(boston.training)) / (max(boston.training) - min(boston.training))

# Convertir los nuevos datos a una matriz
nuevo_dato_normalized  <- as.matrix(nuevo_dato_normalized )



# Realizar la predicción utilizando tu modelo k-NN
medv_pred_nuevos_datos <- knn(train = boston.training, test = nuevo_dato_normalized , cl = boston.trainLabel, k = 5)

# Imprimir o utilizar la predicción según sea necesario
print(medv_pred_nuevos_datos)
summary(medv_pred_nuevos_datos)

## MEDV PREDECIDO = 0.2




