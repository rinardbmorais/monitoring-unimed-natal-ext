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

> ![image](https://github.com/user-attachments/assets/c04dedc6-0b7d-4791-8a43-c0d80eaa657d)

---

## 🧩 Estrutura do Projeto

```bash
.
├── grafana-dashboard.json       # JSON com o painel do Grafana
├── blackbox.yml                 # Configuração do Blackbox Exporter
├── prometheus.yml               # Configuração do Prometheus
└── README.md
```

---

## ⚙️ Como Rodar Localmente

### 1. Clonar o repositório

```bash
git clone https://github.com/rinardbmorais/monitoring-unimed-natal-ext.git
cd monitoring-unimed-natal-ext
```

### 2. Subir Prometheus + Blackbox + Grafana com Docker Compose

Você pode criar um `docker-compose.yml` como este (opcional):

```yaml
version: '3'

services:
  prometheus:
    image: prom/prometheus
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - ./blackbox.yml:/etc/prometheus/blackbox.yml
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
    ports:
      - 9090:9090

  blackbox:
    image: prom/blackbox-exporter
    volumes:
      - ./blackbox.yml:/etc/blackbox_exporter/config.yml
    command:
      - '--config.file=/etc/blackbox_exporter/config.yml'
    ports:
      - 9115:9115

  grafana:
    image: grafana/grafana
    ports:
      - 3000:3000
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
