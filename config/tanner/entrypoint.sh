#!/bin/bash
echo "[tanner] Aguardando Redis em ${REDIS_HOST}:${REDIS_PORT}..."
sleep 5

echo "[tanner] Localizando config do Tanner..."
CONFIG=$(python3 -c "
import tanner, os
pkg = os.path.dirname(tanner.__file__)
for p in ['data/config.yaml', 'data/tanner.cfg', 'config.yaml']:
    full = os.path.join(pkg, p)
    if os.path.exists(full):
        print(full)
        break
" 2>/dev/null)

if [ -n "$CONFIG" ]; then
    echo "[tanner] Config encontrado: $CONFIG"
    sed -i "s/host: localhost/host: ${REDIS_HOST}/" "$CONFIG" 2>/dev/null || true
    sed -i "s/host: 127.0.0.1/host: ${REDIS_HOST}/" "$CONFIG" 2>/dev/null || true
    echo "[tanner] Redis apontado para ${REDIS_HOST}:${REDIS_PORT}"
else
    echo "[tanner] Config nao encontrado, usando defaults"
fi

echo "[tanner] Iniciando Tanner..."
exec python3 -m tanner.server
