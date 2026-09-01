#!/bin/bash

# 1. Definimos y exportamos la variable de ambiente
export FILENAME="FILENAME"

# =====================================================================
# LÓGICA DE PARÁMETROS: EVALUACIÓN DE LIMPIEZA (-d)
# =====================================================================
# Evaluamos de forma lógica si el primer parámetro recibido ($1) es "-d"
if [ "$1" == "-d" ]; then
    echo "======================================"
    echo "     INICIANDO LIMPIEZA DE ENTORNO    "
    echo "======================================"

    # 1. Buscamos y matamos el proceso en segundo plano
    echo "Buscando procesos de 'consolidar.sh' en background..."
    
    # pkill -f busca el patrón del nombre del script en la lista de procesos activos y los mata
    if pkill -f "consolidar.sh" 2>/dev/null; then
        echo "--> Proceso consolidar.sh detenido exitosamente."
    else
        echo "--> No se encontraron procesos activos en segundo plano."
    fi

    # 2. Eliminamos la carpeta del entorno EPNro1 de forma recursiva (-r) y forzada (-f)
    DIR_BASE="$HOME/Documentos/EPNro1"
    if [ -d "$DIR_BASE" ]; then
        echo "Eliminando la carpeta $DIR_BASE y todo su contenido..."
        rm -rf "$DIR_BASE"
        echo "--> ¡Entorno borrado con éxito!"
    else
        echo "--> El entorno $DIR_BASE ya se encontraba vacío o no existía."
    fi

    echo "======================================"
    exit 0 # Salimos del script inmediatamente sin abrir el menú
fi
# =====================================================================


# Si no se pasó el parámetro "-d", el script continúa normalmente al menú interactivo:

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
            echo "Creando estructura de carpetas..."
            mkdir -p ~/Documentos/EPNro1/entrada && echo "--> Carpeta entrada... [OK]"
            mkdir -p ~/Documentos/EPNro1/salida && echo "--> Carpeta salida... [OK]"
            mkdir -p ~/Documentos/EPNro1/procesado && echo "--> Carpeta procesado... [OK]"
            
            echo "Autogenerando script consolidar.sh..."

            # Usamos un Heredoc con 'EOF' para escribir el archivo de forma literal
            cat << 'EOF' > ~/Documentos/EPNro1/consolidar.sh
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
EOF

            # Le otorgamos los permisos de ejecución requeridos al script recién guardado
            chmod +x ~/Documentos/EPNro1/consolidar.sh
            echo "--> Script consolidar.sh generado y configurado... [OK]"
            echo "======================================"
            echo "¡Entorno y script creados exitosamente!"
            echo ""
            ;;

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
