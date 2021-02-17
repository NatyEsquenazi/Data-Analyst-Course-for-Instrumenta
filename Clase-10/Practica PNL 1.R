################# Práctico PLN 1ª Parte #######################################

#Como en todo ejercicio de análisis de texto a través de lenguaje natural, vamos a explorar el df con el 
#objetivo puesto en entender de qué trata este corpus de texto. Por eso, en principio, no damos nunguna pista de 
#qué contenidos tiene este corpus y partimos de la base de que hay que descubrirlo.

#Cargamos el df

#1)Superficialmente, ¿De què trata este corpus? Utilizar funciones exploratorias

#2) ¿En qué otros idiomas fueron escritos estos tweets? Me quedo con aquellos tweets que solo han sido escritos
#en español

#3)¿Cuáles son las 50 palabras más frecuentes para estos tweets?

#4)  Ahora, podemos hacernos una idea de lo que tratan estos tweets, pero podríamos ir un poco más allá con 
# otras herramientas. También podríamos explorar n-grams. Aquí podríamos explorar el número de n-grams que 
#quisiéramos, pero lo recomendable en PLN es explorar hasta 3-grams y no más ya que suele ser infructuoso. 
#Veamos entonces ¿cuáles son los 10 bigramas y los 10 trigramas más comunes? Recordemos que aquí la estrategia
#para limpiar palabras vacías no es anti_join

#5) ¿Qué nodos de significado existen y cuáles son son los núcleos más importantes? Lo graficamos a través de 
#redes de n.gramas. Recordar que para graficar estas redes, los biogrmas tienen que estar separados.