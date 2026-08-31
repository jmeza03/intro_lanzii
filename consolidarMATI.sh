#!/bin/bash

# Rutas absolutas del proyecto
DIR_BASE="$HOME/Documentos/EPNro1"
DIR_ENTRADA="$DIR_BASE/entrada"
DIR_SALIDA="$DIR_BASE/salida"
DIR_PROCESADO="$DIR_BASE/procesado"
ARCHIVO_LOG="$DIR_BASE/procesado.log"

# Aseguramos que existan las carpetas necesarias
mkdir -p "$DIR_ENTRADA" "$DIR_SALIDA" "$DIR_PROCESADO"

# 1. VALIDACIÓN LOGICA DE LA VARIABLE DE AMBIENTE EXTERNA
# Si FILENAME está vacía, escribimos el fallo directamente en el log y salimos
if [ -z "$FILENAME" ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') [ERROR] El servicio no pudo iniciar: La variable de ambiente FILENAME no está definida." >> "$ARCHIVO_LOG"
    exit 1
fi

# Registramos el inicio exitoso del servicio en el log
echo "$(date '+%Y-%m-%d %H:%M:%S') [SISTEMA] Servicio iniciado. Consolidando datos en: $DIR_SALIDA/$FILENAME.txt" >> "$ARCHIVO_LOG"

# 2. Bucle infinito para monitoreo periódico
while true
do
    for archivo in "$DIR_ENTRADA"/*
    do
        if [ -f "$archivo" ]; then
            nombre_archivo=$(basename "$archivo")

            # Analizamos si el archivo tiene la extensión .txt
            if [[ "$nombre_archivo" == *.txt ]]; then
                echo "$(date '+%Y-%m-%d %H:%M:%S') [INFO] Procesando archivo de texto: $nombre_archivo" >> "$ARCHIVO_LOG"

                # Adjuntamos la información usando el valor dinámico de la variable $FILENAME
                cat "$archivo" >> "$DIR_SALIDA/$FILENAME.txt"
                echo "" >> "$DIR_SALIDA/$FILENAME.txt"

                # Movemos el archivo procesado
                mv "$archivo" "$DIR_PROCESADO/"
                echo "$(date '+%Y-%m-%d %H:%M:%S') [EXITO] '$nombre_archivo' consolidado y movido." >> "$ARCHIVO_LOG"
            else
                echo "$(date '+%Y-%m-%d %H:%M:%S') [ALERTA] Archivo ignorado (no es .txt): $nombre_archivo" >> "$ARCHIVO_LOG"
            fi
        fi
    done

    # Pausa de 5 segundos
    sleep 5
done