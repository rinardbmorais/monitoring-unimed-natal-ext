#!/bin/bash

# Diretórios
DATA_DIR="$HOME/monitoring-unimed-natal-ext"
GRAFANA_DB="$DATA_DIR/grafana/grafana.db"
BACKUP_DIR="$DATA_DIR/backups"
TIMESTAMP=$(date +%Y-%m-%d_%H-%M)

# Garante que o diretório existe
mkdir -p "$BACKUP_DIR"

# Backup do grafana.db
if [ -f "$GRAFANA_DB" ]; then
  cp "$GRAFANA_DB" "$BACKUP_DIR/grafana_${TIMESTAMP}.db"
else
  echo "Arquivo $GRAFANA_DB não encontrado. Pulando backup do Grafana."
fi

# Backup do Prometheus (config + dados)
if [ -d "$DATA_DIR/prometheus-data" ]; then
  tar -czf "$BACKUP_DIR/prometheus_${TIMESTAMP}.tar.gz" \
      -C "$DATA_DIR" prometheus.yml prometheus-data
else
  echo "Diretório prometheus-data não encontrado. Pulando backup do Prometheus."
fi

# Remova as linhas abaixo se não estiver usando Git
#if [ -d "$DATA_DIR/.git" ]; then
#  cd "$DATA_DIR"
#  git pull origin main
#  git add backups/
#  git commit -m "Backup automático em $TIMESTAMP"
#  git push origin main
#else
#  echo "Diretório não é um repositório Git. Pulando operações Git."
#fi
