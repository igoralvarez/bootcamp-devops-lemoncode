cd contenedores-ii

# 1. Ver todas las imagenes en local hasta ahora
docker images

# 2. Pulling o descargar una imagen
# 2.1 pull desde Docker Hub (Registro configurado por defecto)
docker pull mysql

#Escoger una versión/tag específica
docker pull redis:6.0.5

# 2.2 pull desde un registro diferente a Docker Hub
# Google
docker run --rm gcr.io/google-containers/busybox echo "hello world"
# Azure
docker pull mcr.microsoft.com/mcr/hello-world

#descargar todas las versiones/tags de una imagen
docker pull -a nginx

#Digest
docker images --digests

#Descargar una imagen por su digest en lugar de por el tag
docker pull redis@sha256:800f2587bf3376cb01e6307afe599ddce9439deafbd4fb8562829da96085c9c5

# 3. Buscar imágenes en Docker Hub
docker search microsoft

# El CLI no te devuelve los tags, pero puedes hacerlo así
curl -s -S 'https://registry.hub.docker.com/v2/repositories/library/nginx/tags/' | jq '."results"[]["name"]' |sort

docker search google
docker search aws

# Al menos 100 estrellas
docker search --filter=stars=100 --no-trunc nginx

#Devuelve solo la oficial
docker search --filter is-official=true nginx

#Formateo de la salida usando Go
docker search --format "{{.Name}}: {{.StarCount}}" nginx
docker search --format "table {{.Name}}\t{{.Description}}\t{{.IsAutomated}}\t{{.IsOfficial}}" nginx


#Crear un contenedor a partir de una imagen de docker
docker run --rm -p 9090:80 nginx

#Crear múltiples contenedores de una imagen
docker run -d --rm -p 7070:80 nginx
docker run -d --rm -p 6060:80 nginx

#### Crear tu propia imagen ####

# Dockerfile en contenedores-ii/Dockerfile

#Construccion de la imagen utilizando el Dockerfile
# docker build . -t webapp:v1
docker build . -t simple-nginx
docker images
#Ahora verás que tienes la imagen alpine descargada, al utilizarla como base, y una nueva llamada nginx que tiene el tag v1

#Se ven todos los cambios que se han hecho para construir en esta imagen, tanto los que vienen 
#de la base como los hechos en el propio Docker file
docker history simple-nginx

#Inspeccionando la imagen puedes saber cuántas capas tiene la misma
docker inspect simple-nginx

#Cada instrucción en el Dockerfile genera una capa

#Manifiesto de una imagen (hay que habilitar el modo experimental)
docker manifest inspect nginx
docker manifest inspect nginx | grep 'architecture\|os'

#The NGINX image exposes ports 80 and 443 in the container and the -P option tells Docker to map 
#those ports to ports on the Docker host that are randomly selected from the range between 49153 and 65535. 
docker run -p 8080:80 simple-nginx 

#En este caso, con --rm cuando se para el contenedor se elimina automáticamente
docker run --rm --name hello-nginx -p 8080:80 simple-nginx 

#Si intentamos eliminar una imagen y hay algún contenedor que la está utilizando no será posible, dará error, incluso si este ya terminó de ejecutarse.
docker rmi simple-nginx

#Filtrar por nombre del repositorio
docker images nginx

#Filtrar por nombre del repositorio y tag
docker images simple-nginx:latest

#Usando --filter
#SHOW UNTAGGED IMAGES (DANGLING)
docker images --filter="dangling=true"

#Listar los ids de las imágenes en local
docker images -q

#Eliminar una imagen
docker image rm 039a2a6425c5
docker image rm 48fdbab01aa6 a24bb4013296

#Eliminar todas las imágenes
docker rmi $(docker images -q) -f