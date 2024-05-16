# establecer el generador de números pseudoaleatorios
set.seed (10)
# Adjuntar Paquetes
library (tidyverse) # manipulación y visualización de datos
library (kernlab) # metodología SVM
library (e1071) # metodología SVM
library (ISLR) # contiene un conjunto de datos de ejemplo "Khan"
library (RColorBrewer) # coloración personalizada de las parcelas

# Clasificador de margen máximo

# Si las clases son separables por un límite lineal, podemos usar un clasificador de margen máximo para
# encontrar el límite de clasificación. Para visualizar un ejemplo de datos separados, generamos 40
# observaciones aleatorias y las asignamos a dos clases. Tras una inspección visual, podemos ver que existen
# infinitas líneas que dividen las dos clases.

# Construir el conjunto de datos de muestra - completamente separados
x <- matrix (rnorm (20 * 2), ncol = 2)
y <- c (rep (-1,10), rep (1,10))
x [y == 1,] <- x [y == 1,] + 3/2
dat <- data.frame (x = x, y = as.factor (y))

# Trazar datos
ggplot(data = dat, aes(x = x.2, y = x.1, color = y, shape = y)) +
  geom_point(size = 2) +
  scale_color_manual(values=c("#000000", "#FF0000")) +
  theme(legend.position = "none")

# 
# El objetivo del clasificador de margen máximo es identificar el límite lineal que maximiza la distancia total
# entre la línea y el punto más cercano en cada clase. Podemos usar la función svm() en el paquete e1071 para
# encontrar este límite.

# Ajustar el modelo de la máquina de vectores de soporte al conjunto de datos
svmfit <- svm(y~., data = dat, kernel = "linear", scale = FALSE)
# Plot Results
plot(svmfit, dat)

# 
# En la imagen, los puntos que están representados por una "x" son los vectores de soporte, o los puntos que
# afectan directamente a la línea de clasificación. Los puntos marcados con una "o" son los otros puntos, que
# no afectan el cálculo de la línea. Este principio sentará las bases para las máquinas de vectores de soporte.
# El mismo diagrama se puede generar usando el paquete kernlab, con los siguientes resultados:
# ajusta el modelo y realiza el plot

kernfit <- ksvm(x, y, type = "C-svc", kernel = 'vanilladot')
plot (kernfit, data = x)


# Clasificadores de vectores de soporte
# Por más conveniente que sea el clasificador marginal máximo para comprender, la mayoría de los conjuntos
# de datos reales no serán completamente separables por un límite lineal. Para manejar tales datos, debemos
# usar una metodología modificada. Simulamos un nuevo conjunto de datos donde las clases son más mixtas.
# Construir conjunto de datos de muestra: no completamente separados
x <- matrix(rnorm(20*2), ncol = 2)
y <- c(rep(-1,10), rep(1,10))
x[y==1,] <- x[y==1,] + 1
dat <- data.frame(x=x, y=as.factor(y))
# Conjunto de datos de trazado
ggplot(data = dat, aes(x = x.2, y = x.1, color = y, shape = y)) +
   geom_point(size = 2) +
  scale_color_manual(values=c("#000000", "#FF0000")) +
  theme(legend.position = "none")


# Si los datos son separables o no, la sintaxis del comando svm() es la misma. Sin embargo, en el caso de
# datos que no son separables linealmente, el argumento costo = adquiere una importancia real.
# Esto cuantifica la penalización asociada con tener una observación en el lado equivocado del límite de
# clasificación. Podemos trazar el ajuste de la misma manera que el caso completamente separable. Primero
# usamos e1071:
# Ajustar el modelo de la máquina de vectores de soporte al conjunto de datos
svmfit <- svm(y~., data = dat, kernel = "linear", cost = 10)
# Trazar resultados
plot(svmfit, dat)


# Al aumentar el costo de la clasificación errónea de 10 a 100, puedes ver la diferencia en la línea de
# clasificación. Repetimos el proceso de trazado de la SVM utilizando el paquete kernlab:
# Ajustar el modelo de la máquina de vectores de soporte al conjunto de datos
kernfit <- ksvm(x,y, type = "C-svc", kernel = 'vanilladot', C = 100)
# Trazar resultados
plot(kernfit, data = x)


# Pero, ¿cómo decidimos qué tan costosas son realmente estas clasificaciones erróneas? En lugar de
# especificar un costo por adelantado, podemos usar la función tune() de e1071 para probar varios costos e
# identificar qué valor produce el mejor modelo de ajuste.
# encontrar el costo óptimo de la clasificación errónea
tune.out <- tune(svm, y~., data = dat, kernel = "linear",
                  ranges = list(cost = c(0.001, 0.01, 0.1, 1, 5, 10, 100)))
# extraer el mejor modelo
(bestmod <- tune.out$best.model)


# Para nuestro conjunto de datos, el costo óptimo (de entre las opciones que proporcionamos) se calcula en
# 0.1, lo que no penaliza mucho al modelo por las observaciones mal clasificadas. Una vez que se ha
# identificado este modelo, podemos construir una tabla de clases pronosticadas contra clases verdaderas
# usando el comando predict() de la siguiente manera:
# Crear una tabla de observaciones mal clasificadas
ypred <- predict(bestmod, dat)
(misclass <- table(predict = ypred, truth = dat$y))
# Usando este clasificador de vector de soporte, el 80% de las observaciones fueron clasificadas
# correctamente, lo que coincide con lo que vemos en la gráfica.


# ------------------------------------------------------------------------------
# Máquinas de Vectores de Soporte
# Los clasificadores de vectores de soporte son un subconjunto del grupo de estructuras de clasificación
# conocidas como Máquinas de vectores de soporte. Las máquinas de vectores de soporte pueden construir
# límites de clasificación que no son de forma lineal. Las opciones para las estructuras de clasificación que
# utilizan el comando svm() del paquete e1071 son lineales, polinomiales, radiales y sigmoideas. Para
# demostrar un límite de clasificación no lineal, construiremos un nuevo conjunto de datos.
# construir un conjunto de datos aleatorios más grande
x <- matrix(rnorm(200*2), ncol = 2)
x[1:100,] <- x[1:100,] + 2.5
x[101:150,] <- x[101:150,] - 2.5
y <- c(rep(1,150), rep(2,50))
dat <- data.frame(x=x,y=as.factor(y))
# Trazar datos
ggplot(data = dat, aes(x = x.2, y = x.1, color = y, shape = y)) +
  geom_point(size = 2) +
  scale_color_manual(values=c("#000000", "#FF0000")) +
  theme(legend.position = "none")



# Ten en cuenta que los datos no son separables linealmente y, además, no están agrupados en un solo grupo.
# Hay dos secciones de observaciones de clase 1 con un grupo de observaciones de clase 2 en medio. Para
# demostrar el poder de las SVM, tomaremos 100 observaciones aleatorias del conjunto y las usaremos para
# construir nuestro límite. Establecemos kernel = "radial" en función de la forma de nuestros datos y
# graficamos los resultados.
# establecer generador de números pseudoaleatorios
set.seed(123)
# ejemplo de datos de entrenamiento y modelo de ajuste
train <- base::sample(200,100, replace = FALSE)
svmfit <- svm(y~., data = dat[train,], kernel = "radial", gamma = 1, cost = 1)
# grafica el clasificador
plot(svmfit, dat)


# El mismo procedimiento se puede ejecutar utilizando el paquete Kernlab, que tiene muchas más opciones
# de kernel que la función correspondiente en e1071. Además de las cuatro opciones en e1071, este paquete
# permite el uso de una tangente hiperbólica, Laplaciano, Bessel, Spline, String o ANOVA RBF kernel. Para
# ajustar esta información, establecemos que el costo sea el mismo que antes, 1.
# Ajustar SVM radial en kernlab
kernfit <- ksvm(x[train,],y[train], type = "C-svc", kernel = 'rbfdot', C = 1, scaled = c())
# Trazar los datos de entrenamiento
plot(kernfit, data = x[train,])

# 
# Vemos que, al menos visualmente, la SVM hace un trabajo razonable de separar las dos clases. Para
# ajustarse al modelo, utilizamos el cost = 1, pero como se mencionó anteriormente, no suele ser obvio qué
# costo producirá el límite de clasificación óptimo. Podemos usar el comando tune() para probar diferentes
# valores de costo así como varios valores diferentes de γ, un parámetro de escala utilizado para ajustarse a
# los límites no lineales.
# modelo de sintonía para encontrar un costo óptimo, valores gamma
tune.out <- tune(svm, y~., data = dat[train,], kernel = "radial",
                   ranges = list(cost = c(0.1,1,10,100,1000),
                                   gamma = c(0.5,1,2,3,4)))
# show best model
tune.out$best.model


# El modelo que reduce más el error en los datos de entrenamiento utiliza un costo de 01 y un valor γ de 1.
# Ahora podemos ver qué tan bien funciona la SVM al predecir la clase de las 100 observaciones de prueba:
# validar el rendimiento del modelo
(valid <- table(true = dat[-train,"y"], pred = predict(tune.out$best.model,newx = dat[-train,])))