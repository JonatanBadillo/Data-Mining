# Ejercicio Propuesto para practica de Examen

# Crea un clasificador basado en k-NN a partir de los
# puntajes de lectura, escritura, matemáticas y ciencias de los estudiantes de secundaria. Evalúa
# la precisión del clasificador para predecir a qué programa académico se unirá el estudiante.

library(readr)
hsbdemo <- read_csv("hsbdemo.csv")
View(hsbdemo)