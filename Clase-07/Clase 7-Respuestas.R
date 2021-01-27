#             CLASE 7                                                #########################################


# Procesamiento de lenguaje natural - Redes semánticas --------------------

#Vamos a tomar algunos libros del Gutemberg Project para realizar algunos análisis. Quiero los libros de 
#g wells y verne, y los de Tolstoi y Austen

#cordoba

mujertweets <- read.csv("mujertweets.csv")

View(mujertweets)

#Supongamos que yo quiero saber, en efecto, de dónde vienen estos tweets ya que por el perímetro, puede ser que
#me esté trayendo tweets de otras partes que no sean solo de Córdoba. Entonces voy a graficar la distribución 
#de los usuarios según la ubicación

mujertweets %>%
  filter(location != "", !is.na(location)) %>% 
  count(location) %>% 
  top_n(20, n) %>% 
  ggplot() +
  geom_col(aes(x = reorder(location, n), y = n)) + 
  coord_flip() +
  labs(title = "Procedencia de los usuarios",
       x = "ubicación",
       y = "cantidad")

# Podríamos visualizar también la cantidad de tweets sin dejar de lados los que no fueron geolocalizados

mujertweets %>%
  count(location) %>% 
  top_n(10, n) %>% 
  ggplot() +
  geom_col(aes(x = reorder(location, n), y = n)) + 
  coord_flip() +
  labs(title = "Procedencia de los usuarios",
       x = "ubicación",
       y = "cantidad")

#Ahora vamos a filtrar para quedarnos con aquellos tweets que si o sí sean de Córdoba y vamos a guardarlos en 
#un nuevo objeto

mujertweets <- mujertweets  %>%
  filter(str_detect(`location`, c("Córdoba, Argentina","Córdoba", "Cordoba")))

#Podemos ver qué usuarios son los que más hablan acerca de la mujer

mujertweets_usuarios <- mujertweets %>%
  count(screen_name, sort = TRUE) 

head(mujertweets_usuarios$screen_name)

#Podemos tokenizar para conocer la frecuencia de palabras para los tweets asociados a mujer que hemos 
#recolectado. Podríamos optar por eliminar retweets por considerar que son palabras que se repiten y no revelan 
#la diversidad de los temas que se están hablando en redes. Por ejemplo...

mujertweets_filter <- mujertweets %>% 
  unnest_tokens(word, text, token = "tweets", to_lower = TRUE) %>%
  filter(!word %in% my_stopwords$word ,
         str_detect(word, "[a-z]")) %>%
  count(word, sort = TRUE)

mujertweets_filter  %>% top_n(20)

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

# Nos quedamos con un número finito de palabrs sobre las que realizar las relacioness
top_words_timelines <- names(topfeatures(mujertweets_dfm, 10))


#Hacemos una matriz de palabras (palabras que aparecen juntas en el mismo texto/oracion): 
#fcm hace una matriz de correlacion de palabras
words_timelines_fcm <- fcm(mujertweets_dfm)

#Visualizamos las relaciones
words_fcm <- fcm_select(words_timelines_fcm, pattern = top_words_timelines) #Me quedo con las palabras 
#que estan en el top 50
textplot_network(words_fcm, min_freq = 0.1, edge_color = "#008037", edge_alpha = 0.5, edge_size = 0.8)







