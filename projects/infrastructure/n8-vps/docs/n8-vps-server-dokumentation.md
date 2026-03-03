# 🖥️ n8-vps Server — Komplette Statusdokumentation

**Erstellt:** 2026-03-01
**Aktualisiert:** 2026-03-03
**Autor:** MR-ByteZ + Claude
**Zweck:** Übersicht über Ist-Zustand, geplante Services und nächste Schritte
**Ablage im Repo:** `projects/infrastructure/n8-vps/docs/n8-vps-server-dokumentation.md`
**Referenz-Chats:** Wird in Chats als zentrale VPS-Referenz verlinkt

---

## 1. Server-Steckbrief

| Eigenschaft | Wert |
|-------------|------|
| **Hostname** | n8-vps |
| **Typ** | Hetzner EX63 Dedicated Server |
| **Standort** | Hetzner Rechenzentrum Falkenstein, Deutschland |
| **Prozessor** | Intel Xeon E5-2650 v4 (12 Kerne / 24 Threads) |
| **RAM** | 128 GB DDR4 ECC |
| **Storage** | 2× 1 TB NVMe (RAID 1) |
| **LVM-Layout** | 500 GB root, 100 GB home, 8 GB swap (~353 GB Reserve) |
| **OS** | Arch Linux (vanilla slim, installimage) |
| **IPv4** | `136.243.101.223` |
| **IPv6** | `2a01:4f8:171:ad1::2` |
| **SSH-Port** | 61020 (Key-Only, Password disabled) |
| **SSH Fallback** | Port 22 (temporär, sollte entfernt werden!) |
| **User** | `mrohwer` (sudo NOPASSWD, wheel-Gruppe) |
| **Rolle** | Production Server (read-only für Git, kein Commit!) |

---

## 2. Ist-Zustand — Was bereits installiert/konfiguriert ist

### ✅ Phase 0: Rescue System & OS-Installation (erledigt)

- Arch Linux via Hetzner `installimage` installiert
- RAID 1 über 2× NVMe konfiguriert
- LVM-Partitionierung abgeschlossen
- Hostname `n8-vps` gesetzt

### ✅ Phase 1: System-Basis (erledigt)

**User & Sicherheit:**
- User `mrohwer` angelegt (sudo, wheel-Gruppe)
- SSH auf Port 61020 (Key-Only, PasswordAuth deaktiviert)
- SSH-Keys für root + mrohwer hinterlegt
- sudo Timeout: 1 Stunde

**System-Konfiguration:**
- Tastatur: `de-latin1-nodeadkeys`
- Locale: `en_US.UTF-8` (System), `de_DE.UTF-8` (verfügbar)
- Timezone: `Europe/Berlin`
- pacman optimiert (Farben, 10 parallele Downloads, Hetzner Mirror)

**Installierte Pakete (30+):**
- Basis: `base-devel`, `linux-headers`, `sudo`
- Editoren: `vim`, `micro`
- Monitoring: `iotop`, `sysstat`, `ncdu`, `tree`, `lsof`
- Netzwerk: `networkmanager`, `openssh`, `curl`, `wget`, `rsync`
- DNS: `bind` (dig), `ldns` (drill), `unbound`
- Security: `ufw`, `fail2ban`, `wireguard-tools`, `gnupg`
- Kompression: `unzip`, `zip`, `tar`, `gzip`, `bzip2`, `xz`
- Tools: `jq`, `tmux`, `screen`, `git`
- Development: `python`, `python-pip`, `nodejs`, `npm`
- Container: `docker`, `docker-compose`, `docker-buildx`

**Fehlende Pakete (aus Host-Matrix Pre-Flight):**
- `duf`, `dust`, `htop`, `ripgrep`, `less` — noch zu installieren

**Firewall (UFW):**
- IPv6 komplett deaktiviert
- Default: deny incoming, allow outgoing, deny routed
- Port 61020/tcp: SSH (rate-limited)
- Port 80/tcp: HTTP (fuer Traefik)
- Port 443/tcp: HTTPS (fuer Traefik)
- Port 61820/udp: WireGuard VPN
- Docker Outbound: `route allow in on br+ out on enp130s0` (Container Internet-Zugang)
- Docker DNS: `allow in on br+ to any port 53 proto udp` (Container → Host Unbound)

**Hetzner Robot Firewall (externe Hardware-Firewall):**
- Default-Policy: discard (alles nicht explizit Erlaubte wird verworfen)
- IPv6 komplett gefiltert, Hetzner Services erlaubt
- Eingehend:
  - #1: ICMP erlaubt (Diagnose)
  - #2: Port 22/tcp (temporaer — entfernen!)
  - #3: TCP Established (ACK-Flag, Antwort-Pakete, Ziel-Port 32768-65535)
  - #4: Port 61020/tcp (SSH)
  - #5: Port 80/tcp (HTTP, fuer Traefik)
  - #6: Port 443/tcp (HTTPS, fuer Traefik)
  - #7: UDP Established (Antwort-Pakete, Ziel-Port 32768-65535) — fuer DNS-Antworten
- Ausgehend:
  - #1+#2: Block Mail Ports 25,465 (ipv4+ipv6, discard)
  - #3: Allow all (accept)

**DNS (Unbound):**
- Lokaler DNS-Resolver aktiv
- Interface: 0.0.0.0 (alle Interfaces, inkl. Docker-Bridges)
- Access-Control: 127.0.0.0/8 allow, 172.16.0.0/12 allow (Docker), 0.0.0.0/0 refuse
- DoT (DNS over TLS) zu Cloudflare + Quad9
- Optimiert fuer 20 Cores, 64 GB RAM

### ✅ Phase 2: Fish Shell (erledigt/übersprungen)

- Fish Shell installiert für root + mrohwer
- Fisher/Tide übersprungen (mr-bytez eigenes Prompt-System)
- Farbige Bash-Prompts als Fallback konfiguriert

### ✅ Phase 3: AUR & Dev Tools (erledigt)

- `yay` v12.5.7 gebaut und installiert
- VS Code Installation übersprungen (Remote SSH von n8-kiste!)

### ✅ Phase 4: Docker (erledigt)

- Docker installiert und aktiviert (Autostart)
- `mrohwer` in `docker`-Gruppe
- Keine Container laufen aktuell (alles geplant)

### ✅ mr-bytez Deployment (erledigt)

- Repository geklont nach `/mr-bytez`
- Stabiler Anker: `/opt/mr-bytez/current → /mr-bytez`
- System-Symlinks aktiv:
  - `/etc/fish → /opt/mr-bytez/current/shared/etc/fish`
  - `/usr/local/share/micro → /opt/mr-bytez/current/shared/usr/local/share/micro`
- Fish Loader erkennt `n8-vps` als Host
- Powerline Prompt aktiv (rot = Production!)
- Feature-Flags: `MR_HAS_GUI=false`, `MR_IS_DEV=true`, `MR_DISPLAY_TYPE=headless`
- Secrets-Deployment verifiziert (deploy.fish ✅, SSH ✅, Dual-Remote ✅)
- GitHub CLI mit OAuth authentifiziert
- Codeberg SSH mit `AddressFamily inet` (IPv6-Workaround)

### ✅ DNS-Infrastruktur (erledigt)

- Wildcard DNS Records für `*.mr-bytez.de` → n8-vps (A + AAAA)
- CAA Records für Let's Encrypt (`issue` + `issuewild`)
- hcloud CLI auf n8-kiste konfiguriert
- API-Token: `mr-bytez-dns-management.secret`
- DNS Backup vorhanden: `~/mr-bytez-dns-backup-2026-02-09.json`
- TTLs temporär auf 300s (später auf 3600s hochsetzen)

---

## 3. Geplante Services — Die n8-vps Master-Planung

Basierend auf der `n8-vps_Master-Planung_v4_1.md` (14 Stacks, 30 Services) und den dienst-spezifischen Tags in der Tag-Registry sind folgende Services für n8-vps vorgesehen:

### Infrastruktur-Stacks (Kern)

| Stack | Services | Zweck | Priorität |
|-------|----------|-------|-----------|
| **Traefik** | Reverse Proxy, Let's Encrypt ACME | Zentraler Eingang für alle Services, SSL/TLS | 🔴 Höchste |
| **Authentik** | SSO Server, PostgreSQL, Valkey | Single Sign-On, OAuth2, OIDC für alle Services | 🔴 Hoch |
| **WireGuard** | VPN Tunnel | Verbindung zu n8-kiste und anderen Hosts | 🟠 Mittel |
| **CrowdSec** | IDS/IPS, Threat Intelligence | Intrusion Detection & Prevention | 🟠 Mittel |
| **Unbound** | DNS Resolver | Lokaler DNS (bereits aktiv als System-Service) | ✅ Erledigt |

### Produktiv-Stacks (Dienste)

| Stack | Services | Zweck | Migration von n8-kiste |
|-------|----------|-------|------------------------|
| **Forgejo** | Git-Server | Self-Hosted Git (ersetzt Portainer-basiertes Setup) | Neu |
| **Nextcloud** | App, PostgreSQL, Valkey, Cron | Cloud-Storage, CalDAV, WebDAV | ✅ Läuft auf n8-kiste |
| **Plex** | Media Server | Streaming (evtl. Jellyfin als Alternative) | ✅ Läuft auf n8-kiste |
| **Jellyfin** | Media Server | Open-Source Media Streaming | ✅ Läuft auf n8-kiste |
| **Vaultwarden** | Password Manager | Self-Hosted Bitwarden-kompatibel | Neu |
| **Paperless-NGX** | Dokumenten-Management | DMS mit OCR | Neu |
| **Immich** | Foto/Video Management | Google Photos Alternative | Neu |

### Monitoring & Wartung

| Stack | Services | Zweck |
|-------|----------|-------|
| **Portainer** | Docker Management UI | Container-Verwaltung |
| **Watchtower** | Container Auto-Update | Automatische Image-Updates |
| **UptimeKuma** | Monitoring | Service-Verfügbarkeit |
| **Prometheus** | Metriken-Collection | System-Metriken |
| **Grafana** | Dashboards | Visualisierung |

### Backup & Storage

| Stack | Services | Zweck |
|-------|----------|-------|
| **Borg/borgmatic** | Deduplizierendes Backup | Verschlüsselte Backups |
| **rclone** | Cloud-Sync, VFS Cache | Sync zu externem Storage |

### Weitere geplante Services

| Service | Zweck |
|---------|-------|
| **AdGuard Home** | DNS-Blocking & Filtering |
| **Mailcow** | Mail-Suite mit SOGo |
| **MariaDB** | Datenbank (für WordPress/Shopware) |
| **PostgreSQL** | Datenbank (für Authentik, Nextcloud, etc.) |
| **Redis** | Cache, Session Store |
| **WordPress** | Blog/CMS |
| **Shopware** | E-Commerce |

### Entwicklungs-Stacks (aus Roadmap A3/A4)

| Stack | Location | Zweck |
|-------|----------|-------|
| **mrbz-dev** | `shared/stacks/mrbz-dev/` | Claude Dev Container (Arch Linux) |
| **mrbz-mcp** | `shared/stacks/mrbz-dev/` | MCP Server (TypeScript) |
| **mrbz-qdrant** | `shared/stacks/mrbz-dev/` | Vector DB für RAG |

---

## 4. Netzwerk-Architektur

### DNS-Setup (aktuell)

```
mr-bytez.de (A)     → 78.47.47.61        (Webhosting)
www.mr-bytez.de (A)  → 78.47.47.61        (Webhosting)
*.mr-bytez.de (A)    → 136.243.101.223    (n8-vps / Traefik)
*.mr-bytez.de (AAAA) → 2a01:4f8:171:ad1::2 (n8-vps / Traefik)
```

Alle Subdomains (außer `@` und `www`) werden auf n8-vps geroutet.
Traefik entscheidet dann per Host-Header, welcher Service angesprochen wird.

### Geplante Subdomains (Beispiele)

| Subdomain | Service |
|-----------|---------|
| `auth.mr-bytez.de` | Authentik SSO |
| `git.mr-bytez.de` | Forgejo |
| `cloud.mr-bytez.de` | Nextcloud |
| `vault.mr-bytez.de` | Vaultwarden |
| `monitor.mr-bytez.de` | UptimeKuma |
| `grafana.mr-bytez.de` | Grafana |
| `portainer.mr-bytez.de` | Portainer |
| `mcp.mr-bytez.de` | MCP Server |
| `docs.mr-bytez.de` | Paperless-NGX |
| `photos.mr-bytez.de` | Immich |

### Docker-Netzwerke (geplant)

| Netzwerk | Subnet | Zweck |
|----------|--------|-------|
| `mrbz-proxy-net` | TBD | Traefik ↔ alle Services |
| `mrbz-dev-net` | `172.30.0.0/24` | Development Stack (intern) |
| Stack-interne Netze | je Stack | Isolierung zwischen Stacks |

### SSH-Zugriff

| Von → Nach | Status |
|------------|--------|
| n8-kiste → n8-vps | ✅ Funktioniert (Port 61020) |
| n8-station → n8-vps | ✅ Funktioniert (Port 61020) |
| n8-vps → n8-kiste | ❌ Noch nicht (braucht VPN) |
| VS Code Remote SSH | ✅ Funktioniert (von n8-kiste) |

---

## 5. Schritt-für-Schritt: Was jetzt zu tun ist

Die Schritte sind nach der aktuellen ROADMAP priorisiert. Manche können parallel laufen.

### 🔴 Schritt 1: Fehlende Pakete nachinstallieren

**Aufwand:** 5 Minuten
**Warum:** Pre-Flight aus Host-Matrix zeigt fehlende Basis-Tools.

```fish
sudo pacman -S duf dust htop ripgrep less
```

Danach Port 22 aus UFW **und** Hetzner Robot Firewall entfernen:
```fish
sudo ufw delete allow 22/tcp
sudo ufw status
```
→ In Hetzner Robot: Regel #2 "ssh-legacy" löschen

### 🔴 Schritt 2: Traefik Reverse Proxy aufsetzen (B14/A4 Prerequisite)

**Aufwand:** 1–2 Stunden
**Warum:** Traefik ist die Grundvoraussetzung für ALLE öffentlich erreichbaren Services.
**Abhängigkeiten:** DNS Wildcard ✅, CAA Records ✅, Firewall Ports 80+443 ✅

**Teilschritte:**

1. **Verzeichnisstruktur anlegen** (auf n8-kiste committen, auf n8-vps pullen):
   ```
   projects/infrastructure/n8-vps/stacks/traefik/
   ├── docker-compose.yml
   ├── config/
   │   ├── traefik.yml          # Statische Konfiguration
   │   └── dynamic/             # Dynamische File-Provider Configs
   ├── .env.example
   └── README.md
   ```

2. **API-Token für ACME DNS-01 Challenge:**
   - Token `mr-bytez-dns-management.secret` mit Age verschlüsseln (D3)
   - Auf n8-vps als Docker Secret einbinden
   - Provider: `hetzner` (nutzt `api.hetzner.cloud`)

3. **Traefik docker-compose.yml erstellen:**
   - Container: `mrbz-traefik`
   - Netzwerk: `mrbz-proxy-net` (extern)
   - Ports: 80, 443
   - ACME: DNS-01 Challenge über Hetzner API
   - Wildcard-Zertifikat: `*.mr-bytez.de`
   - Dashboard: `traefik.mr-bytez.de` (mit Authentik geschützt, später)
   - Let's Encrypt Staging erst testen, dann Production!
   - Logs: `/var/log/traefik/` (Access + Error)

4. **Starten und verifizieren:**
   - `docker compose up -d`
   - Wildcard-Zertifikat prüfen
   - Test-Route einrichten (z.B. `whoami.mr-bytez.de`)

### 🟠 Schritt 3: Authentik SSO aufsetzen

**Aufwand:** 2–3 Stunden
**Warum:** Zentrales Login für alle Services. Wird von fast allen anderen Stacks benötigt.
**Abhängigkeiten:** Traefik (Schritt 2)

**Teilschritte:**

1. Stack-Verzeichnis anlegen:
   ```
   projects/infrastructure/n8-vps/stacks/authentik/
   ├── docker-compose.yml
   ├── .env.example
   └── README.md
   ```

2. Services: Authentik Server, Worker, PostgreSQL, Valkey
3. Traefik-Labels für `auth.mr-bytez.de`
4. Secrets: DB-Passwort, Secret-Key via `openssl rand -base64 32`
5. Initial-Admin einrichten
6. OAuth2/OIDC Provider für Traefik Forward-Auth konfigurieren

### 🟠 Schritt 4: Portainer & Watchtower

**Aufwand:** 30 Minuten
**Warum:** Einfachere Container-Verwaltung und automatische Updates.
**Abhängigkeiten:** Traefik (Schritt 2)

- Portainer CE hinter Traefik (`portainer.mr-bytez.de`)
- Watchtower mit Notifications konfigurieren
- Beide laufen bereits auf n8-kiste → Configs als Vorlage nutzen

### 🟡 Schritt 5: WireGuard VPN einrichten

**Aufwand:** 1–2 Stunden
**Warum:** Sichere Verbindung zwischen n8-vps und n8-kiste/n8-station.
**Port:** 61820/udp (bereits in Firewall offen)

- WireGuard Server auf n8-vps
- Peers: n8-kiste, n8-station (später: n8-book, n8-archstick)
- Ermöglicht: n8-vps → n8-kiste SSH, gemeinsamer Zugriff auf interne Services

### 🟡 Schritt 6: CrowdSec IDS/IPS

**Aufwand:** 1 Stunde
**Warum:** Schutz vor Brute-Force und bekannten Angreifern.
**Abhängigkeiten:** Traefik (für Bouncer)

- CrowdSec Agent auf n8-vps
- Traefik Bouncer Plugin
- Community Blocklists aktivieren

### 🟡 Schritt 7: Monitoring Stack (Prometheus + Grafana + UptimeKuma)

**Aufwand:** 2–3 Stunden
**Abhängigkeiten:** Traefik, Authentik (optional für Login)

- Prometheus: Node Exporter, cAdvisor, Docker Metrics
- Grafana: Dashboards für System + Docker
- UptimeKuma: Endpoint-Monitoring aller Services

### 🟢 Schritt 8: Backup-Strategie (Borg/borgmatic)

**Aufwand:** 2 Stunden
**Warum:** Bevor produktive Daten auf dem Server liegen!

- borgmatic für automatisierte Backups
- Verschlüsselte Deduplizierung
- Ziel: Hetzner Storage Box oder n8-kiste via VPN
- Cron-Job für tägliche Backups
- Retention Policy definieren

### 🟢 Schritt 9: Produktiv-Services migrieren/deployen

**Reihenfolge basierend auf Abhängigkeiten und n8-kiste Migration:**

1. **Forgejo** (Git-Server) — Neues Setup, kein Migration nötig
2. **Vaultwarden** (Passwort-Manager) — Neues Setup
3. **Nextcloud** (Cloud) — Migration von n8-kiste (Daten + DB!)
4. **Plex/Jellyfin** (Media) — Migration von n8-kiste (Libraries!)
5. **Paperless-NGX** (Dokumente) — Neues Setup
6. **Immich** (Fotos) — Neues Setup

### 🟢 Schritt 10: DNS-Optimierung

**Nach Stabilisierung aller Services:**

- TTLs von 300s auf 3600s hochsetzen
- PTR-Record für IPv4 in Hetzner Robot setzen
- PTR-Record für IPv6 setzen
- Alte API-Tokens aufräumen (D4)
- HTTPS-Record (optional)

---

## 6. Verknüpfung mit der ROADMAP

| ROADMAP-Punkt | VPS-Relevanz | Abhängigkeit |
|---------------|-------------|-------------|
| **A1** Secrets-Repo | Secrets-Deployment auf n8-vps ✅ | — |
| **A2** Fish DRY | Fish-Config auf n8-vps deployed ✅ | — |
| **A3** Dev Container | Kann auf n8-kiste ODER n8-vps laufen | Docker ✅ |
| **A4** MCP Server | **Production auf n8-vps** (`mcp.mr-bytez.de`) | Traefik, Authentik |
| **B14** Traefik Setup | **Kerntask für n8-vps** | DNS ✅ |
| **D1** DNS TTL | Nach Stabilisierung | Alle Services |
| **D2** PTR Records | Jederzeit machbar | — |
| **D3** API-Token Age | Für Traefik ACME | — |
| **D4** Token Cleanup | Nach Traefik | — |
| **D14** Traefik ACME DNS-01 | = Schritt 2 oben | DNS ✅ |

---

## 7. Relevante Dateien im Repo

| Datei/Pfad | Inhalt |
|------------|--------|
| `projects/infrastructure/n8-vps/` | Host-spezifische Configs |
| `projects/infrastructure/n8-vps/stacks/traefik/` | Traefik Stack (geplant) |
| `projects/infrastructure/n8-vps/docs/` | Diese Dokumentation |
| `projects/infrastructure/mcp-server/` | MCP Server (geplant) |
| `.claude/context/infrastructure.md` | Hosts, Netzwerk, Deployment-Status |
| `.claude/context/docker.md` | Container-Naming, Stack-Konventionen |
| `.claude/context/handoffs/HANDOFF_[DNS][Infra]_dns-hetzner-traefik.md` | DNS Handoff (Optimierung offen) |
| `.claude/context/handoffs/HANDOFF_[Traefik][Docker]_n8-vps-traefik-setup.md` | Traefik Setup Handoff (aktiv) |
| `.claude/context/HOST_MATRIX.md` | Feature-Flags aller Hosts |
| `.claude/archive/mrbz-dev-plan.md` | Dev Container Architektur |
| `DEPLOYMENT.md` | Deployment-Guide (Quickstart) |
| `ROADMAP.md` | Aktuelle Projekt-Roadmap |

---

## 8. Zusammenfassung

**n8-vps ist ein leistungsstarker Hetzner EX63 Dedicated Server** (E5-2650v4, 128 GB RAM, 2× 1 TB NVMe RAID 1) in Falkenstein, Deutschland. Das Basis-Setup ist vollständig abgeschlossen: Arch Linux, SSH-Hardening, Firewall (UFW + Hetzner Robot), Docker, Fish Shell mit mr-bytez Integration, DNS Wildcard Records.

**Was fehlt für den produktiven Betrieb:**
Der Server hat aktuell **keine laufenden Docker-Services**. Der kritische Pfad ist:

```
Traefik (Reverse Proxy + SSL) ──────────────────────┐
    ↓                                                 │
Authentik (SSO) ─────────────────────────┐            │
    ↓                                     │            │
Portainer + Watchtower                    │            │
    ↓                                     │            │
WireGuard VPN ←──── n8-kiste ←──── n8-station         │
    ↓                                                  │
CrowdSec IDS/IPS ←────────────────────── Traefik ─────┘
    ↓
Monitoring (Prometheus + Grafana + UptimeKuma)
    ↓
Backup (Borg/borgmatic) ←── BEVOR produktive Daten!
    ↓
Forgejo → Vaultwarden → Nextcloud → Media → Paperless → Immich
```

**Nächster konkreter Schritt:** Traefik aufsetzen (Schritt 2). Alles andere baut darauf auf.
→ Details siehe `HANDOFF_[Traefik][Docker]_n8-vps-traefik-setup.md`
→ DNS-Nacharbeiten siehe `HANDOFF_[DNS][Infra]_dns-hetzner-traefik.md`
