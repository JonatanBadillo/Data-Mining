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