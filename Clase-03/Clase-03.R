
####################### CLASE 03 ################################ ---------------------

############## Introduccion al manejo de Datos ################## --------------

## Todas estas operaciones son un paso inicial para cualquier análisis o visualización: se estima que el 80% del tiempo de análisis de datos se invierte en modificar y limpiar nuestros datos para su uso óptimo (Dasu & Johnson, 2003 en Wickham 2014).

library(tidyverse)
library(readr)
library(funModeling)

df <- read_csv("Clase-02/delitos_2019.csv")
summary(df)
dim(df)

############### OPERACIONES BASICAS ############################## ---------------------

######################## Select ################################## ---------------------

## A veces queremos trabajar sólo con un extracto de las variables de nuestros datos. Para ello, existe la función select(). Podemos seleccionar varias columnas a la vez, separadas por comas. 

df_1 <- df %>% 
  select(tipo_delito, barrio)

df_2 <- df %>% 
  select(franja_horaria:comuna) 

## La funcion everything es util para ubicar a la columna al principio del df

df_3 <- df %>% 
  select(tipo_delito, everything()) 

## Otra función útil para select() es ends_with() y starts_with(), que nos permite seleccionar las columnas según los patrones en sus nombres. Por ejemplo, a continuación se seleccionarán todas las columnas que finalicen con la plabra “delito”

df_4 <- df %>% 
  select(ends_with("delito")) 


######################## Renombrar columnas ################################## ---------------------

## Podemos cambiar los nombres de las columnas de una base con el comando rename(). A la izquierda deberan ubicar el nombre que quieren poenerle a la columna. 

df_5 <- df %>% 
  rename(pib_ppp_c2011 = pib, 
         desempleo_porcentaje = desempleo) 


######################## Filtrar ################################## ---------------------

## A menudo queremos mantener sólo algunas observaciones de nuestra base de datos, filtrando según características específicas. Podemos hacerlo gracias a la función filter() y a los operadores lógicos. Para empezar, mantengamos sólo las observaciones para Puerto Madero:

df_6 <- df %>% 
  filter(barrio == 'Puerto Madero') # Filtro por un barrio

## Operador |

df_7 <- df %>% 
filter(barrio %in% c('Puerto Madero', 'San Telmo'))

df_7 <- df %>% 
  filter(barrio == 'Puerto Madero' | barrio == 'San Telmo')

## Operador &

df_8 <- df %>% 
  filter(barrio == 'Puerto Madero' &
         tipo_delito == 'Hurto (sin violencia)') 

## Operador >, <,  >= , <=

df_7 <- df_7 %>% 
  filter(franja_horaria >= 14 & franja_horaria <= 18)

## Filtrar nulos 

df_7 <- df_7 %>% 
  filter(is.na(franja_horaria))


######################## Cambiar el orden ################################## ---------------------

## Una de las operaciones más comunes con los bases de datos es clasificarlas según una variable de interés. Esto puede darnos pistas claras sobre nuestras observaciones. Podemos hacerlo gracias a la función arrange(). Por ejemplo, clasifiquemos las observaciones desde el delito menos frecuente al mas frecuente: 

df_7 <- df_7 %>% 
  arrange(tipo_delito)

## Para utilizar un orden alfabético inverso (de la Z a la A), tenemos que utilizar la función desc().

df <- df %>%
arrange(desc(tipo_delito))


######################## Transformar Variables ################################## ---------------------









































































