
####################### CLASE 02 ################################ ---------------------

####################### ETAPAS DE UN PROYECTO ################## ---------------------

## 1. Explorar
## 2. Entrenar
## 3. Comunicar

###################### CARGAR DATOS ############################ ----------------------

## ¿Cómo podemos cargar la base de datos en el formato .csv? Como puedes sospechar, empezaremos con la base de datos más simple de cargar. Gracias a la función read_csv() en readr, sólo tendremos que escribir la ruta del archivo dentro de nuestro proyecto:

install.packages("readr")
library(readr)
df <- read_csv("delitos_2019.csv")
df <- read_csv("data/desiguales.csv",
               col_types = cols_only_chr(c("age", # Columnas que queremos seleccionar 
                                           "p2")))
## Excel 

install.packages("readxl")
library(readxl)
df <- read_excel("Clase-02/delitos_2019.xls", sheet = 2)

## SPSS y STATA

install.packages("haven")
library(haven)
df <- read_spss("Clase-02/delitos_2019.sav")
df <- read_stata("Clase-02/delitos_2019.dta")

####################### FUNCIONES EXPLORATORIAS ############### -------------------

install.packages("tidyverse")
library(tidyverse)

install.packages("funmodeling")
library(funmodeling)

glimpse(df)
str(df)
head(df) # Primeros 5 registros
tail(df) # Ultimos 5 registros 
names(df) # Nombre columnas 
View(df)
df_status(df)


####################### AYUDA ################################ ---------------------

## R Studio 

help(sqrt) 
?sqrt

## R pubs 

## Stack Overflow 

####################### TWITTER DEVELOPER ############### -------------------

####################### MAS OPCIONES PARA SEGUIR EXPLORANDO ############### -------------------

## ¿cómo podemos manejar una base de datos muy grande? Para acortarla desde un inicio se puede utilizar el argumento n_max= en read_csv() y sus funciones hermanas (por ejemplo, read_tsv()). De esta manera podemos examinar las primeras cien observaciones de la base de datos, haciendo que el proceso de cálculo sea menos exigente:

df <- read_csv("delitos_2019.csv", n_max = 100)


## Ahora, ¿qué pasa si, después de comprobar los datos, descubres que sólo necesitas un par de variables para el análisis?

df <- read_csv("delitos_2019.csv",
               col_types = cols_only_chr(c("tipo_delito","barrio")))

## Otras dos alternativas de optimizacion

library(data.table)
df <- fread("delitos_2019.csv")

library(ff)
df <- read.csv.ffdf(file = "delitos_2019.csv")












