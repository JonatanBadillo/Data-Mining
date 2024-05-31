# Series de tiempo y causalidad

# Una serie de tiempo univariada es donde las mediciones se recopilan durante una medida de
# tiempo estándar, que podría ser por minuto, hora, día, semana, mes, etc. Lo que hace que las
# series temporales sean más problemáticas que otros datos es que el orden de las
# observaciones importa. Esta dependencia del orden puede hacer que los métodos de análisis
# estándar produzcan un sesgo o una variación innecesariamente altos.

# Otro aspecto de las series temporales que a menudo se pasa por alto es la causalidad. Sí, no
# queremos confundir correlación con causalidad, pero, en el análisis de series temporales,
# podemos aplicar la técnica de causalidad de Granger para determinar si la causalidad,
# estadísticamente hablando, existe.
# Aplicaremos series de tiempo/técnicas econométricas para identificar
# modelos de pronóstico univariados (incluidos conjuntos), modelos de vectores
# autorregresivos y, finalmente, la causalidad de Granger. 

# es posible que no domines completamente el análisis de series de tiempo, pero
# sabrás lo suficiente para realizar un análisis efectivo y comprender las cuestiones
# fundamentales a considerar al construir modelos de series de tiempo y crear modelos
# predictivos (pronósticos).
# Los siguientes son los temas que se cubrirán:
# • Análisis univariado de series de tiempo
# • Datos de series de tiempo
# • Modelado y evaluación




# Análisis univariado de series temporales

# Nos centraremos en dos métodos para analizar y pronosticar una única serie temporal:
# modelos de suavizado exponencial (exponential smoothing) y media móvil integrada
# autorregresiva (ARIMA, Autoregressive Integrated Moving Average). Comenzaremos
# analizando modelos de suavizado exponencial.
# Al igual que los modelos de media móvil, los modelos de suavizado exponencial utilizan
# ponderaciones para observaciones pasadas. Pero a diferencia de los modelos de media móvil, 
# cuanto más reciente es la observación, más peso se le da en relación con las posteriores. Hay
# tres posibles parámetros de suavizado para estimar: el parámetro de suavizado general, un
# parámetro de tendencia y el parámetro de suavizado estacional. Si no hay tendencia o
# estacionalidad, estos parámetros se vuelven nulos.

# El parámetro de suavizado produce un pronóstico (forecast) con la siguiente ecuación:
#   𝑌𝑡 + 1 = 𝛼(𝑌𝑡) + (1 − 𝛼)𝑌𝑡 − 1 + (1 − 𝛼)2𝑌𝑡 + ⋯ , donde 0 < 𝛼 ≤ 1

# En esta ecuación, Yt es el valor en ese momento, T, y alfa (α) es el parámetro de suavizado.
# Los algoritmos optimizan el alfa (y otros parámetros) minimizando los errores, la suma de
# errores cuadráticos (SSE, Sum of Squared Error) o la máxima verosimilitud.
# La ecuación de pronóstico junto con las ecuaciones de tendencia y estacionalidad, si
# corresponde, será la siguiente:
#   • El pronóstico, donde A es la ecuación de suavizado anterior y h es el número de
# períodos de pronóstico: 𝑌𝑡 + ℎ = 𝐴 + ℎ𝐵𝑡 + 𝑆𝑡
# • La ecuación de tendencia: 𝐵𝑡 = 𝛽(𝐴𝑡 − 𝐴𝑡 − 1) + (1 − 𝛽)𝐵𝑡 − 1
# • La estacionalidad, donde m es el número de períodos estacionales:
#   𝑆𝑡 = Ω(𝑌𝑡 − 𝐴𝑡 − 1 − 𝐵𝑡 − 1) + (1 − Ω)𝑆𝑡 − 𝑚

# Esta ecuación se conoce como método de Holt-Winters. La ecuación de pronóstico es de
# naturaleza aditiva y la tendencia es lineal. El método también permite la inclusión de una
# tendencia amortiguada y una estacionalidad multiplicativa, donde la estacionalidad aumenta
# o disminuye proporcionalmente con el tiempo. Con estos modelos, no tienes que preocuparte
# por el supuesto de estacionariedad como en un modelo ARIMA. La estacionariedad es
# cuando la serie de tiempo tiene una media, varianza y correlación constantes entre todos los
# períodos de tiempo. Dicho esto, sigue siendo importante comprender los modelos ARIMA,
# ya que habrá situaciones en las que tendrán el mejor rendimiento.
# Comenzando con el modelo autorregresivo, el valor de Y en el tiempo T es una función lineal
# de los valores anteriores de Y. La fórmula para un modelo autorregresivo de retraso lag-11
# AR(1) es 𝑌𝑡 = constante + Φ𝑌𝑡 − 1 + 𝐸𝑡. Los supuestos críticos para el modelo son los
# siguientes:
#   • Et denota los errores que se distribuyen de manera idéntica e independiente con una
# media cero y una varianza constante
# • Los errores son independientes de Yt
# • Yt, Yt-1, Yt-n... es estacionario, lo que significa que el valor absoluto de Φ es menor
# que uno

# Con una serie temporal estacionaria, se puede examinar la función de autocorrelación (ACF, Autocorrelation Function).
# El ACF de una serie estacionaria proporciona correlaciones entre
# Yt e Yt-h para h = 1, 2...n. Usemos R para crear una serie AR(1) y trazarla:

install.packages("forecast")
library(forecast)
set.seed(1966)

# este comando simula una serie temporal de un modelo autorregresivo de orden 1 (AR(1)).
# especifica el modelo AR(1) con un coeficiente autorregresivo de 0.5.
# order = c(1, 0, 0) indica que el modelo tiene un término autorregresivo de primer orden (1), sin diferencias (0), y sin términos de media móvil (0).
# ar = 0.5 especifica el coeficiente del término autorregresivo.
# n = 200 indica que se deben generar 200 observaciones para la serie temporal.
ar1 <- arima.sim(list(order = c(1, 0, 0), ar = 0.5), n = 200)
# Este comando utiliza la función autoplot del paquete forecast para graficar la serie temporal simulada.
forecast::autoplot(ar1, main = "AR1")


# Ahora, examinemos ACF:
# Calcula la función de autocorrelación (ACF) de la serie temporal ar1 sin generar un gráfico inmediatamente.
# Utiliza autoplot del paquete forecast para graficar la función de autocorrelación.
forecast::autoplot(acf(ar1, plot = F), main = "ACF of simulated AR1")



# El gráfico ACF muestra que las correlaciones disminuyen exponencialmente a medida que
# aumenta el Lag (retraso). Las líneas azules punteadas indican las bandas de confianza de una
# correlación significativa. Cualquier línea que se extienda por encima o por debajo de la banda
# mínima se considera significativa. Además de ACF, también deberíamos examinar la función
# de autocorrelación parcial (PACF, Partial Autocorrelation Function). La PACF es una
# correlación condicional, lo que significa que la correlación entre Yt e Yt-h está condicionada
# a las observaciones que se encuentran entre los dos. Una forma de entender esto
# intuitivamente es pensar en un modelo de regresión lineal y sus coeficientes. Supongamos
# que tienes Y = 0 + 1X1 versus Y = 0 + 1X1 + 2X2. La relación de X a Y en el primer
# modelo es lineal con un coeficiente, pero en el segundo modelo, el coeficiente será diferente
# debido a que ahora también se tiene en cuenta la relación entre Y y X2. Ten en cuenta que, en
# el siguiente gráfico PACF, el valor de autocorrelación parcial en el lag-1 es idéntico al valor
# de autocorrelación en el lag-1, ya que no se trata de una correlación condicional:

forecast::autoplot(pacf(ar1, plot = F), main = "PACF of simulated AR1")

# Podemos suponer con seguridad que la serie es estacionaria a partir de la apariencia del
# gráfico de la serie temporal anterior. Veremos un par de pruebas estadísticas en el ejercicio
# práctico para asegurarnos de que los datos sean estacionarios pero, en ocasiones, la prueba
# del globo ocular (eyeball test) es suficiente. Si los datos no son estacionarios, entonces es
# posible eliminar la tendencia de los datos tomando sus diferencias. 

# Este es el Integrado (I) en ARIMA. Después de diferenciar, la nueva serie se convierte en
# ΔYt = Yt - Yt-1. Se debería esperar que una diferencia de primer orden alcance la 
# estacionariedad pero, en algunas ocasiones, puede ser necesaria una diferencia de segundo
# orden. Un modelo ARIMA con AR(1) e I(1) se anotaría como (1, 1, 0).
# MA significa media móvil (Moving Average). Este no es el promedio móvil simple como el
# promedio móvil de 50 días del precio de una acción, sino más bien un coeficiente que se
# aplica a los errores. Por supuesto, los errores se distribuyen de forma idéntica e independiente
# con una media cero y una varianza constante. La fórmula para un modelo MA(1) es Yt =
# constante + Et + ΘEt-1. Como hicimos con el modelo AR(1), podemos construir un MA(1)
# en R, de la siguiente manera:

set.seed(123)
ma1 <- arima.sim(list(order = c(0, 0, 1), ma = -0.5), n = 200)
forecast::autoplot(ma1, main = "MA1")

# Los gráficos ACF y PACF son un poco diferentes del modelo AR(1). Ten en cuenta que
# existen algunas reglas generales al observar los gráficos para determinar si el modelo tiene
# términos AR y/o MA. Pueden ser un poco subjetivos, así que dejaremos que tu aprendas estas
# heurísticas, pero confiamos en R para identificar el modelo adecuado. En los siguientes
# gráficos, veremos una correlación significativa en el retraso 1 y dos correlaciones parciales
# significativas en el retraso 1 y el retraso 2:
forecast::autoplot(acf(ma1, plot = F), main = "ACF of simulated MA1")

# La figura anterior es el gráfico ACF y ahora veremos el gráfico PACF:
forecast::autoplot(pacf(ma1, plot = F), main = "PACF of simulated MA1")

# Con los modelos ARIMA es posible incorporar la estacionalidad, incluidos los términos
# autorregresivos, integrados y de media móvil. La notación del modelo ARIMA no estacional
# suele ser (p, d, q). Con ARIMA estacional, supongamos que los datos son mensuales,
# entonces la notación sería (p, d, q) × (P, D, Q)12, y el 12 en la notación tomaría en cuenta la
# estacionalidad mensual. En los paquetes que usaremos, R puede identificar automáticamente
# si se debe incluir la estacionalidad; de ser así, también se incluirán los términos óptimos.



# Comprender la causalidad de Granger
# Imagina que te hacen una pregunta como: ¿Cuál es la relación entre el número de recetas
# nuevas y el total de recetas del medicamento X? Tu sabes que estos se miden mensualmente,
# entonces, ¿qué podrías hacer para comprender esa relación, dado que la gente cree que los
# nuevos guiones aumentarán el total de guiones? ¿O qué tal si se prueba la hipótesis de que
# los precios de las materias primas (en particular, el cobre) son un indicador adelantado de los
# precios del mercado de valores en Estados Unidos?
#   Bueno, con dos conjuntos de datos de series temporales, x e y, la causalidad de Granger es
# un método que intenta determinar si es probable que una serie influya en un cambio en la
# otra. Esto se hace tomando diferentes rezagos de una serie y utilizándolos para modelar el
# cambio en la segunda serie. Para lograr esto, crearemos dos modelos que predecirán y, uno
# solo con los valores pasados de y(Ω) y el otro con los valores pasados de y y x(π). Los
# modelos son los siguientes, donde k es el número de rezagos en la serie de tiempo:
#   Sea Ω = 𝑦𝑡 = 𝛽0 + 𝛽1𝑦𝑡 − 1 + ⋯ 𝛽𝑘𝑦𝑡 − 𝑘 + 𝜖 y
# sea 𝜋 = 𝑦𝑡 = 𝛽0 + 𝛽1𝑦𝑡 − 1 + ⋯ + 𝛽𝑘𝑦𝑡 − 𝑘 + 𝛼1𝑦𝑡 − 1 + ⋯ + 𝛼𝑘𝑦𝑡 − 𝑘 + 𝜖
# Luego se compara el RSS y se utiliza la prueba F para determinar si el modelo anidado (Ω)
# es lo suficientemente adecuado para explicar los valores futuros de y o si el modelo completo
# (π) es mejor. La prueba F se utiliza para probar las siguientes hipótesis nulas y alternativas:
#   • H0:1=0 para cada i[1, k], sin causalidad de Granger
# • H1: 1≠0 para al menos un i[1, k], causalidad de Granger

# Básicamente, estamos tratando de determinar si podemos decir que, estadísticamente, x
# proporciona más información sobre los valores futuros de y que los valores pasados de y
# solos. En esta definición, está claro que no estamos tratando de probar una causalidad real,
# sólo que los dos valores están relacionados por algún fenómeno. En este sentido, también
# debemos ejecutar este modelo a la inversa para verificar que y no proporciona información
# sobre los valores futuros de x. Si encontramos que este es el caso, es probable que haya alguna
# variable exógena, digamos Z, que deba controlarse o que posiblemente sea una mejor
# candidata para la causalidad de Granger. Originalmente, había que aplicar el método a series
# temporales estacionarias para evitar resultados espurios. Este ya no es el caso como se
# demostrará.

# Hay un par de formas diferentes de identificar la estructura de retraso (lag) adecuada.
# Naturalmente, podemos utilizar la fuerza bruta y la ignorancia para probar todos los retrasos
# razonables, uno a la vez. Es posible que tengamos una intuición racional basada en la
# experiencia en el dominio o quizás en investigaciones previas que existan para guiar la
# selección del retraso.
# De lo contrario, puedes aplicar auto regresión vectorial (VAR, Vector Autoregression) para
# identificar la estructura de retraso con el criterio de información más bajo, como el criterio
# de información de Aikake (AIC, Aikake’s Information Criterion) o el error de predicción
# final (FPE, Final Prediction Error). Para simplificar, aquí está la notación para los modelos
# VAR con dos variables, y esto incorpora solo un lag para cada variable. Esta notación se
# puede ampliar para tantas variables y lags como sea apropiado:
#   • Y = constante1 + B11Yt-1 + B12Yt-1 + e1
# • X = constante1 + B21Yt-1 + B22Yt-1 + e2
# En R, este proceso es bastante sencillo de implementar como veremos en el siguiente
# problema práctico.



# ------------------------------------------------------------------------------

# Datos de series de tiempo

# El cambio climático está ocurriendo. Siempre lo ha sido y lo será, pero la gran pregunta, al
# menos desde un punto de vista político y económico, ¿es el cambio climático provocado por
# el hombre? Utilizaremos esta parte del documento para poner a prueba el modelado
# econométrico de series temporales para tratar de aprender si las emisiones de carbono causan,
# estadísticamente hablando, el cambio climático y, en particular, el aumento de las
# temperaturas.

# Los datos que usaremos se proporcionan como una anomalía anual, que se calcula como la
# diferencia de la temperatura superficial anual media para un período de tiempo determinado
# versus el promedio de los años de referencia (1961-1990). La temperatura superficial anual
# es un conjunto de temperaturas recopiladas a nivel mundial y combinadas a partir de los
# conjuntos de datos de temperatura del aire en la superficie CRUTEM4 y de la superficie del
# mar HadSST3. Los escépticos han atacado a los parciales y poco fiables:
#   https://www.telegraph.co.uk/comment/11561629/Top-scientists-start-to-examine-fiddledglobal-warming-figures.html. Esto está muy fuera de nuestro alcance de esfuerzo aquí, por
# lo que debemos aceptar y utilizar estos datos tal como están, pero de todos modos lo
# encontramos divertido. Obtuvimos los datos desde 1919 hasta 2013 para que coincidan con
# nuestros datos de CO2.

# Las estimaciones de emisiones globales de CO2 se pueden encontrar en el Centro de Análisis
# de Información sobre Dióxido de Carbono (CDIAC) del Departamento de Energía de EE.
# UU. en el siguiente sitio web: https://data.globalchange.gov/organization/carbon-dioxideinformation-analysis-center.
# Instalemos bibliotecas según sea necesario, carguemos los datos y examinemos la estructura:
library(magrittr)
library(ggthemes)
library(tseries)
library(ggplot2)
library(tidyverse)
climate <- readr::read_csv("climate.csv")
str(climate)


# Pondremos esto en una estructura de serie temporal, especificando los años de inicio y
# finalización:
climate_ts <- ts(climate[, 2:3],
                 start = 1919,
                 end = 2013)
#   Con nuestros datos cargados y colocados en estructuras de series temporales, ahora podemos
# comenzar a comprenderlos y prepararlos aún más para el análisis.


# Exploración de datos
# Comencemos con una gráfica de la serie temporal usando la base de R:

plot(climate_ts, main = "CO2 and Temperature Deviation")

# Parece que los niveles de CO2 realmente comenzaron a aumentar después de la Segunda
# Guerra Mundial y hay un rápido aumento de las anomalías de temperatura a mediados de los
# años 1970. No parece haber valores atípicos obvios y la variación a lo largo del tiempo parece
# constante.
# Utilizando el procedimiento estándar, podemos ver que las dos series están altamente
# correlacionadas, como sigue:
cor(climate_ts)


# Como se mencionó anteriormente, esto no es motivo de alegría, ya que no prueba
# absolutamente nada. Buscaremos la estructura trazando ACF y PACF para ambas series:
forecast::autoplot(acf(climate_ts[, 2], plot = F), main="Temperature ACF")

# Este código nos da el gráfico PACF para la temperatura:
forecast::autoplot(pacf(climate_ts[, 2], plot = F), main = "Temperature PACF")

# Este código nos da el gráfico ACF para CO2:
forecast::autoplot(acf(climate_ts[, 1], plot = F), main = "CO2 ACF")

# Este código nos da el gráfico PACF para CO2:
forecast::autoplot(acf(climate_ts[, 1], plot = F), main = "CO2 PACF")

# Con los patrones ACF que decaen lentamente y los patrones PACF que decaen rápidamente,
# podemos suponer que ambas series son autorregresivas, aunque Temp parece tener algunos
# términos MA significativos. A continuación, echemos un vistazo a la función de correlación
# cruzada (CCF, Cross-Correlation Function). Ten en cuenta que ponemos nuestra x antes de
# nuestra y en la función:

forecast::autoplot(ccf(climate_ts[, 1], climate_ts[, 2], plot = F), main = "CCF")

# El CCF nos muestra la correlación entre la temperatura y los lags de CO2. Si los lags
# negativos de la variable x tienen una correlación alta, podemos decir que x adelanta a y. Si
# los lags positivos de x tienen una correlación alta, decimos que x lags y. Aquí podemos ver
# que el CO2 es una variable tanto adelantada como retrasada. Para nuestro análisis, es
# alentador que veamos lo primero, pero extraño que veamos lo segundo. Veremos durante el
# análisis de causalidad del VAR y de Granger si esto importará o no.
# Además, necesitamos probar si los datos son estacionarios. Podemos probar esto con la
# prueba Augmented Dickey-Fuller (ADF) disponible en el paquete tseries, usando la función
# adf.test(), de la siguiente manera:

tseries::adf.test(climate_ts[, 1])
tseries::adf.test(climate_ts[, 2])

# Para ambas series, tenemos valores p insignificantes, por lo que no podemos rechazar el valor
# nulo y concluir que no son estacionarios.
# Habiendo explorado los datos, comencemos el proceso de modelado, comenzando con la
# aplicación de técnicas univariadas a las anomalías de temperatura.


# Modelado y evaluación
# Para el paso de modelado y evaluación, nos centraremos en tres tareas. La primera es producir
# un modelo de pronóstico univariado aplicado únicamente a la temperatura de la superficie.
# El segundo es desarrollar un modelo de auto regresión vectorial de la temperatura de la
# superficie y los niveles de CO2, utilizando ese resultado para informar nuestro trabajo sobre
# si los niveles de CO2 causan las anomalías de la temperatura de la superficie.
# Previsión de series temporales univariadas
# Con esta tarea, el objetivo es producir un pronóstico univariado para la temperatura de la
# superficie, centrándose en elegir un modelo de suavizado exponencial, un modelo ARIMA o
# un conjunto de métodos, incluida una red neuronal. Entrenaremos los modelos y
# determinaremos su precisión predictiva en un conjunto de pruebas fuera de tiempo, tal como
# lo hemos hecho en otros esfuerzos de aprendizaje. El siguiente código crea el entrenamiento
# y los conjuntos de prueba:
  
temp_ts <- ts(climate$Temp, start = 1919, frequency = 1)
train <- window(temp_ts, end = 2007)
test <- window(temp_ts, start = 2008)

# Para construir nuestro modelo de suavizado exponencial, usaremos la función ets() que se
# encuentra en el paquete forecast. La función encontrará el mejor modelo con el AIC más
# bajo:
  
fit.ets <- forecast::ets(train)
fit.ets

# El objeto modelo devuelve una serie de parámetros de interés. Lo primero que hay que
# comprobar es qué significa (A, A, N). Representa que el modelo seleccionado es un
# suavizado exponencial simple con errores aditivos. La primera letra indica el tipo de error, la 
# segunda letra la tendencia y la tercera letra la estacionalidad. Las letras posibles son las
# siguientes:
#   • A = aditivo
# • M = multiplicativo
# • N = ninguno
# También vemos las estimaciones de parámetros con alfa, el parámetro de suavizado, para la
# corrección de errores (el nivel) y beta para la pendiente. Los valores del estado inicial se
# utilizaron para iniciar la selección del modelo; sigma es la variación de los residuos y se
# proporcionan los valores de los criterios del modelo. Puedes trazar cómo cambian las
# estimaciones con el tiempo:
forecast::autoplot(fit.ets)


# Ahora trazaremos el pronóstico y veremos qué tan bien se desempeñó visualmente en los
# datos de prueba:
plot(forecast::forecast(fit.ets, h = 6))
lines(test, type = "o")


# Mirando el gráfico, parece que este pronóstico muestra una ligera tendencia alcista lineal y
# está sobreestimando los valores reales. Ahora veremos las medidas de precisión del modelo:
fit.ets %>% forecast::forecast(h = 6) %>%  forecast::accuracy(temp_ts)


# Hay ocho medidas de error. En el que creo que deberíamos centrarnos es en la U de Theil (en
# realidad, la U2, ya que la U de Theil original tenía algunos defectos), que sólo está disponible
# en los datos de prueba. La U de Theil es una estadística interesante ya que no depende de la
# escala, por lo que se pueden comparar varios modelos.
# Por ejemplo, si en un modelo transformas la serie temporal usando una escala logarítmica,
# puedes comparar la estadística con un modelo que no transforma los datos. Puedes
# considerarlo como la proporción en la que el pronóstico mejora la previsibilidad con respecto
# a un pronóstico ingenuo, o podemos describirlo como la raíz del error cuadrático medio
# (RMSE) del modelo dividido por el RMSE de un modelo ingenuo.
# Por lo tanto, las estadísticas U de Theil mayores que 1 funcionan peor que un pronóstico
# ingenuo, un valor de 1 equivale a ingenuo y menos de 1 indica que el modelo tiene un
# rendimiento ingenuo. Más información sobre cómo se deriva la estadística está disponible en
# este enlace:
#   https://www.researchgate.net/publication/323754973_Forecasting_methods_and_principles
# _Evidence-based_checklists_forecastingprinciplescom_forprincom
# El modelo de suavizado proporcionó una estadística de 0.7940449. Eso no es muy
# impresionante a pesar de que está por debajo de uno. En la opinión de los expertos,
# deberíamos esforzarnos por alcanzar valores iguales o inferiores a 0.5.
# Ahora desarrollaremos un modelo ARIMA, usando auto.arima(), que también pertenece al
# paquete forecast.
# Hay muchas opciones que puedes especificar en la función, o simplemente puedes incluir los
# datos de tu serie de tiempo y encontrarás el mejor ajuste ARIMA. Recomendamos utilizar la
# función con precaución, ya que a menudo puede devolver un modelo que viola los supuestos
# para los residuos, como veremos:
fit.arima <- forecast::auto.arima(train)
summary(fit.arima)


# El resultado abreviado muestra que el modelo seleccionado es AR = 0, I = 1 y MA = 4, I = 1, o
# ARIMA(0,1,4). Podemos examinar el gráfico de su desempeño en los datos de prueba de la misma
# manera que antes:
plot(forecast::forecast(fit.arima, h = 6))
lines(test, type = "o")