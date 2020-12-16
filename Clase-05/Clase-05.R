
######################## Introducción a visualizaciónes en R ###################### --------------

library(tidyverse)
library(dplyr)
library(funModeling)
library(tidyr)
library(ggplot2)
library(readr)
library(janitor)

df <- read_csv("nuevo_df.csv", locale = locale(encoding = "Latin1")) # cambiamos la codificacion a latina
comunas <- read_csv("~/Clases/Curso-Data-Analyst/Clase-04/comunas.csv")






######################## EXPLORACION ###################### --------------

df_status(comunas)

df <- df %>% 
  mutate(tipo_delito = as.factor(tipo_delito), # Convertimos a factor
         comuna = as.factor(comuna),
         barrio = as.factor(barrio),
         Horarios = as.factor(Horarios),
         grupo_de_comunas = as.factor(grupo_de_comunas),
         anio= as.factor(anio),
         mes= as.factor(mes),
         dia = as.factor(dia)) %>% 
  clean_names()           # Quitamos las tildes, guiones, puntos, convertimos en minuscula los nombres de las columnas                    

## Fuente: https://elradar.github.io/2019/10/19/un-cran-a-la-vez-janitor/





## Vamos a utilizar la libreria ggplot2 que cuenta con una serie de gramaticas para distintos tipos de graficos, basados en capas. Las 3 capas basicas en ggplot2 son las siguientes: 

##     1. Dataset: LLamar al dataset que vamos a utilizar 

##     2. Estetica: Definir los aesthetics o estetica del grafico (tema, tamaño, titulo, fuente). Para esto se utiliza           mapping=aes()

##     3. Objeto geometrico: tipo de gráfico que queremos hacer, ya sea un gráfico lineal, un gráfico de barras, un             histograma, un gráfico de densidad, o un gráfico de puntos, o si queremos hacer un gráfico de cajas.   







######################## GRAFICO DE BARRAS ###################### --------------

## Los graficos de barras suelen utilizarse para visualizar variables categoricas en valores absolutos o porcentajes. 

## 1. Realizaremos uno con UNA variable categorica: tipo de delito 

## 1.1 Creamos una tabla para ver la cantidad de observaciones por tipo de delito y las proporciones correspondientes.

tab1 <- df %>% 
  group_by(tipo_delito) %>% 
  count() %>% 
  ungroup() %>% 
  mutate(perc = round(n/sum(n) *100, 2))

## 1.2 Creamos las barras

plot1 <- ggplot(data = tab1, aes(x = tipo_delito, y = perc))+
  geom_bar(stat = "identity", fill = "maroon", width = 0.7)   ## stat = transformacion estasitica

## 1.3 Agregamos texto a cada barra 

plot1 <- ggplot(data = tab1, aes(x = tipo_delito, y = perc))+
  geom_bar(stat = "identity", fill = "maroon", width = 0.7)+
  geom_text(aes(label = perc), size = 5, hjust = 0.5, vjust = -0.25)

## 1.4 Incorporamos un tema 

plot1 <- ggplot(data = tab1, aes(x = tipo_delito, y = perc))+
  geom_bar(stat = "identity", fill = "maroon", width = 0.7)+
  geom_text(aes(label = perc), size = 5, hjust = 0.5, vjust = -0.25)+
  theme_minimal()

## 1.5 Finalmente, añadimos un titulo, fuente y nombramos los ejes. Tambien establecemos las dimensiones del eje vertical

plot1 <- ggplot(data = tab1, aes(x = tipo_delito, y = perc))+
  geom_bar(stat = "identity", fill = "maroon", width = 0.7)+
  geom_text(aes(label = perc), size = 5, hjust = 0.5, vjust = -0.25)+
  theme_minimal()+
  labs(title = "Distribucion de tipos de violencia",
       x = "",y = "Porcentaje",
       caption = "Instrumenta Data Analysis")+
  ylim(c(0,55))






######################## GRAFICO DE LINEAS ###################### --------------
############### ¿Cuál fue la evolución de los delitos en puerto madero? ################ --------------

## 1. Los graficos de lineas suelen ser utiles para representar periodos de tiempo. Comenzamos filtrando nuestro dataset por los delitos sucedidos en Puerto Madero y lo agrupamos por mes. De este modo, estamos viendo la cantidad de delitos mensuales en Puerto Madero. 

tab2 <- df %>% 
  filter(barrio == 'Puerto Madero') %>% 
  group_by(mes, barrio) %>% 
  count() %>% 
  ungroup() %>% 
  mutate(perc = round(n/sum(n)*100, 2))

## 1.2 Creamos las lineas

plot2 <- ggplot(data = tab2, aes(x = mes, y = perc, group = 1))+
  geom_point()+
  geom_line(stat = "identity", size = 1, color = "maroon", linetype = "solid")

## 1.3 Incorporamos el texto de cada linea 

plot2 <- ggplot(data = tab2, aes(x = mes, y = perc, group = 1))+
  geom_point()+
  geom_line(stat = "identity", size = 1, color = "maroon", linetype = "solid")+
  geom_text(aes(label = perc), vjust = 0, hjust = 1)

## 1.4 Tema 

plot2 <- ggplot(data = tab2, aes(x = mes, y = perc, group = 1))+
  geom_point()+
  geom_line(stat = "identity", size = 1, color = "maroon", linetype = "solid")+
  geom_text(aes(label = perc), vjust = 0, hjust = 1)+
  theme_light() 

## 1.5 Finalmente, añadimos un titulo, fuente y nombramos los ejes. Tambien establecemos las dimensiones del eje vertical

plot2 <- ggplot(data = tab2, aes(x = mes, y = perc, group = 1))+
  geom_point()+
  geom_line(stat = "identity", size = 1, color = "maroon", linetype = "solid")+
  geom_text(aes(label = perc), vjust = 0, hjust = 1)+
  theme_light() +
  labs(title = "Porcentaje de delitos en Puerto Madero por mes",
       x = "", y = "Porcentaje",
       caption = "Instrumenta Data Analysis")+
  ylim(c(0,15))





######################## HISTOGRAMA ###################### --------------

## Un histograma es una representacion grafica de la distribucion de variables numericas. Solo admite variables numericas. La variable va a ser cortada en bins y el alto de cada barra representa el numero de observaciones por corte. 

## 1. Probamos realizar un histograma para la variable total de poblacion 

plot3 <- df %>% 
  ggplot(mapping = aes(x = total, fill = comuna)) + # Fill para introducir una nueva variable en el histograma
  geom_histogram(bins = 20, alpha = 15)+           # Alpha para el color del interior de la barra
  labs(title = "Poblacion total por comuna",
       x = "Poblacion", y = "Comunas", 
       caption = " Fuente: Portal de Datos Abiertos Gobierno de Buenos Aires")





######################## SCATTER PLOT ###################### --------------
##### ¿Cuál es la relación entre el ingreso de un país y la expectativa de vida al nacer? ###### ---------

## Un scatter plot representa la relacion entre dos variables numericas. Para cada punto, existe una lectura del eje Y y X. 

## 1. Probamos con nuestros datos: Cual es la relacion entre la poblacion y la franja horaria de los delitos?

ggplot(data = df,
       mapping = aes(x=total, y = franja_horaria), group = 1) +
  geom_point()

## 2. Utilizaremos otro set de datos: ¿Cuál es la relación entre el ingreso de un país y la expectativa de vida al nacer?

gapminder_df <- read.table(file = "https://raw.githubusercontent.com/martintinch0/CienciaDeDatosParaCuriosos/master/data/gapminder.csv",
                           sep=';',
                           header = TRUE,
                           stringsAsFactors = FALSE)

gapminderLastCut <- gapminder_df %>% 
  filter(year==2007)

## Scatter plot clasico: 

ggplot(data = gapminderLastCut,
       mapping = aes(x=gdpPercap, y = lifeExp)) +
  geom_point() +
  labs(x = "PIB per cápita",
       y = "Expectativa de vida al nacer (en años)",
       title="A más ingresos mayor tiempo de vida?",
       subtitle="Expectativa de vida al nacer según nivel de ingreso",
       caption="Fuente: Gapminder")

## Scatter plot customizado: 
## Agregaremos argumentos dentro de geom_point(): size(), color(), shape()

ggplot(data = gapminderLastCut,
       mapping = aes(x=gdpPercap, y = lifeExp)) +
  geom_point(size = 1, color = "maroon", shape = 3) +
  theme_grey()+
  labs(x = "PIB per cápita",
       y = "Expectativa de vida al nacer (en años)",
       title="A más ingresos mayor tiempo de vida?",
       subtitle="Expectativa de vida al nacer según nivel de ingreso",
       caption="Fuente: Gapminder")

## Agregamos una tercera variable de tipo categorica!!! Dentro de la función aes(), además de determinar cuáles son los valores del eje vertical (y) y del eje horizontal (x), podemos indicar mediante el argumento color() la incorporacion de una tercera variable. 

ggplot(data = gapminderLastCut,
       mapping = aes(x=gdpPercap, y = lifeExp,color=continent)) +
  geom_point(size=1) +
  labs(x = "PIB per cápita",
       y = "Expectativa de vida al nacer (en años)",
       title="A más ingresos mayor tiempo de vida?",
       subtitle="Expectativa de vida al nacer según nivel de ingreso",
       caption="Fuente: Gapminder")













