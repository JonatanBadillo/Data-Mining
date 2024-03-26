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





