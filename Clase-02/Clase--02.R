
####################### CLASE 02 ################################ ---------------------

###################### Cargar datos ############################ ----------------------

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

####################### AYUDA ################################ ---------------------
help(sqrt) 
?sqrt