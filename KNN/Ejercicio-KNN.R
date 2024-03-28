# Ejercicio de k-NN

# El conjunto de datos incluye una muestra de 50 flores de tres especies de iris (Iris setosa, Iris
# virginica e Iris versicolor). Cada muestra se midió por cuatro características: el largo y el
# ancho de los sépalos y pétalos, en centímetros. Basándonos en la combinación de estos cuatro
# atributos, necesitamos distinguir las especies de iris.

install.packages("ggvis")
library(ggvis)

# Iris scatterplot
(iris %>% ggvis(~Sepal.Length, ~Sepal.Width, fill = ~Species) %>% layer_points)


# Ploteo de datos de Iris en función de la longitud y el ancho de los pétalos de varias
# flores.

(iris %>% ggvis(~Petal.Length, ~Petal.Width, fill = ~Species) %>% layer_points())
# El gráfico indica una correlación positiva entre la longitud del pétalo y el ancho del pétalo
# para todas las diferentes especies que se incluyen en el conjunto de datos Iris.


# tendremos que dividir el conjunto de datos en dos partes: un conjunto de entrenamiento y un
# conjunto de prueba.

# Dividiremos todo el conjunto de datos en dos tercios y un tercio.

# La primera parte, la mayor
# parte del conjunto de datos, se reservará para entrenamiento, mientras que el resto del
# conjunto de datos se utilizará para pruebas.



# Para dividir el conjunto de datos en conjuntos de entrenamiento y de prueba, primero
#debemos establecer una semilla.

# La principal ventaja de establecer una semilla es que podemos obtener la misma secuencia de
# números aleatorios siempre que proporciones la misma semilla en el generador de números aleatorios.
set.seed (1234)



# queremos asegurarnos de que nuestro conjunto de datos de Iris se baraje y que tengamos la
# misma cantidad de cada especie en nuestros conjuntos de entrenamiento y prueba. Una forma
# de asegurarse de eso es usar la función sample() para tomar una muestra con un tamaño que
# se establece como el número de filas del conjunto de datos Iris (aquí, 150).

# Tomamos muestras con reemplazo: elegimos de un vector de dos elementos y asignamos "1"
# o "2" a las 150 filas del conjunto de datos Iris. La asignación de los elementos está sujeta a
# ponderaciones de probabilidad de 0.67 y 0.33. Esto da como resultado que aproximadamente
# dos tercios de los datos se etiqueten como "1" (entrenamiento) y el resto como "2" (prueba).



# crea un vector llamado "ind" donde cada elemento es un número aleatorio entre 1 y 2. 
# Cada número se elige de acuerdo con las probabilidades especificadas en el argumento prob, donde el 67% de las veces se asigna el número 1 y el 33% de las veces se asigna el número 2.
# replace = TRUE, es posible que haya repeticiones en el vector, lo que significa que un mismo número puede aparecer más de una vez.

# Este vector se usará para dividir el conjunto de datos iris en dos conjuntos, uno para entrenamiento y otro para prueba.
# sample se utiliza para generar un vector de muestras de dos valores (1 y 2).
ind <- sample (2, 
               # especifica el número de filas en el conjunto de datos iris
               nrow (iris), 
               # significa que las muestras se seleccionarán con reemplazo,permite que una misma fila pueda estar presente en ambos conjuntos.
               replace = TRUE, 
               # el 67% de las muestras tendrán el valor 1 y el 33% tendrán el valor 2.
               prob = c(0.67, 0.33))
# El vector ind que se genera tendrá la misma longitud que el número de filas en el conjunto de datos iris. 
# Cada elemento de este vector tendrá un valor de 1 o 2, determinado aleatoriamente según las probabilidades especificadas.


# Luego podemos usar la muestra que está almacenada en la variable "ind" para definir nuestros
# conjuntos de entrenamiento y prueba, tomando solo las primeras cuatro columnas o atributos
# de los datos.
iris.training <- iris [ind == 1, 1: 4]
iris.test <- iris [ind == 2, 1: 4]


# "Species", que es la etiqueta de la clase, es nuestra variable
# objetivo y los atributos restantes son atributos predictores. Por lo tanto, necesitamos
# almacenar la etiqueta de la clase en vectores de factores y dividirlos entre los conjuntos de
# entrenamiento y prueba, lo que se puede hacer siguiendo los siguientes pasos:
iris.trainLabels <- iris[ind==1,5]
iris.testLabels <- iris[ind==2,5]


# Listos para usar el K-NN

# La función knn() usa la distancia euclidiana para encontrar las
# similitudes entre las instancias de entrenamiento k y su instancia de prueba. El valor de k
# debe ser proporcionado por el usuario, que es usted en este caso.
install.packages("class")
library(class)
                  # indica que el modelo se entrenará utilizando el conjunto de datos iris.training.
Iris_pred <- knn(train = iris.training, 
                 # indica que el conjunto de datos que se va a utilizar para realizar las predicciones es iris.test
                 test = iris.test, 
                 # contiene las etiquetas de clase correspondientes a las observaciones en el conjunto de datos de entrenamiento.
                 cl = iris.trainLabels, 
                 #  Este argumento especifica el número de vecinos más cercanos que se utilizarán para hacer las predicciones.
                 k=3)

Iris_pred
summary(Iris_pred)

# Dado que hemos construido un modelo y hemos predicho las etiquetas de clase para nuestros
# atributos de prueba, evaluemos qué tan precisas son esas predicciones.

# Para esto, usaremos: tabulación cruzada.

# install.packages("gmodels")
library(gmodels)
CrossTable(x=Iris_pred, y=iris.testLabels, prop.chisq = FALSE)

# En esta tabla, podemos ver cómo nuestras predicciones (iris_pred) coincidieron con la verdad
# (iris.testLabels). Parece haber solo un caso en el que nos equivocamos: predecir "versicolor"
# para algo que era "virginica".

# Con esta tabla, puedes calcular fácilmente la precisión. De 40 predicciones, nos equivocamos
# una vez. Entonces eso nos da 39/40 = 97.5% de precisión.
