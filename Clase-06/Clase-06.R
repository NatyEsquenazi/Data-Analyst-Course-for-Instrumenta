
#################### INTRODUCCION A MODELOS EN R ################### -----------------

library(tidyverse)
library(readr)
library(tidyr)
library(hrbrthemes)
library(MASS)
library(ggplot2)
library(funModeling)
library(tidymodels)
install.packages('ggcorrplot')
library(ggcorrplot)

data_mundial <- read.csv("https://bitsandbricks.github.io/data/gapminder.csv")

summary(data_mundial)

#################### REGRESION LINEAL ################### -----------------

## Como ha se relaciona el paso del tiempo (variable explicativa) con la expectativa de vida en la Argentina?

data_arg <- data_mundial %>% 
  filter(pais == "Argentina")

ggplot(data = data_arg) + 
  geom_point(aes(x = anio, y = expVida)) +
  theme_ipsum()+
  labs(title = "Correlación entre tiempo y expectativa de vida",
       subtitle = "Argentina",
       y = "expectativa de vida")

corr_selected <- cor(data_arg$anio, data_arg$expVida)




## Cual es el efecto que el paso de los anios tiene sobre la expectativa de vida? 

modelo_exp <- lm(expVida ~ anio, data = data_arg)
modelo_exp

## El coeficiente de la variable año es 0.2317. Interpretacion:incrementando la variable año en una unidad, la expectativa de vida se incrementa en 0.2317. Dicho de otra manera, por cada año que pasa la expectativa de vida en la Argentina aumenta casi 3 meses.




## Para que sirve el Intercpeto? 

## Hace referencia a la intersección. Sirve para trazar la línea que permite “predecir” valores para años en los que no tenemos observaciones. La regresión lineal permite crear una línea que permite saber cuanto valdría la variable dependiente ante un valor determinado de la variable predictora.

ggplot(data = data_arg) + 
  geom_point(aes(x = anio, y = expVida)) +
  theme_ipsum()+
  labs(title = "Correlación entre tiempo y expectativa de vida",
       subtitle = "Argentina",
       y = "expectativa de vida",
       caption = "con línea de regresión") +
  geom_abline(aes(intercept = -389.6063, slope = 0.2317), color = "blue")

ggplot(data = data_arg) + 
  geom_point(aes(x = anio, y = expVida)) +
  theme_ipsum()+
  labs(title = "Correlación entre tiempo y expectativa de vida",
       subtitle = "Argentina",
       y = "expectativa de vida",
       caption = "con línea de regresión") +
  geom_abline(aes(intercept = -389.6063, slope = 0.2317), color = "blue") +
  xlim(c(1950, 2030)) + ## Proyectamos la linea hacia el futuro
  ylim(c(60, 85))



## Para que sirven los residuos? 

## Los residuos, en la jerga estadística, no son otra cosa que las diferencias encontradas entre el valor que predice un modelo para una variable y el valor observado en la práctica. Los residuos representan el desvío de cada observación respecto al valor “esperado” por el modelo.

## Cuando los desvíos son pequeños (residuos son pequeños) decimos que nuestro modelo se ajusta bien a los datos observados. Cuando los residuos son grandes ocurre lo contrario, y quizás deberíamos buscar otra forma de describir, de modelar, la relación entre las variables.

## Exploramos la relacion entre PBI y Expectativa de vida

modelo_PBI <- lm(PBI_PC ~ anio, data = data_arg)

modelo_PBI

## Obtuvimos un coeficiente positivo. Según el modelo, cada año que pasa resulta en un incremento de 86 dólares en el PBI per cápita del país. 

residuos <- residuals(modelo_PBI)
residuos

data_arg <- data_arg %>% mutate(residuo_ml = residuos) #Los agregamos al df

ggplot(data_arg) +                                     # Los visualizamos    
  geom_point(aes(x = anio, y = residuo_ml)) +
  geom_hline(yintercept = 0, col = "blue") +
  labs(x = "año", y = "residuo del modelo lineal")


## Entre todos los puntos, los mayores transgresores son los últimos y corresponden a los años 2002 y 2007. El valor del PBI per cápita observado en 2002 año resultó ser más de 2000 dólares menor al esperado por el modelo, todo un derrumbe. ¿A qué se debe tanta discrepancia?

ggplot(data_arg) + 
  geom_line(aes(x = anio, y = PBI_PC)) +
  geom_vline(aes(xintercept = 2001), color = "red") +
  labs(title = "Evolución del PBI en la Argentina",
       y = "PBI per cápita",
       caption = "La línea roja indica la ocurrencia de la crisis del 2001")
































