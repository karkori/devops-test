#!/bin/bash
# $1 : USER
# $2 : PASSWORD
if [ "$(id -u $1)" != "1000" ]
then
    (useradd -m -u 1000 $1 && (echo "$1:$2" | chpasswd) && adduser $1 sudo)
    echo "Usuario $1 creado con éxito"
else echo "El usuario $1 ya existe."
fi