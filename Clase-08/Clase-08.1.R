
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

####################### REGLAS ############################# -----------------------

arbol_1 <- C5.0(formula= survived ~.,
                    data = titanic,
                    rules=TRUE)

plot(arbol_1)

summary(primerArbol)


######################## OPCION CON LIBRERIAS DE R ##########################3 ---------------

install.packages('rpart')
install.packages('rattle')
install.packages('rpart.plot')
install.packages('titanic')

library(rpart)
library(rattle)
library(rpart.plot)
library(titanic)

## Descargamos los datos 
data("titanic_train")

## Modelado con arboles de decision
arbol2 <- rpart(formula=Survived ~ Sex + Age, 
                data=titanic_train,
                method='class')

## Graficamos el arbol

fancyRpartPlot(arbol2)

## Interpreramos el arbol: 

## Un arbol de decision se lee de arriba a abajo, el primer bloque indica el 100% de los datos y el 0 indica que hay mas datos con valor 0 (no sobrevivio) que 1 (sobrevivio). Esto se indica en los porcentajes .62 y .38

## La primera separacion que hace es acerca del genero, destaca el genero masculino. Si la ramificacion es no es masculino el nodo indica que de todos los datos el 35% es femenino y predice que sobrevivieron en un .74 y un .26 no sobrevivio.  Si la ramificacion es si es masculino, la prediccion es de 0 y que del total de los datos representan el 65% de los cuales .81 no sobrevive y .19 si sobrevive. 

## Si la edad es mayor o igual a 6.5. Si la respuesta es si la prediccion es no sobrevivio y si la respuesta es no son menores a 6.5 la prediccion es que si sobrevivieron.

## Si nos fijamos en los porcentajes de abajo, 62+3=65 y 65+35=100

## Prediccion del arbol: 

pred_arbol <- predict(arbol2, type='class')

## Unificamos el dataframe para observar la columna 
titanic_pred <- cbind(titanic_train, pred_arbol)

## Un pasajero masculino de 4 años de edad sobrevivira? 




