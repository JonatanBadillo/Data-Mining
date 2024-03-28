# Ejercicio de k-NN

# El conjunto de datos incluye una muestra de 50 flores de tres especies de iris (Iris setosa, Iris
# virginica e Iris versicolor). Cada muestra se midió por cuatro características: el largo y el
# ancho de los sépalos y pétalos, en centímetros. Basándonos en la combinación de estos cuatro
# atributos, necesitamos distinguir las especies de iris.

install.packages("ggvis")
library(ggvis)

# Iris scatterplot
(iris %>% ggvis(~Sepal.Length, ~Sepal.Width, fill = ~Species) %>% layer_points)
