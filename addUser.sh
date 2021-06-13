#!/bin/bash
# $1 : USER
# $2 : PASSWORD
if [ "$(id -u $1)" != "1000" ]
then
    useradd -m -u 1000 $1 && \
    echo "$2\n$2\n" | passwd "$1" && \
    usermod -aG sudo $1
    echo "\nUsuario $1 creado con éxito"
else echo "El usuario $1 ya existe."
fi