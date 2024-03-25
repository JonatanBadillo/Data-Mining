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
housing_df <- read_csv("Datasets/BostonHousing.csv")
head(housing_df, 9)
