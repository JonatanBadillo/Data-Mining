# Ejemplo 1

# Existe una estafa común entre los
automovilistas por la cual una persona frena bruscamente en medio del tráfico
pesado con la intención de que le choquen por detrás.
• La persona luego presentará una reclamación de seguro por lesiones personales y
daños a su vehículo, alegando que el otro conductor tuvo la culpa.
• Supón que queremos predecir cuáles de los reclamos de una compañía de
seguros son fraudulentos utilizando un árbol de decisiones.
• Para empezar, necesitamos crear un conjunto de formación de reclamaciones
fraudulentas conocidas.
> train <- data.frame(
  + ClaimID = c(1,2,3),
  + RearEnd = c(TRUE, FALSE, TRUE),
  + Fraud = c(TRUE, FALSE, TRUE)
  + )
> train