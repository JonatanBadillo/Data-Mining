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
