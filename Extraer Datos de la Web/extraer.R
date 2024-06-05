# Preparación de datos: Web scraping de tablas htmtl con rvest

# Acceder a diferentes fuentes de datos
# A veces, los datos que necesitas están disponibles en la web. Acceder a ellos facilitará tu vida
# como científico de datos.
# Quiero realizar un análisis de datos exploratorio sobre la temporada 2018/19 de la Premier

# League de Inglaterra.
#   • ¿Hay cambios en el desempeño del equipo durante la línea de tiempo de la
# temporada?
#   • ¿Algunos equipos se agrupan?
#   • ¿Cuál es la primera semana en que podemos predecir las posiciones finales del
# equipo?


#   Necesitamos la tabla de posiciones para cada semana de la temporada e integrarla de manera
# que nos permita trazar los gráficos que queremos. Eliminaremos esas tablas de
# https://www.weltfussball.de/.

# Por ejemplo, la tabla de posiciones para la Semana 1 está en la URL:
# https://www.weltfussball.de/spielplan/eng-premier-league-2018-2019-spieltag/1
# Para las semanas siguientes, solo cambia el número al final, por ejemplo.
# https://www.weltfussball.de/spielplan/eng-premier-league-2018-2019-spieltag/2/ ←
# https://www.weltfussball.de/spielplan/eng-premier-league-2018-2019-spieltag/3/ ←