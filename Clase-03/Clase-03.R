
####################### CLASE 03 ################################ ---------------------

############## Introduccion al manejo de Datos ################## --------------

## Todas estas operaciones son un paso inicial para cualquier análisis o visualización: se estima que el 80% del tiempo de análisis de datos se invierte en modificar y limpiar nuestros datos para su uso óptimo (Dasu & Johnson, 2003 en Wickham 2014).

library(tidyverse)
library(readr)
library(funModeling)

df <- read_csv("Clase-02/delitos_2019.csv")

## Resumen 
summary(df)

## Dimensiones
dim(df)

############### Niveles de Medicion ############################## ---------------------

## Una variable es una característica de las unidades de análisis que puede asumir diferentes valores en cada una de ellas.

## 1. Nominal: Una variable está medida a nivel nominal si los números que representan cada categoría son asignados de manera arbitraria y solo cumplen con la función de designar y distinguir categorías diferentes. Ej: Sexo

## 2. Ordinal: Una variable está medida a nivel ordinal si los números que representan cada categoría son asignados de manera que respeten el orden según aumenta o disminuye la característica que la variable mide.Ej: Nivel educativo

## 3. Intervalar: Una variable está medida a nivel intervalar cuando las distancias entre las categorías son proporcionales. Ej: depresion minima puntaje 0-13

## 4. Proporcional: Una variable está medida a nivel proporcional cuando sus valores respetan relaciones de proporcionalidad y, en consecuencia, el cero tiene un valor absoluto.

##                - Discreta: los valores solo puedan ser números enteros. Ej: cantidad de materias aprobadas
##                - Continua: admite números decimales. Ej: Estatura


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

## La mayoría de las veces queremos crear nuevas variables a partir de las que ya tenemos. Supongamos que quisiéramos separar la columna fecha en diferentes partes  
  
df_7 %>%
  separate(fecha, into = c("dia", "mes", "anio"), sep = "-")







































































