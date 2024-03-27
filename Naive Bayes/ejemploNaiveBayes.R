# Ejemplo con Naive Bayes

# Ejemplo 1: Predecir vuelos retrasados
# El objetivo es predecir con precisión si se retrasará o no un nuevo
# vuelo (no en este conjunto de datos). La variable de resultado es si el vuelo se retrasó y, por
# lo tanto, tiene dos clases (1 = retrasado y 0 = puntual).

# Los datos se dividieron primero en conjuntos de entrenamiento (60%) y validación (40%), y
# luego se aplicó un clasificador Naïve Bayes al conjunto de entrenamiento (usamos el paquete e1071).

library(e1071)
delays.df <- read.csv("FlightDelays.csv")

# se cambian primero las variables numericas a categoricas
# representan días de la semana y horas de salida, respectivamente, y se prefieren como 
# variables categóricas en lugar de numéricas para evitar que los modelos de aprendizaje
# los interpreten como valores numéricos continuos.
delays.df$DAY_WEEK <- factor(delays.df$DAY_WEEK)
delays.df$DEP_TIME <- factor(delays.df$DEP_TIME)


# se crea la hora de salida de los contenedores(bins) por hora
delays.df$CRS_DEP_TIME <- factor(round(delays.df$CRS_DEP_TIME/100))


# se crean conjuntos de entrenamiento y validacion
# contiene los índices de las variables seleccionadas. Estos índices corresponden a columnas específicas en el dataframe
selected.var <- c(10, 1, 8, 4, 2, 13)
# Crea un conjunto de índices de muestra para el conjunto de entrenamiento (train.index).

#  Genera un conjunto de índices de muestra aleatorios (train.index) que representa el 60% del no. total de filas en el dataframe delays.df.
train.index <- sample(c(1:dim(delays.df)[1]), dim(delays.df)[1]*0.6)

# train.df contiene una parte de los datos originales para entrenamiento, 
# valid.df contiene la parte restante de los datos para validación.
train.df <- delays.df[train.index, selected.var]
valid.df <- delays.df[-train.index, selected.var]


# se ejecuta Naive Bayes
delays.nb <- naiveBayes(Flight.Status ~ ., data = train.df)
delays.nb


# use prop.table() with margin = 1 to convert a count table to a proportion table,
# where each row sums up to 1 (use margin = 2 for column sums).
prop.table(table(train.df$Flight.Status, train.df$DEST), margin = 1)


# Predice las probabilidades
pred.prob <- predict(delays.nb, newdata = valid.df, type = "raw")
# Predice la membresia de las clases
pred.class <- predict(delays.nb, newdata = valid.df)
df <- data.frame(actual = valid.df$Flight.Status, predicted = pred.class, pred.prob)
df[valid.df$CARRIER == "DL" & valid.df$DAY_WEEK == 7 & valid.df$CRS_DEP_TIME == 10 & valid.df$DEST == "LGA" & valid.df$ORIGIN == "DCA",]





