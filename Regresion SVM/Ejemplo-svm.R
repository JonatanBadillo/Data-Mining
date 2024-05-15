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
