# Análisis de Contexto ############## -------------------------------------

#Creamos un objeto con los tweets del archivo mujertweets2.csv

mujertweets <- read.csv("mujertweets.csv")


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


# Análisis comparativo de discurso ########## -----------------------------

#Vamos a realizar un análisis comparativo de dos discursos del ex-presidente macri y el presidente A 
#Fernández en Twitter.

#Cargamos los df con los que vamos a trabajar

fernandez_tweet  <- read_csv("fernandez_tweets.csv")

macri_tweet  <- read_csv("macri_tweets.csv")

#Vamos a unir estos dos df y vamos a graficar la frecuencia con la que estos dos usuarios han tweeteado

tweets <- bind_rows(fernandez_tweet %>% 
                      mutate(person = "Fernández"),
                    macri_tweet %>% 
                      mutate(person = "Macri"))

ggplot(tweets, aes(x = created_at, fill = person)) +
  geom_histogram(position = "identity", bins = 20, show.legend = FALSE) +
  facet_wrap(~person, ncol = 1)

#Tokenizamos y eliminamos las palabras vacías. Existen ciertas convenciones en la forma en que las 
#personas usan el texto en Twitter, por lo que usaremos un tokenizador especializado y trabajaremos un poco 
#más con nuestro texto aquí que, por ejemplo, lo hicimos con el texto narrativo del Proyecto Gutenberg.

#Primero, eliminaremos los tweets de este conjunto de datos que sean retweets para que solo tengamos tweets 
#que escribieron los propios usuarios. A continuación, la mutate()línea limpia algunos caracteres que no queremos 
#como símbolos y cosas así.
#Debido a que hemos mantenido texto como hashtags y nombres de usuario en el conjunto de datos, no podemos 
#usar un simple anti_join()para eliminar palabras vacías. En su lugar, podemos tomar el enfoque que se 
#muestra en la filter()línea que usa str_detect()del paquete stringr.

remove_reg <- "&amp;|&lt;|&gt;"

tweets_td <- tweets %>% 
  filter(!str_detect(text, "^RT")) %>%
  mutate(text = str_remove_all(text, remove_reg)) %>%
  unnest_tokens(word, text, token = "tweets") %>%
  filter(!word %in% my_stopwords$word,
         !word %in% str_remove_all(my_stopwords$word, "'"),
         str_detect(word, "[a-z]"))

#Ahora podemos calcular la frecuencia de las palabras para cada persona. Primero, agrupamos por persona y 
#contamos cuántas veces cada persona usó cada palabra. Luego usamos left_join()para sumar una columna del 
#número total de palabras usadas por cada persona. Finalmente, calculamos una frecuencia para cada persona 
#y palabra.

frequency <- tweets_td %>% 
  group_by(person) %>% 
  count(word, sort = TRUE) %>% 
  left_join(tweets_td %>% 
              group_by(person) %>% 
              summarise(total = n())) %>%
  mutate(freq = n/total)

frequency

#Este es un marco de datos agradable y ordenado, pero en realidad nos gustaría trazar esas frecuencias en los 
#ejes x e y de un gráfico, por lo que necesitaremos usar spread()de tidyr para hacer un marco de datos de 
#forma diferente.

frequency <- frequency %>% 
  select(person, word, freq) %>% 
  spread(person, freq) %>%
  arrange(Macri, Fernández)

frequency

#Graficamos. Usemos geom_jitter()para que no veamos tanto la discreción en el extremo inferior de la 
#frecuencia, y check_overlap = TRUE para que las etiquetas de texto no se impriman una encima de la otra 
#(solo algunas se imprimirán).

ggplot(frequency, aes(Macri, Fernández)) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.25, height = 0.25) +
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
  scale_x_log10(labels = percent_format()) +
  scale_y_log10(labels = percent_format()) +
  geom_abline(color = "red")

#Encontremos qué palabras tienen más o menos probabilidades de provenir de la cuenta de cada persona usando 
#la razón de probabilidades de registro. Primero, limitemos el análisis a los tweets de Macri y Fernandez 
#enviados durante 2020, período en el que tenemos actividad por parte de ambos

tweets_td_2020 <- tweets_td %>%
  filter(created_at >= as.Date("2020-01-01"),
         created_at < as.Date("2021-01-01"))

#Usamos str_detect()para eliminar los nombres de usuario de Twitter de la word columna, porque de lo contrario, 
#los resultados aquí están dominados solo por personas que se repiten en Macri y Fernández. Después de 
#eliminarlos, contamos cuántas veces cada persona usa cada palabra y guardamos solo las palabras usadas más 
#de 10 veces. Después de una spread()operación, podemos calcular la razón de probabilidades logarítmicas 
#para cada palabra

word_ratios <- tweets_td_2020 %>%
  filter(!str_detect(word, "^@")) %>%
  count(word, person) %>%
  group_by(word) %>%
  filter(sum(n) >= 10) %>%
  ungroup() %>%
  spread(person, n, fill = 0) %>%
  mutate_if(is.numeric, list(~(. + 1) / (sum(.) + 1))) %>%
  mutate(logratio = log(Macri / Fernández)) %>%
  arrange(desc(logratio))

#¿Cuáles son algunas palabras que han tenido la misma probabilidad de provenir del relato de Macri y
#Fernandez durante 2020?

word_ratios %>% 
  arrange(abs(logratio))

#¿Qué palabras es más probable que provengan del relato de Macri o del relato de Fernández? Tomemos las 15 
#palabras más distintivas de cada cuenta 

word_ratios %>%
  group_by(logratio < 0) %>%
  top_n(15, abs(logratio)) %>%
  ungroup() %>%
  mutate(word = reorder(word, logratio)) %>%
  ggplot(aes(word, logratio, fill = logratio < 0)) +
  geom_col(show.legend = FALSE) +
  coord_flip() +
  ylab("log odds ratio (Macri/Fernández)") +
  scale_fill_discrete(name = "", labels = c("Macri", "Fernández"))

