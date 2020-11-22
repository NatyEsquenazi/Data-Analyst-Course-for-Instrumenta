
####################### CLASE 02 ################################ ---------------------

## Introducción a R. ¿Qué son los entornos y los lenguajes de programación?
## RStudio está dividido en cuatro paneles (consola, guión, objetos y miscelánea), que abordaremos a continuación. La idea de esta sección es familiarizar al lector principiante con la base de R. Además, le recomendamos que edite algunas configuraciones de RSutdio antes de comenzar, lo que en nuestra experiencia mejorará su experiencia de aprendizaje:
## 1. General > Desmarcar “Restaurar .RData en el espacio de trabajo al inicio”
## 2. General > Guardar el espacio de trabajo en .RData al cerrar > Nunca

####################### CONSOLA ################################ ---------------------

## El panel inferior izquierdo de RSutdio es nuestro espacio de comunicación directa con el ordenador, donde le exigimos que realice tareas específicas, utilizando el “lenguaje R”. Llamaremos a estas demandas comandos. Intentemos usar o “ejecutar” un comando que realice una operación aritmética básica:

2+2

10/2

####################### SCRIPT ################################ ---------------------

## El panel superior izquierdo de RStudio puede describirse como un “registro de comandos”. Para escribir un nuevo script es tan fácil como presionar Ctrl + Shift + N o ir a Archivo > Nuevo archivo > R Script. La pantalla blanca de un nuevo script es similar a un bloc de notas en blanco, con la característica de que cada línea debe ser pensada como un comando. Note que escribir un comando en el script y presionar “Enter” no hace nada más que un salto de párrafo. Para ejecutar el comando en una línea, tienes que presionar Ctrl + Enter (si tienes Mac, Cmd + Enter). Es posible seleccionar varias líneas/comandos a la vez y ejecutarlos todos con Ctrl + Enter.

## Escribir sólo código en nuestros scripts no es suficiente, ya que normalmente también queremos escribir comentarios explicativos. Esto no sólo es relevante para el trabajo en grupo (el código extranjero puede ser ininteligible sin una guía clara), sino que también denota atención para tu futuro “tú”. En varias ocasiones, tenemos que comprobar el código que escribimos hace un par de meses, sin entender nada, y pensar cosas desagradables sobre nosotros mismos. Al escribir los comandos, R reconoce que todo lo que sigue a un signo numérico (#) es un comentario. Por lo tanto, hay dos maneras de escribir comentarios, como “comandos estériles” o como un apéndice de comandos funcionales:
  
# Este es un comando estéril. ¡R sabe que es sólo un comentario!

2 + 2 # Este es un apéndice-comando, no modifica el código

####################### OBJETOS ################################ ---------------------

## Este es el panel superior derecho de RStudio. Aunque tiene tres pestañas (“Ambiente”, “Historia” y “Conexiones”), la gran estrella es “Ambiente”, que funciona como un registro de los objetos que creamos mientras trabajamos. Una de las principales características de R es que permite almacenar objetos y luego ejecutar comandos con ellos. La forma de crear un objeto es usando una flecha <-, para que el nombre_del_objeto <- contenido. Llamaremos a esto una asignación. Por ejemplo:
  
objeto_1 <- 2 + 2

## Después de ejecutar esto, un nuevo objeto aparecerá en el panel de “Ambiente”, objeto_1. Este contiene el resultado de 2+2. Es posible preguntarle a R cuál es el contenido de un objeto con sólo ejecutar su nombre como si fuera un comando:
  
objeto_1

## Crucialmente, los objetos pueden ser insertados en otros comandos refiriéndose a su contenido. Por ejemplo:
  
objeto_1 + 10

## También es posible reasignar los objetos: si nos aburrimos de objeto_1 como un 4, podemos asignarle el valor que queramos. Los valores de texto (caracteres) también son válidos, tienen que ser escritos entre comillas:
  
objeto_1 <- "democracia"

objeto_1

## Borrar un objeto también es una tarea sencilla. Aunque puede sonar como si perdiéramos nuestro trabajo duro, tener una ficha de “Ambiente” limpia y fácil de leer a menudo vale la pena. Para ello, tenemos que usar la función 

rm(nombre_del_objeto)

####################### VECTORES ################################ ---------------------

## Crear un vector es simple, sólo tenemos que insertar sus componentes entre una c(), separados por comas:

vector_1 <- c(15, 10, 20)
vector_1

## Una necesidad básica al crear vectores es la inserción de secuencias de números. Una forma sencilla de hacerlo es con colones (:). Por ejemplo, examinemos el siguiente vector:
  
vector_2 <- c(9, 7:10, 2, 14)
vector_2

## Podemos seleccionar elementos específicos de un vector utilizando sus posiciones:
  
vector_2[2] # nos da el segundo elemento

vector_2[4:6] # nos da el cuarto, quinto y sexto elemento.


####################### FUNCIONES ################################ ---------------------

2 + sqrt(25) - log(1) # equivalente a 2 + 5 + 0

## R interpreta que sqrt(25) es la raíz cuadrada de 25, mientras que log(1) es el logaritmo natural de 1. Tanto sqrt() como log() son funciones de R. En términos sencillos, una función es un procedimiento que puede ser delineado como sigue:

## sqrt() asume un valor numérico como entrada y entrega su raíz cuadrada como salida. log() asume esa misma entrada, pero entrega su logaritmo natural. c() una función que usamos previamente, asume diferentes valores únicos como entradas y entrega un vector que los contiene.

## Es debido a los vectores que las funciones en R comienzan a brillar y se alejan de las cualidades básicas de una calculadora (eso, a grandes rasgos, es lo que hemos visto hasta ahora en R, nada impresionante). Examinemos otras funciones que extraen información útil de un vector. ¿Qué hace cada una de ellas?

mean(vector_1) # media

median(vector_1) # median

sd(vector_1) # desviación estándar

sum(vector_1) # sum

min(vector_1) # valor mínimo

max(vector_1) # valor máximo

log(vector_1) # logaritmo natural

exp(vector_1) # exponencial

length(vector_1) # longitud (cantidad de valores)

sort(vector_1) # ordena de mayor a menor 





























  
  
  
  
  
  
  