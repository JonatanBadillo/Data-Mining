# Importacion de librerias necesarias
library(dplyr)
library(rvest)
library(tidyverse)

#url de la pagina
url <- "https://calidaddelaire.puebla.gob.mx/views/reporteICA.php"
pagina <- read_html(url)


table <-pagina %>% html_table()

#table <- pagina %>% html_table('#div_historial_ICA > div > table')
#class(table)

#table <- pagina %>% html_nodes('#div_historial_ICA > div > table') %>% html_table()


# Extraer la tabla
tabla <- html_nodes(pagina, "table") %>%
  html_table(fill = TRUE)

# Mostrar la tabla
print(tabla)


# Leer la tabla dentro del elemento con id div_historial_ICA
tabla <- html_nodes(pagina, xpath = '//*[(@id = "div_historial_ICA")]') %>%
  html_table(fill = TRUE)

# Mostrar la tabla
print(tabla)


# Leer la tabla utilizando el XPath proporcionado
tabla <- html_nodes(pagina, xpath = '//*[(@id = "div_historial_ICA")]//table') %>%
  html_table(fill = TRUE)

# Mostrar la tabla
print(tabla)



