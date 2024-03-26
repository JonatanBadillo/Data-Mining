# Predecir el hype train de los videojuegos

# Utilizando un clasificador Naïve Bayes y un conjunto de datos de 1515 ratings de
# videojuegos, predeciremos qué desarrollador es más probable que haga un juego con
# propiedades específicas (metascore, clasificación ESRB, género, plataforma) en el futuro.


# Aprendizaje Naïve Bayes

# Un clasificador Naïve Bayes es un método muy simple para predecir resultados categóricos.


# Preparacion de los datos
# algunos juegos aparecen más de una vez porque hay entradas separadas para las diferentes
# plataformas (PC, PS4, Switch, ...).


library(data.table)
#  Carga el archivo CSV "metacritic_games.csv" en un objeto data.table llamado games
games <- fread("metacritic_games.csv")

# Crea una tabla de frecuencias para contar cuántas veces aparece cada desarrollador en la columna "developer" 
dev.tab <- table(games$developer)

# Filtra el conjunto de datos games para incluir solo las filas donde el desarrollador aparezca al menos 10 veces. 
# Esto se logra mediante la selección de aquellos nombres de desarrolladores cuyas frecuencias son mayores o iguales a 10 en dev.tab, 
# se seleccionan solo las filas correspondientes en games.
games <- games[games$developer %in% names(dev.tab[dev.tab >= 10]),]

# Exclude empty developers
# Excluye del conjunto de datos games aquellas filas donde el nombre del desarrollador es una cadena vacía.
games <- games[games$developer != "",]


# Exclude empty ESRP ratings
# Excluye del conjunto de datos games aquellas filas donde el rating es una cadena vacía.
games <- games[games$rating != "",]

# Nos quedamos con 1515 juegos de 82 desarrolladores.
nrow(games)
length(unique(games$developer))

