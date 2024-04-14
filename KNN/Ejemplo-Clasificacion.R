# Ejemplo de clasificación basada en similaridades

# Imagina que trabajas en un hospital y estás intentando mejorar el diagnóstico de los pacientes
# con diabetes. Recopilas datos de diagnóstico durante unos meses de pacientes con sospecha
# de diabetes y registras si fueron diagnosticados como sanos, químicamente diabéticos o
# manifiestamente diabéticos. 

# Te gustaría usar el algoritmo k-NN para entrenar un modelo que
# pueda predecir a cuál de estas clases pertenecerá un nuevo paciente, de modo que se puedan
# mejorar los diagnósticos. Este es un problema de clasificación de tres clases.


# Comenzaremos con una forma simple e ingenua de construir un modelo k-NN y luego lo
# mejoraremos gradualmente. 


# Lo primero es lo primero:
#instalemos el paquete mlr y carguémoslo junto con tidyverse (igual y ya lo tienes instalado!):

library(mlr)
library(tidyverse)

# Cargar y explorar el conjunto de datos de diabetes
# carguemos algunos datos integrados en el paquete mclust, conviértelos en un tibble
# (un tibble es la forma tidyverse de almacenar datos rectangulares). Tenemos un tibble con 145 casos y 4 variables.

# El factor de clase muestra que 76 de los casos no eran diabéticos (Normal), 36 eran
# químicamente diabéticos (Chemical) y 33 eran manifiestamente diabéticos (Overt). Las otras
# tres variables son medidas continuas del nivel de glucosa e insulina en sangre después de una
#prueba de tolerancia a la glucosa (glucose e insulin, respectivamente) y el nivel de glucosa
# en sangre en estado estacionario (sspg).
library(mclust)
data(diabetes, package = "mclust")
diabetesTib <- as_tibble(diabetes)
summary(diabetesTib)

diabetesTib

# Para mostrar cómo se relacionan estas variables, se grafican

ggplot(diabetesTib, aes(glucose, insulin, col = class)) +geom_point() +
  theme_bw()
ggplot(diabetesTib, aes(sspg, insulin, col = class)) +
  geom_point() +
  theme_bw()
ggplot(diabetesTib, aes(sspg, glucose, col = class)) +
   geom_point() +
   theme_bw()

# Usando mlr para entrenar tu primer modelo k-NN

# La construcción de un modelo de aprendizaje automático con el
# paquete mlr tiene tres etapas principales:

  # 1. Definir la tarea. La tarea consiste en los datos y lo que queremos hacer con ellos. En
# este caso, los datos son diabetesTib y queremos clasificar los datos con la variable de
# clase como variable objetivo.

  # 2. Definir al aprendiz. El aprendiz es simplemente el nombre del algoritmo que
# planeamos usar, junto con cualquier argumento adicional que acepte el algoritmo.

  # 3. Entrenar el modelo. Esta etapa es lo que parece: pasas la tarea al aprendiz y el
# aprendiz genera un modelo que puede usar para hacer predicciones futuras.

# ------------------------------------------------------------------------------
# CREANDO TAREA



# Queremos construir un modelo de clasificación, por lo que usamos la función
# makeClassifTask() para definir una tarea de clasificación.

# Suministramos el nombre de nuestro tibble como argumento de datos y el nombre del factor
# que contiene las etiquetas de clase como argumento de destino:
diabetesTask <- makeClassifTask(data = diabetesTib, target = "class")
diabetesTask

# ------------------------------------------------------------------------------
# CREANDO APRENDIZ



# Decirle a mlr qué algoritmo usar: definir al aprendiz
# A continuación, definamos a nuestro aprendiz. Los componentes necesarios para definir a un
# aprendiz son los siguientes:
#   • La clase de algoritmo que estamos usando:
  #  o "classif." para clasificación
  #  o "regr." para regresión
  #  o "cluster." para agrupar
  #  o "surv." y "multilabel.". para predecir la supervivencia y la clasificación de
  #  etiquetas múltiples

# • El algoritmo que estamos usando
# • Cualquier opción adicional que deseemos usar para controlar el algoritmo


# Como verás, los componentes primero y segundo se combinan en un argumento de un solo
# carácter para definir qué algoritmo se usará (por ejemplo, "classif.knn").



# Usamos la función makeLearner() para definir un aprendiz. El primer argumento de la
# función makeLearner() es el algoritmo que vamos a usar para entrenar nuestro modelo.

# En este caso, queremos usar el algoritmo k-NN, por lo que proporcionamos "classif.knn"
# como argumento.
# El argumento par.vals representa valores de parámetros, lo que nos permite especificar el
# número de k vecinos más cercanos que queremos que use el algoritmo. 

# Por ahora,estableceremos esto en 2
knn <- makeLearner("classif.knn", par.vals = list("k" = 2))

# ------------------------------------------------------------------------------
# Poniendo todo junto: Entrenando el modelo

# Creamos nuestro modelo
# Esto se logra con la función train(), que toma al aprendiz como primer argumento y la tarea
# como segundo argumento:
knnModel <- train(knn, diabetesTask)


# Tenemos nuestro modelo, así que pasemos los datos a través de él para ver cómo funciona.
# La función predict() toma datos sin etiquetar y los pasa a través del modelo para obtener las
# clases predichas. El primer argumento es el modelo, y los datos que se le pasan se dan como
# el argumento newdata:
knnPred <- predict(knnModel, newdata = diabetesTib)


# Resumen de las funciones predict() y performance() de mlr. 

# predict() pasa las
# observaciones a un modelo y genera los valores predichos. 

# performance() compara estos
# valores predichos con los valores verdaderos de los casos y genera una o más métricas de
# rendimiento que resumen la similitud entre los dos.




# Especificamos qué métricas de rendimiento queremos que devuelva la función
# proporcionándolas como una lista al argumento de medidas. Las dos medidas que
# contemplamos son mmce, el error medio de clasificación errónea; y acc, o exactitud. MMCE
# es simplemente la proporción de casos clasificados como una clase diferente a su verdadera
# clase. La precisión es lo opuesto a esto: la proporción de casos que el modelo clasificó
# correctamente. Puedes ver que los dos suman 1.00:
  

performance(knnPred, measures = list(mmce, acc))
# ¡Así que nuestro modelo clasifica correctamente el 95.86% de los casos!



# ------------------------------------------------------------------------------
# Validación cruzada de nuestro modelo k-NN
# hagamos una validación cruzada del aprendiz.


# Validación cruzada de retención (holdout)
# Holdout CV es el método más simple de entender: simplemente “retiene” una proporción
# aleatoria de tus datos como su conjunto de prueba y entrena tu modelo con los datos restantes.
# Luego pasa el conjunto de prueba a través del modelo y calcula sus métricas de rendimiento
# (hablaremos de esto pronto).
# El conjunto de entrenamiento se usa para entrenar el modelo, que
# luego se usa para hacer predicciones en el conjunto de prueba. La similitud de las
# predicciones con los valores reales del conjunto de prueba se utiliza para evaluar el
# rendimiento del modelo.

# El primer paso al emplear cualquier CV en mlr es hacer una descripción de remuestreo, que
# es simplemente un conjunto de instrucciones sobre cómo se dividirán los datos en conjuntos
# de prueba y entrenamiento. El primer argumento de la función makeResampleDesc() es el
# método CV que vamos a utilizar: en este caso, "Holdout". Para el CV de retención,
# necesitamos decirle a la función qué proporción de los datos se usará como conjunto de
# entrenamiento, por lo que proporcionamos esto al argumento de división:
holdout <- makeResampleDesc(method = "Holdout", split = 2/3,
                            stratify = TRUE)# TRUE. Le pide a la función que
# se asegure de que cuando divida los datos en conjuntos de entrenamiento y prueba, intente
# mantener la proporción de cada clase de paciente en cada conjunto.


# Rendimiento del holdout CV
# Ahora que hemos definido cómo vamos a validar de forma cruzada a nuestro aprendiz,
# podemos ejecutar el CV usando la función resample(). Suministramos el aprendiz y la tarea
# que creamos, y el método de remuestreo que definimos hace un momento, a la función
# resample(). También le pedimos que nos dé medidas de MMCE y precisión:
holdoutCV <- resample(learner = knn, task = diabetesTask,
                          resampling = holdout, measures = list(mmce, acc))

# La función resample() imprime las medidas de rendimiento cuando la ejecutas, pero puede
# acceder a ellas extrayendo el componente $aggr del objeto de remuestreo:
holdoutCV$aggr

# Notarás dos cosas:
  # • La precisión del modelo según lo estimado por la validación cruzada de retención es
  # menor que cuando evaluamos su desempeño en los datos que usamos para entrenar
  # el modelo completo. Esto, ejemplifica el punto anterior de que los modelos
  # funcionarán mejor con los datos que los entrenaron que con los datos invisibles.

  # • De hecho,
  # ejecuta la función resample() una y otra vez, ¡y obtendrás un resultado muy diferente
  # cada vez! El motivo de esta variación es que los datos se dividen aleatoriamente en
  # conjuntos de prueba y de entrenamiento. A veces, la división es tal que el modelo
  # funciona bien en el conjunto de prueba; a veces la división es tal que funciona mal.




# Cálculo de una matriz de confusión
# Para tener una mejor idea de qué grupos se clasifican correctamente y cuáles se clasifican
# incorrectamente, podemos construir una matriz de confusión. Una matriz de confusión es
# simplemente una representación tabular de la clase verdadera y predicha de cada caso en el
# conjunto de prueba.

# Con mlr, podemos calcular la matriz de confusión utilizando la función computeConfusion-
# Matrix(). El primer argumento es el componente $pred de nuestro objeto holdoutCV, que

# contiene las clases verdadera y predicha del conjunto de prueba. El argumento opcional
# relativo le pide a la función que muestre la proporción de cada clase en las etiquetas de clase
# verdadera y predicha:

calculateConfusionMatrix(holdoutCV$pred, relative = TRUE)
# La matriz de confusión absoluta es más fácil de interpretar. Las filas muestran las etiquetas
# de clase verdaderas y las columnas muestran las etiquetas predichas.


