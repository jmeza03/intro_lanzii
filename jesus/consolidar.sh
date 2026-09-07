#!/bin/bash

ENTORNO="$HOME/EPNro1"
ENTRADA="$ENTORNO/entrada"
SALIDA="$ENTORNO/salida"
PROCESADO="$ENTORNO/procesado"
LOG="$ENTORNO/procesado.log"

while true
do

    for archivo in "$ENTRADA"/*.txt
    do

        if [ -f "$archivo" ]
        then

            cat "$archivo" >> "$SALIDA/$FILENAME.txt"

            nombre_archivo=$(basename "$archivo")

            mv "$archivo" "$PROCESADO"

            echo "$(date '+%d/%m/%Y %H:%M:%S') - Procesado archivo $nombre_archivo" >> "$LOG"

        fi

    done

    sleep 5

done