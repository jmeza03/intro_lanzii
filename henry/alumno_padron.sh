read -p "ingresa el padron del alumno:" padron

archivo=~/$CREACION/salida/$FILENAME.txt

if [ -f "$archivo" ]; then
    grep "^$padron" "$archivo"

    if [ $? -ne 0 ]; then
        echo "no se encontró ningún alumno con el padrón $padron."
    fi
    
else
    echo "no se encontró el archivo."
fi
