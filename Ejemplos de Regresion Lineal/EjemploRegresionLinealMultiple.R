# Ejemplo de regresión lineal

# Es hora de ver cómo R maneja la regresión lineal. Para iniciar el análisis de este ejemplo,
# crea un vector para las puntuaciones de aptitud y otro para las puntuaciones de rendimiento:
Aptitude <- c(45, 81, 65, 87, 68, 91, 77, 61, 55, 66, 82, 93, 76, 83, 61, 74)
Performance <- c(56, 74, 56, 81, 75, 84, 68, 52, 57, 82, 73, 90, 67, 79, 70, 66)

# Luego usa los dos vectores para crear un frame de datos
FarMisht.frame <- data.frame(Aptitude,Performance)
FarMisht.frame
