# Clase 6. Procesamiento de lenguaje natural ################################


# N-gramas ###################### ----------------

#Un n-grama es una subsecuencia de n elementos de una secuencia dada. El estudio de los n-gramas es interesante 
#en diversas áreas del conocimiento. Por ejemplo, es usado en el estudio del lenguaje natural, en el estudio de 
#las secuencias de genes y en el estudio de las secuencias de aminoácidos.

library(gutenbergr)
library(tidyverse)
library(dplyr)
library(tidytext)


#palabras en inglés
data(stop_words)

#Si no pudieron instalar los paquetes no se preocupen, nosotres les dejamos el material así pueden descargarlo
#y trabajar desde acá.

gwells <- read.csv("gwells.csv")
tolstoi <- read.csv("tolstoi.csv")
verne <- read.csv("verne.csv")
austen <- read.csv("austen.csv")

#Vamos a tomar algunos libros del Gutemberg Project para realizar algunos análisis. Quiero los libros de 
#g wells y verne, y los de Tolstoi y Austen

gutenberg_authors
gwells <- gutenberg_download(c( 35, 36, 5230, 159))
tolstoi <- gutenberg_download(c(2600, 1399, 986))
verne <- gutenberg_download(c(103, 18857, 83))
austen <- gutenberg_download(c(121, 21839, 42671))

#Ahora vamos a aplicar los mismos procesos que aplicábamos antes con algunas diferencias. En principio, vamos
# a tokenizar por n-gramas, contarlos, y organizarlos de mayor a menor

tolstoi_bigrams <- tolstoi %>%
  unnest_tokens(bigram, text, token = "ngrams", n = 2) %>%
  count(bigram, sort = TRUE)

tolstoi_bigrams

#Qué pasa si quiero aplicarle un antijoin en este paso tal y como hacíamos antes? Probemos

tolstoi_bigrams <- tolstoi %>%
  unnest_tokens(bigram, text, token = "ngrams", n = 2) %>%
  count(bigram, sort = TRUE) %>%
  anti_join(stop_words)

#Las variables que queremos unir, tal y como observamos, no tienen el mismo nombre. Recordemos que para que se
#pueda realizar el antijoin, debe existir una variable con el mismo nombre en los dos marcos de datos. Y en un 
#marco de datos la variable es bogram, mientras que en el otro la variable es word
#Ahora... imaginemos que nosotres cambiaramos el nombre de la variable bigram por la variable word (con un
#mutate, por ejemplo) qué pasaría? Sería una estrategia conveniente? Sí, no, por qué?

#Podemos hacerlo, y seguramente los datos se crucen. pero no se elimine ninguno, por qué?

#Porque los no hay datos iguales en las dos columnas, mientras que en una columna aparece una palabra, en la otra
#apaecen dos. Cuando la función antijoin compare estas dos columnas, no van a existir datos iguales. ¿Qué 
#podemos hacer entonces?

#Como paso intermedio, tenemos que separar las dos columnas utilizando la función de tidyr separate(), 
#que divide una columna en múltiples basándose en un delimitador. Esto nos permite separarlo en dos columnas, 
#“palabra1” y “palabra2”, así podemos eliminar los casos en los que cualquiera de las dos sea una stopword

bigrams_separados <- tolstoi_bigrams %>%
  separate(bigram, c("word1", "word2"), sep = " ")

#Cuando aplicamos esto, nos vamos a encontrar con el mismo inconveniente que nos encontrábamos antes si 
#quisiéramos aplicar un antijoin. Las columnas no tienen el mismo nombre. Es por esto que una alterntiva es 
#aplicar un filter 

filtered_tolstoi <- bigrams_separados %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word)

head(filtered_tolstoi)

#Esta estrategia también funcionaría si la aplicáramos sobre columnas con el mismo nombre. Es un método
#alternativo al antijoin que sirve más específicamente en este caso. Una vez que tenemos los bogramas separados
#vamos a  volver a unir los bigramas, para eso tenemos la función unite

united_tolstoi <- filtered_tolstoi %>%
  unite(bigram, word1, word2, sep = " ")

united_tolstoi %>% top_n(20)

#Tal vez queremos encontrar los trigramas más importantes. Vemos cómo acá implementamos todos los 
#pasos juntos. Separamos en tokens, detemrinamos trigramas,  separamos los trigramas de modo de
#limpiar las palabras vacías y hacemos un conteo

trigram_tolstoi <- tolstoi %>%
  unnest_tokens(trigram, text, token = "ngrams", n = 3) %>%
  separate(trigram, c("word1", "word2", "word3"), sep = " ") %>%
  filter(!word1 %in% stop_words$word,
         !word2 %in% stop_words$word,
         !word3 %in% stop_words$word) %>%
  count(word1, word2, word3, sort = TRUE)

trigram_tolstoi %>% top_n(20)

#Podemos ver que nos pone muchos capitulos, cosa que no nos interesa, los podemos agregar a nuestra lista de 
#palabras vacías. También podemos también sacar la frecuencia inversa de documentos que habíamos sacado antes,
#aquella que analiza el número de cada palabra individual (en este caso cada bigrama), en relación al número 
#total del documento

bigram_tfidf_tolstoi <- united_tolstoi %>%
  count(gutenberg_id, bigram) %>%
  bind_tf_idf(bigram, gutenberg_id, n) %>%
  arrange(desc(tf_idf))

bigram_tfidf_tolstoi %>% top_n(20)

View(bigram_tfidf_tolstoi)

#Visualizamos los bigramas por cada libro. Una manera es l que vimos con anterioridad en la clase pasada

united_tolstoi %>%
  group_by(gutenberg_id) %>%
  top_n(5) %>%
  ungroup() %>%
  ggplot(aes(bigram, n, fill = gutenberg_id)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~gutenberg_id, ncol = 2, scales = "free") +
  labs(x = "tf-idf", y = NULL) +
  coord_flip()

#Una segunda forma de visualizar n-grams es a través de Redes de bigramas

library(igraph)
library(ggraph)
set.seed(2017)

#Esto requiere que tomemos los bigramas separados y que armemos una matriz de relaciones con la función
#graph_from_data_frame. Vamos a tomar solo los primeros 20

tolstoi_bigram_graph <- filtered_tolstoi %>%
  filter(n > 20) %>%
  graph_from_data_frame()

tolstoi_bigram_graph

#Vamos a indicarle los términos que nos interesan para poder graficar: nodos, bordes y texto.

ggraph(tolstoi_bigram_graph, layout = "fr") +
  geom_edge_link() +
  geom_node_point() +
  geom_node_text(aes(label = name), vjust = 1, hjust = 1)

#Ejercicio. Buscar en la función la manera de agregarle colores a los points y los links





