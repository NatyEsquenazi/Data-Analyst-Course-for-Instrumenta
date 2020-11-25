
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


####################### MAS OPCIONES PARA SEGUIR EXPLORANDO ############### -------------------

## ¿cómo podemos manejar una base de datos muy grande? Una primera alternativa es evaluar la necesidad de utilizar toda la base de datos para el análisis, o, si se puede acortar antes de utilizarla. Para iniciar un análisis exploratorio que pueda aclarar este punto, recomendamos usar el argumento n_max= en read_csv() y sus funciones hermanas (por ejemplo, read_tsv()). De esta manera podemos examinar las primeras cien observaciones de la base de datos, haciendo que el proceso de cálculo sea menos exigente:


df_desiguales_large_100 <- read_csv("data/desiguales.csv", n_max = 100)




















