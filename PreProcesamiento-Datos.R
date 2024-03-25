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
View(Dataset)

# Hacemos lo mismo para la columna Salary
Dataset$Salary = ifelse(is.na(Dataset$Salary),
                        ave(Dataset$Salary,FUN = function(x)mean(x,na.rm=TRUE)),
                        Dataset$Salary)
View(Dataset)

# ------------------------------------------------------------------------------
# Paso 3: Codificación de datos categóricos
# Se refiere a transformación de datos de texto en datos numéricos.
# Para transformar una variable categórica en numérica, usamos la función factor().

Dataset$Country = factor(Dataset$Country,
                         levels = c('France','Spain','Germany'),
                         labels = c(1.0, 2.0 , 3.0))
View(Dataset)

# Hacemos lo mismo para la columna purchased
Dataset$Purchased = factor(Dataset$Purchased,
                           levels = c('Yes','No'),
                           labels = c(1,0))

# Busca los valores NA y los reemplaza por 0
Dataset$Purchased[is.na(Dataset$Purchased)] <- 0
# Convierte la columna "Purchased" en un factor nuevamente, 
# Asegurando que los cambios realizados anteriormente se mantengan en la estructura de datos.
as.factor(Dataset$Purchased)

View(Dataset)


# ------------------------------------------------------------------------------
# Paso 4: Dividir el conjunto de datos en el conjunto de entrenamiento y prueba

# En el aprendizaje automático, dividimos los datos en dos partes:
  # • Conjunto de entrenamiento: la parte de los datos en la que implementamos nuestro
      # modelo de aprendizaje automático.
  # • Conjunto de prueba: la parte de los datos en la que evaluamos el rendimiento de
      # nuestro modelo de aprendizaje automático.

# Si dejamos que aprenda demasiado sobre los datos, puede tener un desempeño deficiente
# cuando se prueba en un nuevo conjunto de datos con una correlación diferente.

# Por lo tanto, siempre que estemos construyendo un modelo de aprendizaje automático, la
# idea es implementarlo en el conjunto de entrenamiento y evaluarlo en el conjunto de prueba.
# Esperamos que el rendimiento en el conjunto de entrenamiento y el conjunto de prueba sea
# diferente y, si este es el caso, el modelo puede adaptarse a nuevos conjuntos de datos.


# Usando nuestro conjunto de datos, dividámoslo en conjuntos de entrenamiento y prueba.
library(caTools)
# Establece una semilla para los números aleatorios
set.seed(123)
# Utiliza la función sample.split() para dividir los datos. 
# Esta función toma dos argumentos principales: el vector (o columna) que se va a dividir,
# y la proporción en la que se dividirá el conjunto de datos (80% en este caso). 
# La función devuelve un vector que indica si cada fila del conjunto de datos pertenece al entrenamiento (TRUE) o al conjunto de prueba (FALSE).
split = sample.split(Dataset$Purchased,SplitRatio = 0.8)
# Crea el conjunto de entrenamiento seleccionando las filas del conjunto de datos original donde el vector split es TRUE. 
training_set = subset(Dataset,split == TRUE)
# Crea el conjunto de prueba seleccionando las filas del conjunto de datos original donde el vector split es FALSE.
test_set = subset(Dataset,split == FALSE)

training_set
test_set

# A partir de la salida, queda claro que dos observaciones fueron al conjunto de prueba.









