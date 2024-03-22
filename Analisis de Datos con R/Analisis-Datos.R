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