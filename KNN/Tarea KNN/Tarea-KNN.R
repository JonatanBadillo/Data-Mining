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
View(BostonHousing)

# Excluir la columna CAT.MEDV
BostonHousing <- BostonHousing[, -which(names(BostonHousing) == "CAT.MEDV")]

# Crear una función para normalizar 
normalize <- function(x) return( (x-min(x))/(max(x)-min(x)))

# Aplicar la función de normalización a todas las columnas del conjunto de datos
BostonHousing_normalized <- as.data.frame(lapply(BostonHousing, normalize))


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


medv_pred <- knn(train = boston.training, test = boston.test, cl = boston.trainLabel, k=3)

summary(medv_pred)
