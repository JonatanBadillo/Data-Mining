# Regresión logística
# Nuestra tarea es
# predecir la probabilidad de que una observación pertenezca a una categoría 
# particular de la variable de resultado. 
# En otras palabras, desarrollamos un algoritmo para clasificar las
# observaciones.


# Métodos de clasificación y regresión lineal

# ¿por qué no podemos utilizar el método de regresión de mínimos cuadrados que
#  para obtener un resultado cualitativo? Bueno, resulta que puedes,
# pero bajo tu propio riesgo. Supongamos por un segundo que tienes un resultado que estás
# tratando de predecir y que tienes tres clases diferentes: leve, moderado y severo. Tu y tus
# colegas también suponen que la diferencia entre leve y moderado y moderado y grave es una
# medida equivalente y una relación lineal. Puedes crear una variable ficticia donde 0 es igual
# a leve, 1 es igual a moderado y 2 es igual a grave. Si tienes motivos para creer esto, entonces
# la regresión lineal podría ser una solución aceptable. Sin embargo, etiquetas cualitativas 
# como las anteriores podrían prestarse a un alto nivel de error de medición que puede sesgar
# el OLS.


# En la mayoría de los problemas empresariales, no existe una forma científicamente aceptable
# de convertir una respuesta cualitativa en una cuantitativa. ¿Qué pasa si tienes una respuesta
# con dos resultados, digamos reprobar y aprobar? Nuevamente, utilizando el enfoque de
# variable ficticia, podríamos codificar el resultado fallido como 0 y el resultado aprobado
# como 1. Usando la regresión lineal, podríamos construir un modelo donde el valor predicho
# sea la probabilidad de una observación de aprobado o reprobado. Sin embargo, las
# estimaciones de Y en el modelo probablemente excederán las restricciones de probabilidad
# de [0,1] y, por lo tanto, serán un poco difíciles de interpretar.



# Regresión logística
# Como sabemos de los métodos estudiado previamente, nuestro problema de clasificación se
# modela mejor con las probabilidades ligadas por 0 y 1. Podemos hacer esto para todas
# nuestras observaciones con algunas funciones diferentes, pero aquí nos centraremos en la
# función logística. La función logística utilizada en la regresión logística es la siguiente:

#   Probabilidad de 𝑌 =((𝑒0+𝛽1𝑥) / 1) +𝑒𝛽0+𝛽1𝑥

# Si alguna vez has realizado una apuesta amistosa en carreras de caballos o en la Copa del
# Mundo, es posible que comprendas mejor el concepto de probabilidades.
# La función logística se puede convertir en probabilidades con la formulación de
# Probabilidad(Y)/1 - Probabilidad (Y).
# Por ejemplo, si la probabilidad de que Brasil gane la Copa del Mundo es del 20 por ciento,
# entonces las probabilidades son 0.2/1 - 0,2, lo que equivale a 0.25, lo que se traduce en
# probabilidades de uno entre cuatro.
# Para convertir las odds (probabilidades) en probabilidad, toma las odds y divídelas por uno
# más las probabilidades. Por lo tanto, el ejemplo de la Copa del Mundo es 0.25/1 + 0.25, lo
# que equivale al 20 por ciento. Además, consideremos la razón de las odds. Supongamos que
# las odds de que Alemania gane la Copa son 0.18. Podemos comparar las odds de Brasil y
# Alemania con la razón de las odds. En este ejemplo, la razón de las odds sería la de Brasil
# dividida por la de Alemania. Terminaremos con una razón de probabilidades igual a
# 0.25/0.18, que es igual a 1.39. Aquí diremos que Brasil tiene 1.39 veces más probabilidades
# que Alemania de ganar la Copa del Mundo.


# Teniendo estos hechos en mente, la regresión logística es una técnica potente para predecir
# los problemas que involucran clasificación y, a menudo, es el punto de partida para la
# creación de modelos en dichos problemas. 


# Formación y evaluación de modelos

# Predeciremos la satisfacción del cliente. Los datos se
# basan en un antiguo concurso online. Tomamos la parte de entrenamiento de los datos y la
# limpiamos para nuestro uso (Santander customer satisfaction).
# Este es un conjunto de datos excelente para un problema de clasificación por muchas razones.
# Como muchos datos de clientes, es muy confuso, especialmente antes de que eliminaramos
# un montón de características inútiles (había algo así como cuatro docenas de funciones de
# variación cero). Como se analizó en termas previos anteriores, abordamos los valores
# faltantes, las dependencias lineales y los pares altamente correlacionados. También
# encontramos que los nombres de las funciones eran largos e inútiles, así que los codificamos
# de V1 a V142. Los datos resultantes abordan lo que normalmente es difícil de medir: la
# satisfacción. Debido a los métodos patentados, no se proporciona ninguna descripción o
# definición de satisfacción.
# El problema clásico es que se terminan con
# bastantes falsos positivos al intentar clasificar las etiquetas minoritarias.
# Entonces, comencemos cargando los datos y entrenando un algoritmo de regresión logística.


# Entrenamiento de un algoritmo de regresión logística
# Sigue estos sencillos pasos para entrenar un algoritmo de regresión logística:
#   1. El primer paso es asegurarnos de cargar nuestros paquetes y llamar a la biblioteca
# magrittr en nuestro entorno:
library(tidyverse)
library(magrittr)
library(caret)
library(classifierplots)
library(earth)
library(Information)
library(Metrics)

# 2. Aquí cargamos el archivo, luego verificamos las dimensiones y examinamos una
# tabla de etiquetas de clientes:
library(readr)
santander <- read_csv("Desktop/UNIVERSITY/Servicio-Social/Data-Mining/Regresion Logistica/santander_prepd.csv")
dim(santander)

table(santander$y)

# Tenemos 76,020 observaciones, pero sólo 3,008 clientes están etiquetados con 1, lo
# que significa insatisfecho. A continuación, usaremos el símbolo de intercalación para
# crear conjuntos de entrenamiento y prueba con una división 80/20.

# 3. Dentro de la función createDataPartition() de caret, estratifica automáticamente la
# muestra según la respuesta, por lo que podemos estar seguros de tener un porcentaje
# equilibrado entre el entrenamiento y los conjuntos de prueba:

set.seed(1966)
trainIndex <- caret::createDataPartition(santander$y, p = 0.8, list = FALSE)
train <- santander[trainIndex, ]
test <- santander[-trainIndex, ]

# 4. Veamos cómo se equilibra la respuesta entre los dos conjuntos de datos:
table(train$y)

table(test$y)

# Hay aproximadamente un 4 por ciento en cada conjunto, así que podemos continuar.
# Una cosa interesante que puede suceder cuando divides los datos es que ahora
# terminas con lo que era una característica de varianza casi cero convirtiéndose en una
# característica de varianza cero en tu conjunto de entrenamiento. Cuando trates estos
# datos, solo elimina las características de varianza cero.


# 5. Hubo algunas características de baja variación, así que veamos si podemos eliminar
# algunas nuevas de variación cero:

# identifica las características en el conjunto de datos train que tienen una varianza muy baja.
# Las características con una varianza muy baja pueden no ser informativas para su modelo y podrían eliminarse antes del entrenamiento.
train_zero <- caret::nearZeroVar(train, saveMetrics = TRUE)
table(train_zero$zeroVar)


# 6. Bien, una característica ahora tiene variación cero debido a la división y podemos
# eliminarla:

# selecciona todas las filas y solo aquellas columnas 
# donde el valor en zeroVar  es FALSE. 
# solo conserva las columnas que no fueron identificadas como de baja varianza en el paso anterior
train <- train[, train_zero$zeroVar == 'FALSE']

# Como hicimos con la regresión lineal, para que la regresión logística tenga
# resultados significativos, es decir, que no se sobreajuste, es necesario reducir la cantidad de
# características de entrada. Podríamos seguir adelante con una selección gradual o similar,
# como hicimos en el tema de regresión lineal. Podríamos implementar métodos de
# regularización de características. Sin embargo, queremos presentar un método de reducción
# de características univariadas utilizando el peso de la evidencia (WOE, Weight Of Evidence)
# y el valor de la información (IV, Information Value) y discutir cómo podemos comprender
# cómo usarlo en un problema de clasificación junto con la regresión logística.


# Peso de la evidencia y valor de la información
# 
# Dada la posibilidad de cientos, incluso miles, de características posibles, tuvimos que
# aprender el uso de WOE y IV. Ahora bien, este método no es una panacea. En primer lugar,
# es univariado, por lo que las características que se descartan pueden volverse significativas
# en un modelo multivariado y viceversa. Podemos decir que proporciona un buen
# complemento a otros métodos y deberías tenerlo en tu caja de herramientas de modelado.
# Creo que tuvo su origen en el mundo de la calificación crediticia, por lo que, si trabajas en la
# industria financiera, es posible que ya estés familiarizado con él.
# Primero, veamos la fórmula de WOE:
#   𝑊𝑂𝐸 = ln (porcentaje de eventos)/ (porcentaje de no eventos)

# El WOE sirve como componente del IV. Para funciones numéricas, agruparía tus datos y
# luego calcularías WOE por separado para cada contenedor. Para los categóricos, o cuando
# están codificados en caliente, agrupa para cada nivel y calcula el WOE por separado. 




# Tomemos un ejemplo y demostremos en R.
# Nuestros datos constan de una característica de entrada codificada como 0 o 1, por lo que
# solo tendremos dos contenedores. Para cada contenedor (bin), calculamos nuestro WOE. En
# el contenedor 1, o donde los valores son iguales a 0, hay cuatro observaciones como eventos
# y 96 como no eventos. Por el contrario, en el grupo 2, o donde los valores son iguales a 1,
# tenemos 12 observaciones como eventos y 88 como no eventos. Veamos cómo calcular el
# WOE para cada contenedor:
bin1events <- 4
bin1nonEvents <- 96
bin2events <- 12
bin2nonEvents <- 88
totalEvents <- bin1events + bin2events
totalNonEvents <- bin1nonEvents + bin2nonEvents
# Now calculate the percentage per bin
bin1percentE <- bin1events / totalEvents
bin1percentNE <- bin1nonEvents / totalNonEvents
bin2percentE <- bin2events / totalEvents
bin2percentNE <- bin2nonEvents / totalNonEvents
# It's now possible to produce WOE
bin1WOE <- log(bin1percentE / bin1percentNE)
bin2WOE <- log(bin2percentE / bin2percentNE)
bin1WOE
bin2WOE

# La fórmula es la siguiente:
#   𝐼𝑉 = ∑(Porcentaje de eventos − Porcentaje de no eventos) ∗ WOE


# Tomando nuestro ejemplo actual; esta es nuestra característica IV:
bin1IV <- (bin1percentE - bin1percentNE) * bin1WOE
bin2IV <- (bin2percentE - bin2percentNE) * bin2WOE

bin1IV + bin2IV

# El IV de la característica es 0.322. Ahora bien, ¿qué significa eso? La respuesta corta es que
# depende. Se proporciona una heurística para ayudar a decidir qué umbral IV tiene sentido
# para su inclusión en el desarrollo del modelo:
#   • < 0.02 no predictivo
# • 0.02 a 0.1 débil
# • 0.1 a 0.3 medio
# • 0.3 a 0.5 fuerte
# • 0.5 sospechoso
# Nuestro siguiente ejemplo nos proporcionará decisiones interesantes que tomar con respecto
# a dónde trazar la línea.


# Selección de características
# Lo que vamos a hacer ahora es usar el paquete Information para calcular los IV de nuestras
# funciones. Luego, se mostrará cómo evaluar esos valores y también ejecutar algunos gráficos.
# Dado que no existen reglas estrictas y rápidas sobre los umbrales para la inclusión de
# funciones, daremos una opinión sobre dónde trazar la línea. Por supuesto, puedes rechazar
# eso y aplicar el tuyo propio.
# En este ejemplo, el código creará una serie de tablas que puedes utilizar para explorar los
# resultados. Para comenzar, solo necesitas especificar los datos y la respuesta o variable "y":

IV <- Information::create_infotables(data = train, y = "y", parallel = FALSE)
# Esto nos dará un resumen IV de las 25 características principales:
knitr::kable(head(IV$Summary, 25))
