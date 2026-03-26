A Docker-based network security lab simulating a corporate infrastructure with multiple honeypot layers, segmented firewalls, and a SIEM. Built to study attacker behavior using production-grade tools in a fully isolated environment.

---

## Architecture

The lab emulates a three-tier corporate network with DMZ isolation and strict inter-zone firewall rules.

```
Internet
   │
   ├── ext-firewall (iptables — allows 80, 443, 25, 587, 993)
   │
   └── DMZ — 10.10.0.0/24
         ├── web-server          nginx           10.10.0.10
         ├── mail-server         bytemark/smtp   10.10.0.20
         ├── honeypot-dmz        Kippo SSH       10.10.0.99
         ├── snare               web honeypot    10.10.0.97
         ├── tanner              Snare backend   10.10.0.96
         ├── tanner-redis        Redis           10.10.0.94
         └── opencanary          multi-protocol  10.10.0.95
               │
               └── int-firewall (allowlist only)
                     │
                     └── Internal — 10.20.0.0/24 (isolated, no outbound)
                           ├── erp-system          Odoo 17         10.20.0.10
                           ├── fileshare           Samba           10.20.0.20
                           ├── web-db              PostgreSQL 16   10.20.0.30
                           ├── wazuh-manager                       10.20.0.40
                           ├── wazuh-indexer       OpenSearch      10.20.0.41
                           ├── wazuh-dashboard     Kibana UI       10.20.0.42
                           ├── honeypot-internal   Kippo SSH       10.20.0.99
                           └── workstation         alpine          10.20.0.50
```

### Honeypots

| Container | Tool | Protocol | Position |
|---|---|---|---|
| `honeypot-dmz` | Kippo | SSH :2222 | DMZ |
| `honeypot-internal` | Kippo | SSH | Internal LAN |
| `snare` + `tanner` | SNARE/TANNER | HTTP :8091 | DMZ |
| `opencanary` | OpenCanary | FTP, SSH, HTTP, Telnet, MySQL, Redis | DMZ |

---

## Stack

- **Kippo** — SSH medium-interaction honeypot. Logs credentials, sessions, and every command an attacker runs.
- **SNARE + TANNER** — Web honeypot pair. SNARE serves a fake corporate login page; TANNER analyzes each request and emulates vulnerabilities (SQLi, XSS, LFI, RFI, command injection).
- **OpenCanary** — Multi-protocol honeypot by Thinkst. Fakes SSH, FTP, HTTP, Telnet, MySQL and Redis services with structured JSON logging — the same tool used in real enterprise environments.
- **Wazuh** — Full SIEM stack (manager + OpenSearch indexer + Kibana-based dashboard) receiving syslog from all honeypots.
- **Odoo 17** — ERP on the internal network, simulating a real business application as an attack target.
- **PostgreSQL 16** — Shared database backend.
- **Samba** — File share with per-user ACL, simulating a corporate file server.
- **iptables firewalls** — `ext-firewall` and `int-firewall` running inside Alpine containers, enforcing DMZ segmentation.

---

## Getting started

git clone https://github.com/your-username/network-security-honeypot-lab
cd network-security-honeypot-lab

docker compose build
docker compose up -d
docker compose ps

Wazuh dashboard takes ~2 minutes to become available after startup.

---

## Simulating an attack

Spin up an attacker container on the DMZ network and connect to the Kippo honeypot:

docker run --rm -it --name attacker \
  --network network-security-honeypot-lab_dmz_net \
  ubuntu:20.04 bash

Inside the attacker container:

apt-get update -qq && apt-get install -y -qq openssh-client
ssh -o StrictHostKeyChecking=no \
    -o KexAlgorithms=diffie-hellman-group-exchange-sha1 \
    root@10.10.0.99 -p 2222
# password: root

```

Kippo accepts the connection and logs everything — credentials tried, commands run, files downloaded.

---

## Checking logs

# Kippo SSH honeypot
docker logs honeypot-dmz

# OpenCanary multi-protocol
docker logs opencanary

# Snare web honeypot
docker logs snare
docker logs tanner

---

## Wazuh dashboard

```
http://localhost:8080 
```

---

## Project structure

```
.
├── docker-compose.yml
└── config/
    ├── kippo/
    │   ├── Dockerfile
    │   ├── entrypoint.sh
    │   ├── kippo.cfg
    │   └── userdb.txt
    ├── snare/
    │   ├── Dockerfile
    │   ├── entrypoint.sh
    │   └── pages/
    │       └── index.html
    ├── tanner/
    │   ├── Dockerfile
    │   └── entrypoint.sh
    └── opencanary/
        ├── Dockerfile
        └── opencanary.conf
        
---

## Disclaimer

This environment is intentionally vulnerable. Do not expose any ports to the public internet. Intended for local lab and research use only.
