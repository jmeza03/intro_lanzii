#!/bin/bash

export CREACION="$HOME/EPNro1"

if [ -d "$CREACION" ]; then #-d ve si exite el directorio
    echo "el entorno ya existe"
else
    mkdir -p "$CREACION/entrada"
    mkdir -p "$CREACION/salida"
    mkdir -p "$CREACION/procesado"

    echo f"entorno creado correctamente en: $CREACION"
fi
