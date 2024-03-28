# Ejercicio Propuesto para practica de Examen

# Crea un clasificador basado en k-NN a partir de los
# puntajes de lectura, escritura, matemáticas y ciencias de los estudiantes de secundaria. Evalúa
# la precisión del clasificador para predecir a qué programa académico se unirá el estudiante.

library(readr)
hsbdemo <- read_csv("hsbdemo.csv")
View(hsbdemo)

set.seed (1234)

# Dividimos en conjunto de prueba y entrenamiento
# Entrenamiento 67%
# Prueba 33%
sch <- sample(2,nrow(hsbdemo),replace = T,prob = c(0.67,0.33))

# Solo que tome las columnas necesarias que son los
# puntajes de lectura, escritura, matemáticas y ciencias de los estudiantes de secundaria.
school.training <- hsbdemo[sch==1,6:9]
school.test <- hsbdemo[sch==2,6:9]

# Especificamos cual es nuestra clase, en este caso queremos saber el programa(es nuestra variable objetivo) 
school.trainLabel <- hsbdemo[sch==1,5]
school.testLabel <- hsbdemo[sch==2,5]