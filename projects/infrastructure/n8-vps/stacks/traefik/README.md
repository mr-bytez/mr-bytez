# Traefik Reverse Proxy — n8-vps

**Version:** 0.1.0
**Erstellt:** 2026-03-01
**Aktualisiert:** 2026-03-01
**Autor:** MR-ByteZ

---

## Uebersicht

Traefik v3 als Reverse Proxy auf n8-vps. Grundvoraussetzung fuer ALLE oeffentlich
erreichbaren Services (Authentik, Forgejo, Nextcloud, MCP Server, etc.).

---

## Architektur

| Eigenschaft | Wert |
|------------|------|
| Image | `traefik:v3.6` |
| Container | `mrbz-traefik` |
| Netzwerk | `mrbz-proxy-net` (extern) |
| Ports | 80 (HTTP → HTTPS Redirect), 443 (HTTPS) |
| Dashboard | `traefik.mr-bytez.de` (BasicAuth) |
| TLS | Wildcard `*.mr-bytez.de` via Let's Encrypt |
| ACME | DNS-01 Challenge (Hetzner DNS API) |
| Config | Hybrid: Docker-Labels + File-Provider |
| Logs | `/var/log/traefik/` (Access + Error) |

---

## Dateien

```
traefik/
├── docker-compose.yml          # Stack-Definition
├── config/
│   ├── traefik.yml             # Statische Konfiguration
│   └── dynamic/
│       └── middlewares.yml     # Security-Headers Middleware
├── .env.example                # Beispiel-Environment (→ .env kopieren)
├── README.md                   # Diese Datei
└── DEPLOYMENT.md               # Deployment-Anleitung
```

---

## Konfiguration

### Statische Config (`config/traefik.yml`)

- **EntryPoints:** `web` (Port 80, Redirect auf HTTPS), `websecure` (Port 443)
- **Provider:** Docker (exposedByDefault: false) + File (dynamic/)
- **ACME:** Let's Encrypt Production, DNS-01 via Hetzner, Email: traefik@mr-bytez.de
- **Dashboard:** Aktiviert, insecure: false (nur ueber Router erreichbar)

### Dynamische Config (`config/dynamic/middlewares.yml`)

- **security-headers:** HSTS, X-Frame-Options, X-Content-Type-Options, Referrer-Policy

### Environment (`.env`)

- `HETZNER_API_TOKEN` — Hetzner DNS API-Token fuer ACME
- `TRAEFIK_DASHBOARD_AUTH` — htpasswd-Hash fuer Dashboard BasicAuth

---

## Service anbinden

Neuen Service an Traefik anbinden (Docker-Labels):

```yaml
services:
  mein-service:
    # ...
    networks:
      - mrbz-proxy-net
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.mein-service.rule=Host(`mein-service.mr-bytez.de`)"
      - "traefik.http.routers.mein-service.entrypoints=websecure"
      - "traefik.http.routers.mein-service.tls.certresolver=letsencrypt-production"
      - "traefik.http.routers.mein-service.middlewares=security-headers@file"

networks:
  mrbz-proxy-net:
    external: true
```

---

## Sicherheitshinweise

- **Docker Socket:** Read-only gemountet — spaeter durch Docker Socket Proxy ersetzen
- **BasicAuth:** Temporaer — wird durch Authentik Forward-Auth ersetzt
- **Hetzner API-Token:** Nur DNS-Berechtigungen (Zone Read + Write)
- **acme.json:** Berechtigungen muessen 0600 sein (Traefik prueft das)
- **Secrets:** Nur in `.env` (gitignored), nie im Compose-File

---

## Abhaengigkeiten

Voraussetzungen (bereits erledigt):
- DNS Wildcard A+AAAA Records `*.mr-bytez.de` → n8-vps
- CAA Records fuer Let's Encrypt
- Firewall: Port 80 + 443 offen (UFW + Hetzner Robot)
- Docker installiert auf n8-vps

Services die Traefik benoetigen:
- Authentik (SSO) → ersetzt BasicAuth
- Portainer, Watchtower, UptimeKuma
- Forgejo, Nextcloud, MCP Server

---

## Referenzen

- **Handoff:** `.claude/context/handoffs/HANDOFF_[Traefik][Docker]_n8-vps-traefik-setup.md`
- **Docker-Konventionen:** `.claude/context/docker.md`
- **Traefik Docs:** https://doc.traefik.io/traefik/
- **ROADMAP:** B14 (Traefik Setup), D14 (ACME DNS-01)
