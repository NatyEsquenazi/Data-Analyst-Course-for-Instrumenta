# Clase 4. Procesamiento de lenguaje natural ################################


# Frecuencia de palabras vs Frecuencia inversa de documentos ###################### ----------------

#En la clase anterior vimos una técnica del procesamiento del lenguaje natural llamada frecuencia léxica. Esta
#consiste principalmente en extraer significados del texto a través de la repeteción de una palabra en un conjunto
#de textos que estemos trabajando. Todos los conjuntos de texto que estés destinados a realizar análisis vamos
#a llamarlos "corpus".

#En esta clase vamos a ir paso a paso para realizar dos técnicas de procesamiento de lenguaje natural. La primera
# es la frecuencia de palabras. Lo primero que vamos a hacer es tomar un corpus de texto que nos interese 
#estudiar. 

#Recuerden antes que nada seguir los pasos que les indicamos en la clase 3 sobre la instalación de la librería
#Gutemberg

install.packages("devtools")
library(devtools)
devtools::install_github("ropensci/gutenbergr")
library(gutenbergr)

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

#Una vez que tenemos estos objetos creados podemos explorarlos con las funciones de exploración que vimos en 
#la clase 2. Esto lo hacemos principalmente cuando tenemos objetos que desconocemos en absoluto. Pero también 
#nos sirve explorar aquellos objetos que creemos conocer ya que podemos ver cosas que no habíamos observado 
#antes. 

library(funModeling)

df_status(gwells)
df_status(tolstoi)
df_status(verne)
df_status(austen)

head(gwells)
head(tolstoi)
head(verne)
head(austen)

#Le podemos dar un primer procesamiento a estos textos. Por ejemplo supongamos que para facilitar el trabajo
#me gustaría tener los nombres de los libros que tenemos cargados. Nosotres no tenemos una
#columna que nos indique el autor, cosa que a lo mejor, sospechamos que puede ser muy conveniente a la hora de 
#realizar un análisis. Vamos a agregar todas estas columnas a nuestros df de la siguiente manera:

gwells <- mutate(gwells, author = "H.G. Wells")

#Pero también podríamos generar un marco de datos convinado y ponerlos todos dentro del mismo df.

gwells <- gutenberg_download(c( 35, 36, 5230, 159))

libros <-  bind_rows(mutate(verne, author = "Julio Verne"),
                     mutate(gwells, author = "H.G. Wells"), 
                     mutate(austen, author = "Jane Austen"),
                     mutate(tolstoi, author = "Leo Tolstoi"))

libros

#Ahora vamos a comenzar con el procesamiento. La pregunta que nos guía es ¿De qué tratan estos corpus de texto
#que tenemos en frente? Para poder comenzar con este objetivo vamos a tokenizar nuestros textos. Es decir, vamos
#a elegir las unidades mínimas de significado con las que vamos a trabajar. Estas unidades mínimas pueden ser
#palabras, oraciones, párrafos.

#Para esto vamos a utilizar la función unnest_tokens del paquete tidytext. Por defecto esta función tokeniza por
#palabras. También vamos a limpiar palabras vacías. Las palabras vacías son las que no nos están aportando nada
# al objetivo de responder a la pregunta ¿De qué trata el texto? Noostres aportamos una lista de palabras vacías 
#que pueden descargarla de la clase 3. Pero existen dicciones incorporados en algunos paquetes, solo deben 
#buscar la función si esta lista no les funciona

install.packages("tidytext")
library(tidytext)

#palabras en español
my_stopwords <- read.csv("~/my_stopwords.csv")

#palabras en inglés
data(stop_words)

gwells_token <- gwells %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)

tolstoi_token <- tolstoi %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)

verne_token <- verne %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)

austen_token <- austen %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)


#Una vez que tokenizamos y quitamos palabras vacías podemos utilizar la "Frecuencia de palabras". Esta 
#estrategia consiste en determinar los términos/palabras que más se repiten porque supone que conocer estos 
#términos puede decirnos, aunque sea en parte, de qué tratan nuestros textos. Para esto vamos a aplicarles la
# función count y vamos a aplicar el atributo sort.

gwells_token  %>%  count(word, sort = TRUE)

tolstoi_token  %>%  count(word, sort = TRUE)

verne_token  %>%  count(word, sort = TRUE)

austen_token  %>%  count(word, sort = TRUE)

#Ahora, otra estrategia para responder a la pregunta ¿De qué trata mi texto? es a través de la "Frecuencia 
#inversa de documento"(tf-idf). Esto se utiliza para disminuir el peso de las palabras de uso común y aumentar
#el peso de las que no se usan mucho en una colección de documentos pero no palabras demasiado comunnes. Toma un conjunto de datos de texto 
#ordenado como entrada con una fila por token (término), por documento. Una columna ( word acá) contiene los 
#términos / tokens, una columna contiene los documentos ( gutenberg_id en este caso) y la última columna necesaria 
#contiene los recuentos, cuántas veces cada libro contiene cada término ( en este ejemplo). 
#Vamos a calcular también un total de palabras para cada libro, pero no es necesario 
#para la bind_tf_idf()función; la tabla solo necesita contener todas las palabras en cada documento

gwells_words <- gwells %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  count(gutenberg_id, word, sort = TRUE)

gwells_total_words <- gwells_words %>% 
  group_by(gutenberg_id) %>% 
  summarize(total = sum(n))


gwells_words <- left_join(gwells_words, gwells_total_words)

View(gwells_words)

#Este proceso podemos repetirlo con todos nuestro df o tomar el general y aplicarlo una sola vez y en todo 
#caso después aplicamos un filter por autor o por id


libros_words <- libros %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  count(gutenberg_id, author, word, sort = TRUE)

libros_total_words <- libros_words %>% 
  group_by(gutenberg_id) %>% 
  summarize(total = sum(n))


libros_words <- left_join(libros_words, libros_total_words)

View(libros_words)

#Ahora aplicamos directamente la función bind_tf_idf()

libros_tf_idf <- libros_words %>%
  bind_tf_idf(word, gutenberg_id, n)

libros_tf_idf

#Veamos que idf y, por lo tanto, tf-idf son cero para estas palabras extremadamente comunes. Todas estas son 
#palabras que aparecen en los libros seleccionados, por lo que el término idf (que será el logaritmo natural 
#de 1) es cero. La frecuencia inversa del documento (y por lo tanto tf-idf) es muy baja (cercana a cero) para 
#las palabras que aparecen en muchos de los documentos de una colección; así es como este enfoque disminuye 
#el peso de las palabras comunes. La frecuencia inversa del documento será un número mayor para las palabras 
#que aparecen en menos documentos de la colección.

libros_tf_idf %>%
  select(-total) %>%
  arrange(desc(tf_idf))

#Vamos a ver una visualización de estas palabras de alta tf-idf

library(forcats)

libros_tf_idf %>%
  group_by(gutenberg_id) %>%
  slice_max(tf_idf, n = 15) %>%
  ungroup() %>%
  ggplot(aes(tf_idf, fct_reorder(word, tf_idf), fill = gutenberg_id)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~gutenberg_id, ncol = 2, scales = "free") +
  labs(x = "tf-idf", y = NULL)

#Como vemos esta visualización es un desastre. Son muchos libros que estamos intentando visualizar juntos.
#Lo que vamos a hacer es aplicar un filter para quedarnos con algunos libros (no con todos)


