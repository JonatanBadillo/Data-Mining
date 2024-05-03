# Predicción con regresión lineal

# Para iniciar, necesitamos instalar los siguientes paquetes (si ya está instalado, solo cárgalo!):
library(tidyverse)
library(mlr)
library(imputeTS)
library(prettydoc)


# Necesitamos cargar el conjunto de datos que utilizaremos para este ejemplo de predicción.
coffee=read.csv("coffee_data.csv")
names(coffee)


# Este es un conjunto de datos muy grande. Se pueden hacer muchas cosas, pero hoy
# predeciremos los puntos del total de tazas de café usando la regresión lineal.
install.packages("naniar")
library(naniar)

coffee=coffee %>% select_if(is.numeric)# Esta línea selecciona solo las columnas numéricas decoffee utilizando la función select_if()
                                       # La función is.numeric se utiliza como criterio para seleccionar solo aquellas columnas que son numéricas. 
                                       # El operador %>%, toma el resultado de la expresión a su izquierda y lo pasa como primer argumento a la función a su derecha.
vis_miss(coffee) # para visualizar los valores faltantes en el dataframe resultante.



# Nuestra variable predictora no tiene datos faltantes. Algunos de los datos como
# altitude_low_meters, altitude_high_meters están perdidos. Si eliminamos el NA y vemos la
# correlación entre ellos y los puntos del total de tazas de café es decente, entonces podemos
# imputarlos de otra manera no es necesario.

library(DataExplorer)

coffee_gap=coffee %>%filter(!is.na(altitude_mean_meters),!is.na(Quakers)) # dataframe que contiene solo las filas del dataframe original coffee donde 
                                                                          # tanto la columna altitude_mean_meters como la columna Quakers tienen valores válidos, es decir, no son valores faltantes (NA).

coffee_gap %>%select(Total.Cup.Points,altitude_mean_meters,Quakers) %>%plot_correlation(ggtheme = theme_light(),title = "correlation between Total.Cup.Points vs altitude_mean_meters")



# Como la correlación es muy débil, podemos eliminar las características que contienen valor
# de NA.

coffee_new=coffee %>%select(-c(altitude_high_meters,altitude_low_meters,altitude_mean_meters,X,Quakers))


#making a task
coffee.task=makeRegrTask(data = coffee_new, target ="Total.Cup.Points")
coffee.task


  
#making a learner
coffee.learner=makeLearner("regr.lm")


#spliting the dataset
ho = makeResampleInstance("Holdout",coffee.task)
coffee.train = subsetTask(coffee.task,ho$train.inds[[1]])
coffee.test = subsetTask(coffee.task,ho$test.inds[[1]])


coffee.train
coffee.test


#this means the data will look like
library(caTools)
sample=sample.split(coffee_new$Total.Cup.Points,SplitRatio = 2/3)
train=subset(coffee_new,sample==T)
test=subset(coffee_new,sample==F)

#automating feature selection
library(FSelectorRcpp)
filtervals=generateFilterValuesData(coffee.train,method = "linear.correlation")
filtervals

plotFilterValues(filtervals)



# Esto se muestra mediante el uso de la correlación lineal, podemos identificar qué
# característica usar para nuestro modelo.

# Hacer un envoltorio de filtro para usarlo en nuestro ajuste del hiperparametro y, a veces, esto
# funcionará como un nuevo aprendiz
filterwrapper=makeFilterWrapper(learner = coffee.learner, fw.method = "linear.correlation")
getParamSet(filterwrapper)


#hypermeter tuning the model
#parameter setting, means the in terms of usefulness the absolute value will be lowest at 2 and highest at 12
ps=makeParamSet(makeIntegerParam("fw.abs",2,20))
#search control
#we will use grid search for the best possible ans
sc=makeTuneControlGrid()
kfold=makeResampleDesc("CV", iters=10)
#tuningparameters
tune=tuneParams(filterwrapper,coffee.train, par.set=ps,control=sc,resampling=kfold,rmse)

