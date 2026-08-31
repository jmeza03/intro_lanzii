#!/bin/bash
export FILENAME="FILENAME"

while true
do
    echo "~~~~~~~~~~~~~~~~~~~~~~~~"
    echo -e "\t\tMENU PRINCIPAL"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "1) crear entorno"
    echo "2) correr proceso"
    echo "3) listar alumno"
    echo "4) mostrar 10 notas mas altas"
    echo "5) buscar alumno por padron"
    echo "6) visualizar log"
    echo "7) salir"

    read -p "seleccione una opcion: " opcion #el -p hace que evitemos un echo

    case "$opcion" in

        1) echo "creando entorno"; ./crear_entorno.sh ;;

        2) echo "corriendo proceso"; ./correr_proceso.sh ;;

        3) echo "listando alumnos"; ./listar_alumnos.sh ;;

        4) echo "las 10 notas mas altas son: "; ./notas_altas.sh ;;

        5) echo "buscando el alumno elegido..."; ./alumno_padron.sh ;;

        6) echo "visualizando log"; ./visualizar_log.sh ;;

        7) echo "saliendo del bucle... chau"; break ;;
 
    esac
done
