# Construyendo un modelo Naive Bayes

# Construir y evaluar el desempeño de un modelo de naïve Bayes para predecir la afiliación a un partido político.

# Imagina que eres un politólogo.
# Estás buscando patrones de votación comunes a mediados de la década de 1980 que
# predijeran si un congresista estadounidense era demócrata o republicano. tienes el registro de
# la votación de cada miembro de la Cámara de Representantes en 1984, e identificas 16
# los votos clave que tu crees que dividen más fuertemente a los dos partidos políticos.

# Tu trabajo es entrenar un modelo naïve Bayes para predecir si un congresista era demócrata
# o Republicano, basado en cómo votaron a lo largo del año. 



# Comencemos cargando los paquetes mlr y tidyverse:
library(mlr)
library(tidyverse)

# Cargando y explorando el conjunto de datos HouseVotes84
# Ahora vamos a cargar los datos, que están integrados en el paquete mlbench, convertirlos en
# un tibble (con as_tibble()) y explorarlo.

# Nota. Recuerda que un tibble es solo una versión tidyverse de un marco de datos que ayuda
# a hacer nuestras vidas un poco más fáciles.



# Tenemos un tibble que contiene 435 casos y 17 variables de miembros de la Cámara de
# Representantes en 1984. La variable Class es un factor que indica la afiliación a un partido
# político, y las otras 16 variables son factores que indican cómo votaron los individuos en
# cada uno de los 16 votos. Un valor de y significa que votaron a favor, un valor de n significa
# que votaron en contra y un valor faltante (NA) significa que la persona se abstuvo o no votó.

# Nuestro objetivo es entrenar un modelo que pueda usar la información de estas variables para
# predecir si un congresista era demócrata o republicano, en función de cómo votó.

data(HouseVotes84, package = "mlbench")
votesTib <- as_tibble(HouseVotes84)
votesTib


# Parece que tenemos algunos valores faltantes (NA) en nuestro tibble. Resumamos el número
# de valores faltantes en cada variable usando la función map_dbl(). Recordemos que
# map_dbl() itera una función sobre cada elemento de un vector/lista (o, en este caso, cada
# columna de un tibble), aplica una función a ese elemento y devuelve un vector que contiene
# la salida de la función.

# El primer argumento de la función map_dbl() es el nombre de los datos a los que vamos a
# aplicar la función, y el segundo argumento es la función que queremos aplicar.


# Elegimos usar una función anónima (usando el símbolo ~ como abreviatura de function(.)
  
                                
# Nuestra función pasa cada vector a sum(is.na(.)) para contar el número de valores faltantes
# en ese vector. Esta función se aplica a cada columna del tibble y devuelve el número de
# valores faltantes para cada uno.



# Cuenta cuántos valores faltantes (NA) hay en cada columna de un tibble llamado "votesTib" 
# y devuelve el resultado como un vector numérico donde cada elemento corresponde al número de valores faltantes en 
# una columna específica. 
map_dbl(votesTib, ~sum(is.na(.)))

# ¡Cada columna en nuestro tibble tiene valores perdidos excepto la variable Class!


# Afortunadamente, el algoritmo naïve Bayes puede manejar los datos faltantes de dos
# maneras:

  # • Omitiendo las variables con valores faltantes para un caso particular, pero aún usando
  # ese caso para entrenar el modelo
  # • Al omitir ese caso por completo del conjunto de entrenamiento

# La implementación naïve Bayes que usa mlr es mantener casos y
# descartar variables. Por lo general, esto funciona bien si la proporción de valores faltantes a
# valores completos para la mayoría de los casos es bastante pequeña. Sin embargo, si tienes
# una pequeña cantidad de variables y una gran proporción de valores faltantes, es posible que
# desees omitir los casos (y, en términos más generales, consideres si tu conjunto de datos es
# suficiente para el entrenamiento).

# --------------------------------------------------------------------------------
# Plotear (graficar) los datos

# Grafiquemos nuestros datos para obtener una mejor comprensión de las relaciones entre el
# partido político y los votos.

# Debido a que estamos
# trazando variables categóricas entre sí, configuramos el argumento de posición de la función
# geom_bar() para "rellenar", lo que crea barras apiladas para las respuestas y, n y NA que
# suman 1.




# Convierte el tibble votesTib de un formato "ancho" a un formato "largo", donde "Variable" 
# representa las columnas originales que se están apilando, "Value" representa los valores correspondientes a esas columnas, 
# y "-Class" indica que todas las columnas excepto "Class" se están apilando.
votesUntidy <- gather(votesTib, "Variable", "Value", -Class)

# Crea un objeto ggplot utilizando los datos en el tibble votesUntidy. 
# Establece "Class" en el eje x y utiliza los valores de "Value" para el relleno de las barras.
ggplot(votesUntidy, aes(Class, fill = Value)) +
  # Divide el gráfico en múltiples paneles basados en los niveles de la variable "Variable". 
  facet_wrap(~ Variable, scales = "free_y") +
  # Agrega una capa de barras al gráfico, con la opción position = "fill" que apila las barras en cada grupo y las escala para que sumen 1.
  geom_bar(position = "fill") +
  # Aplica un tema predefinido a la trama para hacerla en blanco y negro.
  theme_bw()

# Podemos ver que hay algunas diferencias de opinión muy claras entre demócratas y republicanos!


# --------------------------------------------------------------------------------
# Entrenando al modelo

# Ahora creamos nuestra tarea y aprendiz, y construyamos nuestro modelo. Establecemos la
# variable Class como el objetivo de clasificación de la función makeClassifTask(), y el
# algoritmo que proporcionamos a la función makeLearner() es "classif.naiveBayes".



# Este código crea un modelo de clasificación Naive Bayes utilizando el paquete mlr, 
# lo entrena con los datos votesTib y lo almacena en la variable bayesModel 
# para su posterior uso en la predicción de nuevas observaciones.


# crea un objeto de tarea de clasificación utilizando la función makeClassifTask() del paquete mlr. 
# Esta función toma el conjunto de datos votesTib y especifica la variable objetivo como "Class". 
# Esto prepara los datos para el proceso de entrenamiento del modelo.
votesTask <- makeClassifTask(data = votesTib, target = "Class")

# Aquí se crea un modelo de aprendizaje (learner) utilizando la función makeLearner() del paquete mlr. 
# Se especifica "classif.naiveBayes" como el tipo de modelo, 
# lo que indica que queremos entrenar un modelo de clasificación ingenua de Bayes.
bayes <- makeLearner("classif.naiveBayes")

# Esta línea entrena el modelo de clasificación Naive Bayes utilizando la función train() del paquete mlr.
# Se pasa el modelo de aprendizaje bayes y la tarea de clasificación votesTask como argumentos.
# Esta función ajusta el modelo a los datos de entrenamiento y devuelve un modelo entrenado, 
# que se almacena en la variable bayesModel.
bayesModel <- train(bayes, votesTask)


# El entrenamiento del modelo se completa sin errores porque Naive Bayes puede manejar los datos que faltan.

# A continuación, utilizaremos una validación cruzada de 10-fold repetida 50 veces para
# evaluar el rendimiento de nuestro procedimiento de creación de modelos. Nuevamente,
# debido a que este es un problema de clasificación de dos clases, tenemos acceso a la tasa de
# falsos positivos y la tasa de falsos negativos, por lo que también los solicitamos en el
# argumento de medidas de la función resample().

kFold <- makeResampleDesc(method = "RepCV", folds = 10, reps = 50, stratify = TRUE)
bayesCV <- resample(learner = bayes, task = votesTask,resampling = kFold,measures = list(mmce, acc, fpr, fnr))
bayesCV$aggr

