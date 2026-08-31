read -p "Ingrese el padron del alumno:" padron

archivo=~/$CREACION/salida/$FILENAME.txt

if [ -f "$archivo" ]; then
    grep "^$padron" "$archivo"

    if [ $? -ne 0 ]; then
        echo "No se encontró ningún alumno con el padrón $padron."
    fi
    
else
    echo "No se encontró el archivo."
fi
