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
