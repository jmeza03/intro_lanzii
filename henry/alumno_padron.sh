read -p "ingresa el padron del alumno:" padron

archivo=~/$CREACION/salida/$FILENAME.txt

if [ -f "$archivo" ] && grep -p "$padron" "$archivo"; then
    grep "^$padron" "$archivo"
else
    echo "no se encontró el archivo"
fi
