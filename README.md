<!-- README.md is generated from README.Rmd. Please edit that file -->
R Al Parque
===========

Que es lo que obtienes cuando organizas una agrupación (cluster) de roqueros (rockers)? Un festival!

R Al Parque es una prueba de concepto para coordinar contenedores Docker y hacerlos trabajar en conjunto como un grupo (*EN:cluster*) de trabajadores R bajo coordinación del paquete `snow`. En este momento no le tenemos una aplicación otra que casos ejemplos, y si tienes una aplicación para la aproximación que describimos aquí nos encantaría escucharlo.

Para hacerlo usamos contenedores [Docker](https://docker.com), con imágenes para R como disponibles en [Rocker](https://github.com/rocker-org/rocker) a los cuales incluimos [snow](https://cran.r-project.org/web/packages/snow/index.html).

Referencia
----------

En la carpeta `"manual/referencia` hay un ejemplo de hacer un snow-cluster dentro de una misma maquina. En nuestro caso lo usamos para hacer correr el código en un mismo contenedor, y lo usamos como referencia para comparar el resultado después.

Para correrlo sigue los siguientes pasos (asumimos que tienes [Docker](https://docker.com) instalado y funcionando).

    $ cd manual/referencia
    $ sudo docker build -t referencia .
    $ sudo docker run --name ejemplo -i referencia

Verás en como parte del output, después de ver las funciones que asignamos a cada uno de los tres maquinas asignadas:

    [1] "Listo! Termine el script del Organizador en la implementacion 'referencia'"
    [1] "el resultado es: \n"
             1          2          3          4          5          6          7 
      7.662232  14.892228  28.978089   8.820645  22.477977  49.578876  34.956109 

Estos valores los tenemos que volver a ver cuando logremos crear un conjunto de contenedores separados.

Orquestración manual
====================

El Parque
---------

El primero paso es crear una red para los contenedores que vamos a iniciar. En otras palabras: necesitamos un parque para poner el podio. En Docker lo podemos [hacer así](http://stackoverflow.com/questions/27937185/assign-static-ip-to-docker-container/35359185#35359185)

    $sudo docker network create --subnet=172.18.0.0/16 simonbolivar

Los artistas
------------

Nuestros artistas son los contenedores secundarios. Se construyen como instancias de un mismo Dockerfile y hay que hacerlo antes de arrancar el organizador. Sin artistas no hay nada que se pueda organizar.

### Arranca los artistas

Primero construimos la imagen genérica para los artistas

    $ cd manual/artistas
    $ sudo docker build -t artista .

Y después incluimos tres actos en el festival

    $ sudo docker run -d -P --net simonbolivar --ip 172.18.0.2 --name aterciopelados -it artista
    $ sudo docker run -d -P --net simonbolivar --ip 172.18.0.3 --name fabulosos_cadillacs -it artista
    $ sudo docker run -d -P --net simonbolivar --ip 172.18.0.4 --name mana -it artista

El organizador
--------------

Necesitamos un [Mario Duarte](https://es.wikipedia.org/wiki/Rock_al_Parque) para tomar la iniciativa. En nuestro caso es el contenedor Docker central que corre como el contenedor primario que dirige contenedores secundarios.

### Arranca el organizador

El organizador tiene su Dockerfile propio.

    $ cd manual/organizador
    $ sudo docker build -t organizador .
    $ sudo docker run --net simonbolivar --ip 172.18.0.10 --name duarte -it organizador

Lo arrancamos dentro del parque simonbolivar, porque is no no puede comunicarse con los artistas.

Ahora, el organizador primer se tiene que conectar con todos los artistas para estar seguro de que están, y intercambiar llaves. En el Dockerfile incluimos una clave estándar que es "artista".

Por ejemplo para tocar el camarín de mana y pedirles una clave hay que hacer lo siguiente:

    root@dce8b92d2453:~# ssh-copy-id root@172.18.0.4
    /usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/root/.ssh/id_rsa.pub"
    /usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
    /usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
    root@172.18.0.4's password: 

    Number of key(s) added: 1

    Now try logging into the machine, with:   "ssh 'root@172.18.0.4'"
    and check to make sure that only the key(s) you wanted were added.

Orquestación Automática
=======================

Docker Compose
--------------

TODO: Orquestar los contenedores para que arranquen en conjunto
