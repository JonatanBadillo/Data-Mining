# Ejemplo 1

# Existe una estafa común entre los
# automovilistas por la cual una persona frena bruscamente en medio del tráfico
# pesado con la intención de que le choquen por detrás.
# • La persona luego presentará una reclamación de seguro por lesiones personales y
# daños a su vehículo, alegando que el otro conductor tuvo la culpa.
# • Supón que queremos predecir cuáles de los reclamos de una compañía de
# seguros son fraudulentos utilizando un árbol de decisiones.
# • Para empezar, necesitamos crear un conjunto de formación de reclamaciones
# fraudulentas conocidas.
train <- data.frame(
  ClaimID = c(1,2,3),
  RearEnd = c(TRUE, FALSE, TRUE),
  Fraud = c(TRUE, FALSE, TRUE)
  )
train

# Primeros pasos con rpart
# • Para hacer crecer nuestro árbol de decisiones, primero tenemos que cargar el
# paquete rpart.
# • Luego, podemos usar la función rpart(), especificando la fórmula del modelo, los
# datos y los parámetros del método.
# • En este caso, queremos clasificar la función Fraud usando el predictor RearEnd,
# por lo que nuestra llamada a rpart() debería verse así
library(rpart)
mytree <- rpart(
  Fraud ~ RearEnd,
  data = train,
  method = "class"
  )
mytree

# Observa que la salida muestra solo un nodo raíz. Esto se debe a que rpart tiene
# algunos parámetros predeterminados que impidieron que nuestro árbol creciera.


# • Es decir, minsplit y minbucket. minsplit es “el número mínimo de observaciones que
# deben existir en un nodo para que se intente una división” y minbucket es “el número
# mínimo de observaciones en cualquier nodo terminal”.
# • Ve lo que sucede cuando anulamos estos parámetros.
mytree <- rpart(
  Fraud ~ RearEnd,
  data = train,
  method = "class",
  minsplit = 2,
  minbucket = 1
  )
plot(mytree)

# • Ahora nuestro árbol tiene un nodo raíz, una división y dos hojas 


# • Observa que rpart codificó nuestra variable booleana como un número entero
# (false = 0, true = 1).
# • Podemos trazar mytree cargando el paquete rattle (y algunos paquetes de ayuda)
# y usando la función fancyRpartPlot().

library(rattle)
library(rpart.color)
library(RColorBrewer)
fancyRpartPlot(mytree, caption = NULL)






