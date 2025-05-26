#!/bin/bash

echo "[INFO] Iniciant càrrega de fitxers CSV..."

SOURCE_DIR="/config"
DESTINATION="gdrive:/HomeAssistant/CSV"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Ruta del fitxer de configuració de rclone
export RCLONE_CONFIG=/config/rclone/rclone.conf

# Crear carpeta temporal per copiar i renombrar
TEMP_DIR="/config/rclone/tmp_upload"
mkdir -p "$TEMP_DIR"

# Copiar fitxers i afegir marca temporal
for file in "$SOURCE_DIR"/*.csv; do
  [ -e "$file" ] || continue
  filename=$(basename "$file")
  new_name="${TIMESTAMP}_${filename}"
  cp "$file" "$TEMP_DIR/$new_name"
done

# Pujar els fitxers renombrats
rclone copy "$TEMP_DIR" "$DESTINATION" --log-level INFO >> /config/rclone/rclone.log 2>&1

# Eliminar fitxers temporals
rm -rf "$TEMP_DIR"

# Eliminar fitxers antics de Google Drive (només deixar els 3 més recents)
FILES_TO_DELETE=$(rclone lsl "$DESTINATION" | grep '.csv' | sort -rk1 | tail -n +4 | awk '{for (i=6; i<=NF; i++) printf $i" "; print ""}')
for file in $FILES_TO_DELETE; do
  echo "[INFO] Eliminant fitxer antic: $file"
  rclone delete "$DESTINATION/$file"
done

echo "[INFO] Sincronització completada."
