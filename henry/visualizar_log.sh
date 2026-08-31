echo "" # Visualizar log

echo "=== ÚLTIMOS REGISTROS EN EL LOG ==="

# Validamos si existe el archivo de log antes de leerlo
if [ -f ~/$CREACION/procesado.log ]; then
    cat ~/$CREACION/procesado.log
else
    echo "El archivo procesado.log aún no se ha creado."
fi

echo "";;
