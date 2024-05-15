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