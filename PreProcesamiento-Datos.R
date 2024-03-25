# Preprocesamiento de Datos
# Paso 1: Importacion del dataset
library(readr)
Dataset <- read_csv("Datasets/Dataset.csv")
View(Dataset)
# ------------------------------------------------------------------------------
# Paso 2: Manejo de Datos que faltan
# Del conjunto de datos, la columna Edad (Age) y Salario (Salary) contienen datos que faltan.

# Reemplaza los datos que faltan con el promedio de la función en la que faltan los datos:

# Nuestra declaración ifelse está tomando tres parámetros:
#   • El primer parámetro es si la condición es verdadera.
#   • El segundo parámetro es el valor que ingresamos si la condición es verdadera.
#   • El tercer parámetro es la acción que tomamos si la condición es falsa.

Dataset$Age=
  # is.na(Dataset$Age). Esto nos dirá si falta o no un valor en Dataset$Age.
  ifelse(is.na(Dataset$Age),
         # la función 'ave()', encuentra la media de la columna Edad.
         # necesitamos excluir los datos nulos en el cálculo de la media
         # Esta es la razón por la que pasamos na.rm = TRUE en nuestra función de media para declarar
         # los valores que deben usarse , excluyendo los valores NA
                   ave(Dataset$Age,FUN = function(x)mean(x,na.rm=TRUE)),
         # La tercera condición es el valor que se devolverá si no falta el valor de la columna Age del
         # conjunto de datos.
                   Dataset$Age)

# Hacemos lo mismo para la columna Salary
Dataset$Salary = ifelse(is.na(Dataset$Salary),
                        ave(Dataset$Salary,FUN = function(x)mean(x,na.rm=TRUE)),
                        Dataset$Salary)