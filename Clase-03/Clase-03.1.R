
# Cómo bajo datos de Twitter? ################# ---------------------------

#Hoy vamos a aprender cómo bajar datos de Twitter. Vamos a trabajar con el paquete rtweet que tiene varias 
#funciones que nos van a servir

install.packages ( " rtweet " )

library(rtweet)

#Vamos a cargar nuestros tokens que son como las claves o contraseñas que nos permiten acceder a las APIs de
#Twitter. Vamos a crear una serie de objetos que no que hacen es permitirnos acceder

# El nombre que le asignamos a la app en el formulario de autorización
appname <- "xxxxxxxxxxxx"
## consumer key (en el ejemplo no es una clave real, usar la verdadera)
consumer_key <- "kxxxxxxxxxxxxxKKiYq"
## consumer secret (en el ejemplo no es un clave real, usar la verdadera)
consumer_secret <- "6csxxxxxxxxxxxxxxxxxxxxxx8ek"
## consumer key (en el ejemplo no es una clave real, usar la verdadera)
access_token <- "10xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx2P"
## consumer secret (en el ejemplo no es un clave real, usar la verdadera)
access_secret <- "YrXxxxxxxxxxxxxxxxxxxxxxxxxxxxN8RC5v"

#Luego de crear estos objetos, lo que hacemos es aplicar create_token()

twitter_token <- create_token(
  app = appname,
  consumer_key = consumer_key,
  consumer_secret = consumer_secret,
  access_token = access_token, 
  access_secret = access_secret)



# Diferentes formas de obtener datos de Twitter ############### -----------


#Existen para eso varias maneras de bajar diferentes tipos de datos.

##Podemos pedirle a Twitter las tendencias de un lugar determinado

trendsAR <- get_trends("argentina")
trendsCBA <- get_trends(lat = -31.417, lng = -64.183)

View(trendsCBA)

#Actividad : Explorar también otras funciones como get_trends_closest() 

#También podemos bajar tweets con get_timeline() y capturar los 3200 últimos tweets de una cuenta

afernandez_tw <- get_timeline("alferdez", n = 3200)

presidencia_tw <- get_timeline(c("alferdez", "CFKArgentina"), n = 500)

#Otra manera es a través de la presencia de determinada palabra en un tweet, para esto vamos a usarla función 
#search_tweets

gaytw <- search_tweets(q = "gay", n = 50, 
                            geocode = "-31.416668,-64.183334,900km")

#Ahora qué pasa si yo quiero traer tweets de palabras que sé que los usuarios escriben de formas diferentes

varontw <- search_tweets(q =  paste(c("varon", "varón"),collapse = '|'), n = 50, 
                              geocode = "-31.416668,-64.183334,900km")


#Para cantidades mayores a 18000 tweets que necesiten iterar el código podemos usar el argumento 
#retryonratelimit = TRUE


# Cómo guardo mis objetos en un archivo csv ########### -------------------


write_as_csv(nombredelobjeto, "nombredelarchivo.csv")



# Herramientas de Procesamiento de Lenguaje Natural (PLN) ######## --------


# Texto ordenado #################### -------------------------------------


#Probamos generar una cadena de texto

texto <- c("Ya no es mágico el mundo. Te han dejado.",
           "Ya no compartirás la clara luna",
           "ni los lentos jardines. Ya no hay una",
           "luna que no sea espejo del pasado,",
           
           "cristal de soledad, sol de agonías.",
           "Adiós las mutuas manos y las sienes",
           "que acercaba el amor. Hoy sólo tienes",
           "la fiel memoria y los desiertos días.",
           
           "Nadie pierde (repites vanamente)",
           "sino lo que no tiene y no ha tenido",
           "nunca, pero no basta ser valiente",
           
           "para aprender el arte del olvido.",
           "Un símbolo, una rosa, te desgarra",
           "y te puede matar una guitarra.")

texto

#Lo que estamos haciendo acá es crear un vector, pero un vector es un marco de datos desordenado para trabajar
#con texto. Para poder trabajarlo lo colocamos en un marco de datos con la función tibble del paquete homónimo

install.packages("tibble")
library(tibble)

texto_df <- tibble(line = 1:14, text = texto)

texto_df

#Esto va a crear dos columnas y 14 filas. Una vez que tenemos ordenado el vector en un marco de datos, es
#posible trabajar con él. Un importante proceso de todo trabajo con texto es la tokenización. Tokenizar es 
#transformar nuestro texto en unidades mínimas de trabajos llamadas tokens. Los tokens pueden ser una letra,
#una palabra, una oración o un párrafo, y así. El proceso de tokeniación se hace con la función unnest_tokens
#del paquete tidytext

install.packages("tidytext")
library(tidytext)

texto_df %>% unnest_tokens(word, text) %>% 
  anti_join(my_stopwords) %>%
  count(word, sort = TRUE)
#Vamos a tomar algunos libros del Gutemberg Project para realizar algunos análisis. Para poder descargar
#libros de este proyecto tenemos una librería paquete específico. Vamos a probar estas herramientas bajando 
#los libros de la Colección de Documentos Inéditos Relativos al Descubrimiento, Conquista y Organización de 
#las Antiguas Posesiones Españolas de Ultramar

devtools::install_github("ropensci/gutenbergr")
library(gutenbergr)

conquistagr <- gutenberg_download(c(57675))


# Ejercicios ################# -------------------------------------------

#1)¿Qué características tiene el objeto conquistagr? Exploremos. ¿Tiene datos números? ¿Qué tipo de datos tiene?
#Cuántas filas y cuántas columnas? ¿Cuáles son los nombres de las columnas? ¿Cómo puedo abrir el documento?
#2)¿Cuáles son las 20 palabras más frecuentes? investigar top_n() y aplicar



  
















