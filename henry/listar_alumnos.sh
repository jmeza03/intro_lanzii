#!/bin/bash

archivo=~/$CREACION/salida/$FILENAME.txt

if [ -f "$archivo" ]; then
    echo "mostrando alumnos ordenados por padrón"
    sort -n "$archivo"
else
    echo "no se encontró el archivo"
fi
