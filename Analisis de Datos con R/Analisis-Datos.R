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

## FUNCIONES DE CICLO
# apply(): Evalúa una función en una sección de un arreglo y devuelve los resultados en un arreglo.
# lapply(): Recorre una lista y evalúa cada elemento o aplica la función a cada elemento.
# sapply(): Una aplicación fácil de usar de lapply() que devuelve un vector, matriz o arreglo.
# tapply(): Usualmente se usa sobre un subconjunto de un conjunto de datos

# Se utilizan para 
# Calcular la media, la suma o cualquier otra manipulación en una fila o columna.
# Transformar o realizar subconjuntos.
  

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

# sapply()
# El resultado de sapply() puede ser un vector o una matriz, mientras que el resultado de lapply() es una lista.

sap <- sapply(cars, mean)
sap
str(sap)

















