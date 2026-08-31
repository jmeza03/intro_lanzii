#!/bin/bash

archivo=~/$CREACION/salida/$FILENAME.txt

if [ -f "$archivo" ]; then
    echo "Mostrando alumnos ordenados por número de padrón:"
    sort -n "$archivo"
else
    echo "No se encontró el archivo."
fi
