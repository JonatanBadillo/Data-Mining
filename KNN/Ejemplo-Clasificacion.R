# Ejemplo de clasificación basada en similaridades

# Imagina que trabajas en un hospital y estás intentando mejorar el diagnóstico de los pacientes
# con diabetes. Recopilas datos de diagnóstico durante unos meses de pacientes con sospecha
# de diabetes y registras si fueron diagnosticados como sanos, químicamente diabéticos o
# manifiestamente diabéticos. 

# Te gustaría usar el algoritmo k-NN para entrenar un modelo que
# pueda predecir a cuál de estas clases pertenecerá un nuevo paciente, de modo que se puedan
# mejorar los diagnósticos. Este es un problema de clasificación de tres clases.


# Comenzaremos con una forma simple e ingenua de construir un modelo k-NN y luego lo
# mejoraremos gradualmente. 


# Lo primero es lo primero:
#instalemos el paquete mlr y carguémoslo junto con tidyverse (igual y ya lo tienes instalado!):

library(mlr)
library(tidyverse)

# Cargar y explorar el conjunto de datos de diabetes
# carguemos algunos datos integrados en el paquete mclust, conviértelos en un tibble
# (un tibble es la forma tidyverse de almacenar datos rectangulares). Tenemos un tibble con 145 casos y 4 variables.

# El factor de clase muestra que 76 de los casos no eran diabéticos (Normal), 36 eran
# químicamente diabéticos (Chemical) y 33 eran manifiestamente diabéticos (Overt). Las otras
# tres variables son medidas continuas del nivel de glucosa e insulina en sangre después de una
#prueba de tolerancia a la glucosa (glucose e insulin, respectivamente) y el nivel de glucosa
# en sangre en estado estacionario (sspg).
library(mclust)
data(diabetes, package = "mclust")
diabetesTib <- as_tibble(diabetes)
summary(diabetesTib)

diabetesTib

# Para mostrar cómo se relacionan estas variables, se grafican

ggplot(diabetesTib, aes(glucose, insulin, col = class)) +geom_point() +
  theme_bw()
ggplot(diabetesTib, aes(sspg, insulin, col = class)) +
  geom_point() +
  theme_bw()
ggplot(diabetesTib, aes(sspg, glucose, col = class)) +
   geom_point() +
   theme_bw()

# Usando mlr para entrenar tu primer modelo k-NN

# La construcción de un modelo de aprendizaje automático con el
# paquete mlr tiene tres etapas principales:

  # 1. Definir la tarea. La tarea consiste en los datos y lo que queremos hacer con ellos. En
# este caso, los datos son diabetesTib y queremos clasificar los datos con la variable de
#clase como variable objetivo.

  # 2. Definir al aprendiz. El aprendiz es simplemente el nombre del algoritmo que
# planeamos usar, junto con cualquier argumento adicional que acepte el algoritmo.

  # 3. Entrenar el modelo. Esta etapa es lo que parece: pasas la tarea al aprendiz y el
# aprendiz genera un modelo que puede usar para hacer predicciones futuras.




# Queremos construir un modelo de clasificación, por lo que usamos la función
# makeClassifTask() para definir una tarea de clasificación.

# Suministramos el nombre de nuestro tibble como argumento de datos y el nombre del factor
# que contiene las etiquetas de clase como argumento de destino:
diabetesTask <- makeClassifTask(data = diabetesTib, target = "class")
diabetesTask


