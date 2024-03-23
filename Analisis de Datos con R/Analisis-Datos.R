# Leer Datos en un archivo de texto:
myCSV<-read.csv ("Datasets/c31.csv", header=TRUE)
str (myCSV)

# Comando Read Table
myTable<-read.table("Datasets/c311.txt", sep="\t", header=TRUE)
str(myTable)

# Leer archivo XLSX
library(xlsx)
ruta <- "Datasets/c311Lot.xlsx"
mydataframe <- read.xlsx(ruta,1)
str(mydataframe)

# Leer archivo XLS
library(XLConnect)
myE1<-loadWorkbook("Datasets/c311Lot1.xls")
mydata<-readWorksheet(myE1,sheet="Lot",header=TRUE)
str(mydata)


# ------------------------------------------------------------------------------
## USO DE ESTRUCTURAS DE CONTROL EN R

# if y else: Prueba una condición
# while: Ejecuta un ciclo cuando una condición es verdadera
# for: Repite un número fijo de veces
# repeat: Ejecuta un ciclo continuamente (debe salir del ciclo salir)
# next: Opción para omitir una iteración de un ciclo
# break: Rompe la ejecución de un ciclo

# If else
#Generate uniform random number
x<-runif(1, 0, 20)
x
if (x>10) (
  print (x)
)else(
  print ("x is less than 10")
) 


# For
x<-c ("Juan", "Beni", "Jorge", "David")
x
for (i in 2:3) (
  ## Imprime solo 2 elementos
  print (x[i])
)  


# seq_along
# Genera un no. entero basado en la longitud del objeto
x
for (i in seq_along(x)) (
  print (x[i])
)   


# While
count<-0
while (count<10) {
  print(count)
  count=count+1
}
# ------------------------------------------------------------------------------
## FUNCIONES DE CICLO
# apply(): Evalúa una función en una sección de un arreglo y devuelve los resultados en un arreglo.
# lapply(): Recorre una lista y evalúa cada elemento o aplica la función a cada elemento.
# sapply(): Una aplicación fácil de usar de lapply() que devuelve un vector, matriz o arreglo.
# tapply(): Usualmente se usa sobre un subconjunto de un conjunto de datos

# Se utilizan para 
# Calcular la media, la suma o cualquier otra manipulación en una fila o columna.
# Transformar o realizar subconjuntos.
  
# ------------------------------------------------------------------------------
# apply()
# apply(), puedes realizar operaciones en cada fila o columna de una matriz o marco de datos o lista sin tener que escribir ciclos.

# function (X, MARGIN, FUN, ..., simplify = TRUE) 

# La función apply() toma lo siguiente:
  # X: Un arreglo
  # MARGIN: Un vector entero para indicar una fila o columna
  # FUN: El nombre de la función que estás aplicando

head (cars)
apply (cars, 2, mean)
apply(cars,2,quantile)


# ------------------------------------------------------------------------------
# lapply()
# La función lapply() genera los resultados como una list.lapply() y se puede aplicar a una lista, marco de datos o vector. 
# La salida siempre es una lista que tiene el mismo número de elementos que el objeto que se pasó a lapply():

# function (X, FUN, ...)
  # X: Conjunto de datos
  # FUN: Función
str(cars)

lap <- lapply(cars,mean)
lap
str(lap)

# ------------------------------------------------------------------------------
# sapply()
# El resultado de sapply() puede ser un vector o una matriz, mientras que el resultado de lapply() es una lista.

sap <- sapply(cars, mean)
sap
str(sap)

# ------------------------------------------------------------------------------
# tapply()
# Se usa sobre subconjuntos de un vector. La función tapply() es similar a otras funciones apply(), excepto que se aplica sobre un subconjunto de un conjunto de datos:

# function (X, INDEX, FUN = NULL, ..., default = NA, simplify = TRUE) 
  # X: Un vector
  # INDEX: Un factor o una lista de factores (o se convierten en factores)
  # FUN: Una función para aplicar
    # ... contiene otros argumentos para pasar a FUN
    # simplify, TRUE o FALSe para simplificar el resultado

# Supongamos que necesitas averiguar el consumo promedio de gasolina (mpg) de cada cilindro.
tapply(mtcars$mpg, mtcars$cyl, mean)
# Averiguar la potencia promedio (hp) para la transmisión automática y manual,
tapply(mtcars$hp,mtcars$am,mean)

# ------------------------------------------------------------------------------
# Cut()
# Es posible que debas dividir las variables continuas para colocarlas en diferentes contenedores.
Orange

# A continuación, crea cuatro grupos según la edad de los árboles. 
# El primer parámetro es el conjunto de datos y la edad, y el segundo parámetro es el número de grupos que se desea crear.
c1<-cut(Orange$age,breaks=4)
table(c1)
# Usando el comando seq(), puedes especificar los intervalos:
seq(100,2000,by=300)
c2<-cut(Orange$age,seq(100,2000,by=300))
table(c2)

# ------------------------------------------------------------------------------
# Split()
# Dividir el conjunto de datos en grupos.

# function (x, f, drop = FALSE, ...) 

# En el siguiente ejemplo, el conjunto de datos de Orange se divide en función de la edad.
# La diferencia es que el conjunto de datos se agrupa según la edad. Hay 7 grupos de edad y el conjunto de datos se divide en 7 grupos:

c3<-split(Orange,Orange$age)
c3









