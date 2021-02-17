
## INICIO DE PRACTICA GUIADA ---------------------------------------------------

## En el siguiente script vamos a iniciar un analisis exploratorio y de visualizacion de un dataset que ya conocemos, delitos! La idea es poner a prueba todo lo que vimos en las clases y desafiarnos con preguntas que requieren una busqueda particular. Esta pensado para que exploremos libremente, intenten ser creativos y ambiciosos a la hora del analisis y sumen cualquier conocimiento adicional que puedan compartir con el resto. 

## Introduccion ----------------------------------------------------------------

## 1. Vamos a iniciar creando un proyecto nuevo en una carpeta para alojar todos los documentos de este trabajo. Recuerden poner un nombre acorde y setear el espacio de trabajo. 

## 2. Cargen todas las librerias y datasets a utilizar. Instalen las librerias que no tengan descargadas y luego importenlas en su espacio de trabajo.      

library(skimr)
library(tidyverse)
library(janitor)
library(hrbrthemes)
library(lubridate)
library(summarytools)
library(dplyr)
library(ggsci)
library(ggplot2)

delitos_2019 <- read_csv("http://cdn.buenosaires.gob.ar/datosabiertos/datasets/mapa-del-delito/delitos_2019.csv")

delitos_2018 <- read_csv("http://cdn.buenosaires.gob.ar/datosabiertos/datasets/mapa-del-delito/delitos_2018.csv")

delitos_2017 <- read_csv("http://cdn.buenosaires.gob.ar/datosabiertos/datasets/mapa-del-delito/delitos_2017.csv")

## 3. Como pueden ver importamos las librerias desde una pagina web. Estas paginas suelen ser una gran fuente de datos cuando queremos inciar un analisis. Pueden revisarlo en el siguiente link: https://mapa.seguridadciudad.gob.ar/ 

## Limpieza de los datos -------------------------------------------------------

## 4. Unifica los tres datasets en uno solo de tal modo que quede uno debajo del otro. En el caso de que aparezca un error, que sucede con la variable franja horaria? Transformala y luego uni los datasets.  



## 5.Cuantas filas tiene cada dataset? Y cuantas columnas? 



## 6. Que tipo de datos contiene el dataset? 



## 7. Cuantos valores faltantes se registran en cada variable? 



## 8. Que sucede con la variable cantidad registrada? Explora los valores unicos, cuales son los valores mas frecuentes y saca conclusiones al respecto. Puede que tengas que buscar sobre tablas de frecuencia.  




## 9. Cual es la relacion entre tipo de delito y subtipo de delito? Describir. Puede que tengas que buscar sobre tablas de contingencia




## 10. Hace el grafico pertinente para mostrar los tipos de delitos existentes y sus frecuencias. No olvides incluir titulo, nombres a los ejes y colores.  











## 11. Hace el grafico pertinente para mostrar como se distribuye la variable franja horaria. No olvides incluir titulo, nombres a los ejes y colores.  












## 12. Incorporaremos al grafico anterior una segmentacion por tipo de delito y un filtro para quedarnos con los delitos que hayan ocurrido especialmente en Puerto Madero. 





























