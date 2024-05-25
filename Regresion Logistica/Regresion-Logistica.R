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