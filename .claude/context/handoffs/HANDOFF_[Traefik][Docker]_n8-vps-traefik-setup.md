# 🔀 MR-ByteZ Traefik Handoff – n8-vps Reverse Proxy Setup

**Chat:** MR-ByteZ #INF01.1 [Traefik][Docker] - n8-vps Traefik Reverse Proxy Setup ACME DNS-01 Wildcard Let's Encrypt Production Docker-Provider BasicAuth Dashboard --- 2026-03-01-20-24
**Chat-Link:** https://claude.ai/chat/14f2d5dd-d902-4303-bb77-f896767a06bf
**Datum:** 2026-03-01
**Status:** 🔴 Offen — Bereit fuer Umsetzung
**Delegation:** ✅ Claude Code (mechanische Tasks), Chat (strategische Entscheidungen)
**Vorgaenger:** `HANDOFF_[DNS][Infra]_dns-hetzner-traefik.md` (DNS-Vorarbeit erledigt)

---

## 📋 Zusammenfassung

Traefik v3 als Reverse Proxy auf n8-vps aufsetzen. Ist die **Grundvoraussetzung** fuer ALLE oeffentlich
erreichbaren Services (Authentik, Forgejo, Nextcloud, MCP Server, etc.).

DNS-Wildcard Records (`*.mr-bytez.de` → n8-vps) und CAA Records fuer Let's Encrypt sind bereits
eingerichtet (siehe DNS-Handoff).

---

## 🏗️ Architektur-Entscheidungen

| Entscheidung | Wahl | Begruendung |
|-------------|------|-------------|
| **Config-Strategie** | Hybrid (Docker + File) | Docker-Labels fuer Standard-Services, File-Provider fuer Spezialf\u00e4lle |
| **Let's Encrypt** | Direkt Production | Kein Staging, DNS-01 + Wildcard ist erprobt |
| **ACME Challenge** | DNS-01 via Hetzner API | Wildcard-Zertifikat `*.mr-bytez.de` |
| **Dashboard** | Aktiviert, BasicAuth | `traefik.mr-bytez.de`, spaeter Authentik Forward-Auth |
| **Netzwerk** | `mrbz-proxy-net` (extern) | Alle Services joinen dieses Netz |
| **Container-Name** | `mrbz-traefik` | Gemaess `mrbz-*` Naming-Konvention |
| **Logs** | Access + Error Log | Pfad: `/var/log/traefik/` auf Host |
| **Traefik Version** | v3.x (latest stable) | Aktuellste Major-Version |

---

## 📁 Ziel-Struktur im Repo

```
projects/infrastructure/n8-vps/stacks/traefik/
├── docker-compose.yml          # Stack-Definition
├── config/
│   ├── traefik.yml             # Statische Konfiguration
│   └── dynamic/                # File-Provider Configs
│       └── middlewares.yml     # Gemeinsame Middlewares (z.B. BasicAuth, Headers)
├── .env.example                # Beispiel-Environment (Secrets NICHT hier!)
├── README.md                   # Stack-Dokumentation
└── DEPLOYMENT.md               # Deployment-Anleitung fuer n8-vps
```

---

## ✅ Voraussetzungen (bereits erledigt)

- [x] DNS Wildcard A+AAAA Records `*.mr-bytez.de` → n8-vps
- [x] CAA Records fuer Let's Encrypt (`issue` + `issuewild`)
- [x] hcloud CLI + API-Token (`mr-bytez-dns-management.secret`)
- [x] Firewall: Port 80 + 443 offen (UFW + Hetzner Robot)
- [x] Docker installiert und laeuft auf n8-vps
- [x] mr-bytez Repo deployed auf n8-vps (read-only)

---

## 📝 Tasks — Reihenfolge

### Phase 1: Vorbereitung (auf n8-kiste, Claude Code)

**Task 1.1: API-Token mit Age verschluesseln (D3)**
- Token: `mr-bytez-dns-management.secret`
- Speicherort: `.secrets/infrastructure/n8-vps/home/mrohwer/.secrets/cloud/hetzner/`
- Mit `derive_key.fish secrets --with-username` verschluesseln
- Muss auf n8-vps ueber deploy.fish verfuegbar sein

**Task 1.2: Verzeichnisstruktur anlegen**
```fish
# Auf n8-kiste:
mkdir -p /mr-bytez/projects/infrastructure/n8-vps/stacks/traefik/config/dynamic
```

**Task 1.3: docker-compose.yml erstellen**
- Container: `mrbz-traefik`
- Image: `traefik:v3.3` (oder latest stable v3.x)
- Ports: `80:80`, `443:443`
- Netzwerk: `mrbz-proxy-net` (external: true)
- Volumes:
  - `./config/traefik.yml:/etc/traefik/traefik.yml:ro`
  - `./config/dynamic/:/etc/traefik/dynamic/:ro`
  - `/var/run/docker.sock:/var/run/docker.sock:ro` (fuer Docker-Provider)
  - `mrbz-traefik-certs:/letsencrypt` (Named Volume fuer ACME)
  - `/var/log/traefik/:/var/log/traefik/` (Logs)
- Labels: Dashboard Route (`traefik.mr-bytez.de`) + BasicAuth Middleware
- Environment: Hetzner API-Token fuer ACME (via Docker Secret oder env_file)
- `restart: unless-stopped`

**Task 1.4: traefik.yml (statische Config) erstellen**
- API: Dashboard aktiviert, insecure: false
- EntryPoints: `web` (80, redirect auf websecure), `websecure` (443, TLS)
- Providers: Docker (exposedByDefault: false) + File (directory: /etc/traefik/dynamic/)
- CertificatesResolvers: `letsencrypt-production`
  - ACME: DNS-01, Provider: `hetzner`
  - Storage: `/letsencrypt/acme.json`
  - Email: (deine Email fuer LE Notifications)
- Logging: Access Log + Error Log nach `/var/log/traefik/`
- Kein Staging — direkt Production

**Task 1.5: middlewares.yml (dynamische Config) erstellen**
- BasicAuth Middleware fuer Dashboard (htpasswd generieren)
- Security-Headers Middleware (HSTS, X-Frame-Options, etc.)
- Rate-Limiting Middleware (optional, fuer spaeter)

**Task 1.6: .env.example erstellen**
- `HETZNER_API_TOKEN=<aus Secrets>` (Platzhalter)
- `TRAEFIK_DASHBOARD_AUTH=<htpasswd hash>` (Platzhalter)
- `ACME_EMAIL=<email>`

**Task 1.7: README.md + DEPLOYMENT.md erstellen**
- Stack-Dokumentation gemaess 5-5-3 Pattern
- Deployment-Schritte fuer n8-vps

**Task 1.8: CHANGELOG + ROADMAP aktualisieren**
- B14 als "in Arbeit" markieren
- CHANGELOG Eintrag vorbereiten

**Task 1.9: Commit + Dual-Push**
- `[Traefik][Docker] n8-vps Traefik Reverse Proxy Stack erstellt`
- Push zu origin + codeberg

### Phase 2: Deployment (auf n8-vps, manuell/Claude Code via SSH)

**Task 2.1: git pull auf n8-vps**
```fish
cd /mr-bytez
git pull origin main
```

**Task 2.2: Docker-Netzwerk erstellen**
```fish
docker network create mrbz-proxy-net
```

**Task 2.3: Log-Verzeichnis erstellen**
```fish
sudo mkdir -p /var/log/traefik
sudo chown mrohwer:mrohwer /var/log/traefik
```

**Task 2.4: .env aus .env.example erstellen**
- API-Token aus Secrets eintragen
- BasicAuth Hash generieren: `htpasswd -nB admin`
  (Achtung: `apache-tools` bzw. `httpd-tools` Paket muss installiert sein)
- ACME Email eintragen

**Task 2.5: Stack starten**
```fish
cd /mr-bytez/projects/infrastructure/n8-vps/stacks/traefik
docker compose up -d
```

**Task 2.6: Verifizierung**
- [ ] Container laeuft: `docker ps | command grep mrbz-traefik`
- [ ] Dashboard erreichbar: `https://traefik.mr-bytez.de` (BasicAuth)
- [ ] Wildcard-Zertifikat: `acme.json` pruefen oder `curl -v https://traefik.mr-bytez.de`
- [ ] HTTP→HTTPS Redirect: `curl -I http://traefik.mr-bytez.de`
- [ ] Logs: `cat /var/log/traefik/access.log`

### Phase 3: Test-Service (Validierung)

**Task 3.1: whoami Test-Container deployen**
```fish
# Temporaerer Test — kann nach Verifizierung wieder entfernt werden
docker run -d \
  --name mrbz-whoami \
  --network mrbz-proxy-net \
  --label "traefik.enable=true" \
  --label "traefik.http.routers.whoami.rule=Host(\`whoami.mr-bytez.de\`)" \
  --label "traefik.http.routers.whoami.entrypoints=websecure" \
  --label "traefik.http.routers.whoami.tls.certresolver=letsencrypt-production" \
  traefik/whoami
```

**Task 3.2: Verifizierung**
- [ ] `curl https://whoami.mr-bytez.de` → zeigt Container-Info
- [ ] SSL-Zertifikat gueltig (Wildcard `*.mr-bytez.de`)
- [ ] HTTP→HTTPS Redirect funktioniert

**Task 3.3: Test-Container entfernen**
```fish
docker rm -f mrbz-whoami
```

---

## ⚠️ Wichtige Hinweise

1. **n8-vps ist read-only fuer Git** — alle Datei-Aenderungen auf n8-kiste committen, auf n8-vps nur pullen!
2. **Secrets NIEMALS in docker-compose.yml** — immer .env (gitignored) oder Docker Secrets
3. **`.env` ist gitignored** — nur `.env.example` wird committed
4. **Docker Socket Mount** ist ein Security-Risiko — spaeter durch Docker Socket Proxy ersetzen (CrowdSec Phase)
5. **BasicAuth ist temporaer** — wird durch Authentik Forward-Auth ersetzt sobald Authentik laeuft
6. **Hetzner API-Token** braucht nur DNS-Berechtigungen (Zone Read + Write)
7. **acme.json** Berechtigungen muessen 0600 sein (Traefik prueft das!)

---

## 🔗 Referenzen

- **DNS-Handoff:** `.claude/context/handoffs/HANDOFF_[DNS][Infra]_dns-hetzner-traefik.md`
- **Docker-Konventionen:** `.claude/context/docker.md`
- **Traefik Docs:** https://doc.traefik.io/traefik/
- **Hetzner ACME Provider:** https://doc.traefik.io/traefik/https/acme/#providers (Provider: `hetzner`)
- **ROADMAP Tasks:** B14 (Traefik Setup), D3 (Token Age), D14 (ACME DNS-01)
- **VPS Server-Doku:** Siehe Artefakt aus diesem Chat (`n8-vps-server-dokumentation.md`)

---

## 📊 Abhaengigkeiten (was nach Traefik kommt)

```
Traefik ✅
  ├── Authentik (SSO) → ersetzt BasicAuth am Dashboard
  ├── Portainer (Docker UI) → traefik.labels
  ├── Watchtower (Auto-Update)
  ├── UptimeKuma (Monitoring)
  ├── Forgejo (Git-Server)
  ├── Nextcloud (Cloud) → Migration von n8-kiste
  ├── MCP Server (A4) → mcp.mr-bytez.de
  └── Alle weiteren Services...
```

Jeder Service bekommt seinen eigenen Handoff wenn er dran ist.
