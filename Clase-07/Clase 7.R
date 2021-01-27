#             CLASE 7                                                #########################################


# Procesamiento de lenguaje natural - Práctica y Redes semánticas --------------------

#1) Crear un obketo con el archivo mujertweets cargado en el Github.

#2) ¿De dónde provienen los tweets? Graficar la distribución de los usuarios según la ubicación dejando de
#lado los que no fueron geolocalizados

#3) Visualizar también la cantidad de tweets sin dejar de lados los que no fueron geolocalizados

#4) Crear un objeto con aquellos tweets que si o sí sean de Córdoba

#5)Teniendo en cuento que el df contiene tweets con la palabra Mujer ¿Cuáles son los 5 usuarios que más 
#tweetearon la palabra mujer?

#6) ¿Cuáles son las 20 palabras más frecuentes para los tweets asociados a mujer que hemos recolectado?
#Exploramos la tokenización "tweets"


# Análisis de Contexto ############## -------------------------------------


#Voy a tomar las cinco principales palabras y voy a analizar su contexto. El contexto de las palabras lo vamos
#a definir a través de la tokenización por oración o por párrafo. En este caso, en el que no hay párrafos para
#analizar, lo más conveniente es hacerlo por tweet o por oración

mujertweets_oracion <- mujertweets %>% 
  unnest_tokens(oracion, text, token = "sentences")

#Luego vamos a seleccionar aquellas oraciones que contengan las palabras sobre las que me interesa observar el
#contexto

mujertweets_hombre <- mujertweets_oracion %>%
  filter(str_detect(oracion, paste(c("hombre", "hombres"),collapse = '|')))

mujertweets_violencia <- mujertweets_oracion %>%
  filter(str_detect(oracion, paste(c("violencia"),collapse = '|')))

mujertweets_loca <- mujertweets_oracion %>%
  filter(str_detect(oracion, paste(c("loca", "loca"),collapse = '|')))


#Ahora sí, observamos el contexto de estas oraciones. Primero, tokenizamos por palabra. Después, hacemos un
#count de cada una de las palabras para saber la cantidad de veces que se repiten, luego de eso, limpiamos
#palabras vacías con un antijoin y por último le aplicamos la función cast_dfm del paquete quanteda. Este
#transforma nuestro marco de datos en una matriz

mujertweets_dfm <- mujertweets_hombre %>%
  unnest_tokens(word, oracion, drop = FALSE) %>%
  filter(!str_detect(word, paste(c("^http", "t.co"),collapse = '|'))) %>%
  count(`oracion`, word) %>%
  anti_join(my_stopwords) %>%
  cast_dfm(`oracion`, word, n)

View(words_timelines_fcm)

# Nos quedamos con un número finito de palabras sobre las que realizar las relacioness
top_words_timelines <- names(topfeatures(mujertweets_dfm, 10)) 

#Hacemos una matriz de palabras (palabras que aparecen juntas en el mismo texto/oracion): 
#fcm hace una matriz de correlacion de palabras
words_timelines_fcm <- fcm(mujertweets_dfm)

#Visualizamos las relaciones
words_fcm <- fcm_select(words_timelines_fcm, pattern = top_words_timelines) #Me quedo con las palabras 
#que estan en el top 10
textplot_network(words_fcm, min_freq = 0.1, edge_color = "#008037", edge_alpha = 0.5, edge_size = 0.8)