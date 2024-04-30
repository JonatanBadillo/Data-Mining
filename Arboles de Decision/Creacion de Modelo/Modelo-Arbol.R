# Creación de un modelo de árbol de clasificación

# En esta pequeña práctica, usaremos una función de árbol
# de decisión basada en el algoritmo CART para resolver el problema que a continuación se
# enuncia. Nuestro objetivo es construir un modelo que prediga si una solicitud de permiso
# pasará por un proceso de revisión acelerada o no en función de las características de la
# solicitud.


# Prediciendo las decisiones de permiso de construcción

# Este conjunto de datos contiene información sobre las decisiones de permisos
# de construcción tomadas por el departamento e incluye información sobre la naturaleza del
# proyecto y si el permiso fue aprobado a través de un proceso acelerado de un día o si fue
# marcado para una revisión más extensa por parte del personal del departamento.

# Los contratistas, por supuesto, preferirían que la mayor cantidad posible de proyectos de
# construcción se encaminaran a través del proceso acelerado. 
# Nuestra tarea es analizar los
# datos para determinar si hay características específicas de una solicitud de permiso que
# hacen que sea más probable que pase por el proceso de revisión acelerada.
# El conjunto de datos incluye una variedad de datos de permisos para nuestro análisis:


#   • status es el estado actual de la solicitud de permiso. Puede tomar valores como: Finalizado, Emitido, Caducado y otros códigos de estado.
#   • permitType contiene la naturaleza de las mejoras solicitadas. Puede tomar valores como Eléctrico, Modificación/Reparación de Edificios, Plomería, etc.
#.  • permitSubtype es el tipo de edificio afectado por el permiso. Puede tomar valores como 1 o 2 Vivienda unifamiliar, Comercial, Apartamento, etc.
#   • initiatingOffice es la ubicación de la oficina del departamento que inició la solicitud
#   • ZIP es el código postal de la dirección de la propiedad.
#.  • Valuation es el valor tasado de la propiedad según los registros de impuestos.
#.  • floorArea son los pies cuadrados del área de piso de la propiedad.
#   • numberUnits es el número de unidades residenciales en una propiedad de varias viviendas.
#   • stories representa el número de pisos del edificio.
#   • contractorState es el estado en el que se encuentra el contratista que solicita el permiso, si corresponde.
#   • licenseType es un campo que categoriza el tipo de licencia que posee el contratista,si corresponde.
#   • zone es la categoría de zonificación de la propiedad.
#   • year y month son el año y mes en que se procesó la solicitud de permiso,
#.  • permitCategory es la variable que queremos predecir. Contiene el valor Plan Check o el valor No Plan Check.


# Dado el problema y los datos proporcionados, estas son algunas de las preguntas que
# debemos responder:
#   ¿Qué variables predicen mejor si una solicitud de permiso se acelerará o se marcará para
# una revisión adicional?
#   ¿Qué tan bien podemos predecir si una solicitud de permiso se marcará para su revisión o
# no en función de las variables de predicción disponibles para nosotros?
#   
#   Primero importamos y previsualizamos nuestros datos.

library(tidyverse)
permits <- read_csv("permits.csv", col_types = "ffffffnnnnfffff")
glimpse(permits)


# Nuestro resultado también muestra que tenemos una serie de valores perdidos para algunas
# de nuestras características (indicadas como NA). Obtengamos un resumen estadístico de
# nuestro conjunto de datos para comprender mejor los problemas que podemos tener con los
# datos faltantes, los valores atípicos y el ruido. Para hacer esto, usamos la función summary().
summary(permits)


# El resultado resumido muestra que nos faltan datos para la mayoría de nuestras
# características. 

# Este no es un problema para los algoritmos de árboles de decisión. Son
# capaces de manejar muy bien los datos faltantes sin necesidad de imputación por nuestra
# parte. Esto se debe a que, durante el proceso de partición recursivo, las divisiones se realizan
# basándose únicamente en los valores observados de una variable. Si una observación tiene
# un valor perdido para la variable que se está considerando, simplemente se ignora.
# 
# También observamos en el resultado de resumen que algunas de las características numéricas,
# como valuation y floorArea, tienen una amplia gama de valores y posibles datos atípicos.
# 
# Con algunos de los enfoques de aprendizaje automático que hemos cubierto hasta ahora, estos
# serían problemáticos y tendrían que solucionarse. Ese no es el caso de los árboles de decisión.
# Son capaces de manejar de forma robusta valores atípicos y datos ruidosos.
# 
# Como puedes comenzar a ver, los árboles de decisiones requieren poco de nosotros en
# términos de preparación de datos.
# Sin embargo, nuestras estadísticas resumidas señalan algunas inconsistencias lógicas con
# algunos de nuestros valores de características. Por ejemplo, vemos que el valor mínimo de
# floorArea es –154,151.
# Este no es un valor razonable para los pies cuadrados de un edificio. También vemos
# problemas similares con los valores mínimos para las características de valuation,
# numberUnits y stories.
# 
# Si bien estas inconsistencias no son un problema para el algoritmo del árbol de decisiones,
# conducirán a reglas de decisión ilógicas si el árbol se usara para la toma de decisiones
# comerciales. Para resolver estas inconsistencias, simplemente las tratamos como datos
# faltantes estableciendo sus valores en NA.


# Esta línea usa el operador %>% (pipe) , que permite encadenar operaciones. Toma el marco de datos "permits", 
# luego utiliza la función mutate() para crear una nueva columna 
# La función ifelse() se utiliza para evaluar si cada valor en la columna "valuation" es menor que 1. Si es así, se reemplaza con NA
permits <- permits %>%mutate(valuation = ifelse(valuation < 1, NA, valuation)) %>%
  mutate(floorArea = ifelse(floorArea < 1, NA, floorArea)) %>%
  
  
#   Las estadísticas de resumen también muestran que tenemos un problema con el valor máximo
# de la característica stories. Una búsqueda rápida en línea revela que el edificio más alto de
# Los Ángeles (el Wilshire Grand Center) tiene solo 73 pisos. Por lo tanto, tratamos cualquier
# valor superior a 73 como datos faltantes estableciendo el valor en NA.
permits <- permits %>% mutate(stories = ifelse(stories > 73, NA, stories))

summary(select(permits, valuation, floorArea, numberUnits, stories))


# Los algoritmos del árbol de decisiones hacen un gran trabajo al seleccionar qué características
# son importantes para predecir el resultado final y cuáles no. Por lo tanto, la selección de
# características como paso de preparación de datos no es necesaria. Sin embargo, para
# simplificar nuestra ilustración, utilicemos únicamente las características permitType,
# permitSubtype e iniciatingOffice como predictores del resultado final, que está representado
# por la característica permitCategory. Usando el comando select() del paquete dplyr,
# reducimos nuestro conjunto de datos a estas cuatro características:

library(dplyr)
# selecciona solo las columnas especificadas del marco de datos "permits" 
# y asigna el resultado de esta operación de selección nuevamente a la variable "permits".
permits <- permits %>%select(
    permitType,
    permitSubtype,
    initiatingOffice,
    permitCategory
    )




# División de datos
# La siguiente etapa de nuestro proceso es dividir nuestros datos en conjuntos de prueba y
# entrenamiento. Con la función sample(), dividimos nuestro conjunto de datos dividiendo el
# 80 por ciento de los datos originales como datos de entrenamiento y el 20 por ciento restante
# como datos de prueba.


set.seed(1234)
sample_set <- sample(nrow(permits), round(nrow(permits)*.80), replace = FALSE)

#  Utiliza los índices generados en sample_set para seleccionar las filas correspondientes del marco de datos "permits"
permits_train <- permits[sample_set, ]
# Utiliza los índices complementarios de sample_set (es decir, las filas no seleccionadas para el conjunto de entrenamiento)
permits_test <- permits[-sample_set, ]

# Estas líneas de código calculan la proporción de cada categoría en la columna "permitCategory" 
# para el conjunto de datos completo (permits) y el conjunto de datos de entrenamiento (permits_train). 
# Luego, redondean estos valores a dos decimales.
round(prop.table(table(select(permits, permitCategory))),2)
round(prop.table(table(select(permits_train, permitCategory))),2)
round(prop.table(table(select(permits_test, permitCategory))),2)


# Entrenamiento de un modelo
# Ahora estamos listos para construir nuestro modelo. El algoritmo CART
# se implementa en R como parte del paquete rpart. Este paquete proporciona una función
# rpart() con un nombre similar, que usamos para entrenar nuestro modelo. Esta función toma
# tres argumentos principales. La primera es la fórmula de predicción, que especificamos como
# permitCategory  ̃. lo que significa que nuestro modelo debe usar todas las demás variables
# del conjunto de datos como predictores de la variable permitCategory. El segundo argumento
# es el método, que especificamos como clase. Esto significa que estamos construyendo un
# árbol de clasificación. El argumento final es el conjunto de datos de entrenamiento que se
# utilizará para construir el modelo.
library(rpart)
permits_mod <- rpart(
  permitCategory ~ .,
  method = "class",
  data = permits_train
  )

# Evaluación del modelo
# Ahora que hemos entrenado nuestro modelo de árbol de decisiones, visualicémoslo. Para
# hacerlo, usamos la función rpart.plot() del paquete rpart.plot de nombre similar. 
library(rpart.plot)
rpart.plot(permits_mod)

# Nuestro árbol en particular comienza con una división por permitType en el nodo raíz. Esto
# nos dice que de las características que usamos en nuestro modelo, permitType es la más
# predictiva de nuestro resultado final. Cuanto más nos alejamos del nodo raíz, menos
# predictiva es una característica del resultado final.

# Esto significa que después de permitType, initiatingOffice es la siguiente característica más
# predictiva, seguida de permitSubtype.
# Además del orden en que se encuentran las características, los colores y las etiquetas de los
# nodos también son útiles para comprender nuestros datos. Recuerda que el nodo raíz de un
# árbol representa el conjunto de datos original antes de la primera división y que cada uno de
# los nodos subsiguientes (nodos de decisión y hoja) representa subparticiones del conjunto de
# datos original después de cada división anterior.




# Ahora, veamos cómo funciona nuestro modelo con este proceso en comparación con nuestra
# prueba. De manera similar a lo que hicimos anteriormente, pasamos el modelo
# (permits_mod) a la función predict() para clasificar los datos de prueba (permits_test),
# estableciendo el argumento de tipo en clase. Después de esto, creamos una matriz de
# confusión basada en nuestras predicciones y calculamos la precisión predictiva de nuestro
# modelo.
permits_pred <- predict(permits_mod, permits_test, type = "class")
permits_pred_table <- table(permits_test$permitCategory, permits_pred)
permits_pred_table

sum(diag(permits_pred_table)) / nrow(permits_test)
# Los resultados muestran que nuestro modelo tiene una precisión predictiva del 86.4 por ciento frente a los datos de la prueba.
