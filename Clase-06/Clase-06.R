
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
  labs(title = "Correlación entre tiempo y expectativa de vida",
       subtitle = "Argentina",
       y = "expectativa de vida")

corr_selected <- cor(data_arg$anio, data_arg$expVida)

## Cual es el efecto que el paso de los anios tiene sobre la expectativa de vida? 













