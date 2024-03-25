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

# ------------------------------------------------------------------------------
# Paso 5: Escalado de características

# Es un caso común en la mayoría de los conjuntos de datos, las características también
# conocidas como entradas no están en la misma escala. Muchos modelos de aprendizaje
# automático se basan en la distancia euclidiana.

# Sucede que, las entidades con unidades grandes dominan a las de unidades pequeñas a la
# hora de calcular la distancia euclidiana y será como si esas entidades con unidades pequeñas
# no existieran.

# Para asegurarnos de que esto no ocurra, necesitamos codificar nuestras funciones para que
# todas estén en el rango entre -3 y 3.

# Hay varias formas que podemos usar para escalar nuestras funciones. 
# La más utilizada es la técnica de estandarización y normalización.

# La técnica de normalización se usa cuando los datos se distribuyen normalmente, mientras
# que la estandarización funciona tanto con datos distribuidos normalmente como con datos
# que no se distribuyen normalmente.

# ESTANDARIZACION
# estandarizacion = (x-mean(x))/ (desviacion_std(x))

# NORMALIZACION
# normalizacion = (x-min(x))/(max(x)-min(x))

# Ahora, vamos a escalar tanto el conjunto de entrenamiento como el conjunto de prueba de
# nuestro conjunto de datos por separado.


# Estandariza las columnas "Age" y "Salary". 
# La función scale() estándariza las variables numéricas restando la media y dividiendo por la desviación estándar. 
# Entonces, esta línea de código calcula la media y la desviación estándar de las columnas seleccionadas y luego estandariza los valores en esas columnas.
training_set[, 2:3] = scale(training_set[, 2:3])

# ver los resultados donde los valores ahora están estandarizados 
# (tienen una media de cero y una desviación estándar de uno
training_set

# También estandariza las columnas "Age" y "Salary".
test_set[, 2:3] = scale(test_set[, 2:3])

# valores estandarizados (con una media de cero y una desviación estándar de uno).
test_set











