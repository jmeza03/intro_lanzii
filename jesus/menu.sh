#!/bin/bash

ENTORNO="$HOME/EPNro1"
ENTRADA="$ENTORNO/entrada"
SALIDA="$ENTORNO/salida"
PROCESADO="$ENTORNO/procesado"
LOG="$ENTORNO/procesado.log"

crear_entorno() {

    if [ -d "$ENTORNO" ]
    then
        echo "El entorno ya existe"
    else
        mkdir -p "$ENTRADA"
        mkdir -p "$SALIDA"
        mkdir -p "$PROCESADO"

        touch "$LOG"

        DIR_SCRIPT="$(cd "$(dirname "$0")" && pwd)"
        cp "$DIR_SCRIPT/consolidar.sh" "$ENTORNO/consolidar.sh"

        chmod +x "$ENTORNO/consolidar.sh"

        echo "Entorno creado"
    fi
}

correr_proceso() {

    if [ -f "$ENTORNO/consolidar.sh" ]
    then

        if [ -f "$ENTORNO/proceso.pid" ]
        then

            echo "El proceso ya esta corriendo"

        else

            "$ENTORNO/consolidar.sh" &
            PID=$!

            echo "$PID" > "$ENTORNO/proceso.pid"

            echo "Proceso iniciado en background"
            
        fi

    else

        echo "Primero debe crear el entorno"

    fi
}

listar_alumnos() {

    archivo="$SALIDA/$FILENAME.txt"

    if [ -f "$archivo" ]
    then
        sort -n -k1 "$archivo"
    else
        echo "El archivo no existe"
    fi
}

mostrar_mejores_notas() {

    archivo="$SALIDA/$FILENAME.txt"

    if [ -f "$archivo" ]
    then
        sort -n -r -k5 "$archivo" | head -10
    else
        echo "El archivo no existe"
    fi
}

buscar_alumno() {

    archivo="$SALIDA/$FILENAME.txt"

    read -p "Ingrese numero de padron: " padron

    if [ -f "$archivo" ]
    then
        grep "^$padron " "$archivo"
    else
        echo "El archivo no existe"
    fi
}

ver_log() {

    if [ -f "$LOG" ]
    then
        cat "$LOG"
    else
        echo "El archivo de log no existe"
    fi
}

eliminar_entorno() {

    if [ -f "$ENTORNO/proceso.pid" ]
    then
        PID=$(cat "$ENTORNO/proceso.pid")
        kill "$PID"
    fi

    rm -rf "$ENTORNO"

    echo "Entorno eliminado"
}


# Parametro -d

if [ "$1" = "-d" ]
then

    eliminar_entorno

else

    opcion=0

    while [ "$opcion" -ne 7 ]
    do

        echo ""
        echo "=========================="
        echo "       MENU PRINCIPAL"
        echo "=========================="
        echo "1) Crear entorno"
        echo "2) Correr proceso"
        echo "3) Listar alumnos"
        echo "4) Mostrar 10 notas mas altas"
        echo "5) Buscar alumno por padron"
        echo "6) Visualizar log"
        echo "7) Salir"
        echo "=========================="

        read -p "Ingrese una opcion: " opcion

        case $opcion in

            1)
                crear_entorno
                ;;

            2)
                correr_proceso
                ;;

            3)
                listar_alumnos
                ;;

            4)
                mostrar_mejores_notas
                ;;

            5)
                buscar_alumno
                ;;

            6)
                ver_log
                ;;

            7)
                echo "Saliendo..."
                ;;

            *)
                echo "Opcion invalida"
                ;;

        esac

    done

fi