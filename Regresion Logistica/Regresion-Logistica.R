# Regresión logística
# Nuestra tarea es
# predecir la probabilidad de que una observación pertenezca a una categoría 
# particular de la variable de resultado. 
# En otras palabras, desarrollamos un algoritmo para clasificar las
# observaciones.


# Métodos de clasificación y regresión lineal

# ¿por qué no podemos utilizar el método de regresión de mínimos cuadrados que
#  para obtener un resultado cualitativo? Bueno, resulta que puedes,
# pero bajo tu propio riesgo. Supongamos por un segundo que tienes un resultado que estás
# tratando de predecir y que tienes tres clases diferentes: leve, moderado y severo. Tu y tus
# colegas también suponen que la diferencia entre leve y moderado y moderado y grave es una
# medida equivalente y una relación lineal. Puedes crear una variable ficticia donde 0 es igual
# a leve, 1 es igual a moderado y 2 es igual a grave. Si tienes motivos para creer esto, entonces
# la regresión lineal podría ser una solución aceptable. Sin embargo, etiquetas cualitativas 
# como las anteriores podrían prestarse a un alto nivel de error de medición que puede sesgar
# el OLS.


# En la mayoría de los problemas empresariales, no existe una forma científicamente aceptable
# de convertir una respuesta cualitativa en una cuantitativa. ¿Qué pasa si tienes una respuesta
# con dos resultados, digamos reprobar y aprobar? Nuevamente, utilizando el enfoque de
# variable ficticia, podríamos codificar el resultado fallido como 0 y el resultado aprobado
# como 1. Usando la regresión lineal, podríamos construir un modelo donde el valor predicho
# sea la probabilidad de una observación de aprobado o reprobado. Sin embargo, las
# estimaciones de Y en el modelo probablemente excederán las restricciones de probabilidad
# de [0,1] y, por lo tanto, serán un poco difíciles de interpretar.



# Regresión logística
# Como sabemos de los métodos estudiado previamente, nuestro problema de clasificación se
# modela mejor con las probabilidades ligadas por 0 y 1. Podemos hacer esto para todas
# nuestras observaciones con algunas funciones diferentes, pero aquí nos centraremos en la
# función logística. La función logística utilizada en la regresión logística es la siguiente:

#   Probabilidad de 𝑌 =((𝑒0+𝛽1𝑥) / 1) +𝑒𝛽0+𝛽1𝑥

# Si alguna vez has realizado una apuesta amistosa en carreras de caballos o en la Copa del
# Mundo, es posible que comprendas mejor el concepto de probabilidades.
# La función logística se puede convertir en probabilidades con la formulación de
# Probabilidad(Y)/1 - Probabilidad (Y).
# Por ejemplo, si la probabilidad de que Brasil gane la Copa del Mundo es del 20 por ciento,
# entonces las probabilidades son 0.2/1 - 0,2, lo que equivale a 0.25, lo que se traduce en
# probabilidades de uno entre cuatro.