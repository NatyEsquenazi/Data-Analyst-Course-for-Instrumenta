
##################### Introduccion a Tidymodels 2 ##################### ----------

library(tidyverse)
install.packages('C50')
library(C50)

## ¿Podemos crear un árbol de decisión que nos permita predecir quienes sobrevivieron y quienes no en base a variables como su edad, género y clase en la que viajaron? 

titanic <- read.csv(file = "https://raw.githubusercontent.com/martintinch0/CienciaDeDatosParaCuriosos/master/data/titanic.csv",
                    stringsAsFactors = FALSE,
                    sep = ';')

## Vemos el dataset

glimpse(titanic)

## Transformaciones a factor

titanic <- titanic %>%
  mutate(survived = factor(survived),
         sex = factor(sex))


## Aplicamos el arbol de decision 

arbol_1 <- C5.0(formula= survived ~.,
                    data = titanic)

plot(arbol_1)


## Donde se encuentra la mayor proporcion de sobrevivientes y no sobrevivientes? 

## RTA: mujeres que pagaron una tarifa mayor a 47.1 USD, mientras que las muertes se ubican en hombres mayores de 9 anios

###################### MATRIZ DE CONFUSION #################### ---------------------

summary(arbol_1)

## Podemos observar un error de 20,4%





















