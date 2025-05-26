#!/bin/bash

echo "[INFO] Iniciant càrrega de fitxers CSV..."

SOURCE_DIR="/config"
DESTINATION="gdrive:/HomeAssistant/CSV"

# Ruta del fitxer de configuració de rclone
export RCLONE_CONFIG=/config/rclone/rclone.conf

# Puja només fitxers .csv des de la carpeta /config
rclone copy "$SOURCE_DIR" "$DESTINATION" --include "*.csv" --log-level INFO >> /config/rclone/rclone.log 2>&1

echo "[INFO] Sincronització completada."
