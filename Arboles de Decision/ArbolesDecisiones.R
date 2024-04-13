# Construir un árbol de decisiones con rpart y cómo ajustar sus hiperparámetros.

# Imagina que trabajas en la participación pública en un santuario de vida silvestre.
# Tienes la tarea de crear un juego interactivo para niños para enseñarles sobre
# diferentes clases de animales.

# El juego pide a los niños que piensen en cualquier animal del santuario y luego les
# haces preguntas sobre las características físicas de ese animal. Según las respuestas
# que dé el niño, el modelo debe decirle a qué clase pertenece su animal (mamífero, ave, reptil, etc.).

# cargando los paquetes mlr y tidyverse:
library(mlr)
library(tidyverse) 
# Cargamos el conjunto de datos del zoológico integrado en el paquete mlbench, convirtámoslo en un tibble y exploremos.
data(Zoo, package = "mlbench")
zooTib <- as_tibble(Zoo)
zooTib

# Convertiremos en factores con la función mutate_if() de dplyr
# Al convertir las variables lógicas en factores,se están tratando como variables categóricas. 
# R entenderá que estas variables tienen un conjunto finito de categorías o niveles, en lugar de interpretarlas como valores lógicos (TRUE o FALSE).

# Esta función toma los datos como primer argumento .

# El segundo argumento es nuestro criterio para seleccionar columnas, por
# lo que aquí hemos usado is.logic para considerar solo las columnas lógicas.

# El argumento final es qué hacer con esas columnas, así que usamos as.factor para
# convertir las columnas lógicas en factores. Esto dejará intacto el tipo de factor
# existente.

zooTib <- mutate_if(zooTib, is.logical, as.factor)



# Entrenaremos un modelo utilizando, la combinación óptima de hiperparámetros.

# Definamos nuestra tarea y nuestro aprendizaje, y construyamos un modelo 
# Esta vez, proporcionamos "classif.rpart" como argumento para
# makeLearner() para especificar que vamos a utilizar rpart.

# se crea un objeto de tarea de clasificación (zooTask) a partir de los datos zooTib.
zooTask <- makeClassifTask(data = zooTib, target = "type")# # Se especifica que la variable objetivo que se utilizará para el aprendizaje supervisado es la columna llamada "type" en zooTib.
# Para crear un modelo de aprendizaje automático de clasificación basado en árboles de decisión.
# El argumento "classif.rpart" indica que se utilizará el algoritmo de árboles de decisión implementado en el paquete rpart.
tree <- makeLearner("classif.rpart")



# A continuación, debemos realizar un ajuste de hiperparámetros.

# para obtener el conjunto de hiperparámetros predeterminado asociado al modelo de árbol de decisión (tree)
getParamSet(tree)

# Ahora, definamos el espacio de hiperparámetros en el que queremos buscar. Vamos a
# ajustar los valores de minsplit (un número entero), minbucket (un número entero), cp (un
# numérico) y maxdepth (un número entero).

# NOTA: Recuerda que usamos makeIntegerParam() y makeNumericParam() para definir los
# espacios de búsqueda para hiperparámetros enteros y numéricos, respectivamente.

treeParamSpace <- makeParamSet(
  makeIntegerParam("minsplit", lower = 5, upper = 20),
  makeIntegerParam("minbucket", lower = 3, upper = 10),
  makeNumericParam("cp", lower = 0.01, upper = 0.1),
  makeIntegerParam("maxdepth", lower = 3, upper = 10))

# podemos definir cómo vamos a buscar el espacio de hiperparámetros
# que definimos en el listado anterior. Debido a que el espacio de hiperparámetros es
# bastante grande, utilizaremos una búsqueda aleatoria

# Usaremos 200 iteraciones.
# Vamos a utilizar una validación cruzada ordinaria de 5 veces.


# Crea un objeto de control de búsqueda de hiperparámetros utilizando una estrategia de búsqueda aleatoria.
# makeTuneControlRandom() es una función que crea un controlador para la búsqueda de hiperparámetros aleatorios.
# El argumento maxit = 200 especifica el número máximo de iteraciones que la búsqueda aleatoria .
randSearch <- makeTuneControlRandom(maxit = 200)

# Crea un objeto de descripción de re-muestreo para la validación cruzada.
# makeResampleDesc() es una función que crea una descripción de la estrategia de re-muestreo.
# El primer argumento "CV" indica que se utilizará la validación cruzada para evaluar el rendimiento del modelo.
# El argumento iters = 5 especifica el número de iteraciones (o "folds") que se utilizarán en la validación cruzada.
cvForTuning <- makeResampleDesc("CV", iters = 5)


# ¡realicemos nuestro ajuste de hiperparámetros!
library(parallel) # está ya instalado, es parte de la base de R
library(parallelMap)
parallelStartSocket(cpus = detectCores())


# Entrenamiento del modelo
# Se encarga de ajustar (o "sintonizar") los hiperparámetros del modelo de árbol de decisión
tunedTreePars <- tuneParams(tree, # modelo de árbol de decisión que se creó previamente.
                            task = zooTask, #  especifica la tarea de clasificación que se utilizará para ajustar los hiperparámetros. zooTask contiene los datos y la variable objetivo.
                            resampling = cvForTuning, # indica la estrategia de re-muestreo que se utilizará para evaluar el rendimiento del modelo durante la sintonización de hiperparámetros.
                            par.set = treeParamSpace,# especifica el espacio de búsqueda de hiperparámetros que se utilizará para la búsqueda.
                            control = randSearch) # indica el control de búsqueda que se utilizará durante la sintonización. randSearch contiene la configuración para la búsqueda aleatoria de hiperparámetros.

parallelStop() # detiene cualquier proceso de computación en paralelo que pueda haber sido iniciado previamente.

tunedTreePars# Este objeto contendrá información sobre los mejores hiperparámetros encontrados durante la búsqueda

# completa el proceso de ajuste del modelo de árbol de decisión utilizando los hiperparámetros optimizados obtenidos durante la sintonización. 
tunedTree <- setHyperPars(
  tree, # modelo de árbol de decisión que se creó previamente.
  par.vals = tunedTreePars$x)# specifica los valores óptimos de los hiperparámetros obtenidos durante la sintonización. tunedTreePars$x contiene los valores óptimos encontrados para los hiperparámetros del modelo.

tunedTreeModel <- train(tunedTree, zooTask)


# Respresentacion grafica
install.packages("rpart.plot")
library(rpart.plot)
treeModelData <- getLearnerModel(tunedTreeModel)
rpart.plot(treeModelData, roundint = FALSE,
             box.palette = "BuBn",
             type = 5)

# Validacion cruzada

outer <- makeResampleDesc("CV", iters = 5)
treeWrapper <- makeTuneWrapper("classif.rpart", resampling = cvForTuning,
                                par.set = treeParamSpace,
                                control = randSearch)
parallelStartSocket(cpus = detectCores())

cvWithTuning <- resample(treeWrapper, zooTask, resampling = outer)

cvWithTuning



