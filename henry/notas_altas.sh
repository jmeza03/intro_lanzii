#!/bin/bash

archivo=~/$CREACION/salida/$FILENAME.txt

if [ -f "$archivo" ]; then
    echo "Mostrando las 10 notas más altas:"
    sort -k 5 -nr "$archivo" | head -n 10
else
    echo "No se encontró el archivo."
fi
