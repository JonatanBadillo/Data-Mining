# ELIMINAR DATOS INNECESARIOS
  # (FILAS)
  # Cargar datos con datos especificados(FILAS)
library(sqldf)
sqldf("SELECT * FROM mtcars WHERE am=1 AND vs=1")

  # Alternativamente:
subset(mtcars,am == 1 & vs == 1)



  # Eliminar columnas(solo seleccionar las columnas especificadas)
subset(mtcars,am == 1 & vs == 1, select = hp:wt)
subset(mtcars,am == 1 & vs == 1, select = wt)
subset(mtcars,am == 1 & vs == 1, c(hp:wt))
subset(mtcars,am == 1 & vs == 1, c(wt))


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


# ------------------------------------------------------------------------------
# Elimina datos innecesarios de otra manera eficiente
# El paquete data.table proporciona una manera extremadamente eficiente de manejar
# conjuntos de datos más grandes en una estructura de datos en memoria autoindexada
library(data.table)

# transformar el data.frame tradicional de hflights en data.table
hflights_dt <- data.table(hflights)

# creamos una nueva columna, llamada nombres de fila, a la que
# asignamos los nombres de fila del conjunto de datos original con la ayuda del: = operador
# de asignación específico de data.table:
hflights_dt[,rownames := rownames(hflights)]
system.time(hflights_dt[Dest=='NBA'])

# De hecho, la sintaxis de data.table es bastante similar a SQL:
  # DT[i, j, ... , drop = TRUE]
# Esto se podría describir con comandos SQL de la siguiente manera:
  # DT[where, select | update, group by][having][order by][ ]...[ ]

# veamos cómo podemos seleccionar las columnas en la sintaxis data.table
# list se usó para definir las columnas requeridas para mantener
str(hflights_dt[Dest == 'BNA',list(DepTime,ArrTime)])

# aunque el uso de c () se usa más tradicionalmente
hflights_dt[Dest == 'BNA',c('DepTime','ArrTime'),with=FALSE]

# ------------------------------------------------------------------------------
# Agregación

# La forma más sencilla de resumir datos es llamar a la función aggregate desde el paquete
# de estadísticas (stats), que hace exactamente lo que estamos buscando: dividir los datos en
# subconjuntos por una variable de agrupación y luego calcular las estadísticas de resumen
# para ellos por separado.

aggregate(hflights$Diverted, by = list(hflights$DayOfWeek),FUN=mean)

# De manera alternativa:
with(hflights,aggregate(Diverted,by = list(DayOfWeek), FUN=mean))

# o...(notacion formula)
aggregate(Diverted ~ DayOfWeek, data=hflights,FUN = mean)


# ------------------------------------------------------------------------------
# Agregación más rápida con comandos base R
# llamar a la función tapply o by, que puedes aplicar una función R sobre una matriz irregular.
tapply(hflights$Diverted, hflights$DayOfWeek, mean)
#           1           2           3           4           5           6           7 
# 0.002997672 0.002559323 0.003226211 0.003065727 0.002687865 0.002823121 0.002589057 

# tapply devuelve un objeto arreglo en lugar de marcos de datos
# convenientes; por otro lado, se ejecuta mucho más rápido que las llamadas agregadas
# mencionadas anteriormente. Por lo tanto, podría ser razonable usar tapply para los cálculos
# y luego convertir los resultados a data.frame con los nombres de columna apropiados.







            