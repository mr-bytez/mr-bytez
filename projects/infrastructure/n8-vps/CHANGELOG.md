# n8-vps — CHANGELOG

> **Pfad:** `projects/infrastructure/n8-vps/CHANGELOG.md`
> **Version:** 0.1.0
> **Erstellt:** 2026-03-04
> **Aktualisiert:** 2026-03-04
> **Autor:** MR-ByteZ
> **Zweck:** Aenderungshistorie fuer den n8-vps Host

---

## [Unreleased]

### Changed
- Stack-Haertung aller 3 Stacks (Traefik, CrowdSec, Authentik):
  - `security_opt: no-new-privileges:true` auf allen Services (5 Container)
  - Traefik: `hostname: traefik.proxy.docker.n8vps`, Healthcheck (ping), Logging-Rotation
  - Traefik: `ping: {}` in statischer Config aktiviert
  - Authentik PostgreSQL: `POSTGRES_HOST_AUTH_METHOD: scram-sha-256`,
    `POSTGRES_INITDB_ARGS: "--auth-host=scram-sha-256 --data-checksums"`,
    `PGDATA` explizit gesetzt, `TZ: Europe/Berlin`
  - Authentik: `AUTHENTIK_HOST_BROWSER` + `AUTHENTIK_WEB__CSRF_TRUSTED_ORIGINS` (CSRF-Schutz)

### Fixed
- Authentik PostgreSQL Volume-Mount: `/var/lib/postgresql/data` → `/var/lib/postgresql`
  (postgres:18-alpine schreibt unter `/var/lib/postgresql/18/docker/`, Volume war leer,
  DB-Daten gingen bei Container-Neustart verloren). Volume auf `external: true` gesetzt.
- Traefik Config-Fix: keepAliveMaxRequests/keepAliveMaxTime von EntryPoint- auf transport-Ebene
  verschoben (Traefik v3.6.9 Restart-Loop behoben — Felder gehoeren unter transport, nicht direkt
  unter dem EntryPoint)

### Added
- Host-Level Tuning Config-Dateien unter shared/etc/ erstellt
  - sysctl.d/90-mr-bytez.conf: vm.swappiness 10, netdev_max_backlog 5000
  - security/limits.d/90-mr-bytez.conf: nofile 65536 (mrohwer + root)
  - docker/daemon.json: default-ulimits nofile 65536
  - systemd/system.conf.d/90-mr-bytez.conf: DefaultLimitNOFILE 65536
  - systemd/user.conf.d/90-mr-bytez.conf: DefaultLimitNOFILE 65536
  - fish/conf.d/010-ulimits.fish: Soft-Limit Workaround (Arch SSH-Login Bug)
  - Deployment: Copy-Methode (nicht Symlink)
- Hardware-Doku Korrektur + Stack-Tuning
  - Hardware-Specs korrigiert: Core Ultra 7 265 (20K), 64 GB DDR5 (vorher falsch)
  - PostgreSQL: shared_buffers 2GB, effective_cache_size 8GB, work_mem 32MB
  - Traefik: Timeouts (read 30s, write 60s), ForwardAuth maxResponseBodySize 1MB
  - CrowdSec: updateIntervalSeconds 15s (Stream-Modus)
  - Host-Level Performance-Tuning Sektion in Server-Doku (sysctl, ulimit)
  - Valkey/Redis komplett entfernt (seit Authentik 2025.10 obsolet)
    PostgreSQL als alleiniger Cache (django_postgres_cache)
    max_connections 200, max_locks_per_transaction 256, wal_buffers 64MB
- CrowdSec Middleware + Authentik Forward-Auth fuer Traefik
  - `crowdsec-bouncer@file` auf Dashboard- und Authentik-Router aktiviert
  - `config/dynamic/authentik.yml`: Forward-Auth Middleware (Embedded Outpost)
  - Outpost-Router Labels auf Authentik Server (Priority 200, Auth-Loop-Schutz)
  - Dashboard: BasicAuth durch Authentik Forward-Auth ersetzt
  - CrowdSec Bouncer: `crowdsecMode: stream` + `updateMaxFailure: 5`
  - Forward-Auth: `X-authentik-entitlements` Header ergaenzt
- 5-5-3 Pattern umgesetzt: README, CHANGELOG, ROADMAP, DEPLOYMENT, CLAUDE.md, hardware.md
- Authentik SSO Stack erstellt (`stacks/authentik/`)
  - docker-compose.yml: 4 Services (postgres, valkey, server, worker)
  - Subnet `172.20.0.0/24`, Worker-Tuning 4x4 (12-Kerne-optimiert)
  - Traefik-Labels fuer `auth.mr-bytez.de`
  - .env.example, README.md, DEPLOYMENT.md

### Fixed
- Authentik docker-compose.yml: Secret-File Volume-Mounts fuer postgres, server, worker hinzugefuegt
  (file://-Pfade muessen als Bind-Mounts im Container verfuegbar sein)

---

## Bisherige Meilensteine

### Maerz 2026

- deploy.fish v0.5.1 Stable — Pakete installiert (duf, dust, htop, ripgrep, less)
- Port 22 aus UFW + Hetzner Robot Firewall entfernt
- Traefik v3.6 Reverse Proxy deployed (Dashboard, LE-Cert, ACME DNS-01)
- Secrets-Deployment verifiziert (deploy.fish, SSH, Dual-Remote)

### Februar 2026

- Phase 0-4: OS (Arch Linux installimage), SSH-Hardening (Port 61020),
  Firewall (UFW + Hetzner Robot), Docker, Fish Shell
- mr-bytez Deployment (Anker, Symlinks, Fish Loader)
- DNS Wildcard Records fuer `*.mr-bytez.de` → n8-vps
- CAA Records fuer Let's Encrypt
- yay (AUR Helper) gebaut und installiert

---

**Letzte Aktualisierung:** 2026-03-05

