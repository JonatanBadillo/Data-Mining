# Construir un árbol de decisiones con rpart y cómo ajustar sus hiperparámetros.

# Imagina que trabajas en la participación pública en un santuario de vida silvestre.
# Tienes la tarea de crear un juego interactivo para niños para enseñarles sobre
# diferentes clases de animales.

# El juego pide a los niños que piensen en cualquier animal del santuario y luego les
# haces preguntas sobre las características físicas de ese animal. Según las respuestas
# que dé el niño, el modelo debe decirle a qué clase pertenece su animal (mamífero, ave, reptil, etc.).

# cargando los paquetes mlr y tidyverse:
library(mlr)
library(tidyverse) 
# Cargamos el conjunto de datos del zoológico integrado en el paquete mlbench, convirtámoslo en un tibble y exploremos.
data(Zoo, package = "mlbench")
zooTib <- as_tibble(Zoo)
zooTib
