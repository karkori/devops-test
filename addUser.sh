#!/bin/bash
# $1 : USER
# $2 : PASSWORD
if [ "$(id -u $1)" != "1002" ]
then
    sudo su && \
    (echo "\n--> Crear nuevo usuario: $1" && \
    useradd $1 && \
    echo "\n--> Crear UID para usuario: $1" && \
    usermod -u 1002 $1 && \
    echo "\n--> Crear password para usuario: $1" && \
    (echo -e "$2\n$2" | passwd "$1") && \
    usermod -aG sudo $1 && \
    echo "\n--> Usuario $1 creado con éxito" ) || \
    echo "\n--> Existe algun error !!"
else echo "El usuario $1 ya existe."
fi