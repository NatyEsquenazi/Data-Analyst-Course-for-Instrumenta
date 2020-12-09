
####################### CLASE 04 ################################ ---------------------

############## Introduccion al manejo de Datos: Parte 2 ################## --------------

library(tidyverse)
library(dplyr)
library(readr)
library(funModeling)

df <- read_csv("Clase-02/delitos_2019.csv")
comunas <- read_csv("Clase-04/comunas.csv")


######################## Transformar Variables ################################## ---------------------

## La mayoría de las veces queremos crear nuevas variables a partir de las que ya tenemos. Case_when junto con Mutate permiten definir una variable, la cual toma un valor particular para cada condición establecida. En caso de no cumplir ninguna de las condiciones establecidas la variable tomara valor NA La sintaxis de la función es case_when( condicion lógica1 ~ valor asignado1).

df_1 <- df %>% 
  mutate(Horarios = case_when(franja_horaria >= 0 & franja_horaria <= 5 ~ 'Madrugada', 
                              franja_horaria >= 19 & franja_horaria <= 23 ~ 'Tarde noche',
                              franja_horaria >= 6 & franja_horaria <= 11 ~ 'Mañana',
                              franja_horaria >= 12 & franja_horaria <= 14 ~ 'Mediodia',
                              franja_horaria >= 15 & franja_horaria <= 18 ~ 'Tarde'))


## ¿Qué pasa si la variable que queremos crear puede asumir más de dos valores? 

df_1 <- df_1 %>% 
  mutate(grupo_de_comunas = case_when(comuna %in% c(8, 9, 7, 4) ~ "Sur",
                                      comuna %in% c(3,5,6,7,15) ~ "Centro",
                                      comuna %in% c(12,13,14) ~ "Norte",
                                      comuna %in% c(11,10) ~ "Oeste",
                                      comuna %in% c(1,2) ~ "Este")) %>%  
  # reduciremos la base de datos para ver mejor los resultados:
  #filter(barrio == 'Puerto Madero' & Horarios == 'Madrugada') %>%
  select(-c(subtipo_delito, cantidad_registrada)) 

## Separar la fecha 

df_1 <- df_1 %>% 
  mutate(anio = substr(fecha, 7, 8),
         mes = substr(fecha, 4, 5),
         dia = substr(fecha, 1, 2))

###################### Resumenes agrupados ####################################### -------------------

## Summarise: Crea una nueva tabla que resuma la información original. Para ello, Definimos las variables de resumen y las formas de agregación.Tiene sentido utilizarla en conjunto con group_by

summarise(comunas, 
          poblacion_promedio = mean(Total))


###################### Dplyr Joins ####################################### -------------------

## left_join: nos devuelve todos los registros de una tabla (x) y los coincidentes con la segunda tabla (y). 

## right_join: nos devuelve todos los registros de una tabla (y) y los coincidentes con la segunda tabla (x).

## inner_join: nos devuelve la interseccion entre dos tablas. Es decir todos los registors coincidentes entre dos df. 

## anti_join: identificamos registros que no coinciden entre las dos tablas 

## full_join: nos devuelve la union entre dos tablas. 

## Probamos el left_join que es el mas utilizado 

comunas <- comunas %>% 
  rename(comuna = Comuna)

nuevo_df <- left_join(df_1, comunas, by='comuna')

###################### Resumenes por grupo ####################################### -------------------

## Esta función permite realizar operaciones de forma agrupada. Lo que hace la función es “separar” a la tabla según los valores de la variable indicada y realizar las operaciones que se especificaba continuación, de manera independiente para cada una de las “subtablas”. En nuestro ejemplo, sería útil para calcular el promedio de los indices por comuna y mes 

grupos_poblac <- nuevo_df %>%
  group_by(grupo_de_comunas) %>%
  summarise(pob_promedio = mean(Total)) %>%
  ungroup()

sexo_comuna <- nuevo_df %>%
  group_by(grupo_de_comunas) %>%
  summarise(muje_promedio = mean(Mujer)) %>%
  ungroup()

delito_horario <- nuevo_df %>%
  group_by(Horarios) %>%
  summarise(tipo_delito = freq(tipo_delito)) %>%
  ungroup()

###################### Gather y Spread ####################################### -------------------

## Gather es una función que nos permite pasar los datos de forma horizontal a una forma vertical.

## spread es una función que nos permite pasar los datos de forma vertical a una forma horizontal.


asjxbal
































