
# 📊 Dashboard de Disponibilidade e Latência com Blackbox Exporter + Prometheus + Grafana

Este projeto apresenta um painel de observabilidade utilizando **Blackbox Exporter**, **Prometheus** e **Grafana**, com foco no monitoramento da **disponibilidade (UP/DOWN)** e **latência** de aplicações e APIs.

---

## 🚀 Tecnologias Utilizadas

- **Prometheus**
- **Blackbox Exporter**
- **Grafana** (versão 10.x)
- **Kubernetes** ou ambiente local com Docker
- **JSON de Dashboard customizado**

![image](https://github.com/user-attachments/assets/dbd8af63-6c79-49d2-801d-9f7cb48bef19)

---

## 🎯 Objetivo

Monitorar a disponibilidade e o tempo de resposta (latência) de aplicações, APIs internas ou externas, usando sondas ativas (HTTP) através do Blackbox Exporter.

O dashboard exibe:

- **Status de disponibilidade (UP/DOWN)**
- **Latência atual (última medição)**
- **Latência ao longo do tempo**
- **Resumo com último scrape, duração e status**

---

## 📸 Prévia do Dashboard

> ![image](https://github.com/user-attachments/assets/c4ff5ecc-f5f0-43da-bd0f-d208bb283044)


---

## 🧩 Estrutura do Projeto

```bash
.monitoring-ext/
├── docker-compose.yml
├── prometheus.yml        # Configuração principal do Prometheus
├── blackbox.yml          # Configuração do Blackbox Exporter
├── grafana/              # Pasta reservada (possivelmente para configs do Grafana)
├── prometheus/           # Pasta reservada (scripts ou arquivos auxiliares para Prometheus)
├── prometheus-data/      # Volume persistente de dados do Prometheus (bind: ./prometheus-data)
│   └── (dados de métricas, TSDB do Prometheus)
├── scripts/              # Scripts auxiliares
├── backups/              # Diretório para possíveis backups
└── README.md             # Documentação do projeto

Contêineres (Docker Compose):
└── Rede: monitoring-net (externa)
    ├── grafana
    │   ├── Imagem: grafana/grafana
    │   ├── Porta: 3000:3000
    │   └── Volume: /home/lab/grafana-storage:/var/lib/grafana
    │
    ├── prometheus
    │   ├── Imagem: prom/prometheus:v2.52.0
    │   ├── Porta: 9090:9090
    │   ├── Volume: ./prometheus.yml:/etc/prometheus/prometheus.yml:ro
    │   └── Volume: ./prometheus-data:/prometheus
    │
    └── blackbox_exporter
        ├── Imagem: prom/blackbox-exporter:latest
        └── Porta: 9115:9115
```

---

## ⚙️ Como Rodar Localmente

### 1. Clonar o repositório

```bash
git clone https://github.com/rinardbmorais/monitoring-ext.git
cd monitoring-ext
```

### 2. Subir Prometheus + Blackbox + Grafana com Docker Compose

Você pode criar um `docker-compose.yml` como este (opcional):

```yaml
services:
  grafana:
    image: grafana/grafana
    container_name: grafana
    ports:
      - "3000:3000"
    volumes:
      - /home/lab/grafana-storage:/var/lib/grafana
    networks:
      - monitoring-net
    restart: unless-stopped

  prometheus:
    image: prom/prometheus:v2.52.0
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml:ro
      - ./prometheus-data:/prometheus
    networks:
      - monitoring-net
    restart: unless-stopped

  blackbox_exporter:
    image: prom/blackbox-exporter:latest
    container_name: blackbox_exporter
    ports:
      - "9115:9115"
    networks:
      - monitoring-net
    restart: unless-stopped

networks:
  monitoring-net:
    external: true

#feito por Rinard Morais - Analista DevOps
```

### 3. Importar o Dashboard no Grafana

1. Acesse `http://localhost:3000`
2. Login padrão: `admin` / `admin`
3. Vá em **Dashboards → Importar**
4. Importe o arquivo `grafana-dashboard.json`
5. Selecione a datasource do Prometheus (criada automaticamente ou manualmente)

---

## 📈 Métricas Monitoradas

- `probe_success{job="blackbox"}` → Disponibilidade (1: UP, 0: DOWN)
- `probe_duration_seconds{job="blackbox"}` → Latência da aplicação
- `probe_timestamp{job="blackbox"}` → Último scrape realizado

---

## 🧠 Aprendizados

- Uso do **Blackbox Exporter** como alternativa simples para healthchecks de APIs
- Visualização clara e objetiva no Grafana para **status e performance**
- Integração com Kubernetes ou ambiente local via Prometheus

---

## 📣 Contato

Feito por [Rinard Morais](https://www.linkedin.com/in/rinard-morais)

---

## 📌 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.
