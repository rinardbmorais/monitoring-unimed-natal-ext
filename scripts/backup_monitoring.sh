#!/bin/bash

# Diretórios
DATA_DIR="$HOME/monitoring-unimed-natal-ext"
GRAFANA_DB="$DATA_DIR/grafana/grafana.db"
BACKUP_DIR="$DATA_DIR/backups"
TIMESTAMP=$(date +%Y-%m-%d_%H-%M)

echo "Iniciando backup em $(date)"

# Garante que o diretório existe
mkdir -p "$BACKUP_DIR"

# Backup do grafana.db
if [ -f "$GRAFANA_DB" ]; then
  cp "$GRAFANA_DB" "$BACKUP_DIR/grafana_${TIMESTAMP}.db"
  echo "Backup do Grafana concluído."
else
  echo "Arquivo $GRAFANA_DB não encontrado. Pulando backup do Grafana."
fi

# Backup do Prometheus (config + dados)
if [ -d "$DATA_DIR/prometheus-data" ]; then
  tar -czf "$BACKUP_DIR/prometheus_${TIMESTAMP}.tar.gz" \
      -C "$DATA_DIR" prometheus.yml prometheus-data
  echo "Backup do Prometheus concluído."
else
  echo "Diretório prometheus-data não encontrado. Pulando backup do Prometheus."
fi

# --- Remover backups antigos, mantendo somente o mais recente ---

# Remove backups antigos do Grafana, mantém só o último
find "$BACKUP_DIR" -name "grafana_*.db" -type f -printf '%T+ %p\n' | \
sort -r | tail -n +2 | cut -d' ' -f2- | xargs -r rm --

# Remove backups antigos do Prometheus, mantém só o último
find "$BACKUP_DIR" -name "prometheus_*.tar.gz" -type f -printf '%T+ %p\n' | \
sort -r | tail -n +2 | cut -d' ' -f2- | xargs -r rm --

echo "Backup finalizado em $(date)"

# --- Commit e push para o GitHub ---

cd "$DATA_DIR" || { echo "Diretório $DATA_DIR não encontrado."; exit 1; }

# Atualiza repositório local (evitar conflitos)
git pull origin main

# Adiciona os arquivos da pasta backups
git add "$BACKUP_DIR"

# Comita com mensagem dinâmica
git commit -m "Backup automático em $TIMESTAMP" || echo "Nada para commitar."

# Envia para o remoto
git push origin main

echo "Backup enviado para o repositório remoto."
