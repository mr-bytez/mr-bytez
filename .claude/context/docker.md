# Docker — Container & Stack-Konventionen

**Version:** 1.0.0
**Erstellt:** 2026-02-10
**Aktualisiert:** 2026-02-10
**Autor:** MR-ByteZ

---

## Naming-Konventionen

### Container

- Präfix: `mrbz-` für alle mr-bytez Container
- Format: `mrbz-<stack>-<service>`
- Beispiele: `mrbz-dev-workspace`, `mrbz-traefik`, `mrbz-mcp`

### Netzwerke

- Format: `mrbz-<stack>-net`
- Beispiele: `mrbz-dev-net`, `mrbz-proxy-net`

### Volumes

- Format: `mrbz-<stack>-<zweck>`
- Beispiele: `mrbz-dev-fish-history`, `mrbz-qdrant-data`

---

## Stack-Locations

| Typ | Pfad | Beispiel |
|-----|------|----------|
| Shared Stacks | `shared/stacks/<name>/` | `shared/stacks/mrbz-dev/` |
| Host-spezifische Stacks | `projects/infrastructure/<host>/stacks/<name>/` | `projects/infrastructure/n8-vps/stacks/traefik/` |

---

## Stack-Struktur (Standard)

```
<stack>/
├── docker-compose.yml
├── Dockerfile           # Falls custom Image
├── .env                 # Environment (gitignored!)
├── README.md            # Stack-Dokumentation
├── DEPLOYMENT.md        # Stack-Deployment
└── .devcontainer/       # VS Code DevContainer (optional)
    └── devcontainer.json
```

---

## Geplante Stacks

| Stack | Location | Netzwerk | Status |
|-------|----------|----------|--------|
| mrbz-dev | `shared/stacks/mrbz-dev/` | mrbz-dev-net (172.30.0.0/24) | 🔴 Geplant |
| mrbz-mcp | `shared/stacks/mrbz-dev/` | mrbz-dev-net | 🔴 Geplant |
| mrbz-qdrant | `shared/stacks/mrbz-dev/` | mrbz-dev-net | 🔴 Geplant |
| Traefik | `projects/infrastructure/n8-vps/stacks/traefik/` | mrbz-proxy-net | 🔴 Geplant |

**Architektur-Details:** → `.claude/archive/mrbz-dev-plan.md`

---

## Docker Compose Best Practices

- YAML: 2 Spaces Indentation, NIEMALS Tabs
- `restart: unless-stopped` als Standard
- Explizite IP-Adressen in Custom Networks
- Named Volumes für persistente Daten
- `stdin_open: true` + `tty: true` für interaktive Container

---

## Dockerfile Best Practices

- UPPERCASE Instructions (FROM, RUN, COPY, etc.)
- Multi-stage Builds bevorzugen
- Layer minimieren durch Zusammenfassen von RUN-Befehlen
- Arch Linux Base: `archlinux:base-devel`
- Cache bereinigen: `pacman -Scc --noconfirm` am Ende von RUN

---

## Secrets in Docker

- **NIEMALS** Secrets in Environment-Variablen im Compose-File
- Docker Secrets mit secretfile verwenden
- Secrets via openssl erzeugen: `openssl rand -base64 32` (minimum 30 Zeichen)
- Immer Befehle zur Secret-Erzeugung bereitstellen
- Details zu Secrets-Policy → `.claude/context/security.md`
