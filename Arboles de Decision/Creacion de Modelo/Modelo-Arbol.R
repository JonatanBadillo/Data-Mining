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

permits <- permits %>%mutate(valuation = ifelse(valuation < 1, NA, valuation)) %>%
  mutate(floorArea = ifelse(floorArea < 1, NA, floorArea)) %>%
  mutate(numberUnits = ifelse(numberUnits < 1, NA, numberUnits)) %>%
  mutate(stories = ifelse(stories < 1, NA, stories))

