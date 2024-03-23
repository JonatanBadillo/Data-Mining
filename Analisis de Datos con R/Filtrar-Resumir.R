# ELIMINAR DATOS INNECESARIOS
  # (FILAS)
  # Cargar datos con datos especificados(FILAS)
library(sqldf)
sqldf("SELECT * FROM mtcars WHERE am=1 AND vs=1")

  # Alternativamente:
subset(mtcars,am == 1 & vs == 1)



  # Eliminar columnas(solo seleccionar las columnas especificadaws)
subset(mtcars,am == 1 & vs == 1, select = hp:wt)
subset(mtcars,am == 1 & vs == 1, select = wt)


# ------------------------------------------------------------------------------
# Elimina datos innecesarios de una manera eficiente
library(hflights)
system.time(sqldf("SELECT * FROM hflights WHERE Dest == 'BNA'",row.names = TRUE))
#   user  system elapsed 
#   0.737   0.019   1.061

system.time(subset(hflights,Dest== 'BNA'))
#   user  system elapsed 
#   0.007   0.002   0.010 


library(dplyr)
system.time(filter(hflights, Dest == 'BNA'))
#  user  system elapsed 
#  0.010   0.001   0.012 

# podemos extender esta solución eliminando algunas columnas del conjunto de datos como lo hicimos antes con el subconjunto
str(select(filter(hflights,Dest == 'BNA'),DepTime:ArrTime))


# los nombres de las filas no se conservan en dplyr, 
# por lo que si los necesitas, vale la pena copiar los nombres en variables

mtcars$rownames <- rownames(mtcars)
select(filter(mtcars, hp>300),c(rownames,hp))








explícitas antes de pasarlas a dplyr o