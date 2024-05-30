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








