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




