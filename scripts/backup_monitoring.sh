#!/bin/bash

# Diretórios
DATA_DIR="$HOME/monitoring-unimed-ext"
GRAFANA_DB="$HOME/grafana-storage/grafana.db"
BACKUP_DIR="$DATA_DIR/backups"
TIMESTAMP=$(date +%Y-%m-%d_%H-%M)

# Garante que o diretório existe
mkdir -p "$BACKUP_DIR"

# Backup do grafana.db
cp "$GRAFANA_DB" "$BACKUP_DIR/grafana_${TIMESTAMP}.db"

# Opcional: backup leve do Prometheus (ex: config e active queries)
tar -czf "$BACKUP_DIR/prometheus_${TIMESTAMP}.tar.gz" \
    -C "$DATA_DIR/prometheus-data" queries.active \
    -C "$DATA_DIR" prometheus.yml

# Git: adiciona, commita e faz push
cd "$DATA_DIR"
git pull origin main

git add backups/
git commit -m "Backup automático em $TIMESTAMP"
git push origin main
