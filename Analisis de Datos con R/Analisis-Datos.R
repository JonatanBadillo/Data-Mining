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

## Uso de estructuras de control en R
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
  
  
  
  