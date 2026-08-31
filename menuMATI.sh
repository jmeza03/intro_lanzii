#!/bin/bash

# 1. Definimos y exportamos la variable de ambiente
export FILENAME="FILENAME"



while true
do


    echo "======================================"
    echo "          MENÚ DE OPCIONES            "
    echo "======================================"
    echo "1 - Crear entorno"
    echo "2 - Correr proceso"
    echo "3 - Listar alumnos por padrón"
    echo "4 - Mostrar las 10 notas más altas"
    echo "5 - Buscar alumno por padrón"
    echo "6 - Visualizar log"
    echo "7 - Salir"
    read -p "Seleccione una opcion: " opcion #el -p hace que evitemos un echo


    case $opcion in

        1) echo "" # Crear entorno
           mkdir -p ~/Documentos/EPNro1/entrada && echo "Creando carpeta entrada... "
           mkdir -p ~/Documentos/EPNro1/salida && echo "Creando carpeta salida... "
           mkdir -p ~/Documentos/EPNro1/procesado && echo "Creando carpeta procesado... "
           echo "Carpetas creadas en ~/Documentos/EPNro1"
           echo "";;

        2) echo "" # Correr proceso
         # Verificamos si el proceso ya está corriendo en segundo plano para no duplicarlo
         if ps -ef | grep -v grep | grep "consolidar.sh" > /dev/null; then
            echo "El servicio de consolidación ya está corriendo en segundo plano."
         else
            echo "Iniciando servicio de consolidación en segundo plano..."
                
            # CORREGIDO: Ejecutamos en segundo plano (&) y redirigimos las salidas 
            # (tanto stdout como stderr) al log para no bloquear este menú
            bash ~/Documentos/EPNro1/consolidar.sh >> ~/Documentos/EPNro1/procesado.log 2>&1 &
                
            # Damos un segundo de espera para que se asiente el proceso
            sleep 1
            echo "¡Servicio lanzado con éxito! Podés verificar su estado visualizando el log (Opción 6)."
         fi
         ;;
           
        3) echo "" # Listar alumnos por padrón
           archivo=$(ls ~/Documentos/EPNro1/salida | grep -E '\.txt$' | head -n 1)
        # -E: Habilita el motor de expresiones regulares extendidas (para interpretar \. y $)
        # head -n 1 lee la primera línea que recibe de la lista para quedarse con el nombre del primer archivo que aparezca
        # $( ... ) ejecuta todo lo que está dentro de los paréntesis y almacena ese resultado dentro de la variable 'archivo'
               if [ -z "$archivo" ]; then
               # -z evalúa si la longitud de una cadena de texto es cero
           echo "No hay archivos en la carpeta de salida."
           exit 1
               fi
            echo "Archivo a procesar: $archivo"
            echo "Mostrando listado de alumnos ordenados por número de padrón"
            cat ~/Documentos/EPNro1/salida/$archivo | sort -n 
            echo "";;

        4) echo "" # Mostrar las 10 notas más altas
           archivo=$(ls ~/Documentos/EPNro1/salida | grep -E '\.txt$' | head -n 1)
               if [ -z "$archivo" ]; then
           echo "No hay archivos en la carpeta de salida."
           exit 1
               fi               
           echo "Archivo a procesar: $archivo"
           echo "Mostrando las 10 notas más altas del listado"
           sort -k 5 -nr ~/Documentos/EPNro1/salida/$archivo | head -n 10
           # -k 5 indica la columna 5, -nr indica orden descendente y numérico
           echo "";;

        5) echo "" # Buscar alumno por padrón
           read -p "Ingrese el número de padrón del alumno a buscar: " padron
           archivo=$(ls ~/Documentos/EPNro1/salida | grep -E '\.txt$' | head -n 1)
              if [ -z "$archivo" ]; then
           echo "No hay archivos en la carpeta de salida."
           exit 1
              fi
           echo "Archivo a procesar: $archivo"
           
           grep -E -w "^$padron" ~/Documentos/EPNro1/salida/$archivo
           # -E: Habilita el motor de expresiones regulares extendidas (para interpretar ^)
           # -w le indica a grep que busque únicamente palabras completas.
              if [ $? -ne 0 ]; then 
              # $? Almacena temporalmente un código numérico que evalua si el comando anterior se ejecutó o no.
           echo "No se encontró ningún alumno con el número de padrón $padron."
              fi
           echo "";;

         6) echo "" # Visualizar log
            echo "=== ÚLTIMOS REGISTROS EN EL LOG ==="
            # Validamos si existe el archivo de log antes de leerlo
            if [ -f ~/Documentos/EPNro1/procesado.log ]; then
                cat ~/Documentos/EPNro1/procesado.log
            else
                echo "El archivo procesado.log aún no se ha creado."
            fi
            echo "";;


         7) break # Rompe el ciclo 'while true' de forma segura

    esac

done