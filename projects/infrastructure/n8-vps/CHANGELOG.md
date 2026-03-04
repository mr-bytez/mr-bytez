# n8-vps — CHANGELOG

> **Pfad:** `projects/infrastructure/n8-vps/CHANGELOG.md`
> **Version:** 0.1.0
> **Erstellt:** 2026-03-04
> **Aktualisiert:** 2026-03-04
> **Autor:** MR-ByteZ
> **Zweck:** Aenderungshistorie fuer den n8-vps Host

---

## [Unreleased]

### Added
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
