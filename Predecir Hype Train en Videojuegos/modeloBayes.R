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