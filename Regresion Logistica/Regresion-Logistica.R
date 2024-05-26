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


# Los resultados nos muestran el número de columna de la característica, el nombre de la
# característica y el IV.
# Observa que tenemos cinco características que posiblemente sean sospechosas. Estoy
# totalmente a favor de tomar cualquier característica con un IV superior a 0.02, que es la parte
# inferior de los predictores débiles. Eso nos dará 21 funciones de entrada. La característica V2
# es interesante. Si nos fijamos en los valores y pensamos en los datos, parece claro que se trata
# de la edad del cliente. Veamos cómo se agrupan los datos, los valores WOE y los IV:

knitr::kable(IV$Tables$V2)

# Mira el contenedor número 2, que creo que tiene una edad
# de cliente de 23 años. Constituye casi el 27 por ciento del total de observaciones y aporta
# más de la mitad del IV. ¡Realmente sospechoso! ¿Cómo ayudará cualquier algoritmo que
# produzcamos con estos datos si esta característica es AGE genuina, como sospecho? Sin
# embargo, eso está fuera del alcance de este esfuerzo y no vale la pena perder más tiempo ni
# esfuerzo. Aquí podemos mostrar rápidamente un diagrama de barras de los WOE por
# contenedor:

Information::plot_infotables(IV, "V2", show_values = TRUE)

# Es interesante que exista una relación algo lineal entre esta característica y la respuesta. Lo
# que se puede hacer es crear funciones que conviertan los valores agrupados en valores WOE.
# Estas nuevas funciones serían lineales y podrían usarse en lugar de las funciones originales.
# Renunciaremos a eso porque ¿qué método hará eso por nosotros? Así es, ¡MARS
# puede hacer eso por nosotros! Aquí hay un diagrama de cuadrícula de las
# cuatro características principales:
Information::plot_infotables(IV, IV$Summary$Variable[1:4], same_scales=TRUE)



# Ahora, dado el punto de corte que elegimos anteriormente, podemos seleccionar esas 21
# características:
features <- IV$Summary$Variable[1:21]
train_reduced <- train[, colnames(train) %in% features]
train_reduced$y <- train$y
# Ahí tienes. Ahora estamos listos para comenzar a entrenar nuestro algoritmo.




# Validación cruzada y regresión logística

# Nuestro objetivo aquí es construir un modelo utilizando validación cruzada quíntuple.
# Utilizaremos el paquete de intercalación para establecer nuestro esquema de muestreo y
# producir el modelo final. Comience por crear una función trainControl() separada:
  
glm_control <-caret::trainControl(method = "cv",number = 5,returnResamp = "final")


# Este objeto se pasa como argumento para entrenar el algoritmo. Ahora producimos nuestras
# características de entrada, la variable de respuesta (debe ser un factor para que caret se entrene
# como regresión logística), configuramos nuestra semilla aleatoria y entrenamos el modelo.
# Para la función train(), especificamos glm para el modelo lineal generalizado (GLM, Generalized Linear Model):
x <- train_reduced[, -22]
y <- as.factor(train_reduced$y)
set.seed(1988)
glm_fit <-caret::train(x, y, method = "glm",
                        trControl = glm_control,
                        trace = FALSE)
# Cuando hayas terminado, podrás comprobar rápidamente los resultados:
glm_fit$results




# Mira eso, ¡96 por ciento de precisión! Sé que eso no tiene ningún sentido porque si
# supusiéramos que todas las etiquetas en la respuesta eran cero, alcanzaríamos el 96 por
# ciento.



# Kappa se refiere a lo que se conoce como estadística Kappa de Cohen. La estadística Kappa
# proporciona una idea de este problema ajustando las puntuaciones de precisión, lo que se
# hace teniendo en cuenta que el modelo es completamente correcto por mera casualidad. La
# fórmula de la estadística es la siguiente:
#   Kappa = (porcentaje de acuerdo − porcentaje de posible acuerdo)/(1
#                                                                    − porcentaje de posible acuerdo)
# El porcentaje de acuerdo es la tasa que el modelo acordó para la clase (precisión) y el
# porcentaje de posible acuerdo de probabilidad es la tasa que el modelo acordó aleatoriamente.
# Cuanto mayor sea la estadística, mejor será el rendimiento, siendo el acuerdo máximo uno.
# Entonces, con esta puntuación Kappa, el modelo es patético.
# Bueno, Kappa sería útil con etiquetas más equilibradas. Ahora nos quedamos para encontrar
# otras formas de examinar los resultados del modelo. Siempre es una buena idea comparar las
# distribuciones de probabilidad de las diferentes clases con un diagrama de densidad o caja.
# Aquí producimos una gráfica de densidad elegante y colorida en los datos de entrenamiento:

glm_train_pred <- predict(glm_fit, train, type = "prob")
colnames(glm_train_pred) <- c("zero", "one")
classifierplots::density_plot(train_reduced$y, glm_train_pred$one)


library(InformationValue)
glm_cutoff <-InformationValue::optimalCutoff(train_reduced$y,
    glm_train_pred$one,
    optimiseFor = 'Both',
    returnDiagnostics = TRUE)
# Si haces clic en glm_cutoff en tu entorno global o ejecutas View(glm_cutoff), verás una lista
# de seis resultados diferentes:

# Si seleccionamos un límite de 0.0606, lograremos una tasa de verdaderos positivos (TPR) de
# casi el 61 por ciento. Sin embargo, más del 19 por ciento serán falsos positivos.
# Dado el desequilibrio en las clases, se trata de una enorme cantidad de clientes. Una matriz
# de confusión puede demostrar ese hecho:
InformationValue::confusionMatrix(train_reduced$y, glm_train_pred$one, threshold = 0.0607)



glm_test_pred <- predict(glm_fit, test, type = "prob")
colnames(glm_test_pred) <- c("zero", "one")
classifierplots::density_plot(test$y, glm_test_pred$one)

# Resultados muy similares en los datos de la prueba. ¿Qué pasa con una matriz de confusión
# dado nuestro umbral determinado durante el entrenamiento? Vamos a ver:
InformationValue::confusionMatrix(test$y, glm_test_pred$one, threshold = 0.0607)


# ¡Resultados consistentes! Ahora, examinemos el rendimiento de este modelo en los datos de
# prueba para que podamos compararlo con lo que producirá el próximo modelo MARS. Dos
# métricas deberían abordar el problema: el área bajo la curva (AUC, Area Under the Curve)
# y la pérdida logarítmica (log-loss). El AUC proporciona un indicador útil de rendimiento y
# se puede demostrar que el AUC es igual a la probabilidad de que el observador identifique
# correctamente el caso positivo cuando se le presenta un par de casos elegidos al azar en los
# que un caso es positivo y el otro es positivo. En nuestro caso, cambiaremos de observador
# con nuestro algoritmo y evaluaremos en consecuencia. La pérdida logarítmica es una métrica
# eficaz, ya que tiene en cuenta la probabilidad prevista y cuánto se desvía de la etiqueta
# correcta. La siguiente fórmula lo produce:
Metrics::auc(test$y, glm_test_pred$one)
Metrics::logLoss(test$y, glm_test_pred$one)
# Nuestras AUC no son tan buenas, diríamos. Si el modelo no fuera mejor que una suposición
# aleatoria, entonces el AUC sería igual a 0.5 y, si fuera perfecto, sería 1. Nuestra pérdida
# logarítmica solo es esencial cuando se compara con el siguiente modelo.


# Lo entrenaremos con validación cruzada quíntuple y estableceremos nprune = 15 para limitar
# el número máximo de características a 15. Recuerda que, en regresión lineal múltiple, son
# posibles más de 15 términos ya que se ajusta a splines por partes.
# Este código nos dará nuestro objeto modelo. Ten en cuenta que esto puede tardar algún
# tiempo en completarse:
set.seed(1972)
earth_fit <-earth::earth(x = train[, -142],
    y = train[, 142],
    pmethod = 'cv',
    nfold = 5,
    degree = 1,
    minspan = -1,
    nprune = 15,
    glm = list(family = binomial)
    )
summary(earth_fit)
