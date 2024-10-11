#!/bin/bash

# Directorio con los archivos
DIRECTORIO="jamonconnutella"
CONTADOR=0
BLOQUE=300

# Cambia al directorio
cd "$DIRECTORIO" || exit 1

# Asegúrate de que estás en un repositorio de git
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Este no es un repositorio de Git."
    exit 1
fi

# Recorre los archivos en el directorio
for ARCHIVO in "$DIRECTORIO"/*; do
    # Agrega el archivo al área de preparación
    git add "$ARCHIVO"
    ((CONTADOR++))

    # Cuando el contador alcanza el bloque de 100 archivos, haz commit, push y espera
    if (( CONTADOR % BLOQUE == 0 )); then
        git commit -m "Commit de bloque de $BLOQUE archivos"
        git push
    fi
done

# Si quedan archivos sin hacer commit al final
if (( CONTADOR % BLOQUE != 0 )); then
    git commit -m "Commit final con los últimos archivos"
    git push
fi

echo "Todos los archivos han sido añadidos, comiteados y enviados."