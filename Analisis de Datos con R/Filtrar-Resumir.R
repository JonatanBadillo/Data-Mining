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
