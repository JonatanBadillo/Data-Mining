# Ejemplo de regresión lineal múltiple
# 
# Hacer malabares con muchas relaciones a la vez: regresión múltiple

# La regresión lineal es una gran herramienta para hacer predicciones. Cuando conoces la
# pendiente y la intersección de la línea que relaciona dos variables, puedes tomar un nuevo
# valor de x y predecir un nuevo valor de y. En el ejemplo en el que has estado trabajando en
# estos ejemplos, toma una puntuación de aptitud y predice una puntuación de desempeño para
# un solicitante de FarMisht.

# ¿Qué pasaría si supieras más que solo el puntaje de aptitud de cada solicitante? Por ejemplo,
# imagina que el equipo directivo de FarMisht decide que un tipo de personalidad en particular
# es ideal para sus consultores. Por eso desarrollan el Inventario de Personalidad de FarMisht,
# una escala de 20 puntos en la que una puntuación más alta indica una mayor compatibilidad
# con la cultura corporativa de FarMisht y, presumiblemente, predice un mejor desempeño.
# La idea es utilizar esos datos junto con las puntuaciones de aptitud para predecir el
# rendimiento.

# La tabla 1 muestra las puntuaciones de aptitud, desempeño y personalidad de los 16
# consultores actuales. Por supuesto, en una corporación de la vida real, es posible que tengas
# muchos más empleados en la muestra.

Aptitude <- c(45, 81, 65, 87, 68, 91, 77, 61, 55, 66, 82, 93, 76, 83, 61, 74)
Performance <- c(56, 74, 56, 81, 75, 84, 68, 52, 57, 82, 73, 90, 67, 79, 70, 66)
Personality <- c(9, 15, 11, 15, 14, 19, 12, 10, 9, 14, 15, 14, 16, 18, 15, 12)
FarMisht.frame <- data.frame(Aptitude,Performance,Personality)



# Cuando trabajas con más de una variable independiente, te encuentras en el ámbito de la
# regresión múltiple. Como en la regresión lineal, encuentras coeficientes de regresión. En el
# caso de dos variables independientes, estás buscando el plano que mejor se ajuste a través de
# un diagrama de dispersión tridimensional.

# Una vez más, “mejor ajuste” significa que la suma de las distancias al cuadrado desde los
# puntos de datos al plano es mínima.
# Aquí está la ecuación del plano de regresión:
#   
#   residual estandar =  residual − residual promedio / syx
# 
# Para este ejemplo, eso se traduce en
# y′ = a + b1x1 + b2x2

# Puedes probar hipótesis sobre el ajuste general y sobre los tres coeficientes de regresión.
#  Iremos directamente al análisis R.
# Aquí hay algunas cosas a tener en cuenta antes de continuar:
#   • Puedes tener cualquier número de variables x. (usamos dos en este ejemplo).
#   • Esperamos que el coeficiente de aptitud cambie de regresión lineal a regresión
#   múltiple. Esperamos que la intercepción también cambie.
#   • Esperamos que el error estándar de estimación disminuya de la regresión lineal a la
#   regresión múltiple. Dado que la regresión múltiple usa más información que la
#   regresión lineal, reduce el error.



# Regresión múltiple en R
# En el código anterior agregamos un vector para las puntuaciones de personalidad:
#   La aplicación de lm() produce el análisis:
FM.multreg <- lm(Performance ~ Aptitude + Personality,data = FarMisht.frame)
summary(FM.multreg)

# Entonces, la ecuación genérica para el plano de regresión es

# Predicted GPA = a + b1 (SAT) + b2 (High School Average)
# 
# O, en términos de este ejemplo
# 
# y’ = a + 0.0025x1 + 0.043x2
# 
# Nuevamente, el valor F alto (F-value) y el valor p bajo (p-value) indican que el plano de
# regresión es un ajuste excelente para el gráfico de dispersión.


