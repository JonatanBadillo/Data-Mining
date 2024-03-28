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

# Convertir las variables a matrices de datos simples
school.training <- as.matrix(school.training)
school.test <- as.matrix(school.test)

# Especificamos cual es nuestra clase, en este caso queremos saber el programa(es nuestra variable objetivo) 
school.trainLabel <- hsbdemo[sch==1,5]
school.testLabel <- hsbdemo[sch==2,5]

# Convertir las etiquetas de clase de listas a vectores
school.trainLabel <- school.trainLabel$prog
school.testLabel <- school.testLabel$prog



# Ahora construir el modelo KNN
# con K=9
library(class)


prog_pred <- knn(train = school.training, test = school.test, cl = school.trainLabel, k=9)

summary(prog_pred)
# academic  general vocation 
#  42       10       18

# Evaluar modelo con tabulacion cruzada
library(gmodels)
CrossTable(x=prog_pred, y=school.testLabel, prop.chisq = FALSE)

# De 70 predicciones, la precision fue de 43 correctas:
# es decir 43/70 = 0.61 de precision
