# Construyendo un modelo Naive Bayes

# Construir y evaluar el desempeño de un modelo de naïve Bayes para predecir la afiliación a un partido político.

# Imagina que eres un politólogo.
# Estás buscando patrones de votación comunes a mediados de la década de 1980 que
# predijeran si un congresista estadounidense era demócrata o republicano. tienes el registro de
# la votación de cada miembro de la Cámara de Representantes en 1984, e identificas 16
# los votos clave que tu crees que dividen más fuertemente a los dos partidos políticos.

# Tu trabajo es entrenar un modelo naïve Bayes para predecir si un congresista era demócrata
# o Republicano, basado en cómo votaron a lo largo del año. 



# Comencemos cargando los paquetes mlr y tidyverse:
library(mlr)
library(tidyverse)

# Cargando y explorando el conjunto de datos HouseVotes84
# Ahora vamos a cargar los datos, que están integrados en el paquete mlbench, convertirlos en
# un tibble (con as_tibble()) y explorarlo.

# Nota. Recuerda que un tibble es solo una versión tidyverse de un marco de datos que ayuda
# a hacer nuestras vidas un poco más fáciles.



# Tenemos un tibble que contiene 435 casos y 17 variables de miembros de la Cámara de
# Representantes en 1984. La variable Class es un factor que indica la afiliación a un partido
# político, y las otras 16 variables son factores que indican cómo votaron los individuos en
# cada uno de los 16 votos. Un valor de y significa que votaron a favor, un valor de n significa
# que votaron en contra y un valor faltante (NA) significa que la persona se abstuvo o no votó.

# Nuestro objetivo es entrenar un modelo que pueda usar la información de estas variables para
# predecir si un congresista era demócrata o republicano, en función de cómo votó.

data(HouseVotes84, package = "mlbench")
votesTib <- as_tibble(HouseVotes84)
votesTib


# Parece que tenemos algunos valores faltantes (NA) en nuestro tibble. Resumamos el número
# de valores faltantes en cada variable usando la función map_dbl(). Recordemos que
# map_dbl() itera una función sobre cada elemento de un vector/lista (o, en este caso, cada
# columna de un tibble), aplica una función a ese elemento y devuelve un vector que contiene
# la salida de la función.

# El primer argumento de la función map_dbl() es el nombre de los datos a los que vamos a
# aplicar la función, y el segundo argumento es la función que queremos aplicar.


# Elegimos usar una función anónima (usando el símbolo ~ como abreviatura de function(.).
  
                                
# Nuestra función pasa cada vector a sum(is.na(.)) para contar el número de valores faltantes
# en ese vector. Esta función se aplica a cada columna del tibble y devuelve el número de
# valores faltantes para cada uno.



# Cuenta cuántos valores faltantes (NA) hay en cada columna de un tibble llamado "votesTib" 
# y devuelve el resultado como un vector numérico donde cada elemento corresponde al número de valores faltantes en 
# una columna específica. 
map_dbl(votesTib, ~sum(is.na(.)))

# ¡Cada columna en nuestro tibble tiene valores perdidos excepto la variable Class!


