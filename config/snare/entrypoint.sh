#!/bin/bash
echo "[snare] Aguardando Tanner em ${TANNER_HOST}:8090..."
sleep 5

echo "[snare] Iniciando honeypot web na porta ${SNARE_PORT}..."
exec python3 -m snare \
    --page-dir /opt/snare/pages \
    --tanner "${TANNER_HOST}" \
    --port "${SNARE_PORT}"
