#!/bin/sh
echo "[kippo] Iniciando honeypot SSH na porta 2222..."
cd /kippo
exec twistd -n -y kippo.tac