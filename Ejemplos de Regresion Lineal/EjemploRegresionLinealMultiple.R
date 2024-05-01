# Ejemplo de regresión lineal

# Es hora de ver cómo R maneja la regresión lineal. Para iniciar el análisis de este ejemplo,
# crea un vector para las puntuaciones de aptitud y otro para las puntuaciones de rendimiento:
Aptitude <- c(45, 81, 65, 87, 68, 91, 77, 61, 55, 66, 82, 93, 76, 83, 61, 74)
Performance <- c(56, 74, 56, 81, 75, 84, 68, 52, 57, 82, 73, 90, 67, 79, 70, 66)

# Luego usa los dos vectores para crear un frame de datos
FarMisht.frame <- data.frame(Aptitude,Performance)
FarMisht.frame

# La función lm() (modelo lineal, se utiliza para ajustar modelos de regresión lineal en R.) realiza el análisis:
FM.reg <-lm(Performance ~ Aptitude, data=FarMisht.frame) # estamos tratando de predecir el rendimiento en función de la aptitud.
# siempre, el operador de tilde (~) significa “depende de,” por lo que este es un ejemplo
# perfecto de una variable dependiente y una variable independiente.

summary(FM.reg)

# Las primeras dos líneas proporcionan información resumida sobre los residuos. La tabla de
# coeficientes muestra la intersección y la pendiente de la línea de regresión. Si divides cada
# número en la columna Estimate por el número contiguo en la columna Std.Error, obtienes el
# número en la columna de valor t. Estos valores t, por supuesto, son las pruebas de
# significancia que se estudian en los cursos de estadística para la intersección y la pendiente.
# Los valores p extremadamente bajos indican el rechazo de la hipótesis nula (que un
#                                                                             coeficiente = 0) para cada coeficiente.
# La parte inferior de la salida muestra la información sobre qué tan bien se ajusta la línea al
# 
# diagrama de dispersión. Presenta el error estándar del residual, seguido de Multiple R-
#   squared y Adjusted R-squared. Estos dos últimos van de 0 a 1.00 (cuanto mayor sea el valor,
#                                                                    
#                                                                    mejor será el ajuste).
# Su alto valor y bajo valor p asociado indican que la línea se ajusta perfectamente al diagrama
# de dispersión.
# Nos referimos al resultado del análisis de regresión lineal como “el modelo lineal”.





# Características del modelo lineal

# El modelo lineal producido por lm() es un objeto que proporciona información, si la solicitas
# de la manera correcta. Como ya se conoce, utilizando summary() nos brinda toda la
# información que necesitas sobre el análisis.

# También puedes concentrarte en los coeficientes:
coefficients(FM.reg)

# y en sus intervalos de confianza:
confint(FM.reg)

# Utilizando fitted(FM.reg) produce los valores ajustados y residuals(FM.reg) dan los
# residuales.




# Haciendo predicciones

# El valor de la regresión lineal es que brinda la capacidad de predecir, y R proporciona una
# función que hace precisamente eso: predict() aplica un conjunto de valores x al modelo lineal
# y devuelve los valores predichos. Imagina dos solicitantes con puntajes de aptitud de 85 y
# 62:

# El primer argumento es el modelo lineal, y el segundo hace un marco de datos a partir del
# vector de valores de la variable independiente.
predict(FM.reg,data.frame(Aptitude=c(85,62)))

