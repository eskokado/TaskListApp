#!/bin/bash
set -e

# Cria o diretório tmp/pids se não existir
mkdir -p /app/tmp/pids

# Remove um arquivo de servidor PID pré-existente
rm -f /app/tmp/pids/server.pid

exec "$@"
