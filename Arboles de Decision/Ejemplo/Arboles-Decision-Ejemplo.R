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


# • El árbol de decisiones identificó correctamente que si una reclamación implicaba
# una colisión por alcance, lo más probable es que la reclamación fuera
# fraudulenta.


# • De forma predeterminada, rpart utiliza gini impureza para seleccionar divisiones
# al realizar la clasificación.
# • En su lugar, puedes utilizar la ganancia de información especificándola en el
# parámetro parms.
mytree <- rpart(
  Fraud ~ RearEnd,
  data = train,
  method = "class",
  parms = list(split = 'information'),
  minsplit = 2,
  minbucket = 1
  )
mytree



# Supongamos ahora que nuestro equipo de entrenamiento tiene este aspecto ...
train <- data.frame(
  ClaimID = c(1,2,3),
  RearEnd = c(TRUE, FALSE, TRUE),
  Fraud = c(TRUE, FALSE, FALSE)
  )
train

# Si tratamos de construir un árbol de decisiones sobre estos datos ...
mytree <- rpart(
  Fraud ~ RearEnd,
  data = train,
  method = "class",
  minsplit = 2,
  minbucket = 1
  )

mytree


# • Una vez más nos quedamos con solo un nodo raíz. Internamente, rpart realiza un
# seguimiento de algo llamado complejidad de un árbol.
# • La medida de complejidad es una combinación del tamaño de un árbol y la
# capacidad del árbol para separar las clases de la variable objetivo.
# • Si la siguiente mejor división en el crecimiento de un árbol no reduce la
# complejidad general del árbol en una cierta cantidad, rpart terminará el proceso
# de crecimiento.
# • Esta cantidad se especifica mediante el parámetro de complejidad, cp, en la
# llamada a rpart().
# • Establecer cp en una cantidad negativa asegura que el árbol crezca
# completamente.

mytree <- rpart(
  Fraud ~ RearEnd,
  data = train,
  method = "class",
  minsplit = 2, 
  minbucket = 1, 
  cp = -1
  )
fancyRpartPlot(mytree, caption=NULL)
                                                                                                                                                        

# Esto no siempre es una buena idea, ya que normalmente producirá árboles sobreajustados, pero los árboles se pueden podar como se explica más adelante en este ejemplo. 
# • También puedes ponderar cada observación para la construcción del árbol especificando 
# el argumento ponderaciones en rpart(). 
mytree <- rpart( 
  Fraud ~ RearEnd, 
  data = train, 
  method = "class", 
  minsplit = 2, 
  minbucket = 1, 
  weights = c(0.4, 0.4, 0.2) 
  ) 
fancyRpartPlot(mytree, caption = NULL)


# Si la compañía de seguros quiere investigar agresivamente las reclamaciones (es decir, investigar muchas
# reclamaciones), puede entrenar su árbol de decisiones de una manera que
# penalice las reclamaciones fraudulentas etiquetadas incorrectamente más de lo
# que penaliza las reclamaciones no fraudulentas etiquetadas incorrectamente.
# • Para alterar el valor predeterminado, la penalización igual de las clases objetivo
# mal etiquetadas establece el componente de pérdida del parámetro parms en una
# matriz donde el elemento (i, j) es la penalización por clasificar erróneamente una
# i como una j. (La matriz de pérdidas debe tener ceros en la diagonal). Por
# ejemplo, considera los siguientes datos de entrenamiento.

train <- data.frame(
  ClaimID = 1:7,
  RearEnd = c(TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE),
  Whiplash = c(TRUE, TRUE, TRUE, TRUE, TRUE, FALSE, FALSE),
  Fraud = c(TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE)
  )
train

# Ahora hagamos crecer nuestro árbol de decisiones, restringiéndolo a una división
# estableciendo el argumento maxdepth en 1.

mytree <- rpart(
  Fraud ~ RearEnd + Whiplash,
  data = train,
  method = "class",
  maxdepth = 1,
  minsplit = 2,
  minbucket = 1
  )
fancyRpartPlot(mytree, caption = NULL)

# Si la compañía de seguros quiere identificar un alto porcentaje de reclamos
# fraudulentos sin preocuparse demasiado por investigar reclamos no fraudulentos,
# puedes establecer la matriz de pérdidas para penalizar los reclamos etiquetados
# incorrectamente como fraudulentos tres veces menos que los reclamos
# etiquetados incorrectamente como no fraudulentos.

lossmatrix <- matrix(c(0,1,3,0), byrow = TRUE, nrow = 2)
lossmatrix

mytree <- rpart(
  Fraud ~ RearEnd + Whiplash,
  data = train,
  method = "class",
  maxdepth = 1,
  minsplit = 2,
  minbucket = 1,
  parms = list(loss = lossmatrix)
  )
fancyRpartPlot(mytree, caption = NULL)

# Ahora nuestro modelo sugiere que Whiplash es la mejor variable para identificar
# reclamaciones fraudulentas.
# • Lo que se acaba de describir se conoce como una métrica de valoración y queda
# a discreción de la compañía de seguros decidir al respecto.

# Supón que la compañía de seguros contrata a un investigador para evaluar el nivel de actividad 
# de los reclamantes. Los niveles de actividad pueden ser muy activos, activos, inactivos o muy inactivos. 
train <- data.frame( 
  ClaimID = c(1,2,3,4,5), 
  Activity = factor( 
    x = c("active", "very active", "very active", "inactive", "very inactive"), 
    levels = c("very inactive", "inactive", "active", "very active") 
    ), 
  Fraud = c(FALSE, TRUE, TRUE, FALSE, TRUE) 
  ) 
train 

mytree<- rpart( 
  Fraud~ Activity, 
  data= train, 
  method="class", 
  minsplit=2, 
  minbucket=1 
  ) 
fancyRpartPlot(mytree, caption= NULL) 

# En el primer conjunto de datos, no especificamos que Activity fuera un factor ordenado, 
# por lo que rpart probó todas las formas posibles de dividir los niveles del vector Activity. 


train <- data.frame( 
  ClaimID = 1:5, 
  Activity = factor( 
    x = c("active", "very active", "very active", "inactive", "very inactive"), 
    levels = c("very inactive", "inactive", "active", "very active"), 
    ordered = TRUE 
    ), 
  Fraud = c(FALSE, TRUE, TRUE, FALSE, TRUE) 
  ) 
train

mytree<- rpart( 
  Fraud~ Activity, 
  data= train, 
  method="class", 
  minsplit=2, 
  minbucket=1 
) 
fancyRpartPlot(mytree, caption= NULL) 


# En el segundo conjunto de datos, la Activity se especificó como un factor ordenado, 
# por lo que rpart solo probó divisiones que separaban el conjunto ordenado de niveles de Actividad. 



# • Por lo general, es una buena idea podar un árbol de decisiones. 
# • Los árboles completamente desarrollados no funcionan bien con los datos que no están en el conjunto de entrenamiento 
# porque tienden a estar sobre ajustados, por lo que la poda se usa para reducir su complejidad manteniendo 
# solo las divisiones más importantes. 

train <- data.frame( 
  ClaimID = 1:10, 
  RearEnd = c(TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, FALSE), 
  Whiplash = c(TRUE, TRUE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, TRUE), 
  Activity = factor( 
    x = c("active", "very active", "very active", "inactive", "very inactive", "inactive", "very inactive", "active", "active", "very active"), 
    levels = c("very inactive", "inactive", "active", "very active"), 
    ordered=TRUE 
    ), 
  Fraud = c(FALSE, TRUE, TRUE, FALSE, FALSE, TRUE, TRUE, FALSE, FALSE, TRUE)
  ) 

train


mytree<- rpart(
  Fraud~ RearEnd + Whiplash +Activity,
  data = train,
  method= "class",
  minsplit=2,
  minbucket=1,
  cp=-1
)
fancyRpartPlot(mytree,caption=NULL)




# Puedes ver la importancia de cada variable en el modelo haciendo referencia al atributo variable.importance del objeto rpart resultante. 
# De la documentación de rpart, “Una medida general de importancia variable es la suma de la bondad de las medidas divididas para cada división para la que fue la variable principal ...” 
mytree$variable.importance 


# Entonces, queremos el árbol más pequeño con xerror menor que 0.65298. 
# Este es el árbol con cp = 0.2, por lo que querremos podar nuestro árbol con un cp ligeramente mayor que 0.2. 
mytree <- prune(mytree, cp = 0.21) 
fancyRpartPlot(mytree) 

# Por lo tanto, podemos usar nuestro árbol de decisiones para predecir reclamos 
# fraudulentos en un conjunto de datos invisible usando la función predict(). 
test <- data.frame( 
  ClaimID = 1:10, 
  RearEnd = c(FALSE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, FALSE), Whiplash = c(FALSE, TRUE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, TRUE), Activity = factor( 
    x = c("inactive", "very active", "very active", "inactive", "very inactive", "inactive", "very inactive", "active", "active", "very active"), 
    levels = c("very inactive", "inactive", "active", "very active"), 
    ordered = TRUE 
    ) 
  ) 
test 


test$FraudClass <- predict(mytree, newdata = test, type = "class") 
test$FraudProb <- predict(mytree, newdata = test, type = "prob") 
test 







