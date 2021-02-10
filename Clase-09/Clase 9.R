##################### Análisis comparativo de discurso ########## -----------------------------

# Librerias:

library(tibble)
library(tidyverse)
library(dplyr)
library(tidytext)
library(janeaustenr)
library(dplyr)
library(stringr)
library(ggplot2)
library(gutenbergr)
library(tidytext)
library(scales)
library(igraph)
library(ggraph)
library(topicmodels)
library(tm)
library(rtweet)
library(lubridate)
library(cronR)
library(devtools)
library(quanteda)
library(splus2R)
library(stringi)

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
  filter(!word %in% my_stopwords$word)

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
  ylab("Probabilidades (Macri/Fernández)") +
  scale_fill_discrete(name = "", labels = c("Macri", "Fernández"))



################## Modelado de temas ##########################

#En la minería de texto, a menudo tenemos colecciones de documentos, como publicaciones de blogs
#o artículos de noticias, que nos gustaría dividir en grupos naturales para poder entenderlos 
#por separado. El modelado de temas es un método para la clasificación no supervisada de dichos 
#documentos, similar al agrupamiento de datos numéricos, que encuentra grupos naturales de 
#elementos incluso cuando no estamos seguros de lo que estamos buscando.

#La asignación de Dirichlet latente (LDA) es un método particularmente popular para ajustar un 
#modelo de tema. Trata cada documento como una mezcla de temas y cada tema como una mezcla de 
#palabras. Esto permite que los documentos se "superpongan" entre sí en términos de contenido, 
#en lugar de estar separados en grupos discretos, de una manera que refleja el uso típico del 
#lenguaje natural.


#cargo el marco de datos

general <- read_csv("noticias.csv")

general <- general  %>%
  unnest_tokens(word, `Cuerpo de Noticia`, drop = FALSE) %>%
  filter(!str_detect(word, "^[0-9]*$")) %>%
  anti_join(my_stopwords) %>%
  count(`Noticia (link)`, word, sort = TRUE)
  
head(general)

#Ahora estamos casi en condiciones de pasarle a la función LDA nuestro marco de datos. El único inconveniente
#acá es que así como algunos paquetes de minería de texto existentes proporcionan matrices de términos 
#de documento como datos de muestra o salida, algunos algoritmos esperan tales matrices como 
#entrada. Por lo tanto, tidytext proporciona las funciones cast_ para convertir de una forma ordenada a 
#estas matrices. podríamos tomar el conjunto de datos de noticias ordenado y  convertirlo en una
#matriz de documentos y términos usando la cast_dtm()función. Esto es porque los marcos de datos de texto 
#ordenados son de una fila por token, pero para los algoritmos de aprendizaje estadístico necesitamos nuestros
#datos en un formato de una fila por documento. Es decir, una matriz de documentos y términos.

general_dtm <- general %>%
  cast_dtm(`Noticia (link)`, word, n)


# La asignación de Dirichlet latente es un algortimo que nos ayuda a encontrar temas que conforman
#un documento y palabras que conforman cada tema. 

ap_lda <- LDA(general_dtm, k = 2, control = list(seed = 1234))
ap_lda

#Con esto ajustamos nuestros datos a un modelo de dos temas (k =2) y plantamos una semilla de 1234
#pero no podemos sacar ninguna conclusión con este ajuste solo, necesitamos trabajar los datos
#y esto lo hacemos con las herramientas tradicionales que ya aprendimos

#El tidy() método para ordena los objetos del modelo. El paquete tidytext proporciona este método 
#para extraer las probabilidades por tema por palabra, a través de la función llamad β ("Beta")
#del modelo.

ap_topics <- tidy(ap_lda, matrix = "beta")
ap_topics

#Esto convierte el modelo en un formato de un tema por término por fila. Para cada combinación, 
#el modelo calcula la probabilidad de que ese término se genere a partir de ese tema. Por ejemplo,
#el término "aaron" tiene un 1,686917 × 10-12 probabilidad de ser generado a partir del tema 1, 
#pero una 3.8959408 × 10-5 probabilidad de ser generado a partir del tema 2.
#Podríamos usar dplyr top_n()para encontrar los 10 términos que son más comunes dentro de cada 
#tema. Como marco de datos ordenado, esto se presta bien a una visualización ggplot2.

ap_top_terms <- ap_topics %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

ap_top_terms %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(term, beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip() +
  scale_x_reordered()

#Esta visualización nos permite comprender los dos temas que se extrajeron de las noticias. Las 
#palabras más comunes en el tema 1 incluyen "robo", "policía", "delincuentes" y "mujer", 
#lo que sugiere que puede representar noticias sobre seguridad. Los más comunes en el 
#tema 2 incluyen "borberos", "fuego" y "incendios", lo que sugiere que este tema representa 
#noticias incendios. Una observación importante acerca de las palabras en cada tema es que 
#algunas palabras, como “Córdoba” es comun en ambos temas. Ésta es una ventaja del 
#modelado de temas en comparación con los métodos de "agrupamiento duro": los temas utilizados 
#en lenguaje natural pueden tener cierta superposición en términos de palabras.

#Como alternativa, podríamos considerar los términos que tuvieran la mayor diferencia en β entre 
#el tema 1 y el tema 2. Esto se puede estimar en función de la relación logarítmica de los dos: 
#Iniciar sesión 2 (β2β1) (una relación logarítmica es útil porque hace que la diferencia sea 
#simétrica: β2 ser el doble de grande conduce a una relación logarítmica de 1, mientras que β1
#ser el doble de grande da como resultado -1). Para restringirlo a un conjunto de palabras 
#especialmente relevantes, podemos filtrar por palabras relativamente comunes, como aquellas 
#que tienen un β mayor que 1/1000 en al menos un tema.

beta_spread <- ap_topics %>%
  mutate(topic = paste0("topic", topic)) %>%
  spread(topic, beta) %>%
  filter(topic1 > .001 | topic2 > .001) %>%
  mutate(log_ratio = log2(topic2 / topic1))

beta_spread

#Podemos visualizar

beta_spread %>%
  arrange(desc(abs(log_ratio))) %>%
  head(20) %>%
  mutate(term = reorder(term, log_ratio)) %>%
  ggplot(aes(term, log_ratio, fill = log_ratio > 0)) +
  geom_col(show.legend = FALSE) +
  xlab("Term") +
  ylab("Log") +
  coord_flip()

