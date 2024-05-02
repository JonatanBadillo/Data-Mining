# Ejemplo de regresión lineal
# 
# En estadística, la regresión lineal se usa para modelar una relación entre una variable
# dependiente continua y una o más variables independientes. La variable independiente puede
# ser categórica o numérica. El caso en el que solo tenemos una variable independiente se
# denomina regresión lineal simple. Si tenemos más de una variable independiente, entonces
# se llama regresión multivariada.
# Una representación matemática de un modelo de regresión lineal es la siguiente:
#   
#   Y = β0 + β1X1 + β2X2 + β3X3 + ... + βnXn + error
# 
# En la ecuación anterior, el coeficiente β_0 representa la intersección y el coeficiente β_i
# representa la pendiente. Aquí usaremos un enfoque de estudio de caso para ayudarlo a
# comprender el algoritmo de regresión lineal.

# En el estudio de caso a continuación, usaremos datos de vivienda de EE. UU. para predecir
# el precio. Veamos las seis observaciones principales de los datos de vivienda de EE. UU.

housing <- read.csv("USA_Housing.csv", header = TRUE, sep = ",")
head(housing)



# Análisis exploratorio de datos
# 
# El ejercicio de análisis exploratorio de datos es fundamental para cualquier proyecto
# relacionado con el aprendizaje automático (o minería de datos). Es un enfoque para
# comprender y resumir las principales características de un dato dado. En su mayoría, esto
# implica cortar y dividir los datos en diferentes niveles, y los resultados a menudo se presentan
# con métodos visuales. Si se hace correctamente, puede revelar muchos aspectos de los datos,
# lo que seguramente te ayudará a construir mejores modelos.


# Cada conjunto de datos es diferente y, por lo tanto, no es fácil enumerar los pasos que se
# deben realizar como parte de la exploración de datos. Sin embargo, la clave para un EDA
# exitoso es seguir haciendo las preguntas que uno cree que ayudan a resolver el problema
# comercial o presentar todo tipo de hipótesis y luego probarlas usando las pruebas estadísticas
# apropiadas.

# En otras palabras, trata de averiguar si existe una relación estadísticamente significativa entre
# el objetivo y las variables independientes. ¿Cuáles son las cosas que derivan las variables
# objetivo?


#   A continuación, hay algunas cosas que deberíamos considerar explorar desde el punto de
# vista estadístico:

#   1. Comprobación de la distribución de la variable objetivo: En primer lugar, siempre debe
# tratar de comprender la naturaleza de su variable objetivo. Para lograr esto, dibujaremos un
# histograma con un gráfico de densidad.

library(ggplot2)
ggplot(data=housing, aes(housing$Price)) + # especifica el conjunto de datos housing y la variable Price que se utilizará para trazar los datos. 
                                           # aes() se utiliza para mapear variables estéticas, como x, y, color, forma, etc.
  geom_histogram(aes(y =..density..), fill = "orange") + # ..density.. se utiliza para normalizar la distribución en el histograma.
                                                         # para que la suma de las áreas de las barras sea igual a 1,
  geom_density() # agrega una capa de gráfico de densidad al gráfico utilizando la función geom_density(). Esto muestra la distribución de probabilidad de los datos continuos. 

# La variable precio (price) sigue una distribución normal y es bueno que la variable objetivo
# siga una distribución normal desde la perspectiva de las regresiones lineales.




# 2. Análisis de estadísticas de resumen:

# Aquí, simplemente crearemos estadísticas de
# resumen para todas las variables para comprender el comportamiento de todas las variables
# independientes. También proporcionará información sobre valores faltantes o valores
# atípicos, si los hubiera. 
# Tanto los valores perdidos como los valores atípicos son motivo de preocupación para los
# modelos de Machine Learning, ya que tienden a empujar el resultado hacia valores extremos.
library(psych)
psych::describe(housing)


# 3. Comprobación de valores atípicos mediante diagramas de caja: 

# “Cómo identificar y tratar los valores atípicos mediante métodos univariados o
# multivariados”. Aquí se está usando un diagrama de caja para trazar la distribución de cada
# variable numérica para verificar si hay valores atípicos.
# Si los puntos se encuentran más allá de los susurros, entonces tenemos valores atípicos
# presentes. Por ahora, solo vamos por análisis de valores atípicos univariados. Pero se te anima
# que busques también valores atípicos en un nivel multivariado. Si hay valores atípicos, debes
# eliminarlos o realizar un tratamiento adecuado antes de seguir adelante.
library(reshape)
meltData <- melt(housing)

p <- ggplot(meltData, aes(factor(variable), value))
p + geom_boxplot() + facet_wrap(~variable, scale="free")
# Aparte del área del número de habitaciones, todas las demás variables parecen tener valores
# atípicos


# 4. Visualización de matriz de correlación
# Usaremos el paquete corrgram para visualizar y analizar la matriz de correlación. En teoría, la
# correlación entre las variables independientes debería ser cero. En la práctica, esperamos y
# estamos de acuerdo con una correlación débil o nula entre las variables independientes.
# También esperamos que las variables independientes reflejen una alta correlación con la
# variable objetivo.
require(corrgram)
corrgram(housing, order=TRUE)




# Entrenamiento del modelo de regresión

# Para construir una regresión lineal, usaremos la función lm(). La función toma dos
# argumentos principales.
#     • Formula que establece las variables dependientes e independientes separadas por
#     ~(tilder).
#     • El nombre del conjunto de datos (dataset).
#     • Hay otros argumentos útiles y, por lo tanto, te solicitaremos que uses help (lm) para
#     leer más de la documentación.

# División de los datos en subconjuntos de entrenamiento y prueba
# Los datos de la vivienda se dividen en 70:30 división de entrenamiento y prueba. La división
# 70:30 es la más común y se usa principalmente durante la fase de entrenamiento. El 70 % de
# los datos se usa para entrenamiento, y el 30 % restante es para probar qué tan bien pudimos
# aprender el comportamiento de los datos.
library(caret)
index <- createDataPartition(housing$Price, p = .70, list = FALSE)
train <- housing[index, ]
test <- housing[-index, ]
dim(train)

# Puedes ver que tenemos el 70 % de las observaciones aleatorias en el conjunto de datos de
# entrenamiento.



# Construcción del modelo
# Training model
lmModel <- lm(Price ~ . , data = train) #  especifica que la variable dependiente es Price, y el . indica que todas las demás variables en el conjunto de datos train se utilizarán como variables independientes para predecir Price.
# Printing the model object
print(lmModel)





# Interpretación de los coeficientes de regresión

# En el resultado anterior, Intercept representa el valor mínimo de Price que se recibirá, si todas
# las variables son constantes o están ausentes.
# Ten en cuenta
# La intercepción no siempre tiene sentido en términos comerciales.
# La pendiente (representada por variables independientes) nos informa sobre la tasa de cambio
# que presenciará la variable Precio (Price), con cada cambio de una unidad en la variable
# independiente. Por ejemplo, si AreaHouse de la casa aumenta en una unidad más, el Precio
# de la casa aumentará en 165,637.




# Validación de modelos y coeficientes de regresión

# En R, la función lm ejecuta una prueba t de una muestra contra cada
# coeficiente beta para garantizar que sean significativos y que no se hayan producido por
# casualidad. Del mismo modo, necesitamos validar el modelo general. Al igual que una prueba
# t de una muestra, la función lm también genera tres estadísticas, que ayudan a los científicos
# de datos a validar el modelo. Estas estadísticas incluyen R-Square, R-Square ajustado y F-
#   test, también conocidas como pruebas globales.

# Para ver estas estadísticas, necesitamos pasar el objeto lmModel a la función summary().
summary(lmModel)




# En el resultado anterior, Pr(>|t|) representa el valor p, que se puede comparar con el valor
# alfa de 0.05 para garantizar si el coeficiente beta correspondiente es significativo o no. La
# función lm aquí ayuda. Todos los valores en la salida que tienen (.) punto o (*) asterisco
# contra los nombres de las variables indican que estos valores son significativos. Con base en
# esto, ahora sabemos que todas las variables son estadísticamente significativas excepto
# Avg..AreaNumberofBedrooms.

# Para la precisión general del modelo, analicemos las estadísticas generadas por la función lm
# una por una.

# 1. R-cuadrado múltiple: 0.919: El valor de R-cuadrado se denomina formalmente coeficiente
# de determinación. Aquí, 0.919 indica que las variables intersección, Ingreso de área, Casa de
# área, Número de habitaciones de área y Población de área, cuando se juntan, pueden explicar
# el 91.9 % de la varianza en la variable Precio. El valor de R-cuadrado se encuentra entre 0 y
# 1. En aplicaciones prácticas, si el valor de R2 es superior a 0.70, lo consideramos un buen
# modelo.

# 2. R-cuadrado ajustado: 0.9189: El valor de R-cuadrado ajustado indica si la adición de nueva
# información (variable) aporta una mejora significativa al modelo o no. Así que, a partir de
# ahora, este valor no proporciona mucha información. Sin embargo, el aumento en el valor de
# R-cuadrado ajustado con la adición de una nueva variable indicará que la variable es útil y
# aporta una mejora significativa al modelo.
# No se aprecia una gran diferencia entre el R-cuadrado y el R-cuadrado ajustado y
# generalmente indica que existe multicolinealidad dentro de los datos.

# 3. Estadístico F: 7925 en 5 y 3494 DF, p-value: < 2.2e-16 – Esta línea habla sobre la prueba
# global del modelo. La función lm ejecuta una prueba ANOVA para verificar la importancia
# del modelo general. Aquí la hipótesis nula es que el modelo no es significativo, y la
# alternativa es que el modelo es significativo. Según los valores de p < 0.05, nuestro modelo
# es significativo.




# Sin embargo, mirar estas estadísticas es suficiente para tomar una decisión sobre la
# importancia del modelo. Pero existen otros métodos de validación para la regresión lineal
# que pueden ser de ayuda al decidir qué tan bueno o malo es el modelo. Algunos de ellos se
# mencionan a continuación:

#   4. Valores AIC y BIC: el AIC (criterio de información de Akaike, 1974) y el BIC (criterio de
#   información bayesiano, 1978) son criterios de probabilidad penalizada. Ambas medidas
# utilizan una “medida de ajuste + penalización por complejidad” para obtener los valores
# finales.

# AIC = – 2 * ln(likelihood) + 2 * p
# BIC = – 2 * ln(likelihood) + ln(N) * p

# Aquí p = número de parámetros estimados y N = tamaño de muestra.
# Los valores AIC y BIC se pueden usar para elegir los mejores subconjuntos de predictores
# en regresión y para comparar diferentes modelos. Al comparar diferentes modelos, el modelo
# con valores mínimos de AIC y BIC se considera el mejor modelo.
# Nota:
#   Es probable que AIC sobreajuste los datos, mientras que BIC probablemente no ajuste los
# datos.

AIC(lmModel)

BIC(lmModel)


# 5. Error cuadrático medio (RMSE): Al comparar las estadísticas de RMSE de diferentes
# modelos, podemos decidir cuál es un mejor modelo. El modelo con el valor RMSE más bajo
# se considera un mejor modelo. Hay otras funciones similares como MAE, MAPE, MSE, etc.
# que se pueden usar. Estas funciones se pueden encontrar en Metrics R Package. Estas
# funciones toman principalmente dos argumentos: uno es el valor real y el segundo, los valores
# predichos. Así que veamos cómo podemos obtener estos valores. Los datos reales se pueden
# encontrar al 100 % a partir del conjunto de datos original o de los datos de entrenamiento en
# nuestro caso. Sin embargo, para encontrar los valores ajustados, necesitamos explorar el
# objeto modelo.

names(lmModel)

# El vector anterior presenta los nombres de los objetos que constituyen el objeto modelo.
# Aquí, los valores ajustados son los valores predichos. Ahora, usaremos estos valores para
# generar los valores rmse.

library(Metrics)
rmse(actual = train$Price, predicted = lmModel$fitted.values)




# Comprobación de supuestos de regresión lineal

# La regresión lineal es paramétrica, lo que significa que el algoritmo hace algunas
# suposiciones sobre los datos. Un modelo de regresión lineal solo se considera adecuado si se
# cumplen estos supuestos. Hay alrededor de cuatro suposiciones y se mencionan a
# continuación. Si el modelo no cumple con estos supuestos, entonces simplemente no
# podemos usar este modelo.


# 1. Los errores deben seguir una distribución normal: Esto se puede verificar dibujando
# un histograma de residuos o usando la función plot(). La función plot crea 4 gráficos
# diferentes. Uno de los cuales es un diagrama de NPP. El gráfico confirma si los errores siguen
# una distribución normal o no.

# Generando histograma
hist(lmModel$residuals, color = "grey")

# El histograma de errores anterior establece claramente que los errores se distribuyen
# normalmente.



# Generando gráfico NPP

# Exceptuamos que los puntos estén muy cerca de la línea punteada en un diagrama de NPP.
# Los puntos que están cerca de la línea significan que los errores siguen una distribución
# normal.

plot(lmModel)


# 2. No debe haber heterocedasticidad: Esto significa que la varianza de los términos de error
# debe ser constante. No veremos ningún patrón cuando dibujemos un gráfico entre residuos y
# valores ajustados. Y la línea media debe estar cerca de cero.
# Generación del diagrama de dispersión entre residuos y valores ajustados
plot(lmModel)

# Una línea roja recta más cercana al valor cero representa que no tenemos un problema de
# heterocedasticidad en nuestros datos.
